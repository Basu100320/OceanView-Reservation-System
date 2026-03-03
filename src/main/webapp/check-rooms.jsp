<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 11:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page import="dao.ReservationDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Room Availability - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #2c3e50; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }
        .sidebar h2 { color: #1abc9c; font-size: 22px; margin-bottom: 30px; }
        .menu-item { display: block; color: white; text-decoration: none; padding: 12px; margin-bottom: 10px; border-radius: 5px; background: #34495e; transition: 0.3s; }
        .menu-item:hover { background: #1abc9c; }

        /* Search Bar Design */
        .search-container { margin-bottom: 25px; display: flex; gap: 10px; align-items: center; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .search-input { flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px; outline: none; font-size: 14px; }
        .search-input:focus { border-color: #1abc9c; }

        /* Table Design */
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #1abc9c; color: white; font-weight: 600; }
        tr:hover { background-color: #f9f9f9; }

        /* Status Badges */
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: bold; text-transform: uppercase; }
        .status-available { color: #27ae60; background: #e8f6ef; border: 1px solid #27ae60; }
        .status-booked { color: #e74c3c; background: #fdeaea; border: 1px solid #e74c3c; }

        .no-data { text-align: center; padding: 20px; color: #7f8c8d; font-style: italic; }
    </style>
</head>
<body>

<%
    ReservationDAO dao = new ReservationDAO();
    dao.autoUpdateRoomStatus();
%>

<div class="sidebar">
    <h2>Ocean View</h2>
    <a href="dashboard.jsp" class="menu-item">🏠 Dashboard</a>
    <a href="check-rooms.jsp" class="menu-item" style="background: #1abc9c;">🏨 Room Availability</a>
    <a href="add-reservation.jsp" class="menu-item">➕ New Reservation</a>
    <a href="view-reservation.jsp" class="menu-item">🔍 Search Reservation</a>
    <a href="calculate-bill.jsp" class="menu-item">💳 Calculate Bill</a>
    <a href="help.jsp" class="menu-item">❓ Help Section</a>
</div>

<div class="main-content">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h1>🏨 Room Availability Status</h1>
        <p>User: <strong><%= session.getAttribute("username") %></strong></p>
    </div>

    <div class="search-container">
        <strong>🔍 Filter Rooms:</strong>
        <input type="text" id="typeSearch" onkeyup="filterTable()" placeholder="Search by Room Type (Single, Double, Luxury)..." class="search-input">
    </div>

    <table id="roomTable">
        <thead>
        <tr>
            <th>Room ID</th>
            <th>Room Type</th>
            <th>Price (Per Night)</th>
            <th>Current Status</th>
        </tr>
        </thead>
        <tbody>
        <%
            boolean dataFound = false;
            try {
                Connection conn = DBConnection.getConnection();
                if (conn != null) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM rooms ORDER BY room_id ASC");

                    while(rs.next()) {
                        dataFound = true;
                        String status = rs.getString("status");
                        String statusClass = status.equalsIgnoreCase("Available") ? "status-available" : "status-booked";
        %>
        <tr>
            <td><strong>RM-<%= rs.getInt("room_id") %></strong></td>
            <td><%= rs.getString("room_type") %></td>
            <td>Rs. <%= String.format("%,.2f", rs.getDouble("price_per_night")) %></td>
            <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
        </tr>
        <%
                    }
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }

            if (!dataFound) {
        %>
        <tr>
            <td colspan="4" class="no-data">No room records found in the database.</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

<script>
    function filterTable() {
        // Variables
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("typeSearch");
        filter = input.value.toUpperCase();
        table = document.getElementById("roomTable");
        tr = table.getElementsByTagName("tr");

        // Loop through all table rows (excluding header)
        for (i = 1; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[1];
            if (td) {
                txtValue = td.textContent || td.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>

</body>
</html>
