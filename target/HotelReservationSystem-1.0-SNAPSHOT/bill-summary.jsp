<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/10/2026
  Time: 7:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.Reservation" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bill Summary - Ocean View</title>
    <style>
        /* Modern Font Family */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            padding: 50px;
            margin: 0;
            color: #333;
        }

        /* Clean Invoice Container */
        .invoice-box {
            background: #ffffff;
            max-width: 600px;
            margin: auto;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 12px;
            border: 1px solid #eee;
        }

        /* Hotel Header Section */
        .hotel-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 15px;
        }
        .hotel-name { font-size: 28px; font-weight: 800; color: #007bff; letter-spacing: 1px; }
        .hotel-contact { font-size: 13px; color: #666; margin-top: 5px; }

        /* Invoice Meta Data */
        .invoice-meta { display: flex; justify-content: space-between; margin-bottom: 25px; }
        .meta-group { font-size: 14px; }
        .meta-title { font-weight: bold; color: #555; }
        .invoice-title { font-size: 18px; font-weight: 700; color: #2c3e50; }

        /* Detail Line Items */
        .details-section { margin-bottom: 25px; }
        .line { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px; padding-bottom: 5px; border-bottom: 1px solid #fafafa; }
        .line span:first-child { color: #555; font-weight: 600; }
        .line span:last-child { color: #000; font-weight: 700; }

        /* Total Section Styling */
        .total-container {
            margin-top: 30px;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .total-label { font-size: 16px; font-weight: 600; color: #555; }
        .total-amount { font-size: 28px; font-weight: 800; color: #2ecc71; text-align: right; }

        /* Print and Action Buttons */
        .action-buttons { display: flex; gap: 15px; margin-top: 35px; justify-content: center; }
        .btn {
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
            cursor: pointer;
            border: none;
            display: inline-block;
            text-align: center;
        }
        .btn-print { background: #007bff; color: white; box-shadow: 0 2px 5px rgba(0,123,255,0.2); }
        .btn-print:hover { background: #0056b3; box-shadow: 0 4px 8px rgba(0,123,255,0.3); }
        .btn-back { background: #6c757d; color: white; box-shadow: 0 2px 5px rgba(108,117,125,0.2); }
        .btn-back:hover { background: #5a6268; box-shadow: 0 4px 8px rgba(108,117,125,0.3); }

        /* Print-Specific Styles */
        @media print {
            body { background-color: white; padding: 0; margin: 0; color: black; }
            .invoice-box { box-shadow: none; border: none; max-width: 100%; padding: 30px; }
            .action-buttons { display: none; }
            .hotel-header { border-bottom: 2px solid black; }
            .total-container { border: 1px solid black; background-color: #f0f0f0 !important; -webkit-print-color-adjust: exact; }
            .total-amount { color: #2ecc71 !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<div class="invoice-box">
    <div class="hotel-header">
        <div class="hotel-name">OCEAN VIEW RESORT</div>
        <div class="hotel-contact">Marine Drive, Colombo 03 | +94 11 234 5678</div>
    </div>

    <%
        // Decimal Format for currency styling
        DecimalFormat df = new DecimalFormat("#,##0.00");

        Reservation res = (Reservation) request.getAttribute("res");
        long nights = (long) request.getAttribute("nights");
        double price = (double) request.getAttribute("price");
        double total = (double) request.getAttribute("total");
    %>

    <div class="invoice-meta">
        <div class="meta-group">
            <span class="meta-title">Invoiced to:</span><br>
            <%= res.getGuestName() %><br>
            <%= res.getAddress() != null ? res.getAddress() : "Guest Address" %><br>
            <%= res.getContactNo() %>
        </div>
        <div class="meta-group" style="text-align: right;">
            <div class="invoice-title">Guest Invoice</div>
            <span class="meta-title">Bill No:</span> INV-<%= System.currentTimeMillis() / 10000 %><br>
            <span class="meta-title">Date:</span> <%= java.time.LocalDate.now() %>
        </div>
    </div>

    <div class="details-section">
        <div class="line"><span>Reservation ID:</span> <span><%= res.getReservationNo() %></span></div>
        <div class="line"><span>Room Type:</span> <span><%= res.getRoomType() %></span></div>
        <div class="line"><span>Check-in Date:</span> <span><%= res.getCheckInDate() %></span></div>
        <div class="line"><span>Check-out Date:</span> <span><%= res.getCheckOutDate() %></span></div>
    </div>

    <div class="details-section">
        <div class="line"><span>Price per Night:</span> <span>Rs. <%= df.format(price) %></span></div>
        <div class="line"><span>Number of Nights:</span> <span><%= nights %></span></div>

        <div class="total-container">
            <div class="line" style="border:none; margin-bottom:0;">
                <span class="total-label">TOTAL AMOUNT PAYABLE:</span>
                <span class="total-amount">Rs. <%= df.format(total) %></span>
            </div>
        </div>
    </div>

    <div class="action-buttons">
        <button onclick="window.print()" class="btn btn-print">Print Receipt</button>
        <a href="dashboard.jsp" class="btn btn-back">← Back to Home</a>
    </div>
</div>

</body>
</html>
