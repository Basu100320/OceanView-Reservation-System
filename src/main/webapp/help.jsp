<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 8:23 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Guide & Help - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; margin: 0; padding: 40px; }
        .help-container { max-width: 900px; margin: auto; background: white; padding: 40px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        h1 { color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        h2 { color: #333; margin-top: 30px; display: flex; align-items: center; }
        h2 span { background: #007bff; color: white; border-radius: 50%; width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; margin-right: 15px; font-size: 16px; }
        p { color: #666; line-height: 1.6; }
        .step-box { background: #f8f9fa; padding: 20px; border-left: 5px solid #007bff; margin: 15px 0; border-radius: 5px; }
        .tip { background: #fff3cd; padding: 15px; border-radius: 5px; border-left: 5px solid #ffc107; color: #856404; font-weight: bold; margin: 20px 0; }
        .back-btn { display: inline-block; margin-top: 30px; text-decoration: none; color: white; background: #6c757d; padding: 10px 20px; border-radius: 5px; transition: 0.3s; }
        .back-btn:hover { background: #5a6268; }

        .role-indicator { font-size: 12px; padding: 5px 15px; border-radius: 20px; text-transform: uppercase; font-weight: bold; }
        .admin-tag { background: #f8d7da; color: #721c24; }
        .manager-tag { background: #fff3cd; color: #856404; }
        .receptionist-tag { background: #d1ecf1; color: #0c5460; }

        ul { padding-left: 20px; }
        li { margin-bottom: 10px; color: #444; }
        b { color: #007bff; }
    </style>
</head>
<body>

<%
    String userRole = (String) session.getAttribute("role");
    if (userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="help-container">
    <h1>📖 System User Guide
        <span class="role-indicator <%= userRole.toLowerCase() %>-tag">Role: <%= userRole %></span>
    </h1>
    <p>Welcome, <b><%= session.getAttribute("username") %></b>. This guide is tailored specifically for your access level.</p>

    <% if ("Receptionist".equals(userRole) || "Manager".equals(userRole)) { %>
    <div class="section">
        <h2><span>1</span> Viewing the Dashboard</h2>
        <div class="step-box">
            <p>The **Dashboard** is your main control panel. From here, you can see:</p>
            <ul>
                <li>Total number of active reservations.</li>
                <li>Current room occupancy status.</li>
                <li>Quick links to add or search for reservations.</li>
            </ul>
        </div>

        <h2><span>2</span> Making a Reservation</h2>
        <div class="step-box">
            <ul>
                <li>Go to <b>New Reservation</b>.</li>
                <li>Enter Guest Name, Address, and <b>ID Details (NIC/Passport)</b>.</li>
                <li>The system validates phone numbers (7-15 digits).</li>
                <li>Room status updates to <b>"Booked"</b> immediately after saving.</li>
            </ul>
        </div>

        <h2><span>3</span> Bill Generation</h2>
        <div class="step-box">
            <p>After a successful booking, you can generate a professional invoice. Use the <b>Print Receipt</b> button to provide a physical copy to the guest.</p>
        </div>

        <div class="tip">
            💡 Pro-Tip: Always double-check the Guest's Contact Number before confirming, as this is used for all future communications!
        </div>

        <h2><span>4</span> Room Availability Logic</h2>
        <p>The system automatically manages room inventory. When you create a reservation, a room's status changes to <b>"Booked"</b>. When a reservation is deleted, that room is instantly released back into the available pool.</p>

    </div>
    <% } %>

    <% if ("Manager".equals(userRole)) { %>
    <div class="section" style="border-top: 2px dashed #eee; margin-top: 30px; padding-top: 10px;">
        <h2 style="color: #856404;"><span>M</span> Managerial Controls</h2>
        <div class="step-box" style="border-left-color: #ffc107;">
            <p>As a Manager, you have additional permissions:</p>
            <ul>
                <li><b>Update Reservations:</b> You can modify guest info or change dates.</li>
                <li><b>Cancel Bookings:</b> Deleting a reservation will <b>instantly release</b> the room back to "Available" status.</li>
                <li><b>Check & Download Reports:</b> Get All <b>Reports</b> of the Ocean View Hotel.</li>
            </ul>
        </div>
        <div class="tip">💡 Note: Every update or deletion you perform is logged for audit purposes.</div>
    </div>
    <% } %>

    <% if ("Admin".equals(userRole)) { %>
    <div class="section">
        <h2 style="color: #721c24;"><span>A</span> Administrator Controls</h2>
        <div class="step-box" style="border-left-color: #dc3545;">
            <ul>
                <li><b>Staff Management:</b> You can Add, Edit, or Delete staff members.</li>
                <li><b>Account Security:</b> If a user fails to login 3 times, their account is <b>Locked</b>. You must use the "Unlock" button in Staff Management to restore access.</li>
                <li><b>System Logs:</b> Monitor all critical actions (Who added whom, who deleted bookings, etc.) via the Logger.</li>
            </ul>
        </div>
        <div class="tip">🚨 Warning: Deleting a staff member is permanent and cannot be undone!</div>
    </div>
    <% } %>

    <%
        String backUrl = "dashboard.jsp";
        if("Admin".equals(session.getAttribute("role"))) {
            backUrl = "admin-dashboard.jsp";
        }
    %>
    <a href="<%= backUrl %>" class="back-btn">← Back to Dashboard</a>
</div>

</body>
</html>
