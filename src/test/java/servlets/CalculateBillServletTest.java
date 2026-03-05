package servlets;

import dao.ReservationDAO;
import model.Reservation;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class CalculateBillServletTest {

    private CalculateBillServlet servlet;

    @Mock
    HttpServletRequest request;

    @Mock
    HttpServletResponse response;

    @Mock
    RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new CalculateBillServlet();
    }

    @Test
    void testDoGetWithValidId() throws Exception {
        String testResId = "OV-1001";
        when(request.getParameter("resId")).thenReturn(testResId);
        when(request.getRequestDispatcher("bill-summary.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(request).getRequestDispatcher("bill-summary.jsp");
        verify(dispatcher).forward(request, response);

        verify(request, atLeastOnce()).setAttribute(eq("total"), anyDouble());
    }

    @Test
    void testDoGetWithEmptyId() throws Exception {
        when(request.getParameter("resId")).thenReturn("");

        servlet.doGet(request, response);

        verify(response).sendRedirect("calculate-bill.jsp?status=invalid");
    }
}