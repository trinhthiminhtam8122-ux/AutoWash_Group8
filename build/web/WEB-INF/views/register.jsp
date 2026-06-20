<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String errorEmail = (String) request.getAttribute("ERROR_EMAIL");
    String errorPhone = (String) request.getAttribute("ERROR_PHONE");
    String errorPw = (String) request.getAttribute("ERROR_PW");
    String errorGeneral = (String) request.getAttribute("ERROR");
    
    String fn = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
    String em = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    String ph = request.getAttribute("phone") != null ? (String) request.getAttribute("phone") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <nav>
        <a href="javascript:void(0)" onclick="navTo('home')" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
        <div class="nav-links">
            <a href="javascript:void(0)" onclick="navTo('home')">Home</a>
            <a href="#">Services</a>
            <a href="#">Pricing</a>
            <a href="javascript:void(0)" onclick="navTo('profile')">Profile</a>
        </div>
        <div class="nav-buttons">
            <a href="javascript:void(0)" onclick="navTo('login')" class="btn-outline">Log in</a>
            <a href="javascript:void(0)" onclick="navTo('register')" class="btn-solid">Register</a>
        </div>
    </nav>

    <div class="main-wrapper">
        <!-- Left Side -->
        <div class="left-col">
            <h1>Create your account<span>and get started!</span></h1>
            <p>Join AutoWash and enjoy the best car care experience. Fast, easy, and reliable.</p>
            
            <div class="feature">
                <div class="feature-icon"><i class="fa-solid fa-medal"></i></div>
                <div class="feature-text">
                    <h3>Earn Points</h3>
                    <p>Join our loyalty program and earn points every time.</p>
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon"><i class="fa-regular fa-calendar-check"></i></div>
                <div class="feature-text">
                    <h3>Easy Booking</h3>
                    <p>Book your car wash in just a few clicks.</p>
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon"><i class="fa-solid fa-shield-halved"></i></div>
                <div class="feature-text">
                    <h3>Secure & Reliable</h3>
                    <p>Your data is safe with us. We care about your privacy.</p>
                </div>
            </div>
            
        </div>

        <!-- Right Side -->
        <div class="right-col">
            <div class="login-card">
                <h2>Register</h2>
                <p class="subtitle">Fill in the information below to create your account</p>

                <% if (errorGeneral != null) { %>
                    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= errorGeneral %></div>
                <% } %>

                <form action="RegisterController" method="POST">
                    <input type="hidden" name="totalVehicles" value="0">
                    
                    <div class="input-group">
                        <label>Full name</label>
                        <input type="text" name="fullName" class="input-field" placeholder="Enter your full name" value="<%= fn %>" required>
                    </div>

                    <div class="input-group">
                        <label>Email address</label>
                        <input type="email" name="email" class="input-field <%= errorEmail != null ? "error" : "" %>" placeholder="Enter your email" value="<%= em %>" required>
                        <% if (errorEmail != null) { %>
                            <span class="error-text"><%= errorEmail %></span>
                        <% } %>
                    </div>

                    <div class="input-group">
                        <label>Phone number</label>
                        <input type="tel" name="phone" class="input-field <%= errorPhone != null ? "error" : "" %>" placeholder="Enter your phone number" value="<%= ph %>" required>
                        <% if (errorPhone != null) { %>
                            <span class="error-text"><%= errorPhone %></span>
                        <% } %>
                    </div>

                    <div class="input-group">
                        <label>Password</label>
                        <input type="password" name="password" id="pw" class="input-field <%= errorPw != null ? "error" : "" %>" placeholder="Enter your password" required>
                        <i class="fa-regular fa-eye eye-icon" onclick="togglePassword('pw')"></i>
                    </div>

                    <div class="input-group">
                        <label>Confirm password</label>
                        <input type="password" name="confirmPassword" id="cpw" class="input-field <%= errorPw != null ? "error" : "" %>" placeholder="Confirm your password" required>
                        <i class="fa-regular fa-eye eye-icon" onclick="togglePassword('cpw')"></i>
                        <% if (errorPw != null) { %>
                            <span class="error-text"><%= errorPw %></span>
                        <% } %>
                    </div>

                    <div class="options">
                        <input type="checkbox" id="tos" required>
                        <label for="tos">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
                    </div>

                    <button type="submit" class="btn-submit">Create Account</button>
                </form>

                <div class="signup-link">
                    Already have an account? <a href="javascript:void(0)" onclick="navTo('login')">Log in</a>
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

    <form id="postNavForm" action="main" method="POST" style="display:none;">
        <input type="hidden" name="action" id="postNavAction">
    </form>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/auth.js"></script>
</body>
</html>
