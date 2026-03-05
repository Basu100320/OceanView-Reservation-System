package dao;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

class LoggerDAOTest {

    @Test
    void log() {

        // test data
        String username = "test_user";
        String action = "JUnit test log entry";

        // verify that method executes without exception
        assertDoesNotThrow(() -> {
            LoggerDAO.log(username, action);
        });

    }
}