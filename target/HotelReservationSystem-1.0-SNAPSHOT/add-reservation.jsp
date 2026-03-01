<%--
  Created by IntelliJ IDEA.
  User: GF63
  Date: 2/9/2026
  Time: 2:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Reservation - Ocean View</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; margin: 20px; }
        .form-container { background: white; padding: 25px; border-radius: 10px; max-width: 500px; margin: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h2 { color: #007bff; text-align: center; }
        label { font-weight: bold; color: #555; display: block; margin-top: 10px; }
        input, select { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; outline: none; }

        /* Validation Styling */
        input:focus { border-color: #007bff; box-shadow: 0 0 5px rgba(0,123,255,0.2); }
        input:invalid:not(:placeholder-shown) { border-color: #e74c3c; }
        input:valid:not(:placeholder-shown) { border-color: #2ecc71; }

        .btn-submit { background-color: #28a745; color: white; border: none; padding: 12px; cursor: pointer; font-size: 16px; width: 100%; border-radius: 5px; margin-top: 20px; transition: 0.3s; font-weight: bold; }
        .btn-submit:hover { background-color: #218838; }

        .error-msg { background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 15px; border: 1px solid #f5c6cb; font-size: 14px; }
        .success-msg { background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 15px; border: 1px solid #c3e6cb; }
        .back-link { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #007bff; font-size: 14px; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>🏨 New Guest Registration</h2>

    <%-- Error handling --%>
    <% if("notavailable".equals(request.getParameter("error"))) { %>
    <div class="error-msg">⚠️ Sorry! No rooms available for the selected type.</div>
    <% } %>
    <% if("invalidphone".equals(request.getParameter("error"))) { %>
    <div class="error-msg">❌ Invalid Contact Number. Please use 7-15 digits.</div>
    <% } %>

    <form action="ReservationServlet" method="POST" id="resForm">
        <label>Guest Name:</label>
        <input type="text" name="guestName" placeholder="Enter guest's full name" required>

        <label>Address:</label>
        <input type="text" name="address" placeholder="Current address" required>

        <label>Identification Type:</label>
        <select name="idType" id="idType" onchange="updateIdValidation()" required>
            <option value="" disabled selected>Select ID Type</option>
            <option value="NIC">Local ID (NIC)</option>
            <option value="Passport">Passport</option>
        </select>

        <div id="idInputContainer" style="display:none;">
            <label id="idLabel">ID Number:</label>
            <input type="text" name="idNumber" id="idNumber" placeholder="Enter number" required>
            <small id="idHint" style="color: #666; font-size: 11px; display: block; margin-top: -5px;"></small>
        </div>

        <label>Contact Number:</label>
        <input type="text" name="contactNo" id="contactNo"
               placeholder="e.g. 0771234567 or +94771234567"
               pattern="^\+?[0-9]{7,15}$"
               title="Please enter a valid phone number (7 to 15 digits). '+' is allowed for international guests."
               required>

        <label>Room Type:</label>
        <select name="roomType">
            <option value="Single">Single Room (Rs. 5,000)</option>
            <option value="Double">Double Room (Rs. 8,500)</option>
            <option value="Luxury">Luxury Room (Rs. 15,000)</option>
            <option value="Suite">Suite (Rs. 20,000)</option>
        </select>

        <label>Check-in Date:</label>
        <input type="date" name="checkIn" id="checkIn" required onchange="setMinCheckOut()">

        <label>Check-out Date:</label>
        <input type="date" name="checkOut" id="checkOut" required>

        <button type="submit" class="btn-submit">Confirm & Register</button>
    </form>

    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
</div>

<script>
    // 1. Check-out date validation
    function setMinCheckOut() {
        var checkInVal = document.getElementById('checkIn').value;
        var checkOutField = document.getElementById('checkOut');
        checkOutField.setAttribute('min', checkInVal);
        if(checkOutField.value < checkInVal) {
            checkOutField.value = checkInVal;
        }
    }

    // 2. Set today as minimum check-in date
    var today = new Date().toISOString().split('T')[0];
    document.getElementById('checkIn').setAttribute('min', today);

    // 3. Contact Number Auto-Sanitize (Only numbers and +)
    document.getElementById('contactNo').addEventListener('input', function (e) {
        var x = e.target.value.replace(/[^\d+]/g, ''); // Numbers and '+' witharak ithuru karanawa
        e.target.value = x;
    });

    function updateIdValidation() {
        var idType = document.getElementById('idType').value;
        var container = document.getElementById('idInputContainer');
        var idInput = document.getElementById('idNumber');
        var idLabel = document.getElementById('idLabel');
        var idHint = document.getElementById('idHint');

        container.style.display = 'block';
        idInput.value = ""; // කලින් තිබුණ ඒවා අයින් කරනවා

        if (idType === "NIC") {
            idLabel.innerText = "NIC Number:";
            idInput.placeholder = "e.g. 123456789V or 200012345678";
            // පැරණි NIC (ඉලක්කම් 9 + V/X) හෝ අලුත් NIC (ඉලක්කම් 12) පරීක්ෂාව
            idInput.pattern = "^([0-9]{9}[vVxX]|[0-9]{12})$";
            idHint.innerText = "Format: 9 digits with V/X OR 12 digits";
        } else if (idType === "Passport") {
            idLabel.innerText = "Passport Number:";
            idInput.placeholder = "e.g. N1234567";
            // සාමාන්‍යයෙන් Passport එකක් අකුරකින් පටන් ගෙන ඉලක්කම් 7-9 ක් එනවා
            idInput.pattern = "^[a-zA-Z][0-9]{7,9}$";
            idHint.innerText = "Format: 1 Letter followed by 7-9 digits";
        }
    }
</script>

</body>
</html>
