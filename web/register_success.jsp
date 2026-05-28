<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash - Success</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --text-dark: #111827;
            --text-muted: #6b7280;
            --bg-body: #f3f4f6;
            --success: #22c55e;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .auth-container {
            width: 100%;
            max-width: 400px;
            background: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }

        @media (min-width: 600px) {
            .auth-container {
                min-height: auto;
                border-radius: 20px;
                overflow: hidden;
                margin: 2rem 0;
            }
        }

        .header {
            text-align: center;
            padding: 2rem;
            margin-top: 1rem;
        }

        .logo-area {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 2rem;
        }

        .logo-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .brand-name {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-dark);
        }
        
        .success-circle {
            width: 100px;
            height: 100px;
            background: var(--success);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            margin: 0 auto 1.5rem auto;
        }

        .header h1 {
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .header p {
            font-size: 0.85rem;
            color: var(--text-muted);
            max-width: 80%;
            margin: 0 auto;
        }

        .form-content {
            padding: 0 2rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .summary-box {
            background: #f8fafc;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .summary-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1.2rem;
        }
        
        .summary-item:last-child {
            margin-bottom: 0;
        }
        
        .summary-item i {
            font-size: 1.2rem;
            color: var(--success);
            margin-top: 0.2rem;
        }
        
        .summary-text h4 {
            font-size: 0.9rem;
            color: var(--text-dark);
            margin-bottom: 0.1rem;
        }
        
        .summary-text p {
            font-size: 0.75rem;
            color: var(--text-muted);
        }

        .btn-submit {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 0.9rem;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 3rem;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-submit:hover {
            background: #1d4ed8;
        }

        .footer {
            background: #0f172a;
            color: #94a3b8;
            padding: 1.5rem;
            font-size: 0.7rem;
            display: flex;
            justify-content: space-between;
        }
        
        .footer-left { display: flex; flex-direction: column; gap: 0.5rem; flex: 1; }
        .footer-right { display: flex; flex-direction: column; gap: 0.5rem; width: 100px;}
        .footer-right div { display: flex; align-items: center; gap: 0.4rem; }
    </style>
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

            <a href="dashboard.jsp" class="btn-submit">Go to home</a>
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

</body>
</html>
