package servlets;

import dao.ReservationDAO;
import model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateDeleteServlet")
public class UpdateDeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        String resId = request.getParameter("resId");

        if (!"Manager".equals(role)) {
            response.sendRedirect("view-reservation.jsp?status=unauthorized&searchId=" + resId);
            return;
        }

        String action = request.getParameter("action");
        ReservationDAO dao = new ReservationDAO();

        if ("delete".equals(action)) {
            boolean success = dao.deleteReservation(resId);
            if (success) {
                response.sendRedirect("view-reservation.jsp?status=deleted");
            } else {
                response.sendRedirect("view-reservation.jsp?status=error");
            }

        }
        else if ("update".equals(action)) {
            String contact = request.getParameter("contactNo");

            if (contact == null || !contact.matches("^\\+?[0-9]{7,15}$")) {
                response.sendRedirect("view-reservation.jsp?status=invalidphone&searchId=" + resId);
                return;
            }

            Reservation res = new Reservation();
            res.setReservationNo(resId);
            res.setGuestName(request.getParameter("guestName"));
            res.setAddress(request.getParameter("address"));
            res.setContactNo(contact);
            res.setIdType(request.getParameter("idType"));
            res.setIdNumber(request.getParameter("idNumber"));
            res.setRoomType(request.getParameter("roomType"));
            res.setCheckInDate(request.getParameter("checkIn"));
            res.setCheckOutDate(request.getParameter("checkOut"));

            if (dao.updateReservation(res)) {
                response.sendRedirect("view-reservation.jsp?status=updated&searchId=" + resId);
            } else {
                response.sendRedirect("view-reservation.jsp?status=error&searchId=" + resId);
            }
        }
    }
}