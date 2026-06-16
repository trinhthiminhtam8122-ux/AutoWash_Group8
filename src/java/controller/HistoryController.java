package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "HistoryController", urlPatterns = {"/HistoryController"})
public class HistoryController extends HttpServlet {

    private static final String VIEW_PAGE = "/WEB-INF/views/history.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/main?action=login");
            return;
        }

        Account account = (Account) session.getAttribute("LOGIN_USER");
        CustomerDAO customerDAO = new CustomerDAO();
        BookingDAO bookingDAO = new BookingDAO();

        try {
            Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
            if (customer != null) {
                List<Booking> bookings = bookingDAO.getBookingsByCustomer(customer.getCustomerID());
                request.setAttribute("bookings", bookings);
                request.setAttribute("customerName", customer.getFullName());
            } 
            request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("ERROR_MSG", "Unable to load booking history. Error: " + ex.getMessage());
            request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
        
}
