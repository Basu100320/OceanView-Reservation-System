<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/28/2026
  Time: 11:01 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Financial Reports - Ocean View</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #2c3e50; height: 100vh; color: white; padding: 20px; position: fixed; }
        .main-content { margin-left: 270px; padding: 40px; width: calc(100% - 270px); }

        .report-header { display: flex; gap: 20px; margin-bottom: 30px; }
        .report-card { background: white; padding: 25px; border-radius: 12px; flex: 1; box-shadow: 0 4px 10px rgba(0,0,0,0.08); border-top: 5px solid #1abc9c; }
        .report-card h3 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .report-card p { font-size: 28px; font-weight: bold; margin: 10px 0; color: #2c3e50; }

        .action-buttons { margin-bottom: 20px; display: flex; gap: 10px; }
        .btn-export { padding: 10px 15px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; color: white; transition: 0.3s; }
        .btn-excel { background: #27ae60; }
        .btn-pdf { background: #e74c3c; }
        .btn-export:hover { opacity: 0.8; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #34495e; color: white; }
        .total-row { background: #f9f9f9; font-weight: bold; font-size: 18px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>📊 Reports</h2>
    <a href="dashboard.jsp" style="color:white; text-decoration:none; display:block; padding:10px;">🏠 Back to Dashboard</a>
</div>

<div class="main-content">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <h1>💰 Financial Income Report</h1>
            <p>Detailed breakdown of hotel revenue based on guest stays.</p>
        </div>

        <div class="action-buttons">
            <button onclick="exportToExcel()" class="btn-export btn-excel">📥 Export Excel</button>
            <button onclick="exportToPDF()" class="btn-export btn-pdf">📄 Download PDF</button>
        </div>
    </div>

    <%
        double grandTotal = 0;
        int totalBookings = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT res.guest_name, res.room_type, res.check_in, res.check_out, " +
                    "DATEDIFF(res.check_out, res.check_in) as nights, r.price_per_night " +
                    "FROM reservations res " +
                    "JOIN rooms r ON res.room_id = r.room_id";

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
    %>

    <div class="report-header">
        <div class="report-card">
            <h3>Total Completed Bookings</h3>
            <div id="bookingCountText"><p>Loading...</p></div>
        </div>
        <div class="report-card" style="border-top-color: #e67e22;">
            <h3>Gross Revenue</h3>
            <div id="revenueText"><p>Loading...</p></div>
        </div>
    </div>

    <table id="incomeTable">
        <thead>
        <tr>
            <th>Guest Name</th>
            <th>Room Type</th>
            <th>Duration</th>
            <th>Nights</th>
            <th>Price/Night</th>
            <th>Sub-Total</th>
        </tr>
        </thead>
        <tbody>
        <%
            while(rs.next()) {
                int nights = rs.getInt("nights");
                if(nights <= 0) nights = 1;
                double price = rs.getDouble("price_per_night");
                double subTotal = nights * price;

                grandTotal += subTotal;
                totalBookings++;
        %>
        <tr>
            <td><%= rs.getString("guest_name") %></td>
            <td><%= rs.getString("room_type") %></td>
            <td><%= rs.getString("check_in") %> to <%= rs.getString("check_out") %></td>
            <td><%= nights %></td>
            <td>Rs. <%= String.format("%,.2f", price) %></td>
            <td><strong>Rs. <%= String.format("%,.2f", subTotal) %></strong></td>
        </tr>
        <% } %>
        <tr class="total-row">
            <td colspan="5" style="text-align: right;">Grand Total Revenue:</td>
            <td style="color: #e67e22;">Rs. <%= String.format("%,.2f", grandTotal) %></td>
        </tr>
        </tbody>
    </table>

    <script>
        document.getElementById("bookingCountText").innerHTML = "<p><%= totalBookings %></p>";
        document.getElementById("revenueText").innerHTML = "<p>Rs. <%= String.format("%,.2f", grandTotal) %></p>";

        function exportToExcel() {
            var table = document.getElementById("incomeTable");
            var html = table.outerHTML;
            var url = 'data:application/vnd.ms-excel,' + encodeURIComponent(html);
            var link = document.createElement("a");
            link.download = "OceanView_Income_Report.xls";
            link.href = url;
            link.click();
        }

        function exportToPDF() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();

            doc.setFontSize(18);
            doc.text("Ocean View Resort - Financial Report", 14, 20);
            doc.setFontSize(11);
            doc.setTextColor(100);
            doc.text("Generated on: " + new Date().toLocaleString(), 14, 30);

            doc.autoTable({
                html: '#incomeTable',
                startY: 40,
                theme: 'striped',
                headStyles: { fillColor: [44, 62, 80], textColor: [255, 255, 255] },
                styles: { fontSize: 9 }
            });

            doc.save("Hotel_Income_Report.pdf");
        }
    </script>

    <%
        } catch(Exception e) { e.printStackTrace(); }
    %>
</div>

</body>
</html>
