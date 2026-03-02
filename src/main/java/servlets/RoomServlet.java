package servlets;

import dao.LoggerDAO;
import db.DBConnection;
import util.RoomFactory;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RoomServlet")
public class RoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String currentAdmin = (String) session.getAttribute("username");

        if ("addRoom".equals(action)) {
            String type = request.getParameter("roomType");
            double price = Double.parseDouble(request.getParameter("price"));
            String status = "Available";

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO rooms (room_type, price_per_night, status) VALUES (?, ?, ?)";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, type);
                pst.setDouble(2, price);
                pst.setString(3, status);

                int result = pst.executeUpdate();

                if (result > 0) {
                    LoggerDAO.log(currentAdmin, "Admin added a new " + type + " room (Price: Rs." + price + ")");

                    response.sendRedirect("admin-dashboard.jsp?status=room_added");
                } else {
                    response.sendRedirect("admin-dashboard.jsp?status=fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-dashboard.jsp?status=error");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String currentAdmin = (String) session.getAttribute("username");

        if ("delete".equals(action)) {
            String roomId = request.getParameter("id");

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM rooms WHERE room_id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(roomId));

                if (pst.executeUpdate() > 0) {
                    LoggerDAO.log(currentAdmin, "Admin deleted room ID: " + roomId);
                    response.sendRedirect("room-config.jsp?status=deleted");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("room-config.jsp?status=error");
            }
        }
    }

}
