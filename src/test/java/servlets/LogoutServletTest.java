package servlets;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.mockito.Mockito.*;

class LogoutServletTest {

    private LogoutServlet servlet;

    @Mock
    HttpServletRequest request;

    @Mock
    HttpServletResponse response;

    @Mock
    HttpSession session;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new LogoutServlet();
    }

    @Test
    @DisplayName("Test Successful Logout and Session Invalidation")
    void testLogoutSuccess() throws Exception {
        when(request.getSession(false)).thenReturn(session);

        servlet.doGet(request, response);

        verify(session, times(1)).invalidate();

        verify(response).sendRedirect("login.jsp?status=loggedout");
    }

    @Test
    @DisplayName("Test Logout when no session exists")
    void testLogoutWithNoSession() throws Exception {
        when(request.getSession(false)).thenReturn(null);

        servlet.doGet(request, response);

        verify(response).sendRedirect("login.jsp?status=loggedout");

        verify(session, never()).invalidate();
    }
}