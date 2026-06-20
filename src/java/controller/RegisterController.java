package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Account;
import dto.Customer;
import dto.Vehicle;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "RegisterController", urlPatterns = { "/RegisterController" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class RegisterController extends HttpServlet {

    // Hàm tiện ích lấy tên file
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    // Hàm lưu file vào ổ đĩa và trả về đường dẫn URL
    private String saveFileAndGetUrl(Part part, HttpServletRequest request) throws IOException {
        String fileName = getFileName(part);
        if (fileName == null || fileName.trim().isEmpty()) {
            return null; // Không upload ảnh
        }

        // Thư mục lưu trên Server đã chuyển ra ngoài ổ đĩa D: để không bị mất khi Clean
        // & Build
        String uploadFilePath = "D:" + File.separator + "auto_wash_uploads";

        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs(); // Tạo thư mục nếu chưa có
        }

        // Tạo tên file ngẫu nhiên để tránh trùng lặp
        String uniqueFileName = UUID.randomUUID().toString() + "_" + Paths.get(fileName).getFileName().toString();
        part.write(uploadFilePath + File.separator + uniqueFileName);

        // Vẫn trả về tiền tố uploads/ để ImageServlet có thể bắt được URL
        return "uploads/" + uniqueFileName;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");

            // Backend validation
            if (!password.equals(confirmPassword)) {
                request.setAttribute("ERROR_PW", "Passwords do not match.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            AccountDAO accountDAO = new AccountDAO();
            // Normalize phone and validate
            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("ERROR_PHONE", "Phone is required.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            String normalizedPhone = phone.trim().replaceAll("[\\s\\-()]", "");
            if (!normalizedPhone.matches("^\\+?\\d+$")) {
                request.setAttribute("ERROR_PHONE", "Số điện thoại không hợp lệ.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            CustomerDAO customerDAOCheck = new CustomerDAO();
            if (email != null && !email.trim().isEmpty() && customerDAOCheck.checkEmailExist(email)) {
                request.setAttribute("ERROR_EMAIL", "Email đã trùng lặp.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            if (accountDAO.checkAccountExist(normalizedPhone) || customerDAOCheck.checkPhoneExist(phone)) {
                request.setAttribute("ERROR_PHONE", "Số điện thoại đã trùng lặp.");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            CustomerDAO customerDAO = new CustomerDAO();
            VehicleDAO vehicleDAO = new VehicleDAO();

            // 1. Tạo Account mới (Username là số điện thoại)
            Account newAccount = new Account();
            newAccount.setUsername(normalizedPhone);
            newAccount.setPasswordHash(password);
            newAccount.setRole("Customer");
            newAccount.setStatus("Active");

            int accountId = accountDAO.insertAccountReturnId(newAccount);
            newAccount.setAccountID(accountId);

            if (accountId > 0) {
                // 2. Tạo Customer
                Customer newCustomer = new Customer();
                newCustomer.setAccountID(accountId);
                newCustomer.setFullName(fullName);
                newCustomer.setPhone(phone);
                newCustomer.setEmail(email);
                newCustomer.setTierID(1); // Mặc định hạng 1 (Member)
                newCustomer.setTotalWashes(0);
                newCustomer.setLifetimeSpend(BigDecimal.ZERO);
                newCustomer.setCurrentPoints(0);
                newCustomer.setAvatarUrl("/assets/images/default-avatar.png");

                int customerId = customerDAO.insertCustomerReturnId(newCustomer);

                if (customerId > 0) {
                    newCustomer.setCustomerID(customerId);

                    // Auto login
                    request.getSession().setAttribute("LOGIN_USER", newAccount);
                    request.getSession().setAttribute("CUSTOMER_INFO", newCustomer);

                    // Đăng ký thành công, chuyển tới màn hình thành công
                    request.getSession().setAttribute("CURRENT_VIEW", "register-success");
                    response.sendRedirect("main");
                } else {
                    request.setAttribute("ERROR", "Lỗi tạo hồ sơ khách hàng. Vui lòng thử lại!");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("ERROR", "Email này đã được đăng ký hoặc có lỗi xảy ra!");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log("Error at RegisterController: " + e.toString());
            request.setAttribute("ERROR", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
