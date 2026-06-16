package dao;

import dbutils.DBUtils;
import dto.Booking;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO Booking (CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime,ServiceID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stm.setInt(1, booking.getCustomerID());
            stm.setInt(2, booking.getVehicleID());

            stm.setString(3, booking.getServiceType());
            stm.setBigDecimal(4, booking.getPrice());
            stm.setString(5, booking.getVehiclePlateSnapshot());
            stm.setString(6, booking.getCustomerNameSnapshot());
            stm.setDate(7, booking.getScheduledDate());
            stm.setTime(8, booking.getScheduledTime());
            stm.setInt(9, booking.getServiceID());
            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stm.getGeneratedKeys()) {
                    if (rs.next()) {
                        booking.setBookingID(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public List<Booking> getBookingsByCustomer(int customerID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT BookingID, CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime, BookingDate, Status, ServiceID "
                + "FROM Booking WHERE CustomerID = ? ORDER BY ScheduledDate DESC, ScheduledTime DESC";
        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, customerID);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(new Booking(
                            rs.getInt("BookingID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("VehicleID"),
                            rs.getString("ServiceType"),
                            rs.getBigDecimal("Price"),
                            rs.getString("VehiclePlateSnapshot"),
                            rs.getString("CustomerNameSnapshot"),
                            rs.getDate("ScheduledDate"),
                            rs.getTime("ScheduledTime"),
                            rs.getTimestamp("BookingDate"), // <--- Đổi ở đây
                            rs.getString("Status"),
                            rs.getInt("ServiceID")));
                }
            }
        }
        return bookings;
    }


    public boolean hasActiveBookingForVehicle(int vehicleID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT 1 FROM Booking WHERE VehicleID = ? AND Status IN ('Pending', 'Confirmed', 'Washing')";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, vehicleID);
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Booking> getAllBookings() throws ClassNotFoundException, SQLException {
        String sql = "SELECT BookingID, CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime, BookingDate, Status, ServiceID "
                + "FROM Booking ORDER BY ScheduledDate DESC, ScheduledTime DESC, BookingDate DESC";
        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(new Booking(
                            rs.getInt("BookingID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("VehicleID"),
                            rs.getString("ServiceType"),
                            rs.getBigDecimal("Price"),
                            rs.getString("VehiclePlateSnapshot"),
                            rs.getString("CustomerNameSnapshot"),
                            rs.getDate("ScheduledDate"),
                            rs.getTime("ScheduledTime"),
                            rs.getTimestamp("BookingDate"),
                            rs.getString("Status"),
                            rs.getInt("ServiceID")));
                }
            }
        }
        return bookings;
    }

    public boolean updateBookingStatus(int bookingID, String status) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking SET Status = ? WHERE BookingID = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, bookingID);
            return stm.executeUpdate() > 0;
        }
    }
}
