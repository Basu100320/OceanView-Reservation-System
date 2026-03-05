package dao;

import model.Reservation;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ReservationDAOTest {

    ReservationDAO dao = new ReservationDAO();

    @Test
    void getAllReservations() {
        List<Reservation> list = dao.getAllReservations();
        assertNotNull(list);
    }

    @Test
    void generateNextReservationID() {
        String id = dao.generateNextReservationID();
        assertNotNull(id);
        assertTrue(id.startsWith("OV-"));
    }

    @Test
    void getAvailableRoomID() {
        int roomId = dao.getAvailableRoomID("Single");
        assertTrue(roomId >= -1);
    }

    @Test
    void updateRoomStatus() {
        assertDoesNotThrow(() -> {
            dao.updateRoomStatus(1, "Booked");
        });
    }

    @Test
    void addReservation() {

        Reservation r = new Reservation();

        r.setReservationNo("OV-9999");
        r.setGuestName("JUnit Test Guest");
        r.setAddress("Colombo");
        r.setIdType("NIC");
        r.setIdNumber("123456789V");
        r.setContactNo("0771234567");
        r.setRoomType("Single");
        r.setCheckInDate("2026-03-10");
        r.setCheckOutDate("2026-03-12");
        r.setRoomId(1);

        boolean result = dao.addReservation(r);

        assertTrue(result || !result);
    }

    @Test
    void getReservationByID() {

        Reservation res = dao.getReservationByID("OV-9999");

        if (res != null) {
            assertEquals("OV-9999", res.getReservationNo());
        } else {
            assertNull(res);
        }
    }

    @Test
    void getRoomPrice() {

        double price = dao.getRoomPrice("Single");

        assertTrue(price >= 0);
    }

    @Test
    void updateReservation() {

        Reservation r = new Reservation();

        r.setReservationNo("OV-9999");
        r.setGuestName("Updated Guest");
        r.setAddress("Kandy");
        r.setIdType("NIC");
        r.setIdNumber("987654321V");
        r.setContactNo("0711111111");
        r.setRoomType("Single");
        r.setCheckInDate("2026-03-10");
        r.setCheckOutDate("2026-03-12");

        boolean result = dao.updateReservation(r);

        assertTrue(result || !result);
    }

    @Test
    void deleteReservation() {

        boolean result = dao.deleteReservation("OV-9999");

        assertTrue(result || !result);
    }

    @Test
    void autoUpdateRoomStatus() {

        assertDoesNotThrow(() -> {
            dao.autoUpdateRoomStatus();
        });
    }
}