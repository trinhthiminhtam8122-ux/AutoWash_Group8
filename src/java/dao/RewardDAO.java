package dao;

import dbutils.DBUtils;
import dto.Reward;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RewardDAO {

    // Lấy tất cả phần thưởng
    public List<Reward> getAllRewards() throws ClassNotFoundException, SQLException {
        List<Reward> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT RewardID, RewardName, PointsCost, Description FROM Reward";
                stm = conn.prepareStatement(sql);
                rs = stm.executeQuery();
                while (rs.next()) {
                    list.add(new Reward(
                            rs.getInt("RewardID"),
                            rs.getString("RewardName"),
                            rs.getInt("PointsCost"),
                            rs.getString("Description")
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

    // Lấy phần thưởng theo ID
    public Reward getRewardByID(int rewardID) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        Reward reward = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT RewardID, RewardName, PointsCost, Description "
                           + "FROM Reward WHERE RewardID = ?";
                stm = conn.prepareStatement(sql);
                stm.setInt(1, rewardID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    reward = new Reward(
                            rs.getInt("RewardID"),
                            rs.getString("RewardName"),
                            rs.getInt("PointsCost"),
                            rs.getString("Description")
                    );
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stm != null) stm.close();
            if (conn != null) conn.close();
        }
        return reward;
    }
}
