package dao;

import dbutils.DBUtils;
import dto.AdminBookingCounts;
import dto.AdminBookingDTO;
import dto.Booking;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean createBooking(Booking booking) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO Booking (CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime, ServiceID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, customerID);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapRow(rs));
                }
            }
        }
        return bookings;
    }

    public Booking getBookingByID(int bookingID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT BookingID, CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime, BookingDate, Status, ServiceID "
                + "FROM Booking WHERE BookingID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, bookingID);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * Chỉ chặn khi vehicle đang có booking ở trạng thái Pending. Confirmed,
     * Washing, Completed, Cancelled đều cho phép đặt tiếp.
     */
    public boolean hasPendingBookingForVehicle(int vehicleID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT 1 FROM Booking WHERE VehicleID = ? AND Status = 'Pending'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, vehicleID);
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra slot (ngày + giờ) đã có booking Pending chưa. Nếu đã có thì
     * không cho phép khách khác đặt cùng slot. Booking đã Cancelled được coi là
     * slot trống (giải phóng slot).
     */
    public boolean isSlotTaken(Date scheduledDate, Time scheduledTime) throws ClassNotFoundException, SQLException {
        // CAST(ScheduledTime AS TIME) để tương thích khi cột DB có kiểu DATETIME
        String sql = "SELECT 1 FROM Booking "
                + "WHERE CAST(ScheduledDate AS DATE) = ? "
                + "AND CAST(ScheduledTime AS TIME) = CAST(? AS TIME) "
                + "AND Status = 'Pending'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setDate(1, scheduledDate);
            stm.setTime(2, scheduledTime);
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Cancel booking — chỉ cho phép nếu: 1. Booking thuộc về đúng customerID
     * (tránh cancel của người khác). 2. Status đang là Pending. 3. Thời gian
     * hẹn còn cách hiện tại ít nhất 2 tiếng.
     *
     * Logic kiểm tra 2h được thực hiện ở Controller trước khi gọi hàm này. Hàm
     * này chỉ đảm bảo tính toàn vẹn: chỉ UPDATE khi đúng owner + Pending.
     */
    public boolean cancelBooking(int bookingID, int customerID) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking SET Status = 'Cancelled' WHERE BookingID = ? AND CustomerID = ? AND Status = 'Pending'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, bookingID);
            stm.setInt(2, customerID);
            return stm.executeUpdate() > 0;
        }
    }

    public List<Booking> getAllBookings() throws ClassNotFoundException, SQLException {
        String sql = "SELECT BookingID, CustomerID, VehicleID, ServiceType, Price, VehiclePlateSnapshot, CustomerNameSnapshot, ScheduledDate, ScheduledTime, BookingDate, Status, ServiceID "
                + "FROM Booking ORDER BY ScheduledDate DESC, ScheduledTime DESC, BookingDate DESC";
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapRow(rs));
                }
            }
        }
        return bookings;
    }

    public List<AdminBookingDTO> getTodayBookings() throws ClassNotFoundException, SQLException {
        String sql = adminBookingSelectSql()
                + " WHERE b.ScheduledDate = CAST(GETDATE() AS DATE)"
                + " ORDER BY b.ScheduledTime ASC, b.BookingID ASC";
        List<AdminBookingDTO> bookings = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapAdminBooking(rs));
                }
            }
        }
        return bookings;
    }

    public List<AdminBookingDTO> getAllAdminBookings() throws ClassNotFoundException, SQLException {
        String sql = adminBookingSelectSql()
                + " ORDER BY b.ScheduledDate DESC, b.ScheduledTime DESC, b.BookingDate DESC";
        List<AdminBookingDTO> bookings = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapAdminBooking(rs));
                }
            }
        }
        return bookings;
    }

    public AdminBookingCounts getTodayBookingCounts() throws ClassNotFoundException, SQLException {
        String sql = "SELECT "
                + "COUNT(*) AS TodayBookings, "
                + "SUM(CASE WHEN b.Status = 'Pending' THEN 1 ELSE 0 END) AS PendingCount, "
                + "SUM(CASE WHEN b.Status = 'Washing' THEN 1 ELSE 0 END) AS WashingCount, "
                + "SUM(CASE WHEN b.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedCount "
                + "FROM Booking b WHERE b.ScheduledDate = CAST(GETDATE() AS DATE)";
        AdminBookingCounts counts = new AdminBookingCounts();

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                counts.setTodayBookings(rs.getInt("TodayBookings"));
                counts.setPending(rs.getInt("PendingCount"));
                counts.setWashing(rs.getInt("WashingCount"));
                counts.setCompleted(rs.getInt("CompletedCount"));
            }
        }
        return counts;
    }

    public AdminBookingDTO getStationOneBooking() throws ClassNotFoundException, SQLException {
        String sql = adminBookingSelectSql()
                + " WHERE b.StationNo = 1 AND b.Status = 'Washing'"
                + " ORDER BY b.CheckInTime DESC, b.BookingID DESC";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                return mapAdminBooking(rs);
            }
        }
        return null;
    }

    public boolean checkInBooking(int bookingID) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking "
                + "SET Status = 'Washing', StationNo = 1, "
                + "CheckInTime = GETDATE(), StartWashTime = GETDATE(), "
                + "ExpectedEndTime = DATEADD(MINUTE, 1, GETDATE()), CheckOutTime = NULL "
                + "WHERE BookingID = ? "
                + "AND Status = 'Pending' "
                + "AND ScheduledDate = CAST(GETDATE() AS DATE) "
                + "AND NOT EXISTS ("
                + "    SELECT 1 FROM Booking "
                + "    WHERE StationNo = 1 AND Status = 'Washing'"
                + ")";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, bookingID);
            return stm.executeUpdate() > 0;
        }
    }

    public boolean checkOutBooking(int bookingID) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking "
                + "SET Status = 'Completed', CheckOutTime = GETDATE(), StationNo = NULL "
                + "WHERE BookingID = ? "
                + "AND Status = 'Washing' "
                + "AND StationNo = 1 "
                + "AND ExpectedEndTime <= GETDATE()";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, bookingID);
            return stm.executeUpdate() > 0;
        }
    }

    public boolean updateBookingStatus(int bookingID, String status) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking SET Status = ? WHERE BookingID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, bookingID);
            return stm.executeUpdate() > 0;
        }
    }

    // -----------------------------------------------------------------------
    // Helper
    // -----------------------------------------------------------------------
    private Booking mapRow(ResultSet rs) throws SQLException {
        return new Booking(
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
                rs.getInt("ServiceID"));
    }

    /**
     * Tự động cancel các booking Pending đã quá giờ hẹn (no-show).
     */
    public int autoCancelExpiredBookings() throws ClassNotFoundException, SQLException {
        String sql = "UPDATE Booking SET Status = 'Cancelled' "
                + "WHERE Status = 'Pending' "
                + "AND CAST(ScheduledDate AS DATETIME) + CAST(ScheduledTime AS DATETIME) < GETDATE()";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            return stm.executeUpdate();
        }
    }

    private String adminBookingSelectSql() {
        return "SELECT "
                + "b.BookingID, "
                + "ISNULL(c.FullName, b.CustomerNameSnapshot) AS CustomerName, "
                + "ISNULL(c.Phone, '') AS Phone, "
                + "ISNULL(v.LicensePlate, b.VehiclePlateSnapshot) AS LicensePlate, "
                + "ISNULL(v.VehicleModel, '') AS VehicleModel, "
                + "ISNULL(s.ServiceName, b.ServiceType) AS ServiceName, "
                + "b.ScheduledDate, b.ScheduledTime, b.Status, "
                + "b.StationNo, b.CheckInTime, b.ExpectedEndTime, b.CheckOutTime "
                + "FROM Booking b "
                + "LEFT JOIN Customer c ON b.CustomerID = c.CustomerID "
                + "LEFT JOIN Vehicle v ON b.VehicleID = v.VehicleID "
                + "LEFT JOIN Service s ON b.ServiceID = s.ServiceID";
    }

    private AdminBookingDTO mapAdminBooking(ResultSet rs) throws SQLException {
        AdminBookingDTO booking = new AdminBookingDTO();
        booking.setBookingID(rs.getInt("BookingID"));
        booking.setCustomerName(rs.getString("CustomerName"));
        booking.setPhone(rs.getString("Phone"));
        booking.setLicensePlate(rs.getString("LicensePlate"));
        booking.setVehicleModel(rs.getString("VehicleModel"));
        booking.setServiceName(rs.getString("ServiceName"));
        booking.setScheduledDate(rs.getDate("ScheduledDate"));
        booking.setScheduledTime(rs.getTime("ScheduledTime"));
        booking.setStatus(rs.getString("Status"));

        int stationNo = rs.getInt("StationNo");
        booking.setStationNo(rs.wasNull() ? null : stationNo);

        booking.setCheckInTime(rs.getTimestamp("CheckInTime"));
        booking.setExpectedEndTime(rs.getTimestamp("ExpectedEndTime"));
        booking.setCheckOutTime(rs.getTimestamp("CheckOutTime"));
        fillTimerFields(booking);
        return booking;
    }

    private void fillTimerFields(AdminBookingDTO booking) {
        Timestamp expectedEndTime = booking.getExpectedEndTime();
        if (!booking.isWashing() || expectedEndTime == null) {
            booking.setRemainingSeconds(0);
            booking.setNeedCheckout(false);
            return;
        }

        long millisLeft = expectedEndTime.getTime() - System.currentTimeMillis();
        int secondsLeft = (int) Math.ceil(millisLeft / 1000.0);
        if (secondsLeft <= 0) {
            booking.setRemainingSeconds(0);
            booking.setNeedCheckout(true);
        } else {
            booking.setRemainingSeconds(secondsLeft);
            booking.setNeedCheckout(false);
        }
    }
}
