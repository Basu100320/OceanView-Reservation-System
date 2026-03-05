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
        // Mock objects ආරම්භ කිරීම
        MockitoAnnotations.openMocks(this);
        servlet = new CalculateBillServlet();
    }

    @Test
    void testDoGetWithValidId() throws Exception {
        // 1. Arrange: අවශ්‍ය දත්ත සකස් කිරීම
        String testResId = "OV-1001";
        when(request.getParameter("resId")).thenReturn(testResId);
        when(request.getRequestDispatcher("bill-summary.jsp")).thenReturn(dispatcher);

        // 2. Act: Servlet එකේ doGet method එක run කිරීම
        servlet.doGet(request, response);

        // 3. Assert: Request එක හරියට forward වුණාද කියා පරීක්ෂා කිරීම
        verify(request).getRequestDispatcher("bill-summary.jsp");
        verify(dispatcher).forward(request, response);

        // දත්ත setAttribute හරහා යවා ඇත්දැයි පරීක්ෂා කිරීම
        verify(request, atLeastOnce()).setAttribute(eq("total"), anyDouble());
    }

    @Test
    void testDoGetWithEmptyId() throws Exception {
        // ID එක හිස්ව එවන අවස්ථාව පරීක්ෂා කිරීම
        when(request.getParameter("resId")).thenReturn("");

        servlet.doGet(request, response);

        // වැරදි status එකක් සමඟ redirect විය යුතුය
        verify(response).sendRedirect("calculate-bill.jsp?status=invalid");
    }
}