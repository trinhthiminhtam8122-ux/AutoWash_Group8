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
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
/**
 * Xử lý cancel booking với các rules:
 * 1. Chỉ cancel được booking ở trạng thái Pending.
 * 2. Phải cancel trước giờ hẹn tối thiểu 2 tiếng.
 * 3. Sau khi cancel → status = Cancelled → vehicle & slot được giải phóng.
 *
 * @author trinhthiminhtam
 */
@WebServlet(name = "CancelBookingController", urlPatterns = {"/CancelBookingController"})
public class CancelBookingController extends HttpServlet {
 
    private static final int MIN_CANCEL_HOURS_BEFORE = 2;
 
    /**
     * Chỉ chấp nhận POST — form cancel từ bookingHistory.jsp.
     * GET không được phép để tránh cancel nhầm qua link.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/main?action=history");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
 
        // 1. Kiểm tra session — chưa login thì về trang login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/main?action=login");
            return;
        }
 
        Account account = (Account) session.getAttribute("LOGIN_USER");
        CustomerDAO customerDAO = new CustomerDAO();
        BookingDAO bookingDAO = new BookingDAO();
 
        String bookingIdParam = request.getParameter("bookingID");
 
        try {
            // 2. Lấy customer từ account trong session
            Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/main?action=login");
                return;
            }
 
            // 3. Validate bookingID
            int bookingID;
            try {
                bookingID = Integer.parseInt(bookingIdParam);
            } catch (NumberFormatException ex) {
                session.setAttribute("ERROR_MSG", "Invalid booking request.");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
                return;
            }
 
            // 4. Lấy booking từ DB
            Booking booking = bookingDAO.getBookingByID(bookingID);
            if (booking == null) {
                session.setAttribute("ERROR_MSG", "Booking not found.");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
                return;
            }
 
            // 5. Kiểm tra booking thuộc đúng customer đang đăng nhập
            //    → chặn trường hợp user tự sửa bookingID trên form
            if (booking.getCustomerID() != customer.getCustomerID()) {
                session.setAttribute("ERROR_MSG", "You are not authorized to cancel this booking.");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
                return;
            }
 
            // 6. Chỉ cancel được Pending
            if (!"Pending".equals(booking.getStatus())) {
                session.setAttribute("ERROR_MSG",
                        "Only pending bookings can be cancelled. "
                        + "This booking is already " + booking.getStatus() + ".");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
                return;
            }
 
            // 7. Kiểm tra rule 2 tiếng trước giờ hẹn
            LocalDate scheduledDate = booking.getScheduledDate().toLocalDate();
            LocalTime scheduledTime = booking.getScheduledTime().toLocalTime();
            LocalDateTime scheduledDateTime = LocalDateTime.of(scheduledDate, scheduledTime);
            LocalDateTime cancelDeadline = scheduledDateTime.minusHours(MIN_CANCEL_HOURS_BEFORE);
 
            if (LocalDateTime.now().isAfter(cancelDeadline)) {
                session.setAttribute("ERROR_MSG",
                        "Cancellation is not allowed within " + MIN_CANCEL_HOURS_BEFORE
                        + " hours of the scheduled time. Please contact us directly for assistance.");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
                return;
            }
 
            // 8. Thực hiện cancel
            //    cancelBooking() ở tầng DB cũng WHERE customerID + Status='Pending'
            //    → double-check, tránh race condition
            boolean cancelled = bookingDAO.cancelBooking(bookingID, customer.getCustomerID());
            if (cancelled) {
                session.setAttribute("SUCCESS_MSG",
                        "Booking #" + bookingID + " has been cancelled successfully. "
                        + "Your vehicle and time slot are now available for new bookings.");
            } else {
                session.setAttribute("ERROR_MSG",
                        "Unable to cancel booking. It may have already been processed. "
                        + "Please contact support if you need further help.");
            }
 
        } catch (ClassNotFoundException | SQLException ex) {
            session.setAttribute("ERROR_MSG", "An unexpected error occurred: " + ex.getMessage());
        }
 
        response.sendRedirect(request.getContextPath() + "/main?action=history");
    }
 
    @Override
    public String getServletInfo() {
        return "Handles booking cancellation for AutoWash customers";
    }
}