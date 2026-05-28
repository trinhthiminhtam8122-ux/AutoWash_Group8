package dao;

import dbutils.DBUtils;
import dto.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // Lấy thông tin Customer dựa vào AccountID (Thường dùng sau khi đăng nhập)
    public Customer getCustomerByAccountID(int accountID) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        Customer customer = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT CustomerID, AccountID, FullName, Phone, TierID, TotalWashes, LifetimeSpend, CurrentPoints, AvatarUrl, CreatedAt "
                           + "FROM Customer WHERE AccountID = ?";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, accountID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    customer = new Customer(
                            rs.getInt("CustomerID"),
                            rs.getInt("AccountID"),
                            rs.getString("FullName"),
                            rs.getString("Phone"),
                            rs.getInt("TierID"),
                            rs.getInt("TotalWashes"),
                            rs.getBigDecimal("LifetimeSpend"),
                            rs.getInt("CurrentPoints"),
                            rs.getString("AvatarUrl"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return customer;
    }

    // Lấy tất cả khách hàng
    public List<Customer> getAllCustomers() throws ClassNotFoundException, SQLException {
        List<Customer> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT CustomerID, AccountID, FullName, Phone, TierID, TotalWashes, LifetimeSpend, CurrentPoints, AvatarUrl, CreatedAt FROM Customer";
                stm = conn.prepareStatement(sql);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Customer(
                            rs.getInt("CustomerID"),
                            rs.getInt("AccountID"),
                            rs.getString("FullName"),
                            rs.getString("Phone"),
                            rs.getInt("TierID"),
                            rs.getInt("TotalWashes"),
                            rs.getBigDecimal("LifetimeSpend"),
                            rs.getInt("CurrentPoints"),
                            rs.getString("AvatarUrl"),
                            rs.getTimestamp("CreatedAt")
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
    // Thêm khách hàng mới và trả về ID tự tăng
    public int insertCustomerReturnId(Customer customer) throws ClassNotFoundException, SQLException {
        int generatedId = -1;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO Customer (AccountID, FullName, Phone, TierID, TotalWashes, LifetimeSpend, CurrentPoints, AvatarUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                stm = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                stm.setInt(1, customer.getAccountID());
                stm.setString(2, customer.getFullName());
                stm.setString(3, customer.getPhone());
                stm.setInt(4, customer.getTierID());
                stm.setInt(5, customer.getTotalWashes());
                stm.setBigDecimal(6, customer.getLifetimeSpend() != null ? customer.getLifetimeSpend() : java.math.BigDecimal.ZERO);
                stm.setInt(7, customer.getCurrentPoints());
                stm.setString(8, customer.getAvatarUrl() != null ? customer.getAvatarUrl() : "/assets/images/default-avatar.png");
                
                int affectedRows = stm.executeUpdate();
                if (affectedRows > 0) {
                    rs = stm.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return generatedId;
    }

    // Cập nhật Avatar
    public boolean updateAvatar(int customerID, String avatarUrl) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        PreparedStatement stm = null;
        boolean check = false;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE Customer SET AvatarUrl = ? WHERE CustomerID = ?";
                stm = conn.prepareStatement(sql);
                stm.setString(1, avatarUrl);
                stm.setInt(2, customerID);
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return check;
    }
}
