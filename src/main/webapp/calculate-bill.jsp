<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 7:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.Reservation" %>
<%@ page import="dao.ReservationDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Billing & Reservations - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; margin: 20px; }
        .container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 900px; margin: auto; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 25px; }

        /* Search Bar Styling */
        .search-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 30px; display: flex; gap: 10px; justify-content: center; border: 1px solid #e9ecef; }
        input[type="text"] { width: 60%; padding: 12px; border: 1px solid #ced4da; border-radius: 6px; outline: none; }
        .btn-search { background-color: #007bff; color: white; border: none; padding: 10px 25px; cursor: pointer; border-radius: 6px; font-weight: bold; }

        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #f1f3f5; color: #495057; padding: 15px; text-align: left; border-bottom: 2px solid #dee2e6; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #333; }
        tr:hover { background-color: #f8f9fa; }

        .btn-bill { background-color: #28a745; color: white; padding: 8px 15px; text-decoration: none; border-radius: 5px; font-size: 13px; font-weight: bold; transition: 0.3s; }
        .btn-bill:hover { background-color: #218838; }

        .error { color: #e74c3c; text-align: center; margin-top: 10px; font-weight: bold; }
        .back-link { display: block; margin-top: 20px; text-align: center; color: #007bff; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>

<div class="container">
    <h2>💳 Billing Management</h2>

    <div class="search-section">
        <form action="calculate-bill.jsp" method="GET" style="width: 100%; text-align: center;">
            <input type="text" name="searchId" placeholder="Search by Reservation ID (e.g. OV-1001)..." value="<%= request.getParameter("searchId") != null ? request.getParameter("searchId") : "" %>">
            <button type="submit" class="btn-search">Search ID</button>
        </form>
    </div>

    <%
        String searchId = request.getParameter("searchId");
        ReservationDAO dao = new ReservationDAO();

        if (searchId != null && !searchId.trim().isEmpty()) {
            Reservation res = dao.getReservationByID(searchId);
            if (res != null) {
    %>
    <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 5px solid #007bff;">
        <strong>Found Guest:</strong> <%= res.getGuestName() %> | <strong>Room:</strong> <%= res.getRoomType() %>
        <a href="CalculateBillServlet?resId=<%= res.getReservationNo() %>" class="btn-bill" style="float: right;">Print Bill Now</a>
    </div>
    <%
    } else {
    %>
    <p class="error">❌ No reservation found for ID: <%= searchId %></p>
    <%
            }
        }
    %>

    <h3>All Active Reservations</h3>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Guest Name</th>
            <th>Room Type</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Reservation> allReservations = dao.getAllReservations();
            if (allReservations.isEmpty()) {
        %>
        <tr><td colspan="6" style="text-align:center;">No records found in database.</td></tr>
        <%
        } else {
            for (Reservation r : allReservations) {
        %>
        <tr>
            <td><strong><%= r.getReservationNo() %></strong></td>
            <td><%= r.getGuestName() %></td>
            <td><%= r.getRoomType() %></td>
            <td><%= r.getCheckInDate() %></td>
            <td><%= r.getCheckOutDate() %></td>
            <td>
                <a href="CalculateBillServlet?resId=<%= r.getReservationNo() %>" class="btn-bill">Generate Bill</a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <a href="dashboard.jsp" class="back-link">← Return to Dashboard</a>
</div>

</body>
</html>
