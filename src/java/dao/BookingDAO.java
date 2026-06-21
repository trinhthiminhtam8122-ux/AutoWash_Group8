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

    public List<AdminBookingDTO> getTodayBookings() throws ClassNotFoundException, SQLException {
        String sql = adminBookingSelectSql()
                + " WHERE b.ScheduledDate = CAST(GETDATE() AS DATE)"
                + " ORDER BY b.ScheduledTime ASC, b.BookingID ASC";
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

    public List<AdminBookingDTO> getAllBookings() throws ClassNotFoundException, SQLException {
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
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, bookingID);
            return stm.executeUpdate() > 0;
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
