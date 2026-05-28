<%@page import="java.sql.Connection"%>
<%@page import="dbutils.DBUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kiểm tra kết nối Database</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; text-align: center; }
        .success { color: #16a34a; font-weight: bold; background: #dcfce7; padding: 15px; border-radius: 8px; display: inline-block; }
        .error { color: #dc2626; font-weight: bold; background: #fee2e2; padding: 15px; border-radius: 8px; display: inline-block; }
        .error-detail { color: #7f1d1d; text-align: left; background: #fef2f2; padding: 10px; margin-top: 15px; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <h2>🚀 Database Connection Test 🚀</h2>
    <div style="margin-top: 20px;">
        <%
            try {
                Connection conn = DBUtils.getConnection();
                if (conn != null) {
                    out.println("<div class='success'>✅ Chúc mừng! Ứng dụng đã kết nối thành công tới Database CarWashDB!</div>");
                    conn.close(); // Nhớ đóng kết nối sau khi test
                } else {
                    out.println("<div class='error'>❌ Không thể kết nối. (Connection trả về Null)</div>");
                }
            } catch (ClassNotFoundException e) {
                out.println("<div class='error'>❌ Thiếu thư viện JDBC Driver (sqljdbc4.jar / mssql-jdbc.jar)</div>");
                out.println("<div class='error-detail'>Chi tiết lỗi: " + e.getMessage() + "<br/>Vui lòng chép file thư viện JDBC vào thư mục WEB-INF/lib.</div>");
            } catch (Exception e) {
                out.println("<div class='error'>❌ Lỗi kết nối (Sai thông tin SA, sai pass, hoặc SQL Server chưa bật TCP/IP)</div>");
                out.println("<div class='error-detail'>Chi tiết lỗi: " + e.getMessage() + "</div>");
            }
        %>
    </div>
    
    <div style="margin-top: 30px;">
        <a href="index.jsp" style="text-decoration: none; padding: 10px 20px; background: #2563eb; color: white; border-radius: 5px;">Quay lại trang chủ</a>
    </div>
</body>
</html>
