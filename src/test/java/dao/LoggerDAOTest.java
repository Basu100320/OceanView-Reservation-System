package dao;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

class LoggerDAOTest {

    @Test
    void log() {

        String username = "test_user";
        String action = "JUnit test log entry";

        assertDoesNotThrow(() -> {
            LoggerDAO.log(username, action);
        });

    }
}