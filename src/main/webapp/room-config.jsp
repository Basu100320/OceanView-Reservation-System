<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/28/2026
  Time: 10:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Room Configuration - Admin Panel</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a252f; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }

        .room-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .room-table th, .room-table td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        .room-table th { background: #2c3e50; color: white; }

        .price-input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; width: 120px; }
        .btn-update { background: #f1c40f; color: #000; padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-update:hover { background: #d4ac0d; }

        .msg { padding: 10px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2 style="color: #f1c40f;">🛡️ Admin Panel</h2>
    <a href="admin-dashboard.jsp" style="color:white; text-decoration:none; display:block; padding:10px;">🏠 Back to Dashboard</a>
</div>

<div class="main-content">
    <h1>⚙️ Room Configuration</h1>
    <p>Update room prices per night for different room categories.</p>

    <%
        String status = request.getParameter("status");
        if("updated".equals(status)) {
            out.println("<div class='msg' style='color:green; background:#e8f6ef;'>✔️ Room price updated successfully!</div>");
        }
    %>

    <table class="room-table">
        <thead>
        <tr>
            <th>Room ID</th>
            <th>Room Type</th>
            <th>Current Price (Rs.)</th>
            <th>New Price (Rs.)</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM rooms ORDER BY room_id ASC");
                while(rs.next()) {
        %>
        <tr>
            <form action="RoomConfigServlet" method="POST">
                <td><strong>RM-<%= rs.getInt("room_id") %></strong></td>
                <td><%= rs.getString("room_type") %></td>
                <td><%= String.format("%,.2f", rs.getDouble("price_per_night")) %></td>
                <td>
                    <input type="hidden" name="roomId" value="<%= rs.getInt("room_id") %>">
                    <input type="number" name="newPrice" step="0.01" class="price-input" placeholder="Enter new price" required>
                </td>
                <td>
                    <button type="submit" class="btn-update">Update Price</button>
                </td>
            </form>
        </tr>
        <%
                }
            } catch(Exception e) { e.printStackTrace(); }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
