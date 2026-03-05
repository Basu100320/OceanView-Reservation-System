package servlets;

import db.DBConnection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.mockito.Mockito.*;

class RoomConfigServletTest {

    private RoomConfigServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new RoomConfigServlet();
    }

    @Test
    @DisplayName("Test successful room price update")
    void testDoPostSuccess() throws Exception {
        // 1. Arrange: Mock parameters from the request
        when(request.getParameter("roomId")).thenReturn("101");
        when(request.getParameter("newPrice")).thenReturn("5500.00");

        // Use MockedStatic to mock the static DBConnection class
        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class)) {
            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1); // Simulate 1 row updated

            // 2. Act
            servlet.doPost(request, response);

            // 3. Assert: Check if it correctly sets parameters and redirects
            verify(preparedStatement).setDouble(1, 5500.00);
            verify(preparedStatement).setInt(2, 101);
            verify(response).sendRedirect("room-config.jsp?status=updated");
        }
    }

    @Test
    @DisplayName("Test update failure due to Database Error")
    void testDoPostError() throws Exception {
        // Arrange
        when(request.getParameter("roomId")).thenReturn("101");
        when(request.getParameter("newPrice")).thenReturn("5500.00");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class)) {
            // Simulate a database connection failure
            mockedDb.when(DBConnection::getConnection).thenThrow(new RuntimeException("DB Error"));

            // Act
            servlet.doPost(request, response);

            // Assert: Should redirect with status=error
            verify(response).sendRedirect("room-config.jsp?status=error");
        }
    }
}