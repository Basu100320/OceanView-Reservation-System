<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/28/2026
  Time: 11:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>System Logs - Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a252f; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #2c3e50; color: white; }

        .log-time { color: #7f8c8d; font-size: 13px; }
        .log-user { font-weight: bold; color: #2980b9; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; background: #ecf0f1; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2 style="color: #f1c40f;">🛡️ Admin Panel</h2>
    <a href="admin-dashboard.jsp" style="color:white; text-decoration:none; display:block; padding:10px;">🏠 Back to Dashboard</a>
</div>

<div class="main-content">
    <h1>📜 System Activity Logs</h1>
    <p>Tracking all important actions performed within the Ocean View Management System.</p>

    <table>
        <thead>
        <tr>
            <th>Time Stamp</th>
            <th>Performed By</th>
            <th>Action Description</th>
        </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DBConnection.getConnection()) {
                Statement stmt = conn.createStatement();
                // Aluthma logs udata ena widiyata order karamu
                ResultSet rs = stmt.executeQuery("SELECT * FROM system_logs ORDER BY log_id DESC LIMIT 50");
                while(rs.next()) {
        %>
        <tr>
            <td class="log-time"><%= rs.getTimestamp("log_time") %></td>
            <td><span class="badge"><%= rs.getString("user_name") %></span></td>
            <td><%= rs.getString("action") %></td>
        </tr>
        <%
                }
            } catch (Exception e) { e.printStackTrace(); }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
