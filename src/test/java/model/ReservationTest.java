package model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ReservationTest {

    @Test
    void getReservationNo() {
        Reservation r = new Reservation();
        r.setReservationNo("OV-1001");
        assertEquals("OV-1001", r.getReservationNo());
    }

    @Test
    void setReservationNo() {
        Reservation r = new Reservation();
        r.setReservationNo("OV-2001");
        assertEquals("OV-2001", r.getReservationNo());
    }

    @Test
    void getGuestName() {
        Reservation r = new Reservation();
        r.setGuestName("John");
        assertEquals("John", r.getGuestName());
    }

    @Test
    void setGuestName() {
        Reservation r = new Reservation();
        r.setGuestName("David");
        assertEquals("David", r.getGuestName());
    }

    @Test
    void getAddress() {
        Reservation r = new Reservation();
        r.setAddress("Colombo");
        assertEquals("Colombo", r.getAddress());
    }

    @Test
    void setAddress() {
        Reservation r = new Reservation();
        r.setAddress("Kandy");
        assertEquals("Kandy", r.getAddress());
    }

    @Test
    void getIdType() {
        Reservation r = new Reservation();
        r.setIdType("NIC");
        assertEquals("NIC", r.getIdType());
    }

    @Test
    void setIdType() {
        Reservation r = new Reservation();
        r.setIdType("Passport");
        assertEquals("Passport", r.getIdType());
    }

    @Test
    void getIdNumber() {
        Reservation r = new Reservation();
        r.setIdNumber("123456789V");
        assertEquals("123456789V", r.getIdNumber());
    }

    @Test
    void setIdNumber() {
        Reservation r = new Reservation();
        r.setIdNumber("987654321V");
        assertEquals("987654321V", r.getIdNumber());
    }

    @Test
    void getContactNo() {
        Reservation r = new Reservation();
        r.setContactNo("0771234567");
        assertEquals("0771234567", r.getContactNo());
    }

    @Test
    void setContactNo() {
        Reservation r = new Reservation();
        r.setContactNo("0711111111");
        assertEquals("0711111111", r.getContactNo());
    }

    @Test
    void getRoomType() {
        Reservation r = new Reservation();
        r.setRoomType("Single");
        assertEquals("Single", r.getRoomType());
    }

    @Test
    void setRoomType() {
        Reservation r = new Reservation();
        r.setRoomType("Double");
        assertEquals("Double", r.getRoomType());
    }

    @Test
    void getCheckInDate() {
        Reservation r = new Reservation();
        r.setCheckInDate("2026-03-10");
        assertEquals("2026-03-10", r.getCheckInDate());
    }

    @Test
    void setCheckInDate() {
        Reservation r = new Reservation();
        r.setCheckInDate("2026-04-01");
        assertEquals("2026-04-01", r.getCheckInDate());
    }

    @Test
    void getCheckOutDate() {
        Reservation r = new Reservation();
        r.setCheckOutDate("2026-03-12");
        assertEquals("2026-03-12", r.getCheckOutDate());
    }

    @Test
    void setCheckOutDate() {
        Reservation r = new Reservation();
        r.setCheckOutDate("2026-04-05");
        assertEquals("2026-04-05", r.getCheckOutDate());
    }

    @Test
    void getRoomId() {
        Reservation r = new Reservation();
        r.setRoomId(5);
        assertEquals(5, r.getRoomId());
    }

    @Test
    void setRoomId() {
        Reservation r = new Reservation();
        r.setRoomId(10);
        assertEquals(10, r.getRoomId());
    }
}