package servlets;

import db.DBConnection;
import org.junit.jupiter.api.*;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;

import static org.mockito.Mockito.*;

class LoginServletTest {

    private LoginServlet servlet;

    @Mock
    HttpServletRequest request;

    @Mock
    HttpServletResponse response;

    @Mock
    HttpSession session;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        servlet = new LoginServlet();

        try (Connection conn = DBConnection.getConnection()) {
            // First, remove the test user if it already exists
            conn.createStatement().executeUpdate("DELETE FROM users WHERE username = 'testuser'");

            // Fix: Check your DB 'role' column values.
            // If 'User' is too long or not allowed, use 'Admin' or 'Staff'
            String sql = "INSERT INTO users (username, password, role, account_status, failed_attempts, full_name) " +
                    "VALUES ('testuser', 'pass123', 'Admin', 'Active', 0, 'Test User')";
            conn.createStatement().executeUpdate(sql);
        }
    }

    @Test
    @DisplayName("Test Successful Admin Login")
    void testLoginSuccess() throws Exception {
        when(request.getParameter("username")).thenReturn("testuser");
        when(request.getParameter("password")).thenReturn("pass123");
        when(request.getSession()).thenReturn(session);

        servlet.doPost(request, response);

        // Since we used 'Admin' in setUp, it should redirect to admin-dashboard.jsp
        verify(response).sendRedirect("admin-dashboard.jsp");
    }

    @Test
    @DisplayName("Test Login Failure - Invalid Password")
    void testLoginInvalidPassword() throws Exception {
        when(request.getParameter("username")).thenReturn("testuser");
        when(request.getParameter("password")).thenReturn("wrongpass");

        servlet.doPost(request, response);

        // Verify it redirects back to login page
        verify(response).sendRedirect(contains("login.jsp?msg=invalid"));
    }

    @AfterEach
    void tearDown() throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            conn.createStatement().executeUpdate("DELETE FROM users WHERE username = 'testuser'");
        }
    }
}