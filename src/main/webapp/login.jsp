<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/9/2026
  Time: 1:35 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("username") != null) {
        String role = (String) session.getAttribute("role");
        if("Admin".equals(role)) {
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            response.sendRedirect("dashboard.jsp");
        }
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">

    <title>Ocean View Resort - Login</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 8px 30px rgba(0,0,0,0.1); width: 380px; }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 25px; font-weight: 600; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #34495e; font-size: 14px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 12px; margin-bottom: 20px; border: 1px solid #dcdde1; border-radius: 8px; box-sizing: border-box; transition: 0.3s; }
        input:focus { border-color: #3498db; outline: none; box-shadow: 0 0 8px rgba(52, 152, 219, 0.2); }
        button { width: 100%; padding: 13px; background-color: #2c3e50; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: bold; transition: 0.3s; margin-top: 10px; }
        button:hover { background-color: #1a252f; transform: translateY(-1px); }

        /* Notification Box Styles */
        .alert { border-radius: 8px; padding: 15px; margin-top: 20px; font-size: 14px; text-align: center; animation: slideDown 0.4s ease-out; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        .error-alert { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .lock-alert { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .alert-title { font-weight: bold; display: block; margin-bottom: 5px; }
        .admin-contact { font-size: 12px; display: block; margin-top: 10px; padding-top: 10px; border-top: 1px solid rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<div class="login-container">
    <h2>🏢 Ocean View Login</h2>

    <form action="LoginServlet" method="post">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter your username" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter your password" required>

        <button type="submit">Login System</button>
    </form>

    <%
        String msg = request.getParameter("msg");
        String rem = request.getParameter("rem");

        if("invalid".equals(msg)) {
    %>
    <div class="alert error-alert">
        <span class="alert-title">❌ Access Denied</span>
        Invalid credentials. Please try again.

        <% if(rem != null) { %>
        <div style="margin-top: 10px; font-weight: bold; color: #856404;">
            ⚠️ You have only <%= rem %> attempt(s) remaining!
        </div>
        <% } %>

        <br><small>Warning: 3 failed attempts will lock your account.</small>
    </div>
    <%
    }
    else if("locked".equals(msg)) {
    %>
    <div class="alert lock-alert">
        <span class="alert-title">🔒 Account Locked</span>
        This account has been disabled for security reasons.
        <span class="admin-contact">
                📢 Please contact the <strong>System Administrator</strong> to regain access.
            </span>
    </div>
    <% } %>
</div>

<script type="text/javascript">
    window.history.pushState(null, null, window.location.href);
    window.onpopstate = function () {
        window.history.go(1);
    };
</script>

</body>
</html>