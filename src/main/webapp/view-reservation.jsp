<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 11:27 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.Reservation" %>
<%@ page import="dao.ReservationDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reservations - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; padding: 50px; }
        .main-container { max-width: 600px; margin: auto; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; margin-bottom: 20px; }
        input, select { width: 90%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 6px; outline: none; box-sizing: border-box;}

        input:invalid:not(:placeholder-shown) { border-color: #e74c3c; }
        input:valid:not(:placeholder-shown) { border-color: #2ecc71; }

        .btn { padding: 12px 25px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; width: 45%; color: white; transition: 0.3s; }
        .btn-search { background-color: #007bff; width: 95%; }
        .btn-update { background-color: #f1c40f; color: #333; }
        .btn-delete { background-color: #e74c3c; }
        .btn:hover { opacity: 0.8; }

        .error { color: #e74c3c; font-weight: bold; margin: 10px 0; font-size: 14px; }
        .success { color: #27ae60; font-weight: bold; margin: 10px 0; font-size: 14px; }
        label { display: block; text-align: left; margin-left: 5%; font-weight: bold; color: #555; font-size: 14px; margin-top: 10px; }
        .readonly-field { background-color: #e9ecef; cursor: not-allowed; color: #6c757d; }

        .role-badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 12px; margin-bottom: 15px; }
        .mgr { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .rec { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
    </style>
</head>
<body>

<%
    String userRole = (String) session.getAttribute("role");
    boolean isManager = "Manager".equals(userRole);
%>

<div class="main-container">
    <div class="card">
        <div class="role-badge <%= isManager ? "mgr" : "rec" %>">
            Logged as: <strong><%= userRole %></strong>
            (<%= isManager ? "Full Access" : "Read Only" %>)
        </div>

        <h2>🔍 Find Reservation</h2>
        <form action="view-reservation.jsp" method="GET">
            <input type="text" name="searchId" placeholder="Enter ID (e.g. OV-1001)" value="<%= request.getParameter("searchId") != null ? request.getParameter("searchId") : "" %>" required>
            <button type="submit" class="btn btn-search">Search Booking</button>
        </form>

        <% if("notfound".equals(request.getParameter("status"))) { %> <p class="error">Reservation Not Found!</p> <% } %>
        <% if("updated".equals(request.getParameter("status"))) { %> <p class="success">Updated Successfully!</p> <% } %>
        <% if("deleted".equals(request.getParameter("status"))) { %> <p class="success">Deleted Successfully!</p> <% } %>
    </div>

    <%
        String searchId = request.getParameter("searchId");
        if (searchId != null && !searchId.trim().isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            Reservation res = dao.getReservationByID(searchId);

            if (res != null) {
    %>
    <div class="card">
        <h3>Booking Details: <%= res.getReservationNo() %></h3>
        <form action="UpdateDeleteServlet" method="POST">
            <input type="hidden" name="resId" value="<%= res.getReservationNo() %>">
            <input type="hidden" name="roomType" value="<%= res.getRoomType() %>">

            <label>Guest Name</label>
            <input type="text" name="guestName" value="<%= res.getGuestName() %>" <%= isManager ? "required" : "readonly class='readonly-field'" %>>

            <label>Address</label>
            <input type="text" name="address" value="<%= res.getAddress() != null ? res.getAddress() : "" %>" <%= isManager ? "" : "readonly class='readonly-field'" %>>

            <label>Identification Type</label>
            <% if(isManager) { %>
            <select name="idType" id="idType" onchange="updateIdValidation()">
                <option value="NIC" <%= "NIC".equals(res.getIdType()) ? "selected" : "" %>>Local ID (NIC)</option>
                <option value="Passport" <%= "Passport".equals(res.getIdType()) ? "selected" : "" %>>Passport</option>
            </select>
            <% } else { %>
            <input type="text" name="idType" value="<%= res.getIdType() %>" readonly class="readonly-field">
            <% } %>

            <label id="idLabel"><%= "Passport".equals(res.getIdType()) ? "Passport Number" : "NIC Number" %></label>
            <input type="text" name="idNumber" id="idNumber" value="<%= res.getIdNumber() %>"
                <%= isManager ? "required" : "readonly class='readonly-field'" %>>

            <label>Contact No</label>
            <input type="text" name="contactNo" id="contactNo" value="<%= res.getContactNo() %>"
                <%= isManager ? "required pattern='^\\+?[0-9]{7,15}$'" : "readonly class='readonly-field'" %>>

            <label>Room Type (Fixed)</label>
            <input type="text" class="readonly-field" value="<%= res.getRoomType() %>" readonly>

            <label>Check-in Date</label>
            <input type="date" name="checkIn" value="<%= res.getCheckInDate() %>" <%= isManager ? "required" : "readonly class='readonly-field'" %>>

            <label>Check-out Date</label>
            <input type="date" name="checkOut" value="<%= res.getCheckOutDate() %>" <%= isManager ? "required" : "readonly class='readonly-field'" %>>

            <% if (isManager) { %>
            <div style="display: flex; justify-content: space-between; padding: 20px 0 10px 0;">
                <button type="submit" name="action" value="update" class="btn btn-update">Save Changes</button>
                <button type="submit" name="action" value="delete" class="btn btn-delete" onclick="return confirm('Delete this booking permanently?')">Cancel Booking</button>
            </div>
            <% } else { %>
            <p style="margin-top: 20px; color: #6c757d; font-style: italic; font-size: 13px;">
                * You do not have permission to edit this reservation.
            </p>
            <% } %>
        </form>
    </div>

    <script>
        function updateIdValidation() {
            var idType = document.getElementById('idType').value;
            var idInput = document.getElementById('idNumber');
            var idLabel = document.getElementById('idLabel');

            if (idType === "NIC") {
                idLabel.innerText = "NIC Number:";
                idInput.pattern = "^([0-9]{9}[vVxX]|[0-9]{12})$";
            } else if (idType === "Passport") {
                idLabel.innerText = "Passport Number:";
                idInput.pattern = "^[a-zA-Z][0-9]{7,9}$";
            }
        }
        if(<%= isManager %>) { updateIdValidation(); }
    </script>
    <%
    } else {
    %>
    <script>window.location.href="view-reservation.jsp?status=notfound";</script>
    <%
            }
        }
    %>

    <div style="text-align: center;">
        <a href="dashboard.jsp" style="text-decoration: none; color: #007bff;">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
