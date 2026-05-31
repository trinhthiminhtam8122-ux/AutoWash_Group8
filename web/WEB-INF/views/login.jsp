<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Login</title>
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
            <a href="javascript:void(0)" onclick="navTo('register')" class="btn-outline">Register</a>
            <a href="javascript:void(0)" onclick="navTo('login')" class="btn-solid">Log in</a>
        </div>
    </nav>

    <div class="main-wrapper">
        <!-- Left Side -->
        <div class="left-col">
            <h1>Welcome back!<span>Glad to see you again.</span></h1>
            <p>Log in to your account to manage your bookings, earn points, and enjoy exclusive offers.</p>
            
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
            
            <img src="https://cdni.iconscout.com/illustration/premium/thumb/car-wash-service-5349472-4467000.png" alt="Car Wash" class="car-bg" style="width: 100%; max-width: 500px; margin: 0 auto;">
        </div>

        <!-- Right Side -->
        <div class="right-col">
            <div class="login-card">
                <i class="fa-solid fa-car-side login-card-icon"></i>
                <h2>Log in to your account</h2>
                <p class="subtitle">Enter your details to access your account</p>

                <% if (request.getAttribute("ERROR") != null) { %>
                    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("ERROR") %></div>
                <% } %>

                <form action="LoginController" method="POST">
                    <div class="input-group">
                        <label>Email or phone number</label>
                        <i class="fa-regular fa-user input-icon"></i>
                        <input type="text" name="username" class="input-field" placeholder="Enter your email or phone number" required>
                    </div>

                    <div class="input-group">
                        <label>Password</label>
                        <i class="fa-solid fa-lock input-icon"></i>
                        <input type="password" name="password" id="password" class="input-field" placeholder="Enter your password" required>
                        <i class="fa-regular fa-eye eye-icon" onclick="togglePassword()"></i>
                    </div>

                    <div class="options">
                        <label class="remember">
                            <input type="checkbox" name="remember" style="width: 16px; height: 16px; accent-color: var(--primary);"> Remember me
                        </label>
                        <a href="#" class="forgot">Forgot password?</a>
                    </div>

                    <button type="submit" class="btn-submit">Log In</button>
                </form>

                <div class="signup-link">
                    Don't have an account? <a href="javascript:void(0)" onclick="navTo('register')">Register</a>
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
    <script>
        function navTo(action) {
            document.getElementById('postNavAction').value = action;
            document.getElementById('postNavForm').submit();
        }
        function togglePassword() {
            var x = document.getElementById("password");
            var icon = document.querySelector(".eye-icon");
            if (x.type === "password") {
                x.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                x.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/auth.js"></script>
</body>
</html>