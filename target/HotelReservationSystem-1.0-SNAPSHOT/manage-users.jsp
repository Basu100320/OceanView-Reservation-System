<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/27/2026
  Time: 8:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - Admin Panel</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a252f; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }
        .form-container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-add { background: #1abc9c; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #2c3e50; color: white; }
        .btn-delete { background: #e74c3c; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 12px; }
        .btn-edit { background: #3498db; color: white; padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer; margin-right: 5px; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 10% auto; padding: 25px; border-radius: 12px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .msg { padding: 10px; border-radius: 5px; margin-bottom: 20px; font-weight: 500; text-align: center; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2 style="color: #f1c40f;">🛡️ Admin Panel</h2>
    <a href="admin-dashboard.jsp" style="color:white; text-decoration:none; display:block; padding:10px;">🏠 Back to Dashboard</a>
</div>

<div class="main-content">
    <h1>👥 Staff Management</h1>

    <%
        String status = request.getParameter("status");
        if("added".equals(status)) { out.println("<div class='msg' style='color:green; background:#e8f6ef;'>✔️ Staff member added!</div>"); }
        if("updated".equals(status)) { out.println("<div class='msg' style='color:blue; background:#e3f2fd;'>✏️ User updated successfully!</div>"); }
        if("deleted".equals(status)) { out.println("<div class='msg' style='color:red; background:#fdeaea;'>🗑️ Staff member removed!</div>"); }
    %>

    <div class="form-container">
        <h3>➕ Add New Staff</h3>
        <form action="UserServlet" method="POST">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group"><label>Full Name</label><input type="text" name="fullName" required></div>
                <div class="form-group"><label>Username</label><input type="text" name="username" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" required></div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="role">
                        <option value="Receptionist">Receptionist</option>
                        <option value="Manager">Manager</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
            </div>
            <button type="submit" name="action" value="add" class="btn-add">Register Staff</button>
        </form>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th><th>Full Name</th><th>Username</th><th>Role</th><th>Actions</th><th>Acc Status</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM users ORDER BY user_id DESC");
                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td><%= rs.getString("username") %></td>
            <td><strong><%= rs.getString("role") %></strong></td>
            <td>
                <button class="btn-edit" onclick="openEditModal('<%= rs.getInt("user_id") %>', '<%= rs.getString("full_name") %>', '<%= rs.getString("username") %>', '<%= rs.getString("role") %>')">✏️ Edit</button>
                <a href="UserServlet?action=delete&id=<%= rs.getInt("user_id") %>" class="btn-delete" onclick="return confirm('Delete this user?')">🗑️ Delete</a>
            </td>
            <td>
                <% if("Locked".equals(rs.getString("account_status"))) { %>
                <a href="UserServlet?action=unlock&id=<%= rs.getInt("user_id") %>" style="color:red; text-decoration:none;">🔓 Unlock</a>
                <% } else { %>
                <span style="color: #27ae60;">✔ Active</span>
                <% } %>
            </td>
        </tr>
        <% } } catch(Exception e) { e.printStackTrace(); } %>
        </tbody>
    </table>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h3>✏️ Edit Staff Details</h3>
        <form action="UserServlet" method="POST">
            <input type="hidden" name="userId" id="editUserId">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" id="editFullName" required>
            </div>
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" id="editUsername" required>
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" id="editRole">
                    <option value="Receptionist">Receptionist</option>
                    <option value="Manager">Manager</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            <button type="submit" name="action" value="update" class="btn-add" style="background:#3498db; width:100%;">Save Changes</button>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, name, uname, role) {
        document.getElementById('editUserId').value = id;
        document.getElementById('editFullName').value = name;
        document.getElementById('editUsername').value = uname;
        document.getElementById('editRole').value = role;
        document.getElementById('editModal').style.display = "block";
    }

    function closeModal() {
        document.getElementById('editModal').style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('editModal')) closeModal();
    }
</script>

</body>
</html>
