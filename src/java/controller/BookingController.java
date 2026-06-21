package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.ServiceDAO;
import dao.VehicleDAO;
import dao.TierDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import dto.Service;
import dto.Vehicle;
import dto.Tier;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/BookingController"})
public class BookingController extends HttpServlet {

    private static final String VIEW_PAGE = "/WEB-INF/views/booking.jsp";

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

        try {
            Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/main?action=login");
                return;
            }
            forwardBookingPage(request, response, customer);
        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("ERROR_MSG", "Unable to load booking page. Please try again later.");
            request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        VehicleDAO vehicleDAO = new VehicleDAO();
        ServiceDAO serviceDAO = new ServiceDAO();
        BookingDAO bookingDAO = new BookingDAO();

        String vehicleIdValue = request.getParameter("vehicleID");
        String serviceIdValue = request.getParameter("serviceID");
        String scheduledDateValue = request.getParameter("scheduledDate");
        String scheduledTimeValue = request.getParameter("scheduledTime");

        try {
            Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/main?action=login");
                return;
            }

            // --- Validate vehicleID ---
            int vehicleID;
            try {
                vehicleID = Integer.parseInt(vehicleIdValue);
            } catch (NumberFormatException ex) {
                request.setAttribute("ERROR_MSG", "Please select a valid vehicle.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Validate serviceID ---
            int serviceID;
            try {
                serviceID = Integer.parseInt(serviceIdValue);
            } catch (NumberFormatException ex) {
                request.setAttribute("ERROR_MSG", "Please select a valid wash service.");
                forwardBookingPage(request, response, customer);
                return;
            }

            Service selectedService = serviceDAO.getServiceByID(serviceID);
            if (selectedService == null) {
                request.setAttribute("ERROR_MSG", "The selected service is not available.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Validate date ---
            if (scheduledDateValue == null || scheduledDateValue.trim().isEmpty()) {
                request.setAttribute("ERROR_MSG", "Please choose a booking date.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Validate time ---
            if (scheduledTimeValue == null || scheduledTimeValue.trim().isEmpty()) {
                request.setAttribute("ERROR_MSG", "Please select a time slot.");
                forwardBookingPage(request, response, customer);
                return;
            }

            LocalDate scheduledDate;
            LocalTime scheduledTime;
            try {
                scheduledDate = LocalDate.parse(scheduledDateValue);
                scheduledTime = LocalTime.parse(scheduledTimeValue);
            } catch (DateTimeParseException ex) {
                request.setAttribute("ERROR_MSG", "Please select a valid date and time.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Date not in the past ---
            if (scheduledDate.isBefore(LocalDate.now())) {
                request.setAttribute("ERROR_MSG", "Booking date cannot be in the past.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Tier booking window ---
            TierDAO tierDAO = new TierDAO();
            Tier tier = tierDAO.getTierByID(customer.getTierID());
            int bookingWindow = (tier != null) ? tier.getBookingWindow() : 7;
            LocalDate maxDate = LocalDate.now().plusDays(bookingWindow);
            if (scheduledDate.isAfter(maxDate)) {
                String tierName = (tier != null) ? tier.getTierName() : "Member";
                request.setAttribute("ERROR_MSG",
                        "You are " + tierName + ". You can only book " + bookingWindow + " days ahead.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Rule 1: Vehicle không được có booking Pending ---
            if (bookingDAO.hasPendingBookingForVehicle(vehicleID)) {
                request.setAttribute("ERROR_MSG",
                        "This vehicle already has a pending booking. Please cancel it before creating a new one.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Rule 2: Kiểm tra slot đã có booking Pending chưa ---
            Date sqlDate = Date.valueOf(scheduledDate);
            Time sqlTime = Time.valueOf(scheduledTime);
            if (bookingDAO.isSlotTaken(sqlDate, sqlTime)) {
                request.setAttribute("ERROR_MSG",
                        "This time slot is already booked. Please choose a different date or time.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Verify vehicle belongs to customer ---
            Vehicle vehicle = vehicleDAO.getVehicleByID(vehicleID, customer.getCustomerID());
            if (vehicle == null) {
                request.setAttribute("ERROR_MSG", "Selected vehicle is not available for booking.");
                forwardBookingPage(request, response, customer);
                return;
            }

            // --- Create booking ---
            Booking booking = new Booking(
                    0,
                    customer.getCustomerID(),
                    vehicleID,
                    selectedService.getServiceName(),
                    selectedService.getPrice(),
                    vehicle.getLicensePlate(),
                    customer.getFullName(),
                    sqlDate,
                    sqlTime,
                    null,
                    "Pending",
                    serviceID);

            boolean created = bookingDAO.createBooking(booking);
            if (created) {
                session.setAttribute("SUCCESS_MSG",
                        "Booking created successfully. We will notify you once the wash is confirmed.");
                response.sendRedirect(request.getContextPath() + "/main?action=history");
            } else {
                request.setAttribute("ERROR_MSG", "Unable to create booking at this time. Please try again.");
                forwardBookingPage(request, response, customer);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("ERROR_MSG", "An unexpected error occurred: " + ex.getMessage());
            Customer customer = null;
            try {
                customer = customerDAO.getCustomerByAccountID(account.getAccountID());
            } catch (Exception ignore) {
            }
            if (customer != null) {
                forwardBookingPage(request, response, customer);
            } else {
                response.sendRedirect(request.getContextPath() + "/main?action=login");
            }
        }
    }

    // -----------------------------------------------------------------------
    // Helper
    // -----------------------------------------------------------------------
    private void forwardBookingPage(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            BookingDAO bookingDAO = new BookingDAO();
            bookingDAO.autoCancelExpiredBookings();
            VehicleDAO vehicleDAO = new VehicleDAO();
            ServiceDAO serviceDAO = new ServiceDAO();
            TierDAO tierDAO = new TierDAO();

            Tier tier = tierDAO.getTierByID(customer.getTierID());

            request.setAttribute("vehicles", vehicleDAO.getVehiclesByCustomerID(customer.getCustomerID()));
            request.setAttribute("serviceList", serviceDAO.getAllActiveServices());
            request.setAttribute("customerName", customer.getFullName());
            request.setAttribute("tierName", tier != null ? tier.getTierName() : "Member");
            request.setAttribute("bookingWindow", tier != null ? tier.getBookingWindow() : 7);
        } catch (ClassNotFoundException | SQLException ex) {
            request.setAttribute("ERROR_MSG", "Unable to load booking options. Please reload the page.");
        }
        request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
    }

}