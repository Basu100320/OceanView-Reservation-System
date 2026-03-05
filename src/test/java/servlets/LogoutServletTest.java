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
        // Initialize Mockito mocks
        MockitoAnnotations.openMocks(this);
        servlet = new LogoutServlet();
    }

    @Test
    @DisplayName("Test Successful Logout and Session Invalidation")
    void testLogoutSuccess() throws Exception {
        // Arrange: Mocking a pre-existing session
        // getSession(false) should return our mock session object
        when(request.getSession(false)).thenReturn(session);

        // Act: Call the doGet method of LogoutServlet
        servlet.doGet(request, response);

        // Assert: 1. Check if session.invalidate() was called
        verify(session, times(1)).invalidate();

        // Assert: 2. Check if the user was redirected to login.jsp with the correct status
        verify(response).sendRedirect("login.jsp?status=loggedout");
    }

    @Test
    @DisplayName("Test Logout when no session exists")
    void testLogoutWithNoSession() throws Exception {
        // Arrange: If no session exists, getSession(false) returns null
        when(request.getSession(false)).thenReturn(null);

        // Act
        servlet.doGet(request, response);

        // Assert: Verify redirect still happens even if session was already null
        verify(response).sendRedirect("login.jsp?status=loggedout");

        // Ensure invalidate() is NEVER called because session is null
        verify(session, never()).invalidate();
    }
}