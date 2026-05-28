<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%
    // Access without login allowed (Guest Mode)
    Account acc = (Account) session.getAttribute("LOGIN_USER");
    Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
    
    String userName = "Guest";
    int currentPoints = 0;
    String tierName = "Gold member";
    
    if (customer != null) {
        userName = customer.getFullName();
        currentPoints = customer.getCurrentPoints();
        if (customer.getTierID() == 1) tierName = "Bronze member";
        else if (customer.getTierID() == 2) tierName = "Silver member";
        else if (customer.getTierID() == 3) tierName = "Gold member";
        else if (customer.getTierID() == 4) tierName = "Platinum member";
    } else if (acc != null) {
        userName = acc.getUsername();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #60a5fa;
            --primary-dark: #1e3a8a;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --bg-light: #f3f4f6;
            --bg-white: #ffffff;
            --accent-cyan: #06b6d4;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-dark);
        }

        /* Navbar */
        nav {
            background: var(--bg-white);
            padding: 1rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .brand {
            font-size: 1.5rem;
            font-weight: 800;
            color: black;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            font-size: 0.9rem;
            font-weight: 500;
        }
        .nav-links a {
            text-decoration: none;
            color: var(--text-dark);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .logout-btn {
            background: #ef4444;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: 0.3s;
        }
        
        .logout-btn:hover {
            background: #dc2626;
        }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
        }

        /* Hero Banner */
        .hero-card {
            grid-column: 1 / -1;
            background: linear-gradient(to right, rgba(0,0,0,0.8), rgba(0,0,0,0.3)), url('https://images.unsplash.com/photo-1601362840469-51e4d8d58785?auto=format&fit=crop&w=1200&q=80') center/cover;
            border-radius: 1.5rem;
            padding: 3rem;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .hero-left h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .hero-left p {
            max-width: 400px;
            color: #d1d5db;
            line-height: 1.6;
            margin-bottom: 2rem;
            font-size: 0.95rem;
        }

        .hero-actions {
            display: flex;
            gap: 1rem;
        }

        .btn-primary {
            background: #38bdf8;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }

        .btn-outline {
            background: transparent;
            color: white;
            border: 1px solid white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
        }

        .hero-right {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            padding: 1.5rem;
            border-radius: 1rem;
            text-align: right;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .tier-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 700;
            display: inline-block;
            margin-bottom: 1rem;
        }
        .tier-Bronze { background: #cd7f32; color: #fff; }
        .tier-Silver { background: #e2e8f0; color: #475569; }
        .tier-Gold { background: #fbbf24; color: #78350f; }
        .tier-Platinum { background: #e5e7eb; color: #1f2937; box-shadow: inset 0 0 5px rgba(0,0,0,0.1); border: 1px solid #d1d5db; }

        .points {
            font-size: 3rem;
            font-weight: 800;
            line-height: 1;
        }

        .points-label {
            color: #d1d5db;
            font-size: 0.9rem;
        }

        /* Sections */
        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-title a {
            font-size: 0.9rem;
            color: var(--primary);
            text-decoration: none;
        }

        /* Cards Layout */
        .services-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .card {
            background: var(--bg-white);
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .card-service {
            background: #f0fdf4;
            border: 1px solid #dcfce7;
        }
        
        .card-service:nth-child(2) {
            background: #eff6ff;
            border: 1px solid #dbeafe;
        }

        .service-icon {
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            color: var(--primary);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .service-name {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .service-desc {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 1rem;
        }

        .service-price {
            font-weight: 800;
            color: var(--primary);
            font-size: 1.1rem;
        }

        /* Banner Offer */
        .offer-banner {
            background: linear-gradient(135deg, #38bdf8, #06b6d4);
            border-radius: 1rem;
            padding: 1.5rem;
            color: white;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        /* Vehicle Status */
        .status-stepper {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .step {
            display: flex;
            gap: 1rem;
        }

        .step-number {
            width: 32px;
            height: 32px;
            background: var(--primary-light);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        
        .step.active .step-number {
            background: var(--primary);
            box-shadow: 0 0 0 4px #dbeafe;
        }

        .step-info h4 {
            font-size: 1rem;
            margin-bottom: 0.25rem;
        }

        .step-info p {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        /* Footer Banner */
        .bottom-banner {
            grid-column: 1 / -1;
            background: #0f172a;
            border-radius: 1rem;
            padding: 2rem;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
            .hero-card {
                flex-direction: column;
                gap: 2rem;
                text-align: center;
            }
            .hero-right {
                text-align: center;
            }
            .nav-links {
                display: none; /* Hide on mobile for simplicity */
            }
        }
    </style>
</head>
<body>

    <nav>
        <div class="brand">Auto<span style="color: #2563eb;">Wash</span></div>
        <div class="nav-links">
            <a href="dashboard.jsp">Home</a>
            <a href="#">Booking</a>
            <a href="#">Services</a>
            <a href="profile.jsp">Profile</a>
        </div>
        <div class="nav-right">
            <div style="display: flex; align-items: center; gap: 0.5rem;">
                <% if (customer != null && customer.getAvatarUrl() != null && !customer.getAvatarUrl().isEmpty()) { %>
                    <img src="<%= request.getContextPath() + (customer.getAvatarUrl().startsWith("/") ? "" : "/") + customer.getAvatarUrl() %>" alt="Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                <% } else { %>
                    <i class="fa-regular fa-user"></i>
                <% } %>
                <span><%= userName %></span>
            </div>
            <% if (acc != null) { %>
            <a href="LogoutController" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
            <% } else { %>
            <a href="login.jsp" class="logout-btn" style="background: var(--primary);"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
            <% } %>
        </div>
    </nav>

    <div class="container">
        <!-- Hero Section -->
        <div class="hero-card">
            <div class="hero-left">
                <div style="background: rgba(255,255,255,0.2); display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.8rem; margin-bottom: 1rem;">
                    Welcome Back 👋
                </div>
                <h1>Hello, <%= userName %></h1>
                <p>Manage your car wash bookings, track your vehicle cleaning progress, collect loyalty rewards, and enjoy premium membership benefits all in one smart dashboard.</p>
                <div class="hero-actions">
                    <button class="btn-primary">Quick Booking</button>
                    <button class="btn-outline">View Promotions</button>
                </div>
            </div>
            <div class="hero-right">
                <div style="font-size: 0.9rem; margin-bottom: 0.5rem;">Membership Tier</div>
                <div class="tier-badge tier-<%= tierName.replace(" member", "") %>"><%= tierName.replace(" member", "").toUpperCase() %></div>
                <div class="points"><%= String.format("%,d", currentPoints) %></div>
                <div class="points-label">Loyalty Points Available</div>
            </div>
        </div>

        <!-- Left Column -->
        <div class="left-col">
            <div class="section-title">
                Available Services <a href="#">See All</a>
            </div>
            <div class="services-grid">
                <div class="card card-service" style="background: #f0fdf4; border-color: #dcfce7;">
                    <div class="service-icon"><i class="fa-solid fa-car"></i></div>
                    <div class="service-name">Basic Wash</div>
                    <div class="service-desc">Fast exterior cleaning service with premium foam wash.</div>
                    <div class="service-price">120.000đ</div>
                </div>
                <div class="card card-service" style="background: #eff6ff; border-color: #dbeafe;">
                    <div class="service-icon"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
                    <div class="service-name">Premium Wash</div>
                    <div class="service-desc">Full detailing package with wax protection and shine coating.</div>
                    <div class="service-price">350.000đ</div>
                </div>
            </div>

            <div class="offer-banner">
                <div style="background: rgba(255,255,255,0.3); display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.7rem; font-weight: 700; margin-bottom: 0.5rem;">LIMITED OFFER</div>
                <h2 style="font-size: 1.5rem; margin-bottom: 0.5rem;">20% OFF Premium Wash</h2>
                <p style="font-size: 0.85rem; margin-bottom: 1rem; opacity: 0.9;">Use voucher code GOLD20 and earn double loyalty points for all premium bookings this week.</p>
                <button style="background: white; color: #06b6d4; border: none; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 700; cursor: pointer;">Claim Voucher</button>
            </div>
        </div>

        <!-- Right Column -->
        <div class="right-col">
            <div class="card" style="margin-bottom: 1.5rem;">
                <div class="section-title">Vehicle Status</div>
                <div class="status-stepper">
                    <div class="step">
                        <div class="step-number">1</div>
                        <div class="step-info">
                            <h4>Vehicle Checked In</h4>
                            <p>Your car has arrived at the washing station.</p>
                        </div>
                    </div>
                    <div class="step active">
                        <div class="step-number">2</div>
                        <div class="step-info">
                            <h4 style="color: var(--primary);">Exterior Washing</h4>
                            <p>High-pressure cleaning and foam wash in progress.</p>
                        </div>
                    </div>
                    <div class="step">
                        <div class="step-number" style="background: #e5e7eb; color: #9ca3af;">3</div>
                        <div class="step-info">
                            <h4 style="color: #9ca3af;">Drying & Finishing</h4>
                            <p>Estimated completion in 15 minutes.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="section-title">Loyalty Rewards</div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; border-bottom: 1px solid var(--border); padding-bottom: 1rem;">
                    <div>
                        <div style="font-weight: 700; font-size: 0.9rem; color: var(--primary);">Current Points</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">Earn more by booking</div>
                    </div>
                    <div style="font-weight: 800;"><%=(customer != null ? customer.getCurrentPoints() : "2,450")%></div>
                </div>
                <div style="display: flex; justify-content: space-between; padding-top: 1rem;">
                    <div>
                        <div style="font-weight: 700; font-size: 0.9rem; color: var(--primary);">Free Wash Reward</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">Unlock at 3,000 points</div>
                    </div>
                    <div style="font-weight: 800;">81%</div>
                </div>
            </div>
        </div>

        <!-- Bottom Banner -->
        <div class="bottom-banner">
            <div>
                <h2 style="font-size: 1.8rem; margin-bottom: 0.5rem;">Drive Clean. Drive Premium.</h2>
                <p style="color: #94a3b8; font-size: 0.9rem; max-width: 500px;">Enjoy AI-powered booking, premium car care services, loyalty rewards, and exclusive membership benefits with AutoWash Pro Dashboard.</p>
            </div>
            <button class="btn-primary" style="background: #06b6d4;">Book Service Now</button>
        </div>
    </div>

</body>
</html>
