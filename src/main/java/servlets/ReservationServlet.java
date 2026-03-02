package servlets;

import dao.ReservationDAO;
import model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ReservationDAO dao = new ReservationDAO();

        String name = request.getParameter("guestName");
        String address = request.getParameter("address");
        String idType = request.getParameter("idType");
        String idNumber = request.getParameter("idNumber");
        String contact = request.getParameter("contactNo");
        String type = request.getParameter("roomType");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        if (contact == null || !contact.matches("^\\+?[0-9]{7,15}$")) {
            response.sendRedirect("add-reservation.jsp?error=invalidphone");
            return;
        }

        int roomId = dao.getAvailableRoomID(type);

        if (roomId != -1) {
            String uniqueID = dao.generateNextReservationID();

            Reservation newReservation = new Reservation();
            newReservation.setReservationNo(uniqueID);
            newReservation.setGuestName(name);
            newReservation.setAddress(address);
            newReservation.setIdType(idType);
            newReservation.setIdNumber(idNumber);
            newReservation.setContactNo(contact);
            newReservation.setRoomType(type);
            newReservation.setCheckInDate(checkIn);
            newReservation.setCheckOutDate(checkOut);
            newReservation.setRoomId(roomId);

            boolean success = dao.addReservation(newReservation);

            if (success) {
                dao.updateRoomStatus(roomId, "Booked");

                response.sendRedirect("dashboard.jsp?status=success&resId=" + uniqueID);
            } else {
                response.sendRedirect("add-reservation.jsp?status=fail");
            }
        } else {
            response.sendRedirect("add-reservation.jsp?error=notavailable");
        }
    }
}