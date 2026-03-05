package db;

import org.junit.jupiter.api.Test;

import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.*;

class DBConnectionTest {

    @Test
    void getConnection() {

        try {
            Connection conn = DBConnection.getConnection();

            assertNotNull(conn);

            assertFalse(conn.isClosed());

            conn.close();

        } catch (Exception e) {
            fail("Database connection failed: " + e.getMessage());
        }
    }
}