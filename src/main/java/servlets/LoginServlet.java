package servlets;

import db.DBConnection;
import dao.LoggerDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String uName = request.getParameter("username");
        String pass = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            String checkSql = "SELECT * FROM users WHERE username = ?";
            PreparedStatement pstCheck = conn.prepareStatement(checkSql);
            pstCheck.setString(1, uName);
            ResultSet rsCheck = pstCheck.executeQuery();

            if (rsCheck.next()) {
                String role = rsCheck.getString("role");
                String status = rsCheck.getString("account_status");
                int attempts = rsCheck.getInt("failed_attempts");

                if (!"Admin".equalsIgnoreCase(role) && "Locked".equalsIgnoreCase(status)) {
                    response.sendRedirect("login.jsp?msg=locked");
                    return;
                }

                if (pass.equals(rsCheck.getString("password"))) {
                    // Login Success!
                    HttpSession session = request.getSession();
                    session.setAttribute("username", uName);
                    session.setAttribute("role", role);
                    session.setAttribute("fullName", rsCheck.getString("full_name"));

                    PreparedStatement pstReset = conn.prepareStatement("UPDATE users SET failed_attempts = 0 WHERE username = ?");
                    pstReset.setString(1, uName);
                    pstReset.executeUpdate();

                    LoggerDAO.log(uName, "User logged into the system");

                    if ("Admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("admin-dashboard.jsp");
                    } else {
                        response.sendRedirect("dashboard.jsp");
                    }
                } else {
                    if (!"Admin".equalsIgnoreCase(role)) {
                        int newAttempts = attempts + 1;
                        int remaining = 3 - newAttempts;

                        if (newAttempts >= 3) {
                            PreparedStatement pstLock = conn.prepareStatement("UPDATE users SET failed_attempts = 3, account_status = 'Locked' WHERE username = ?");
                            pstLock.setString(1, uName);
                            pstLock.executeUpdate();

                            LoggerDAO.log(uName, "Account LOCKED due to 3 failed attempts");
                            response.sendRedirect("login.jsp?msg=locked");
                        } else {
                            PreparedStatement pstUpdate = conn.prepareStatement("UPDATE users SET failed_attempts = ? WHERE username = ?");
                            pstUpdate.setInt(1, newAttempts);
                            pstUpdate.setString(2, uName);
                            pstUpdate.executeUpdate();

                            response.sendRedirect("login.jsp?msg=invalid&rem=" + remaining);
                        }
                    } else {
                        response.sendRedirect("login.jsp?msg=invalid");
                    }
                }
            } else {
                response.sendRedirect("login.jsp?msg=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=error");
        }
    }
}