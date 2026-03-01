<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/9/2026
  Time: 1:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="dao.ReservationDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">

    <title>Staff Dashboard - Ocean View Resort</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #2c3e50; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }
        .sidebar h2 { color: #1abc9c; font-size: 22px; margin-bottom: 30px; }
        .menu-item { display: block; color: white; text-decoration: none; padding: 12px; margin-bottom: 10px; border-radius: 5px; background: #34495e; transition: 0.3s; }
        .menu-item:hover { background: #1abc9c; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        .logout-btn { background: #e74c3c; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; }
        .card-container { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 30px; }
        .card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        .manager-only { border: 2px dashed #1abc9c; background: #f0fff0; }
    </style>
</head>
<body>

<%
    if(session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if("Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("admin-dashboard.jsp");
        return;
    }

    // Auto Update Rooms
    try {
        new ReservationDAO().autoUpdateRoomStatus();
    } catch(Exception e) {}
%>

<div class="sidebar">
    <h2>Ocean View</h2>
    <a href="dashboard.jsp" class="menu-item" style="background: #1abc9c;">🏠 Dashboard</a>
    <a href="check-rooms.jsp" class="menu-item">🏨 Room Availability</a>
    <a href="add-reservation.jsp" class="menu-item">➕ New Reservation</a>
    <a href="view-reservation.jsp" class="menu-item">🔍 Search Reservation</a>
    <a href="calculate-bill.jsp" class="menu-item">💳 Calculate Bill</a>

    <%-- Manager ට විතරක් පේන Link එකක් --%>
    <% if("Manager".equals(session.getAttribute("role"))) { %>
    <a href="income-reports.jsp" class="menu-item" style="border: 1px solid #1abc9c;">📊 Financial Reports</a>
    <% } %>

    <a href="help.jsp" class="menu-item">❓ Help Section</a>

    <br>
    <a href="LogoutServlet" class="logout-btn" onclick="return confirm('Are you sure you want to logout?')">Logout</a>
</div>

<div class="main-content">
    <div class="header">
        <h1>Staff Management Portal</h1>
        <p>Role: <strong><%= session.getAttribute("role") %></strong> | User: <strong><%= session.getAttribute("fullName") %></strong></p>
    </div>

    <div class="card-container">
        <div class="card">
            <h3>Quick Reservation</h3>
            <p>Assign a room to a new guest immediately.</p>
            <a href="add-reservation.jsp" style="color: #1abc9c; font-weight: bold; text-decoration: none;">New Booking →</a>
        </div>

        <div class="card">
            <h3>Check Availability</h3>
            <p>Real-time room status and pricing.</p>
            <a href="check-rooms.jsp" style="color: #1abc9c; font-weight: bold; text-decoration: none;">View Rooms →</a>
        </div>

        <%-- Manager ට විතරක් පේන Card එක --%>
        <% if("Manager".equals(session.getAttribute("role"))) { %>
        <div class="card manager-only">
            <h3>Performance Overview</h3>
            <p>View hotel occupancy and monthly income stats.</p>
            <a href="income-reports.jsp" style="color: #2c3e50; font-weight: bold; text-decoration: none;">Generate Reports →</a>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>
