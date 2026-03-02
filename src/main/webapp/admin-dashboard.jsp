<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/25/2026
  Time: 7:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">

    <title>Admin Panel - Ocean View Resort</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a252f; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }
        .sidebar h2 { color: #f1c40f; font-size: 22px; margin-bottom: 30px; border-bottom: 1px solid #34495e; padding-bottom: 10px; }
        .menu-item { display: block; color: white; text-decoration: none; padding: 12px; margin-bottom: 10px; border-radius: 5px; background: #2c3e50; transition: 0.3s; }
        .menu-item:hover { background: #f1c40f; color: #000; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        .logout-btn { background: #e74c3c; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 14px; display: inline-block; margin-top: 20px; }

        /* Admin Stats */
        .stat-container { display: flex; gap: 20px; margin-top: 20px; }
        .stat-card { background: white; padding: 20px; border-radius: 10px; flex: 1; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; border-top: 4px solid #f1c40f; }
        .stat-card h3 { margin: 0; color: #7f8c8d; font-size: 16px; }
        .stat-card p { font-size: 24px; font-weight: bold; margin: 10px 0; color: #2c3e50; }

        /* Quick Action Styles */
        .action-box { margin-top: 30px; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .btn-action { background: #2c3e50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; border: none; cursor: pointer; font-size: 14px; transition: 0.3s; }
        .btn-action:hover { background: #34495e; opacity: 0.9; }
        .btn-room { background: #f1c40f; color: #000; font-weight: bold; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-content { background: white; margin: 10% auto; padding: 20px; width: 400px; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group select, .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
    </style>
</head>
<body>

<%
    // Security Check
    if(session.getAttribute("username") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- LIVE DATA FETCHING LOGIC ---
    int staffCount = 0;
    int bookingCount = 0;
    double todayIncome = 0;

    try {
        Connection conn = DBConnection.getConnection();

        // 1. Staff Count
        PreparedStatement pst1 = conn.prepareStatement("SELECT COUNT(*) FROM users");
        ResultSet rs1 = pst1.executeQuery();
        if(rs1.next()) staffCount = rs1.getInt(1);

        // 2. Total Bookings
        PreparedStatement pst2 = conn.prepareStatement("SELECT COUNT(*) FROM reservations");
        ResultSet rs2 = pst2.executeQuery();
        if(rs2.next()) bookingCount = rs2.getInt(1);

        // 3. Today's Income
        String incomeSql = "SELECT SUM(rooms.price_per_night) " +
                "FROM reservations " +
                "JOIN rooms ON reservations.room_id = rooms.room_id " +
                "WHERE DATE(reservations.check_in) = CURDATE()";

        PreparedStatement pst3 = conn.prepareStatement(incomeSql);
        ResultSet rs3 = pst3.executeQuery();
        if(rs3.next()) todayIncome = rs3.getDouble(1);

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="sidebar">
    <h2>🛡️ Admin Panel</h2>
    <a href="admin-dashboard.jsp" class="menu-item" style="background: #f1c40f; color: #000;">🏠 Admin Home</a>
    <a href="manage-users.jsp" class="menu-item">👥 Staff Management</a>
    <a href="view-logs.jsp" class="menu-item">📜 System Logs</a>
    <a href="room-config.jsp" class="menu-item">⚙️ Room Settings</a>
    <a href="income-reports.jsp" class="menu-item">📊 Reports</a>
    <a href="help.jsp" class="menu-item">❓ Help Section</a>
    <br>
    <a href="LogoutServlet" class="logout-btn" onclick="return confirm('Logout from Admin Panel?')">Logout Admin</a>
</div>

<div class="main-content">
    <div class="header">
        <h1>Welcome, System Administrator</h1>
        <p>Admin: <strong><%= session.getAttribute("fullName") %></strong></p>
    </div>

    <%-- Live Stat Cards --%>
    <div class="stat-container">
        <div class="stat-card">
            <h3>Active Staff</h3>
            <p><%= String.format("%02d", staffCount) %></p>
        </div>
        <div class="stat-card">
            <h3>Total Bookings</h3>
            <p><%= bookingCount %></p>
        </div>
        <div class="stat-card" style="border-top-color: #27ae60;">
            <h3>Today's Income</h3>
            <p>Rs. <%= String.format("%,.2f", todayIncome) %></p>
        </div>
    </div>

    <div class="action-box">
        <h3>Admin Quick Actions</h3>
        <hr>
        <p>Configure your hotel inventory and manage staff roles from here.</p>
        <div style="display: flex; gap: 10px; margin-top: 15px;">
            <a href="manage-users.jsp" class="btn-action">Add New Staff Member</a>
            <button onclick="openModal()" class="btn-action btn-room">➕ Add New Room</button>
        </div>
    </div>
</div>

<%-- Add Room Modal --%>
<div id="roomModal" class="modal">
    <div class="modal-content">
        <h2 style="margin-top: 0;">Add New Hotel Room</h2>
        <form action="RoomServlet" method="POST">
            <input type="hidden" name="action" value="addRoom">
            <div class="form-group">
                <label>Room Type</label>
                <select name="roomType" id="roomType" onchange="updatePrice()">
                    <option value="Single">Single</option>
                    <option value="Double">Double</option>
                    <option value="Luxury">Luxury</option>
                    <option value="Suite">Suite</option>
                </select>
            </div>
            <div class="form-group">
                <label>Default Price (Rs.)</label>
                <input type="number" name="price" id="roomPrice" value="5000" required>
            </div>
            <div style="display: flex; gap: 10px;">
                <button type="submit" class="btn-action btn-room" style="flex: 1;">Save Room</button>
                <button type="button" onclick="closeModal()" class="btn-action" style="flex: 1; background: #95a5a6;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function updatePrice() {
        const type = document.getElementById("roomType").value;
        const priceInput = document.getElementById("roomPrice");

        const prices = {
            "Single": 5000,
            "Double": 8500,
            "Luxury": 15000,
            "Suite": 20000
        };

        priceInput.value = prices[type];
    }

    function openModal() { document.getElementById("roomModal").style.display = "block"; }
    function closeModal() { document.getElementById("roomModal").style.display = "none"; }

    window.onclick = function(event) {
        let modal = document.getElementById("roomModal");
        if (event.target == modal) closeModal();
    }
</script>

</body>
</html>
