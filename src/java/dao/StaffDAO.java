package dao;

import dbutils.DBUtils;
import dto.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    // Lấy thông tin Staff dựa vào AccountID (Thường dùng sau khi đăng nhập)
    public Staff getStaffByAccountID(int accountID) throws ClassNotFoundException, SQLException {
//        Connection conn = null;
//        PreparedStatement stm = null;
//        ResultSet rs = null;
//        Staff staff = null;
//        try {
//            conn = DBUtils.getConnection();
//            if (conn != null) {
//                String sql = "SELECT StaffID, AccountID, FullName, Role "
//                           + "FROM Staff WHERE AccountID = ?";
//                stm = conn.prepareStatement(sql);
//                stm.setInt(1, accountID);
//                rs = stm.executeQuery();
//                if (rs.next()) {
//                    staff = new Staff(
//                            rs.getInt("StaffID"),
//                            rs.getInt("AccountID"),
//                            rs.getString("FullName"),
//                            rs.getString("Role")
//                    );
//                }
//            }
//        } finally {
//            if (rs != null) rs.close();
//            if (stm != null) stm.close();
//            if (conn != null) conn.close();
//        }
//        return staff;
    Connection conn =null;
    PreparedStatement stm=null;
    ResultSet rs =null;
    Staff staff =null;
        try {
            conn=DBUtils.getConnection();
            if(conn!=null){
                String sql="SELECT StaffID, AccountID, FullName, Role "
                           + "FROM Staff WHERE AccountID = ?";
                stm=conn.prepareStatement(sql);
                stm.setInt(1, accountID);
                rs=stm.executeQuery();
                if(rs.next()){
                    int staffid=rs.getInt("StaffID");
                    int accountid=rs.getInt("AccountID");
                    String fullName=rs.getString("FullName");
                    String role =rs.getString("Role");
                    staff =new Staff(staffid, accountid, fullName, role);
                    
                    
                }
            }
            
        } catch (Exception e) {
        }
        finally{
            rs.close();
            stm.close();
            conn.close();
        }
        return staff;
    }

    // Lấy danh sách toàn bộ nhân viên
    public List<Staff> getAllStaffs() throws ClassNotFoundException, SQLException {
        List<Staff> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT StaffID, AccountID, FullName, Role FROM Staff";
                stm = conn.prepareStatement(sql);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Staff(
                            rs.getInt("StaffID"),
                            rs.getInt("AccountID"),
                            rs.getString("FullName"),
                            rs.getString("Role")
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
}
