package dao;

import dbutils.DBUtils;
import dto.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<Service> getAllActiveServices() throws ClassNotFoundException, SQLException {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT ServiceID, ServiceName, Description, Price, Status "
                + "FROM Service WHERE UPPER(Status) = 'ACTIVE'";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                services.add(new Service(
                        rs.getInt("ServiceID"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getBigDecimal("Price"),
                        rs.getString("Status")
                ));
            }
        }
        return services;
    }

    public Service getServiceByID(int serviceID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT ServiceID, ServiceName, Description, Price, Status "
                + "FROM Service WHERE ServiceID = ? AND UPPER(Status) = 'ACTIVE'";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, serviceID);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("ServiceID"),
                            rs.getString("ServiceName"),
                            rs.getString("Description"),
                            rs.getBigDecimal("Price"),
                            rs.getString("Status")
                    );
                }
            }
        }
        return null;
    }
}
