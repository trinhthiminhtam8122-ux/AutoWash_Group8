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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>

    <nav>
        <a href="javascript:void(0)" onclick="navTo('home')" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
        <div class="nav-links">
            <a href="javascript:void(0)" onclick="navTo('dashboard')">Home</a>
            <a href="#">Booking</a>
            <a href="#">Services</a>
            <a href="javascript:void(0)" onclick="navTo('profile')">Profile</a>
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
            <a href="javascript:void(0)" onclick="navTo('login')" class="logout-btn" style="background: var(--primary);"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
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

    <form id="postNavForm" action="main" method="POST" style="display:none;">
        <input type="hidden" name="action" id="postNavAction">
    </form>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
