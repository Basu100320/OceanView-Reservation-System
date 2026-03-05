package servlets;

import db.DBConnection;
import dao.LoggerDAO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.mockito.Mockito.*;

class UserServletTest {

    private UserServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new UserServlet();

        // Mock the session behavior globally for these tests
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("username")).thenReturn("admin_user");
    }

    @Test
    @DisplayName("Test adding a new staff member (doPost)")
    void testAddUser() throws Exception {
        // Arrange
        when(request.getParameter("action")).thenReturn("add");
        when(request.getParameter("fullName")).thenReturn("Nimal Perera");
        when(request.getParameter("username")).thenReturn("nimalp");
        when(request.getParameter("password")).thenReturn("staff123");
        when(request.getParameter("role")).thenReturn("Receptionist");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class);
             MockedStatic<LoggerDAO> mockedLogger = mockStatic(LoggerDAO.class)) {

            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1); // Success

            // Act
            servlet.doPost(request, response);

            // Assert
            verify(preparedStatement).setString(1, "Nimal Perera");
            verify(preparedStatement).setString(2, "nimalp");
            verify(preparedStatement).setString(4, "Receptionist");
            verify(response).sendRedirect("manage-users.jsp?status=added");

            // Verify that the action was logged
            mockedLogger.verify(() -> LoggerDAO.log(eq("admin_user"), contains("Added new staff member")));
        }
    }

    @Test
    @DisplayName("Test unlocking a user account (doGet)")
    void testUnlockUser() throws Exception {
        // Arrange
        when(request.getParameter("action")).thenReturn("unlock");
        when(request.getParameter("id")).thenReturn("15");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class);
             MockedStatic<LoggerDAO> mockedLogger = mockStatic(LoggerDAO.class)) {

            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1);

            // Act
            servlet.doGet(request, response);

            // Assert
            verify(preparedStatement).setInt(1, 15);
            verify(response).sendRedirect("manage-users.jsp?status=unlocked");
            mockedLogger.verify(() -> LoggerDAO.log(eq("admin_user"), contains("Unlocked user account")));
        }
    }

    @Test
    @DisplayName("Test deleting a user (doGet)")
    void testDeleteUser() throws Exception {
        // Arrange
        when(request.getParameter("action")).thenReturn("delete");
        when(request.getParameter("id")).thenReturn("20");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class)) {
            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1);

            // Act
            servlet.doGet(request, response);

            // Assert
            verify(preparedStatement).setInt(1, 20);
            verify(response).sendRedirect("manage-users.jsp?status=deleted");
        }
    }
}