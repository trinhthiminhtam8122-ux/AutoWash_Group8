package dao;

import dbutils.DBUtils;
import dto.Account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    // Phương thức xử lý đăng nhập
    public Account login(String username, String passwordHash) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        Account account = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT AccountID, Username, PasswordHash, Role, Status "
                           + "FROM Account WHERE Username = ? AND PasswordHash = ?";
                stm = conn.prepareStatement(sql);
                stm.setString(1, username);
                stm.setString(2, passwordHash);
                rs = stm.executeQuery();
                if (rs.next()) {
                    account = new Account(
                            rs.getInt("AccountID"),
                            rs.getString("Username"),
                            rs.getString("PasswordHash"),
                            rs.getString("Role"),
                            rs.getString("Status")
                    );
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return account;
    }

    // Lấy tất cả tài khoản
    public List<Account> getAllAccounts() throws ClassNotFoundException, SQLException {
        List<Account> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT AccountID, Username, PasswordHash, Role, Status FROM Account";
                stm = conn.prepareStatement(sql);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Account(
                            rs.getInt("AccountID"),
                            rs.getString("Username"),
                            rs.getString("PasswordHash"),
                            rs.getString("Role"),
                            rs.getString("Status")
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

    // Thêm tài khoản mới
    public boolean insertAccount(Account account) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO Account (Username, PasswordHash, Role, Status) VALUES (?, ?, ?, ?)";
                stm = conn.prepareStatement(sql);
                stm.setString(1, account.getUsername());
                stm.setString(2, account.getPasswordHash());
                stm.setString(3, account.getRole());
                stm.setString(4, account.getStatus() != null ? account.getStatus() : "Active");
                check = stm.executeUpdate() > 0;
            }
        } finally {
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return check;
    }
    // Thêm tài khoản mới và trả về ID tự tăng
    public int insertAccountReturnId(Account account) throws ClassNotFoundException, SQLException {
        int generatedId = -1;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO Account (Username, PasswordHash, Role, Status) VALUES (?, ?, ?, ?)";
                stm = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                stm.setString(1, account.getUsername());
                stm.setString(2, account.getPasswordHash());
                stm.setString(3, account.getRole());
                stm.setString(4, account.getStatus() != null ? account.getStatus() : "Active");
                
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

    // Kiểm tra tài khoản đã tồn tại chưa
    public boolean checkAccountExist(String username) throws ClassNotFoundException, SQLException {
        boolean exist = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT AccountID FROM Account WHERE Username = ?";
                stm = conn.prepareStatement(sql);
                stm.setString(1, username);
                rs = stm.executeQuery();
                if (rs.next()) {
                    exist = true;
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return exist;
    }
}
