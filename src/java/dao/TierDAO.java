package dao;

import dbutils.DBUtils;
import dto.Tier;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TierDAO {

    // Lấy tất cả các hạng thành viên (Tier)
    public List<Tier> getAllTiers() throws ClassNotFoundException, SQLException {
        List<Tier> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT TierID, TierName, MinWashes, MinSpend, BookingWindow FROM Tier";
                stm = conn.prepareStatement(sql);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Tier(
                            rs.getInt("TierID"),
                            rs.getString("TierName"),
                            rs.getInt("MinWashes"),
                            rs.getBigDecimal("MinSpend"),
                            rs.getInt("BookingWindow")
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

    // Lấy Tier theo ID
    public Tier getTierByID(int tierID) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        Tier tier = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT TierID, TierName, MinWashes, MinSpend, BookingWindow "
                           + "FROM Tier WHERE TierID = ?";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, tierID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    tier = new Tier(
                            rs.getInt("TierID"),
                            rs.getString("TierName"),
                            rs.getInt("MinWashes"),
                            rs.getBigDecimal("MinSpend"),
                            rs.getInt("BookingWindow")
                    );
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return tier;
    }
}
