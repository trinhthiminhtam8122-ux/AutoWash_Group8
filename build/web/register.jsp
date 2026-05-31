<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String errorEmail = (String) request.getAttribute("ERROR_EMAIL");
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
    <style>
        :root {
            --primary: #2563eb;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --bg-body: #eef2ff;
            --border: #e5e7eb;
            --error: #ef4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        
        body { background-color: var(--bg-body); display: flex; flex-direction: column; min-height: 100vh; }

        /* Navbar */
        nav { background: white; display: flex; justify-content: space-between; align-items: center; padding: 1rem 3rem; border-bottom: 2px solid #3b82f6; }
        .brand { font-size: 1.5rem; font-weight: 800; color: black; text-decoration: none; display: flex; align-items: center; gap: 0.5rem; }
        .brand i { color: #3b82f6; font-size: 1.8rem; }
        .nav-links { display: flex; gap: 2rem; font-size: 0.95rem; font-weight: 700; }
        .nav-links a { color: var(--text-dark); text-decoration: none; transition: 0.3s; }
        .nav-links a:hover { color: var(--primary); }
        .nav-buttons { display: flex; gap: 1rem; }
        .btn-outline { border: 2px solid #3b82f6; color: #3b82f6; padding: 0.5rem 1.5rem; border-radius: 6px; font-weight: 600; text-decoration: none; }
        .btn-solid { background: #2563eb; color: white; padding: 0.5rem 1.5rem; border-radius: 6px; font-weight: 600; text-decoration: none; }

        /* Main Area */
        .main-wrapper { flex: 1; display: flex; }
        
        /* Left Column */
        .left-col { flex: 1; padding: 4rem 4rem 0 4rem; display: flex; flex-direction: column; position: relative; }
        .left-col h1 { font-size: 2.5rem; font-weight: 800; color: var(--text-dark); line-height: 1.2; margin-bottom: 1rem; }
        .left-col h1 span { color: #3b82f6; display: block; }
        .left-col p { font-size: 1.05rem; color: #4b5563; max-width: 450px; margin-bottom: 2rem; line-height: 1.6; }
        
        .feature { display: flex; gap: 1rem; margin-bottom: 1.5rem; max-width: 400px; }
        .feature-icon { width: 45px; height: 45px; background: #dbeafe; color: #2563eb; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .feature-text h3 { font-size: 1.05rem; font-weight: 700; color: var(--text-dark); margin-bottom: 0.3rem; }
        .feature-text p { font-size: 0.85rem; color: var(--text-muted); margin: 0; }
        
        .car-bg { margin-top: auto; max-width: 100%; display: block; }

        /* Right Column */
        .right-col { flex: 1; padding: 2rem 3rem; display: flex; align-items: center; justify-content: center; }
        
        .login-card { background: white; padding: 2.5rem; border-radius: 20px; width: 100%; max-width: 500px; box-shadow: 0 10px 40px rgba(0,0,0,0.05); }
        .login-card h2 { font-size: 1.8rem; font-weight: 800; margin-bottom: 0.5rem; color: var(--text-dark); }
        .login-card p.subtitle { font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.5rem; }

        .input-group { text-align: left; margin-bottom: 1rem; position: relative; }
        .input-group label { display: block; font-size: 0.75rem; font-weight: 700; color: var(--text-dark); margin-bottom: 0.4rem; }
        .input-field { width: 100%; padding: 0.75rem 1rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.9rem; outline: none; transition: 0.3s; }
        .input-field:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .input-field.error { border-color: var(--error); background: #fef2f2; }
        .eye-icon { position: absolute; right: 1rem; top: 2.2rem; color: var(--text-muted); cursor: pointer; }
        .error-text { color: var(--error); font-size: 0.75rem; margin-top: 0.3rem; display: block; font-weight: 500; }

        .options { display: flex; align-items: flex-start; gap: 0.5rem; margin-bottom: 1.5rem; font-size: 0.8rem; font-weight: 600; color: var(--text-dark); }
        .options input { margin-top: 0.2rem; cursor: pointer; width: 14px; height: 14px; accent-color: var(--primary); }
        .options a { color: var(--primary); text-decoration: none; }

        .btn-submit { width: 100%; background: var(--primary); color: white; border: none; padding: 0.9rem; border-radius: 6px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: 0.3s; margin-bottom: 1.5rem; }
        .btn-submit:hover { background: #1d4ed8; }

        .signup-link { font-size: 0.85rem; color: var(--text-dark); font-weight: 600; text-align: center; }
        .signup-link a { color: var(--primary); text-decoration: none; }

        .error-msg { background: #fee2e2; color: #ef4444; padding: 10px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; margin-bottom: 1.5rem; text-align: left;}

        /* Footer */
        footer { background: white; padding: 1.5rem 3rem; display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--text-muted); font-weight: 600; }
        .footer-links { display: flex; gap: 2rem; }
        .footer-links a { color: var(--text-dark); text-decoration: none; }

        @media (max-width: 900px) {
            .main-wrapper { flex-direction: column; }
            .left-col { padding: 2rem; }
            .right-col { padding: 2rem; }
            .nav-links { display: none; }
        }
    </style>
</head>
<body>
    <nav>
        <a href="index.jsp" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="#">Services</a>
            <a href="#">Pricing</a>
            <a href="profile.jsp">Profile</a>
        </div>
        <div class="nav-buttons">
            <a href="login.jsp" class="btn-outline">Log in</a>
            <a href="register.jsp" class="btn-solid">Register</a>
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
            
            <img src="https://cdni.iconscout.com/illustration/premium/thumb/car-wash-service-5349472-4467000.png" alt="Car Wash" class="car-bg" style="width: 100%; max-width: 500px; margin: 0 auto;">
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
                        <input type="tel" name="phone" class="input-field" placeholder="Enter your phone number" value="<%= ph %>" required>
                    </div>

                    <div class="input-group">
                        <label>Password</label>
                        <input type="password" name="password" id="pw" class="input-field <%= errorPw != null ? "error" : "" %>" placeholder="Enter your password" required>
                        <i class="fa-regular fa-eye eye-icon" onclick="togglePw('pw')"></i>
                    </div>

                    <div class="input-group">
                        <label>Confirm password</label>
                        <input type="password" name="confirmPassword" id="cpw" class="input-field <%= errorPw != null ? "error" : "" %>" placeholder="Confirm your password" required>
                        <i class="fa-regular fa-eye eye-icon" onclick="togglePw('cpw')"></i>
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
                    Already have an account? <a href="login.jsp">Log in</a>
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

    <script>
        function togglePw(id) {
            const input = document.getElementById(id);
            if (input.type === "password") {
                input.type = "text";
            } else {
                input.type = "password";
            }
        }
    </script>
</body>
</html>
