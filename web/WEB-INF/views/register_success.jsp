<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Success</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/success.css">
</head>
<body>

    <div class="auth-container">

        <div class="header">
            <div class="logo-area">
                <i class="fa-solid fa-car logo-icon"></i>
                <div class="brand-name">AutoWash</div>
            </div>
            
            <div class="success-circle">
                <i class="fa-solid fa-check"></i>
            </div>
            
            <h1>Account created!</h1>
            <p>Welcome to AutoWash. You have been logged in automatically.</p>
        </div>

        <div class="form-content">
            <div class="summary-box">
                <div class="summary-item">
                    <i class="fa-regular fa-user"></i>
                    <div class="summary-text">
                        <h4>Account created</h4>
                    </div>
                </div>
                <div class="summary-item">
                    <i class="fa-regular fa-star"></i>
                    <div class="summary-text">
                        <h4>Loyalty profile created</h4>
                        <p>Basic member</p>
                    </div>
                </div>
                <div class="summary-item">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                    <div class="summary-text">
                        <h4>Logged in automatically</h4>
                    </div>
                </div>
            </div>

            <a href="javascript:void(0)" onclick="navTo('dashboard')" class="btn-submit">Go to home</a>
        </div>

        <div class="footer">
            <div class="footer-left">
                <p>📍 123 St T, Duong 3/2, Khu Cong Nghe Cao Q.9, Ho Chi Minh City, TP. Thu Duc, VN</p>
                <p>📞 0123456789</p>
                <p>✉️ autowash@gmail.com</p>
            </div>
            <div class="footer-right">
                <div><i class="fa-brands fa-youtube"></i> Youtube</div>
                <div><i class="fa-brands fa-linkedin"></i> LinkedIn</div>
                <div><i class="fa-brands fa-instagram"></i> Instagram</div>
                <div><i class="fa-brands fa-facebook"></i> Facebook</div>
            </div>
        </div>
    </div>

    <form id="postNavForm" action="main" method="POST" style="display:none;">
        <input type="hidden" name="action" id="postNavAction">
    </form>
    <script>
        function navTo(action) {
            document.getElementById('postNavAction').value = action;
            document.getElementById('postNavForm').submit();
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
