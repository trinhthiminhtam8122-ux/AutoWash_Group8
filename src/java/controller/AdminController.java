package controller;

import dao.BookingDAO;
import dto.Account;
import dto.AdminBookingDTO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        if (!isAdmin(session)) {
            session.setAttribute("CURRENT_VIEW", "login");
            response.sendRedirect("main");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "today";
        }

        BookingDAO dao = new BookingDAO();
        try {
            if ("all".equals(action)) {
                request.setAttribute("bookings", dao.getAllBookings());
                request.setAttribute("activePage", "all");
                request.setAttribute("pageTitle", "All Bookings");
            } else {
                List<AdminBookingDTO> todayBookings = dao.getTodayBookings();
                AdminBookingDTO stationBooking = dao.getStationOneBooking();
                request.setAttribute("bookings", todayBookings);
                request.setAttribute("counts", dao.getTodayBookingCounts());
                request.setAttribute("stationBooking", stationBooking);
                request.setAttribute("stationBusy", stationBooking != null);
                request.setAttribute("activePage", "today");
                request.setAttribute("pageTitle", "Today Bookings");
            }
        } catch (Exception e) {
            log("Error at AdminController doGet: " + e.toString(), e);
            request.setAttribute("bookings", Collections.emptyList());
            request.setAttribute("activePage", "all".equals(action) ? "all" : "today");
            request.setAttribute("pageTitle", "all".equals(action) ? "All Bookings" : "Today Bookings");
            request.setAttribute("ERROR_MSG", "Cannot load booking data. Please check database columns.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (!isAdmin(session)) {
            session.setAttribute("CURRENT_VIEW", "login");
            response.sendRedirect("main");
            return;
        }

        String action = request.getParameter("action");
        String bookingIDValue = request.getParameter("bookingID");

        try {
            int bookingID = Integer.parseInt(bookingIDValue);
            BookingDAO dao = new BookingDAO();
            boolean success = false;

            if ("checkIn".equals(action)) {
                success = dao.checkInBooking(bookingID);
                session.setAttribute(success ? "SUCCESS_MSG" : "ERROR_MSG",
                        success ? "Check-in successful." : "Cannot check in. Station 1 may be busy or booking is not valid.");
            } else if ("checkOut".equals(action)) {
                success = dao.checkOutBooking(bookingID);
                session.setAttribute(success ? "SUCCESS_MSG" : "ERROR_MSG",
                        success ? "Check-out successful." : "Cannot check out before the timer ends.");
            }
        } catch (Exception e) {
            log("Error at AdminController doPost: " + e.toString(), e);
            session.setAttribute("ERROR_MSG", "Action failed. Please try again.");
        }

        session.setAttribute("CURRENT_VIEW", "admin");
        response.sendRedirect(request.getContextPath() + "/AdminController?action=today");
    }

    private boolean isAdmin(HttpSession session) {
        Account acc = (Account) session.getAttribute("LOGIN_USER");
        return acc != null && "Admin".equals(acc.getRole());
    }
}
