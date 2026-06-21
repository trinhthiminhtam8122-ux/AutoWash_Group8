package dao;

import dbutils.DBUtils;
import dto.Vehicle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // Lấy danh sách xe của một khách hàng cụ thể
    public List<Vehicle> getVehiclesByCustomerID(int customerID) throws ClassNotFoundException, SQLException {
        List<Vehicle> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT VehicleID, CustomerID, LicensePlate, VehicleModel, Color, VehicleImageUrl "
                        + "FROM Vehicle WHERE CustomerID = ? AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, customerID);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Vehicle(
                            rs.getInt("VehicleID"),
                            rs.getInt("CustomerID"),
                            rs.getString("LicensePlate"),
                            rs.getString("VehicleModel"),
                            rs.getString("Color"),
                            rs.getString("VehicleImageUrl")));
                }
            }
        } finally {
            if (rs != null)
                rs.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return list;
    }

    // Thêm một xe mới cho khách hàng
    public boolean insertVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        PreparedStatement updateOldStm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String normalizedLicense = vehicle.getLicensePlate() == null ? ""
                        : vehicle.getLicensePlate().trim().toUpperCase();

                // Giải phóng biển số nếu có xe đã bị xóa (Deleted) dùng biển này
                String updateOldSql = "UPDATE Vehicle SET LicensePlate = LEFT(LicensePlate, 10) + '_DEL_' + CAST(VehicleID AS VARCHAR(20)) "
                        + "WHERE UPPER(LicensePlate) = ? AND UPPER(Status) != 'ACTIVE'";
                updateOldStm = conn.prepareStatement(updateOldSql);
                updateOldStm.setString(1, normalizedLicense);
                updateOldStm.executeUpdate();

                String sql = "INSERT INTO Vehicle (CustomerID, LicensePlate, VehicleModel, Color, VehicleImageUrl, Status) "
                        + "VALUES (?, ?, ?, ?, ?, 'Active')";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, vehicle.getCustomerID());
                stm.setString(2, normalizedLicense);
                stm.setString(3, vehicle.getVehicleModel());
                stm.setString(4, vehicle.getColor());
                stm.setString(5, vehicle.getVehicleImageUrl());
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (updateOldStm != null)
                updateOldStm.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return check;
    }

    // Xóa mềm xe (chuyển Status sang Deleted)
    public boolean deleteVehicle(int vehicleID, int customerID) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE Vehicle SET Status = 'Deleted', LicensePlate = LEFT(LicensePlate, 10) + '_DEL_' + CAST(VehicleID AS VARCHAR(20)) "
                        + "WHERE VehicleID = ? AND CustomerID = ? AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, vehicleID);
                stm.setInt(2, customerID);
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return check;
    }

    // Kiểm tra xem biển số xe đã tồn tại và đang active hay chưa
    public boolean checkLicensePlateExist(String licensePlate) throws ClassNotFoundException, SQLException {
        boolean exist = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT 1 FROM Vehicle WHERE UPPER(LicensePlate) = ? "
                        + "AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setString(1, licensePlate == null ? "" : licensePlate.trim().toUpperCase());
                rs = stm.executeQuery();
                if (rs.next()) {
                    exist = true;
                }
            }
        } finally {
            if (rs != null)
                rs.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return exist;
    }

    // Kiểm tra xem biển số xe đã tồn tại và đang active hay chưa (ngoại trừ xe đang
    // sửa)
    public boolean checkLicensePlateExistExclude(String licensePlate, int excludeVehicleID)
            throws ClassNotFoundException, SQLException {
        boolean exist = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT 1 FROM Vehicle WHERE UPPER(LicensePlate) = ? "
                        + "AND VehicleID != ? AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setString(1, licensePlate == null ? "" : licensePlate.trim().toUpperCase());
                stm.setInt(2, excludeVehicleID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    exist = true;
                }
            }
        } finally {
            if (rs != null)
                rs.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return exist;
    }

    // Cập nhật thông tin xe
    public boolean updateVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        PreparedStatement updateOldStm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String normalizedLicense = vehicle.getLicensePlate() == null ? ""
                        : vehicle.getLicensePlate().trim().toUpperCase();

                // Giải phóng biển số nếu có xe đã bị xóa (Deleted) dùng biển này
                String updateOldSql = "UPDATE Vehicle SET LicensePlate = LEFT(LicensePlate, 10) + '_DEL_' + CAST(VehicleID AS VARCHAR(20)) "
                        + "WHERE UPPER(LicensePlate) = ? AND UPPER(Status) != 'ACTIVE'";
                updateOldStm = conn.prepareStatement(updateOldSql);
                updateOldStm.setString(1, normalizedLicense);
                updateOldStm.executeUpdate();

                String sql = "UPDATE Vehicle SET LicensePlate = ?, VehicleModel = ?, Color = ?, VehicleImageUrl = ? "
                        + "WHERE VehicleID = ? AND CustomerID = ? AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setString(1, vehicle.getLicensePlate());
                stm.setString(2, vehicle.getVehicleModel());
                stm.setString(3, vehicle.getColor());
                stm.setString(4, vehicle.getVehicleImageUrl());
                stm.setInt(5, vehicle.getVehicleID());
                stm.setInt(6, vehicle.getCustomerID());
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (updateOldStm != null)
                updateOldStm.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return check;
    }

    // Lấy thông tin 1 xe bằng ID
    public Vehicle getVehicleByID(int vehicleID, int customerID) throws ClassNotFoundException, SQLException {
        Vehicle vehicle = null;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT VehicleID, CustomerID, LicensePlate, VehicleModel, Color, VehicleImageUrl "
                        + "FROM Vehicle WHERE VehicleID = ? AND CustomerID = ? AND UPPER(Status) = 'ACTIVE'";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, vehicleID);
                stm.setInt(2, customerID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    vehicle = new Vehicle(
                            rs.getInt("VehicleID"),
                            rs.getInt("CustomerID"),
                            rs.getString("LicensePlate"),
                            rs.getString("VehicleModel"),
                            rs.getString("Color"),
                            rs.getString("VehicleImageUrl"));
                }
            }
        } finally {
            if (rs != null)
                rs.close();
            if (stm != null)
                stm.close();
            if (conn != null)
                conn.close();
        }
        return vehicle;
    }
}
