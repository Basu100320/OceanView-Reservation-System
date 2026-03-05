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
        // 1. Arrange: Mock form parameters
        when(request.getParameter("guestName")).thenReturn("Saman");
        when(request.getParameter("address")).thenReturn("Galle");
        when(request.getParameter("idType")).thenReturn("NIC");
        when(request.getParameter("idNumber")).thenReturn("123456789V");
        when(request.getParameter("contactNo")).thenReturn("0771234567");
        when(request.getParameter("roomType")).thenReturn("Single");
        when(request.getParameter("checkIn")).thenReturn("2026-02-27");
        when(request.getParameter("checkOut")).thenReturn("2026-02-28");

        // Mock DAO behavior
        when(dao.getAvailableRoomID("Single")).thenReturn(101);
        when(dao.generateNextReservationID()).thenReturn("OV-1001");
        when(dao.addReservation(any(Reservation.class))).thenReturn(true);

        // 2. Act
        servlet.doPost(request, response);

        // 3. Assert: Verify success redirect and status update
        verify(dao).updateRoomStatus(101, "Booked");
        verify(response).sendRedirect("dashboard.jsp?status=success&resId=OV-1001");
    }

    @Test
    @DisplayName("Test Reservation Failure - Invalid Phone Number")
    void testInvalidPhone() throws Exception {
        // Arrange: Providing an invalid phone number
        when(request.getParameter("contactNo")).thenReturn("abc-123");

        // Act
        servlet.doPost(request, response);

        // Assert: Should redirect with error=invalidphone
        verify(response).sendRedirect("add-reservation.jsp?error=invalidphone");
        // Ensure DAO was never called since validation failed
        verify(dao, never()).addReservation(any());
    }

    @Test
    @DisplayName("Test Reservation Failure - No Rooms Available")
    void testNoRoomsAvailable() throws Exception {
        // Arrange: DAO returns -1 indicating no rooms
        when(request.getParameter("contactNo")).thenReturn("0771234567");
        when(request.getParameter("roomType")).thenReturn("Deluxe");
        when(dao.getAvailableRoomID("Deluxe")).thenReturn(-1);

        // Act
        servlet.doPost(request, response);

        // Assert: Should redirect with error=notavailable
        verify(response).sendRedirect("add-reservation.jsp?error=notavailable");
    }
}