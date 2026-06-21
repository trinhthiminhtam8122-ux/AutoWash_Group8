/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 */
@WebServlet(name = "HistoryController", urlPatterns = {"/HistoryController"})
public class HistoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
        Account account = (Account) session.getAttribute("LOGIN_USER");
        if (account == null || customer == null) {
            session.setAttribute("CURRENT_VIEW", "login");
            response.sendRedirect("main");
            return;
        }
        CustomerDAO customerDao = new CustomerDAO();
        BookingDAO bookingDao = new BookingDAO();
        try {
            bookingDao.autoCancelExpiredBookings(); 
            Customer cus = customerDao.getCustomerByAccountID(customer.getAccountID());
            if (cus != null) {
                List<Booking> bookingList = bookingDao.getBookingsByCustomer(cus.getCustomerID());
                request.setAttribute("bookings", bookingList);
                request.setAttribute("customer", customer.getFullName());
            }
        } catch (Exception e) {
            log("Error in HistoryController: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(request, response);

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