package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.StaffDAO;
import dto.Account;
import dto.Customer;
import dto.Staff;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username"); // Dùng SĐT hoặc email/username
        String password = request.getParameter("password");
        
        try {
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.login(username, password);
            
            if (account != null) {
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", account);
                
                // Lấy thông tin user (Customer hoặc Staff) theo Role
                if ("Customer".equals(account.getRole())) {
                    CustomerDAO customerDAO = new CustomerDAO();
                    Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
                    session.setAttribute("CUSTOMER_INFO", customer);
                    response.sendRedirect("dashboard.jsp");
                } else if ("Admin".equals(account.getRole()) || "Manager".equals(account.getRole()) || "Staff".equals(account.getRole())) {
                    StaffDAO staffDAO = new StaffDAO();
                    Staff staff = staffDAO.getStaffByAccountID(account.getAccountID());
                    session.setAttribute("STAFF_INFO", staff);
                    response.sendRedirect("dashboard.jsp"); // Có thể chuyển hướng tới trang quản lý riêng
                }
            } else {
                request.setAttribute("ERROR", "Sai số điện thoại/tài khoản hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            log("Error at LoginController: " + e.toString());
            request.setAttribute("ERROR", "Hệ thống đang bảo trì, vui lòng thử lại sau!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
