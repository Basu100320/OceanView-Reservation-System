package dao;

import db.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class LoggerDAO {
    public static void log(String username, String action) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO system_logs (user_name, action) VALUES (?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, action);
            pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}