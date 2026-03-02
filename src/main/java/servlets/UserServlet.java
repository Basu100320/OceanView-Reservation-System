package servlets;

import dao.LoggerDAO;
import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String currentAdmin = (String) session.getAttribute("username");

        try (Connection conn = DBConnection.getConnection()) {

            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                String sql = "INSERT INTO users (full_name, username, password, role, failed_attempts, account_status) VALUES (?, ?, ?, ?, 0, 'Active')";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, fullName);
                pst.setString(2, username);
                pst.setString(3, password);
                pst.setString(4, role);

                if (pst.executeUpdate() > 0) {
                    LoggerDAO.log(currentAdmin, "Added new staff member: " + username + " (" + role + ")");
                    response.sendRedirect("manage-users.jsp?status=added");
                }
            }

            else if ("update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String fullName = request.getParameter("fullName");
                String username = request.getParameter("username");
                String role = request.getParameter("role");

                String sqlUpdate = "UPDATE users SET full_name=?, username=?, role=? WHERE user_id=?";
                PreparedStatement pst = conn.prepareStatement(sqlUpdate);
                pst.setString(1, fullName);
                pst.setString(2, username);
                pst.setString(3, role);
                pst.setInt(4, userId);

                if (pst.executeUpdate() > 0) {
                    LoggerDAO.log(currentAdmin, "Updated details of user ID: " + userId + " (New Username: " + username + ")");
                    response.sendRedirect("manage-users.jsp?status=updated");
                } else {
                    response.sendRedirect("manage-users.jsp?status=error");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users.jsp?status=error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String currentAdmin = (String) session.getAttribute("username");
        String idStr = request.getParameter("id");

        if (idStr == null) return;
        int userId = Integer.parseInt(idStr);

        try (Connection conn = DBConnection.getConnection()) {

            if ("unlock".equals(action)) {
                String sqlUnlock = "UPDATE users SET account_status = 'Active', failed_attempts = 0 WHERE user_id = ?";
                PreparedStatement pst = conn.prepareStatement(sqlUnlock);
                pst.setInt(1, userId);

                if (pst.executeUpdate() > 0) {
                    LoggerDAO.log(currentAdmin, "Unlocked user account with ID: " + userId);
                    response.sendRedirect("manage-users.jsp?status=unlocked");
                }
            }

            else if ("delete".equals(action)) {
                String sqlDelete = "DELETE FROM users WHERE user_id = ?";
                PreparedStatement pst = conn.prepareStatement(sqlDelete);
                pst.setInt(1, userId);

                if (pst.executeUpdate() > 0) {
                    LoggerDAO.log(currentAdmin, "Deleted staff member with ID: " + userId);
                    response.sendRedirect("manage-users.jsp?status=deleted");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users.jsp?status=error");
        }
    }
}