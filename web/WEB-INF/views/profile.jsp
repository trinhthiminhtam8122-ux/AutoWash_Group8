<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%@page import="dao.VehicleDAO"%>
<%@page import="dao.AccountDAO"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%
    // Authentication check
    Account sessionAcc = (Account) session.getAttribute("LOGIN_USER");
    
    if (sessionAcc == null) {
        response.sendRedirect("main?action=login");
        return;
    }
    
    // Fetch fresh data from DB
    AccountDAO aDao = new AccountDAO();
    CustomerDAO cDao = new CustomerDAO();
    
    Account acc = null;
    Customer customer = null;
    
    try {
        acc = aDao.getAccountById(sessionAcc.getAccountID());
        if (acc != null) {
            customer = cDao.getCustomerByAccountID(acc.getAccountID());
            session.setAttribute("LOGIN_USER", acc);
            if (customer != null) {
                session.setAttribute("CUSTOMER_INFO", customer);
            }
        } else {
            response.sendRedirect("main?action=login");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    List<Vehicle> myVehicles = null;
    if (customer != null) {
        VehicleDAO vDao = new VehicleDAO();
        myVehicles = vDao.getVehiclesByCustomerID(customer.getCustomerID());
    }
    
    String userName = "Guest";
    String email = "N/A";
    String phone = "N/A";
    int currentPoints = 0;
    String tierName = "Member";
    String avatarUrl = "";
    
    if (customer != null) {
        userName = customer.getFullName();
        phone = customer.getPhone();
        currentPoints = customer.getCurrentPoints();
        avatarUrl = customer.getAvatarUrl() != null ? customer.getAvatarUrl() : "";
        if (customer.getTierID() == 1) tierName = "Bronze member";
        else if (customer.getTierID() == 2) tierName = "Silver member";
        else if (customer.getTierID() == 3) tierName = "Gold member";
        else if (customer.getTierID() == 4) tierName = "Platinum member";
        else tierName = "Gold member"; // Defaulting to gold for demo matching image
    }
    if (customer != null) {
        email = customer.getEmail() != null ? customer.getEmail() : "N/A";
        if ("Guest".equals(userName)) {
            userName = acc != null ? acc.getUsername() : "Guest";
        }
    } else if (acc != null) {
        email = acc.getUsername();
        if ("Guest".equals(userName)) userName = acc.getUsername();
    }
    
    // Fallback
    if (userName == null || "Guest".equals(userName)) userName = "Guest";
    if (email == null) email = "N/A";
    if (phone == null || "N/A".equals(phone)) phone = "N/A";
    
    // Flash messages
    String successMsg = (String) session.getAttribute("SUCCESS_MSG");
    String errorMsg   = (String) session.getAttribute("ERROR_MSG");
    session.removeAttribute("SUCCESS_MSG");
    session.removeAttribute("ERROR_MSG");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --bg-body: #f3f4f6;
            --border: #e5e7eb;
            --success: #16a34a;
            --error: #dc2626;
        }

        /* Toast Notification */
        .toast {
            position: fixed; top: 1.5rem; right: 1.5rem; z-index: 9999;
            padding: 1rem 1.5rem; border-radius: 12px;
            display: flex; align-items: center; gap: 0.75rem;
            font-size: 0.95rem; font-weight: 600;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease;
            min-width: 280px;
        }
        .toast.success { background: #f0fdf4; color: #15803d; border-left: 4px solid #16a34a; }
        .toast.error   { background: #fef2f2; color: #dc2626; border-left: 4px solid #dc2626; }
        .toast i { font-size: 1.1rem; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(60px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes fadeOut {
            from { opacity: 1; }
            to   { opacity: 0; }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
        nav { background: white; display: flex; justify-content: space-between; align-items: center; padding: 1rem 3rem; border-bottom: 2px solid #3b82f6; }
        .brand { font-size: 1.5rem; font-weight: 800; color: black; text-decoration: none; display: flex; align-items: center; gap: 0.5rem; }
        .brand i { color: #3b82f6; font-size: 1.8rem; }
        .nav-links { display: flex; gap: 2rem; font-size: 0.95rem; font-weight: 700; }
        .nav-links a { color: var(--text-dark); text-decoration: none; transition: 0.3s; }
        .nav-links a:hover { color: var(--primary); }
        
        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .user-nav { display: flex; align-items: center; gap: 0.8rem; text-decoration: none; color: var(--text-dark); font-weight: 600; }
        .user-nav img { width: 35px; height: 35px; border-radius: 50%; object-fit: cover; border: 2px solid #3b82f6; }
        .logout-btn { color: #ef4444; text-decoration: none; font-weight: 600; font-size: 0.9rem; padding: 0.4rem 0.8rem; border-radius: 6px; transition: 0.3s; }
        .logout-btn:hover { background: #fef2f2; }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto 4rem auto;
            width: 100%;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 2.5rem;
            flex: 1;
        }

        /* Sidebar (Left) */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .profile-header {
            background: linear-gradient(135deg, #4da9ff, #7f68ff);
            padding: 3rem 1.5rem;
            color: white;
            position: relative;
            overflow: hidden;
            border-radius: 1.2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(127, 104, 255, 0.15);
        }

        .profile-info {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
            position: relative;
            z-index: 1;
        }

        .avatar-lg {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            border: 4px solid #38bdf8;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: 0.3s;
        }
        
        .avatar-lg:hover {
            transform: scale(1.05);
        }

        .user-details h3 { font-size: 1.5rem; font-weight: 800; margin-bottom: 0.3rem; letter-spacing: -0.5px; }
        .user-details p { font-size: 0.95rem; opacity: 0.9; font-weight: 500; }

        /* Decorative Bubbles */
        .bubble { position: absolute; border: 1px solid rgba(255,255,255,0.4); border-radius: 50%; }
        .bubble-1 { width: 40px; height: 40px; top: 10%; right: 15%; }
        .bubble-2 { width: 60px; height: 60px; top: 30%; left: 10%; }
        .bubble-3 { width: 25px; height: 25px; bottom: 20%; right: 25%; }
        .bubble-4 { width: 80px; height: 80px; bottom: -10%; left: -5%; }
        
        /* Loyalty Points Card */
        .loyalty-card {
            background: #0b1c42;
            border-radius: 1.2rem;
            padding: 2rem;
            color: white;
            box-shadow: 0 10px 30px rgba(11, 28, 66, 0.15);
            position: relative;
            overflow: hidden;
        }
        
        /* Subtle glow inside loyalty card */
        .loyalty-card::before {
            content: ''; position: absolute; top: -50px; right: -50px; width: 150px; height: 150px;
            background: rgba(251, 189, 97, 0.1); border-radius: 50%; filter: blur(30px);
        }
        
        .loyalty-card-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; position: relative; z-index: 1;}
        .loyalty-card-top h3 { font-size: 1.15rem; font-weight: 800; }
        .badge-tier { padding: 0.4rem 1rem; border-radius: 0.5rem; font-size: 0.75rem; font-weight: 800; letter-spacing: 0.5px; }
        .badge-Bronze { background: #cd7f32; color: #fff; }
        .badge-Silver { background: #e2e8f0; color: #475569; }
        .badge-Gold { background: #fbbd61; color: #78350f; }
        .badge-Platinum { background: #e5e7eb; color: #1f2937; box-shadow: inset 0 0 5px rgba(0,0,0,0.1); border: 1px solid #d1d5db; }
        
        .points-big { font-size: 3rem; font-weight: 800; margin-bottom: 0.25rem; line-height: 1; position: relative; z-index: 1;}
        .points-subtitle { font-size: 0.9rem; color: #94a3b8; margin-bottom: 2.5rem; font-weight: 500; }
        
        .progress-label { font-size: 0.9rem; margin-bottom: 0.8rem; color: #ffffff; font-weight: 600;}
        .progress-bar-bg { background: rgba(255,255,255,0.15); height: 8px; border-radius: 4px; margin-bottom: 0.8rem; position: relative; }
        .progress-fill { background: linear-gradient(90deg, #38bdf8, #818cf8); height: 100%; border-radius: 4px; }
        .progress-bar-bg span { position: absolute; right: 0; top: -24px; font-size: 0.8rem; font-weight: 700; color: #38bdf8; }
        .progress-text { font-size: 0.85rem; color: #cbd5e1; display: flex; align-items: center; gap: 0.5rem; margin-top: 1rem; font-weight: 500;}
        .star-icon { color: #fbbd61; font-size: 1rem; }

        /* Main Content (Right) */
        .main-content {
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
        }

        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; padding-bottom: 0.8rem; border-bottom: 2px solid var(--border); }
        .section-header h3 { font-size: 1.4rem; font-weight: 800; color: var(--text-dark); letter-spacing: -0.5px;}
        .section-header a { font-size: 0.95rem; color: var(--primary); text-decoration: none; font-weight: 700; transition: 0.3s; }
        .section-header a:hover { color: #1d4ed8; }

        /* Info Card */
        .info-card { background: white; border-radius: 1.2rem; padding: 2rem; box-shadow: 0 4px 20px rgba(0,0,0,0.03); display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 2rem; }
        .info-label { font-size: 0.85rem; color: var(--text-muted); margin-bottom: 0.5rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;}
        .info-value { font-size: 1.1rem; font-weight: 600; color: var(--text-dark); }

        /* Vehicles */
        .vehicles-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; margin-bottom: 1.5rem; }
        .vehicle-card { background: white; border-radius: 1.2rem; padding: 1.5rem; display: flex; align-items: center; gap: 1.5rem; box-shadow: 0 4px 20px rgba(0,0,0,0.03); transition: 0.3s; border: 1px solid transparent; }
        .vehicle-card:hover { border-color: #bfdbfe; box-shadow: 0 10px 25px rgba(37, 99, 235, 0.1); transform: translateY(-2px); }
        .vehicle-img { width: 90px; height: 90px; border-radius: 12px; background: #f8fafc; object-fit: cover; }
        .vehicle-info { flex: 1; }
        .vehicle-info h4 { font-size: 1.15rem; font-weight: 800; color: var(--text-dark); margin-bottom: 0.3rem; }
        .vehicle-info p { font-size: 0.9rem; color: var(--text-muted); font-weight: 500;}
        .vehicle-actions { display: flex; gap: 1rem; }
        .vehicle-actions a { color: #94a3b8; text-decoration: none; font-size: 1.2rem; transition: 0.3s; background: #f1f5f9; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 50%; }
        .vehicle-actions a:hover { color: white; background: var(--primary); }
        .vehicle-actions a.delete-btn:hover { background: var(--error); }

        .btn-add-vehicle { display: inline-flex; align-items: center; justify-content: center; gap: 0.5rem; background: white; color: var(--primary); border: 2px dashed #93c5fd; padding: 1.2rem; border-radius: 1.2rem; font-size: 1.05rem; font-weight: 700; cursor: pointer; text-decoration: none; transition: 0.3s; width: 100%; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
        .btn-add-vehicle:hover { background: #eff6ff; border-color: var(--primary); }

        /* Vouchers & History Grid */
        .two-col-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }
        
        .list-card { background: white; border-radius: 1.2rem; padding: 1.5rem 1.8rem; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 20px rgba(0,0,0,0.03); margin-bottom: 1rem; border-left: 4px solid transparent; transition: 0.3s; }
        .list-card:hover { transform: translateX(5px); }
        .voucher-card { border-left-color: #38bdf8; }
        
        .list-left h4 { font-size: 1.1rem; font-weight: 800; margin-bottom: 0.4rem; color: #0ea5e9; }
        .history-card .list-left h4 { color: var(--text-dark); }
        .list-left p { font-size: 0.9rem; color: var(--text-muted); font-weight: 500;}
        
        .btn-use { background: linear-gradient(135deg, #a78bfa, #c4b5fd); color: white; border: none; padding: 0.6rem 1.8rem; border-radius: 2rem; font-weight: 700; font-size: 0.95rem; cursor: pointer; box-shadow: 0 4px 10px rgba(167, 139, 250, 0.3); transition: 0.3s;}
        .btn-use:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(167, 139, 250, 0.4); }
        
        .points-plus { font-size: 1.2rem; font-weight: 800; color: #16a34a; background: #dcfce7; padding: 0.4rem 1rem; border-radius: 0.8rem; }

        /* Footer */
        footer { background: white; padding: 2rem 3rem; display: flex; justify-content: space-between; font-size: 0.9rem; color: var(--text-muted); font-weight: 600; border-top: 1px solid var(--border); margin-top: auto;}
        .footer-links { display: flex; gap: 2rem; }
        .footer-links a { color: var(--text-dark); text-decoration: none; transition: 0.3s; }
        .footer-links a:hover { color: var(--primary); }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5); backdrop-filter: blur(4px);
            z-index: 1000; align-items: center; justify-content: center;
        }
        
        .modal-content {
            background: white; width: 100%; max-width: 450px;
            border-radius: 1.2rem; padding: 2.5rem 2rem;
            position: relative; box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: modalFadeIn 0.3s ease;
        }
        
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .modal-close {
            position: absolute; top: 1.5rem; right: 1.5rem;
            background: none; border: none; font-size: 1.5rem;
            color: var(--text-muted); cursor: pointer; transition: 0.3s;
        }
        .modal-close:hover { color: var(--error); }
        
        .modal-header h2 { font-size: 1.4rem; font-weight: 800; margin-bottom: 0.5rem; color: var(--text-dark); }
        .modal-header p { font-size: 0.9rem; color: var(--text-muted); margin-bottom: 1.5rem; }
        
        /* Image Upload Area inside Modal */
        .upload-area {
            background: #f8fafc; border: 2px dashed #93c5fd; border-radius: 12px;
            padding: 1.5rem; text-align: center; margin-bottom: 1.5rem;
            cursor: pointer; transition: 0.3s; position: relative;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            min-height: 120px;
        }
        .upload-area:hover { background: #eff6ff; }
        .upload-icon { width: 40px; height: 40px; background: #3b82f6; color: white; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-bottom: 0.8rem; }
        .upload-area h4 { font-size: 0.95rem; color: var(--text-dark); margin-bottom: 0.3rem; }
        .upload-area p { font-size: 0.8rem; color: var(--text-muted); }
        #modalPreviewImg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; display: none; z-index: 1; border-radius: 10px;}
        
        /* Modal Forms */
        .modal .input-group { margin-bottom: 1.2rem; text-align: left; }
        .modal .input-group label { display: block; font-size: 0.85rem; font-weight: 700; color: var(--text-dark); margin-bottom: 0.5rem; }
        .modal .input-field { width: 100%; padding: 0.9rem; background: #f1f5f9; border: 1px solid transparent; border-radius: 10px; font-size: 0.95rem; outline: none; transition: 0.3s; }
        .modal .input-field:focus { border-color: #3b82f6; background: white; }
        .modal .btn-submit { width: 100%; background: var(--primary); color: white; border: none; padding: 1rem; border-radius: 10px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: 0.3s; margin-top: 1rem; }
        .modal .btn-submit:hover { background: #1d4ed8; }

        @media (max-width: 900px) {
            .container { grid-template-columns: 1fr; max-width: 600px; padding: 0 1.5rem; }
            .info-card { grid-template-columns: 1fr; gap: 1rem; }
            .two-col-grid { grid-template-columns: 1fr; }
            .vehicles-grid { grid-template-columns: 1fr; }
            .nav-links { display: none; }
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
</head>
<body>

    <nav>
        <a href="javascript:void(0)" onclick="navTo('home')" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
        <div class="nav-links">
            <a href="javascript:void(0)" onclick="navTo('home')">Home</a>
            <a href="#">Services</a>
            <a href="#">Pricing</a>
            <a href="javascript:void(0)" onclick="navTo('profile')" style="color: var(--primary);">Profile</a>
        </div>
        <div class="nav-right">
            <% if (avatarUrl != null && !avatarUrl.isEmpty()) { %>
                <a href="javascript:void(0)" onclick="navTo('profile')" class="user-nav">
                    <img src="<%= request.getContextPath() + (avatarUrl.startsWith("/") ? "" : "/") + avatarUrl %>" alt="User">
                    <%= userName %>
                </a>
            <% } else { %>
                <a href="javascript:void(0)" onclick="navTo('profile')" class="user-nav">
                    <div style="width: 35px; height: 35px; background: var(--bg-body); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary); border: 2px solid #3b82f6;">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <%= userName %>
                </a>
            <% } %>
            <a href="LogoutController" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
    
    <%-- Toast notifications --%>
    <% if (successMsg != null) { %>
    <div id="toastMsg" class="toast success">
        <i class="fa-solid fa-circle-check"></i>
        <%= successMsg %>
    </div>
    <% } else if (errorMsg != null) { %>
    <div id="toastMsg" class="toast error">
        <i class="fa-solid fa-circle-xmark"></i>
        <%= errorMsg %>
    </div>
    <% } %>
        
        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="bubble bubble-1"></div>
                <div class="bubble bubble-2"></div>
                <div class="bubble bubble-3"></div>
                <div class="bubble bubble-4"></div>
                
                <div class="profile-info">
                    <form id="avatarForm" action="UpdateAvatarController" method="POST" enctype="multipart/form-data" style="display: none;">
                        <input type="file" id="avatarUpload" name="avatarFile" accept="image/*" onchange="document.getElementById('avatarForm').submit();">
                    </form>

                    <label for="avatarUpload" style="cursor: pointer;" title="Nhấn để thay đổi ảnh đại diện">
                        <div class="avatar-lg" style="position: relative;">
                            <% if (avatarUrl != null && !avatarUrl.isEmpty()) { %>
                                <img src="<%= request.getContextPath() + (avatarUrl.startsWith("/") ? "" : "/") + avatarUrl %>" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                                <i class="fa-solid fa-user" style="font-size: 3rem; color: #cbd5e1;"></i>
                            <% } %>
                            <div style="position: absolute; bottom: 0; left: 0; width: 100%; background: rgba(0,0,0,0.6); padding: 4px 0; text-align: center;">
                                <i class="fa-solid fa-camera" style="color: white; font-size: 0.9rem;"></i>
                            </div>
                        </div>
                    </label>
                    <div class="user-details">
                        <h3><%= userName %></h3>
                        <p><%= tierName %></p>
                    </div>
                </div>
            </div>

            <!-- Loyalty Points Card -->
            <div class="loyalty-card">
                <div class="loyalty-card-top">
                    <h3>Loyalty Points</h3>
                    <div class="badge-tier badge-<%= tierName.replace(" member", "") %>"><%= tierName.replace(" member", "").toUpperCase() %></div>
                </div>
                <div class="points-big"><%= String.format("%,d", currentPoints) %></div>
                <div class="points-subtitle">Current reward points</div>
                
                <% 
                    String nextTier = "Silver";
                    int nextTierPoints = 1000;
                    
                    if (tierName.contains("Silver")) {
                        nextTier = "Gold";
                        nextTierPoints = 2500;
                    } else if (tierName.contains("Gold")) {
                        nextTier = "Platinum";
                        nextTierPoints = 5000;
                    } else if (tierName.contains("Platinum")) {
                        nextTier = "Diamond";
                        nextTierPoints = 10000;
                    }
                    
                    int pointsLeft = nextTierPoints - currentPoints;
                    if (pointsLeft < 0) pointsLeft = 0;
                    int percent = (int) ((double) currentPoints / nextTierPoints * 100);
                    if (percent > 100) percent = 100;
                %>
                
                <div class="progress-label">Progress to <%= nextTier %></div>
                <div class="progress-bar-bg">
                    <div class="progress-fill" style="width: <%= percent %>%;"></div>
                    <span><%= percent %>%</span>
                </div>
                <div class="progress-text">
                    <i class="fa-solid fa-star star-icon"></i>
                    <span><%= String.format("%,d", pointsLeft) %> points left to reach <%= nextTier.toLowerCase() %></span>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            
            <!-- Personal Info -->
            <div>
                <div class="section-header">
                    <h3>Personal Info</h3>
                    <a href="javascript:void(0)" id="editProfileBtn"
                       data-name="<%= userName.replace("\"", "&quot;") %>"
                       data-phone="<%= phone.replace("\"", "&quot;") %>"
                       data-email="<%= email.replace("\"", "&quot;") %>"
                       onclick="openEditProfileModal(this)">
                        <i class="fa-solid fa-pen-to-square"></i> Edit Profile
                    </a>
                </div>
                <div class="info-card">
                    <div class="info-item">
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= userName %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><%= email %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><%= phone %></div>
                    </div>
                </div>
            </div>

            <!-- My Vehicles -->
            <div>
                <div class="section-header">
                    <h3>My Vehicles</h3>
                </div>
                
                <div class="vehicles-grid">
                    <% if (myVehicles != null && !myVehicles.isEmpty()) { 
                        for (Vehicle v : myVehicles) { 
                            String vImg = v.getVehicleImageUrl() != null ? request.getContextPath() + (v.getVehicleImageUrl().startsWith("/") ? "" : "/") + v.getVehicleImageUrl() : request.getContextPath() + "/assets/images/default-car.png";
                    %>
                        <div class="vehicle-card">
                            <img src="<%= vImg %>" class="vehicle-img" alt="Vehicle">
                            <div class="vehicle-info">
                                <h4><%= v.getVehicleModel() != null ? v.getVehicleModel().split(" - ")[0] : v.getLicensePlate() %></h4>
                                <p><%= v.getLicensePlate() %> &bull; <%= v.getColor() %></p>
                            </div>
                            <div class="vehicle-actions">
                                <a href="javascript:void(0)" onclick="openEditModal('<%= v.getVehicleID() %>', '<%= v.getLicensePlate() %>', '<%= v.getVehicleModel() %>', '<%= v.getColor() %>', '<%= v.getVehicleImageUrl() != null ? v.getVehicleImageUrl() : "" %>', '<%= request.getContextPath() %>')" class="edit-btn" title="Edit">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="VehicleController?action=delete&id=<%= v.getVehicleID() %>" onclick="return confirm('Are you sure you want to delete this vehicle?');" class="delete-btn" title="Delete"><i class="fa-solid fa-trash-can"></i></a>
                            </div>
                        </div>
                    <%  } 
                       } else { %>
                        <p style="font-size: 0.95rem; color: #64748b; padding: 1rem 0; font-weight: 500;">You have no vehicles added yet.</p>
                    <% } %>
                </div>
                
                <a href="javascript:void(0)" onclick="openAddModal()" class="btn-add-vehicle">
                    <i class="fa-solid fa-plus"></i> Add New Vehicle
                </a>
            </div>

            <!-- Two Column Grid for Vouchers & History -->
            <div class="two-col-grid">
                <!-- My Vouchers -->
                <div>
                    <div class="section-header">
                        <h3>My Vouchers</h3>
                        <a href="#">View All</a>
                    </div>
                    <div class="list-card voucher-card">
                        <div class="list-left">
                            <h4>20% OFF Wash</h4>
                            <p>Valid until 30 Jun</p>
                        </div>
                        <button class="btn-use">Use</button>
                    </div>
                    <div class="list-card voucher-card">
                        <div class="list-left">
                            <h4>Free Tire Shine</h4>
                            <p>Valid until 10 Jul</p>
                        </div>
                        <button class="btn-use">Use</button>
                    </div>
                </div>

                <!-- Points History -->
                <div>
                    <div class="section-header">
                        <h3>Points History</h3>
                        <a href="#">View All</a>
                    </div>
                    <div class="list-card history-card">
                        <div class="list-left">
                            <h4>Premium Wash</h4>
                            <p>25 May 2026</p>
                        </div>
                        <div class="points-plus">+120</div>
                    </div>
                    <div class="list-card history-card">
                        <div class="list-left">
                            <h4>Interior Cleaning</h4>
                            <p>20 May 2026</p>
                        </div>
                        <div class="points-plus">+80</div>
                    </div>
                </div>
            </div>

        </div>
    </div>
    
    <footer>
        <div>© 2026 AutoWash. All rights reserved.</div>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Term of Services</a>
            <a href="#">Help Center</a>
        </div>
    </footer>

    <!-- Edit Profile Modal -->
    <div id="profileModalOverlay" class="modal-overlay">
        <div class="modal-content modal">
            <button class="modal-close" onclick="closeProfileModal()"><i class="fa-solid fa-xmark"></i></button>
            <div class="modal-header">
                <h2>Edit Profile</h2>
                <p>Update your personal information below.</p>
            </div>
            
            <form id="editProfileForm" action="UpdateProfileController" method="POST">
                <div class="input-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" id="modalFullName" class="input-field" required>
                </div>
                <div class="input-group">
                    <label>Email Address</label>
                    <input type="email" name="email" id="modalEmail" class="input-field" required>
                </div>
                <div class="input-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" id="modalPhone" class="input-field" readonly style="background-color: #e2e8f0; cursor: not-allowed; color: #64748b;" title="Phone number cannot be changed">
                </div>
                <button type="submit" class="btn-submit">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- Vehicle Modal -->
    <div id="vehicleModalOverlay" class="modal-overlay">
        <div class="modal-content modal">
            <button class="modal-close" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
            <div class="modal-header">
                <h2 id="modalTitle">Add Vehicle</h2>
                <p id="modalDesc">Save your vehicle information for faster booking next time.</p>
            </div>
            
            <form action="VehicleController" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" id="modalAction" value="add">
                <input type="hidden" name="vehicleID" id="modalVehicleID" value="">
                <input type="hidden" name="oldImage" id="modalOldImage" value="">

                <label class="upload-area">
                    <div id="modalUploadContent" style="z-index: 2; position: relative;">
                        <div class="upload-icon"><i class="fa-solid fa-plus"></i></div>
                        <h4>Upload Vehicle Image</h4>
                        <p>Tap to upload your car photo</p>
                    </div>
                    <img id="modalPreviewImg">
                    <input type="file" name="vehicleImage" accept="image/*" style="display: none;" onchange="previewModalImage(this)">
                </label>

                <div class="input-group">
                    <label>License Plate</label>
                    <input type="text" name="licensePlate" id="modalLicense" class="input-field" placeholder="51H-234.56" required>
                </div>
                <div class="input-group">
                    <label>Brand</label>
                    <input type="text" name="brand" id="modalBrand" class="input-field" placeholder="Toyota" required>
                </div>
                <div class="input-group">
                    <label>Model</label>
                    <input type="text" name="model" id="modalModel" class="input-field" placeholder="Vios" required>
                </div>
                <div class="input-group">
                    <label>Vehicle Type</label>
                    <input type="text" name="vehicleType" id="modalType" class="input-field" placeholder="Sedan" required>
                </div>
                <div class="input-group">
                    <label>Vehicle Color</label>
                    <input type="text" name="color" id="modalColor" class="input-field" placeholder="Black" required>
                </div>

                <button type="submit" class="btn-submit">Save Vehicle</button>
            </form>
        </div>
    </div>

    <form id="postNavForm" action="main" method="POST" style="display:none;">
        <input type="hidden" name="action" id="postNavAction">
    </form>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile/navigation.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile/profile-modal.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile/vehicle-modal.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/profile/toast.js"></script>
</body>
</html>
