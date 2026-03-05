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
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.mockito.Mockito.*;

class RoomServletTest {

    private RoomServlet servlet;

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
        servlet = new RoomServlet();
    }

    @Test
    @DisplayName("Test adding a new room (doPost)")
    void testDoPostAddRoom() throws Exception {
        when(request.getParameter("action")).thenReturn("addRoom");
        when(request.getParameter("roomType")).thenReturn("Deluxe");
        when(request.getParameter("price")).thenReturn("7500.00");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("username")).thenReturn("admin_user");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class)) {
            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1); // Success

            servlet.doPost(request, response);

            verify(preparedStatement).setString(1, "Deluxe");
            verify(preparedStatement).setDouble(2, 7500.00);
            verify(preparedStatement).setString(3, "Available");
            verify(response).sendRedirect("admin-dashboard.jsp?status=room_added");
        }
    }

    @Test
    @DisplayName("Test deleting a room (doGet)")
    void testDoGetDeleteRoom() throws Exception {
        when(request.getParameter("action")).thenReturn("delete");
        when(request.getParameter("id")).thenReturn("50");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("username")).thenReturn("admin_user");

        try (MockedStatic<DBConnection> mockedDb = mockStatic(DBConnection.class)) {
            mockedDb.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1); // Success

            servlet.doGet(request, response);

            verify(preparedStatement).setInt(1, 50);
            verify(response).sendRedirect("room-config.jsp?status=deleted");
        }
    }
}