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
                           + "FROM Vehicle WHERE CustomerID = ?";
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
                            rs.getString("VehicleImageUrl")
                    ));
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return list;
    }

    // Thêm một xe mới cho khách hàng
    public boolean insertVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO Vehicle (CustomerID, LicensePlate, VehicleModel, Color, VehicleImageUrl) "
                           + "VALUES (?, ?, ?, ?, ?)";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, vehicle.getCustomerID());
                stm.setString(2, vehicle.getLicensePlate());
                stm.setString(3, vehicle.getVehicleModel());
                stm.setString(4, vehicle.getColor());
                stm.setString(5, vehicle.getVehicleImageUrl());
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return check;
    }

    // Xóa xe (Kiểm tra CustomerID để bảo mật)
    public boolean deleteVehicle(int vehicleID, int customerID) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM Vehicle WHERE VehicleID = ? AND CustomerID = ?";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, vehicleID);
                stm.setInt(2, customerID);
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return check;
    }

    // Cập nhật thông tin xe
    public boolean updateVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE Vehicle SET LicensePlate = ?, VehicleModel = ?, Color = ?, VehicleImageUrl = ? WHERE VehicleID = ? AND CustomerID = ?";
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
            if (stm != null) stm.close();
            if (conn != null) conn.close();
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
                           + "FROM Vehicle WHERE VehicleID = ? AND CustomerID = ?";
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
                            rs.getString("VehicleImageUrl")
                    );
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return vehicle;
    }
}
