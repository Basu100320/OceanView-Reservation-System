package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserTest {

    @Test
    void getUserId() {
        User user = new User();
        user.setUserId(1);
        assertEquals(1, user.getUserId());
    }

    @Test
    void setUserId() {
        User user = new User();
        user.setUserId(10);
        assertEquals(10, user.getUserId());
    }

    @Test
    void getUsername() {
        User user = new User();
        user.setUsername("admin");
        assertEquals("admin", user.getUsername());
    }

    @Test
    void setUsername() {
        User user = new User();
        user.setUsername("john123");
        assertEquals("john123", user.getUsername());
    }

    @Test
    void getPassword() {
        User user = new User();
        user.setPassword("12345");
        assertEquals("12345", user.getPassword());
    }

    @Test
    void setPassword() {
        User user = new User();
        user.setPassword("mypassword");
        assertEquals("mypassword", user.getPassword());
    }

    @Test
    void getFullName() {
        User user = new User();
        user.setFullName("John Doe");
        assertEquals("John Doe", user.getFullName());
    }

    @Test
    void setFullName() {
        User user = new User();
        user.setFullName("Nimal");
        assertEquals("Nimal", user.getFullName());
    }

    @Test
    void getRole() {
        User user = new User();
        user.setRole("admin");
        assertEquals("admin", user.getRole());
    }

    @Test
    void setRole() {
        User user = new User();
        user.setRole("receptionist");
        assertEquals("receptionist", user.getRole());
    }
}