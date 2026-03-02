package servlets;

import dao.ReservationDAO;
import model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String resId = request.getParameter("resId");

        if (resId != null && !resId.trim().isEmpty()) {
            ReservationDAO dao = new ReservationDAO();

            Reservation res = dao.getReservationByID(resId);

            if (res != null) {
                request.setAttribute("reservationDetails", res);
                request.getRequestDispatcher("display-details.jsp").forward(request, response);
            } else {
                response.sendRedirect("view-reservation.jsp?status=notfound");
            }
        } else {
            response.sendRedirect("view-reservation.jsp");
        }
    }
}