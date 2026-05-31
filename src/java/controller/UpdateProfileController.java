package controller;

import dao.CustomerDAO;
import dto.Account;
import dto.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateProfileController", urlPatterns = {"/UpdateProfileController"})
public class UpdateProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
        Account account = (Account) session.getAttribute("LOGIN_USER");

        if (customer == null || account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        
        // Prevent phone number from being modified by ignoring the request parameter
        String phone    = customer.getPhone(); 
        if (phone == null) {
            phone = "N/A";
        }

        // --- Validation ---
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("ERROR_MSG", "Full name cannot be empty.");
            response.sendRedirect("profile.jsp");
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("ERROR_MSG", "Email cannot be empty.");
            response.sendRedirect("profile.jsp");
            return;
        }
        // Basic email format check
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            session.setAttribute("ERROR_MSG", "Invalid email format.");
            response.sendRedirect("profile.jsp");
            return;
        }

        try {
            CustomerDAO cDao = new CustomerDAO();

            // Check email uniqueness (exclude current customer)
            if (cDao.checkEmailExist(customer.getCustomerID(), email)) {
                session.setAttribute("ERROR_MSG", "Email already used by another account.");
                response.sendRedirect("profile.jsp");
                return;
            }

            boolean updated = cDao.updateCustomerProfile(
                    customer.getCustomerID(),
                    fullName.trim(),
                    email.trim(),
                    phone
            );

            if (updated) {
                // Refresh session with new values
                customer.setFullName(fullName.trim());
                customer.setEmail(email.trim());
                customer.setPhone(phone.trim());
                session.setAttribute("CUSTOMER_INFO", customer);
                session.setAttribute("SUCCESS_MSG", "Profile updated successfully!");
            } else {
                session.setAttribute("ERROR_MSG", "Failed to update profile. Please try again.");
            }
        } catch (Exception e) {
            log("Error at UpdateProfileController: " + e.toString());
            session.setAttribute("ERROR_MSG", "An error occurred. Please try again.");
        }

        response.sendRedirect("profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("profile.jsp");
    }
}
