package servlets;

import dao.ReservationDAO;
import model.Reservation;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static org.mockito.Mockito.*;

class ReservationServletTest {

    @InjectMocks
    private ReservationServlet servlet;

    @Mock
    private ReservationDAO dao;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    @DisplayName("Test Successful Reservation Creation")
    void testDoPostSuccess() throws Exception {
        when(request.getParameter("guestName")).thenReturn("Saman");
        when(request.getParameter("address")).thenReturn("Galle");
        when(request.getParameter("idType")).thenReturn("NIC");
        when(request.getParameter("idNumber")).thenReturn("123456789V");
        when(request.getParameter("contactNo")).thenReturn("0771234567");
        when(request.getParameter("roomType")).thenReturn("Single");
        when(request.getParameter("checkIn")).thenReturn("2026-02-27");
        when(request.getParameter("checkOut")).thenReturn("2026-02-28");

        when(dao.getAvailableRoomID("Single")).thenReturn(101);
        when(dao.generateNextReservationID()).thenReturn("OV-1001");
        when(dao.addReservation(any(Reservation.class))).thenReturn(true);

        servlet.doPost(request, response);

        verify(dao).updateRoomStatus(101, "Booked");
        verify(response).sendRedirect("dashboard.jsp?status=success&resId=OV-1001");
    }

    @Test
    @DisplayName("Test Reservation Failure - Invalid Phone Number")
    void testInvalidPhone() throws Exception {
        when(request.getParameter("contactNo")).thenReturn("abc-123");

        servlet.doPost(request, response);

        verify(response).sendRedirect("add-reservation.jsp?error=invalidphone");
        verify(dao, never()).addReservation(any());
    }

    @Test
    @DisplayName("Test Reservation Failure - No Rooms Available")
    void testNoRoomsAvailable() throws Exception {
        when(request.getParameter("contactNo")).thenReturn("0771234567");
        when(request.getParameter("roomType")).thenReturn("Deluxe");
        when(dao.getAvailableRoomID("Deluxe")).thenReturn(-1);

        servlet.doPost(request, response);

        verify(response).sendRedirect("add-reservation.jsp?error=notavailable");
    }
}