package controller;

import dao.BookingDAO;
import dto.Account;
import dto.Booking;
import java.io.IOException;
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
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("LOGIN_USER");
        
        if (acc == null || (!"Admin".equals(acc.getRole()) && !"Manager".equals(acc.getRole()) && !"Staff".equals(acc.getRole()))) {
            session.setAttribute("CURRENT_VIEW", "login");
            response.sendRedirect("main");
            return;
        }

        try {
            BookingDAO dao = new BookingDAO();
            List<Booking> list = dao.getAllBookings();
            request.setAttribute("bookings", list);
        } catch (Exception e) {
            log("Error at AdminController doGet: " + e.toString());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("LOGIN_USER");
        
        if (acc == null || (!"Admin".equals(acc.getRole()) && !"Manager".equals(acc.getRole()) && !"Staff".equals(acc.getRole()))) {
            response.sendRedirect("main");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                String newStatus = request.getParameter("status");
                
                BookingDAO dao = new BookingDAO();
                boolean success = dao.updateBookingStatus(bookingID, newStatus);
                
                if (success) {
                    session.setAttribute("SUCCESS_MSG", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("ERROR_MSG", "Cập nhật thất bại.");
                }
            } catch (Exception e) {
                log("Error at AdminController doPost: " + e.toString());
                session.setAttribute("ERROR_MSG", "Có lỗi xảy ra: " + e.getMessage());
            }
        }
        
        session.setAttribute("CURRENT_VIEW", "admin");
        response.sendRedirect("main");
    }
}
