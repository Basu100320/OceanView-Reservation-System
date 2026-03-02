package servlets;

import dao.ReservationDAO;
import model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/CalculateBillServlet")
public class CalculateBillServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String resId = request.getParameter("resId");

        if (resId == null || resId.trim().isEmpty()) {
            response.sendRedirect("calculate-bill.jsp?status=invalid");
            return;
        }

        ReservationDAO dao = new ReservationDAO();

        Reservation res = dao.getReservationByID(resId);

        if (res != null) {
            double pricePerNight = dao.getRoomPrice(res.getRoomType());

            try {
                LocalDate checkIn = LocalDate.parse(res.getCheckInDate());
                LocalDate checkOut = LocalDate.parse(res.getCheckOutDate());

                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);

                if(nights <= 0) nights = 1;

                double totalBill = nights * pricePerNight;

                request.setAttribute("res", res);
                request.setAttribute("nights", nights);
                request.setAttribute("price", pricePerNight);
                request.setAttribute("total", totalBill);

                request.getRequestDispatcher("bill-summary.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("calculate-bill.jsp?status=error");
            }
        } else {
            response.sendRedirect("calculate-bill.jsp?status=notfound");
        }
    }
}