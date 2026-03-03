<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 11:29 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.Reservation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Details - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; padding: 40px; }
        .details-card { background: white; max-width: 600px; margin: auto; padding: 25px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); border-top: 5px solid #007bff; }
        h2 { color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; color: #777; border-bottom: 1px solid #eee; width: 40%; }
        td { padding: 12px; color: #333; font-weight: bold; border-bottom: 1px solid #eee; }
        .btn-group { margin-top: 25px; display: flex; gap: 10px; }
        .btn { padding: 10px 20px; text-decoration: none; border-radius: 5px; color: white; font-size: 14px; }
        .btn-back { background: #6c757d; }
        .btn-bill { background: #28a745; }
    </style>
</head>
<body>

<div class="details-card">
    <%
        Reservation res = (Reservation) request.getAttribute("reservationDetails");
        if(res != null) {
    %>
    <h2>Reservation #<%= res.getReservationNo() %></h2>
    <table>
        <tr> <th>Guest Name</th> <td><%= res.getGuestName() %></td> </tr>
        <tr> <th>Address</th> <td><%= res.getAddress() %></td> </tr>
        <tr> <th>Contact</th> <td><%= res.getContactNo() %></td> </tr>
        <tr> <th>Room Type</th> <td><%= res.getRoomType() %></td> </tr>
        <tr> <th>Check-in</th> <td><%= res.getCheckInDate() %></td> </tr>
        <tr> <th>Check-out</th> <td><%= res.getCheckOutDate() %></td> </tr>
    </table>

    <div class="btn-group">
        <a href="view-reservation.jsp" class="btn btn-back">Search Again</a>
        <a href="CalculateBillServlet?resId=<%= res.getReservationNo() %>" class="btn btn-bill">Generate Bill</a>
    </div>
    <% } %>
</div>

</body>
</html>
