package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RoomConfigServlet")
public class RoomConfigServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        double newPrice = Double.parseDouble(request.getParameter("newPrice"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE rooms SET price_per_night = ? WHERE room_id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setDouble(1, newPrice);
            pst.setInt(2, roomId);

            int row = pst.executeUpdate();
            if(row > 0) {
                response.sendRedirect("room-config.jsp?status=updated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("room-config.jsp?status=error");
        }
    }
}