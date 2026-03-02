package model;

import java.util.Date;

public class Reservation {
    private String reservationNo;
    private String guestName;
    private String address;
    private String idType;
    private String idNumber;
    private String contactNo;
    private String roomType;
    private String checkInDate;
    private String checkOutDate;
    private int roomId;

    public Reservation() {}

    public Reservation(String reservationNo, String guestName, String address, String idType, String idNumber,
                       String contactNo, String roomType, String checkInDate, String checkOutDate, int roomId) {
        this.reservationNo = reservationNo;
        this.guestName = guestName;
        this.address = address;
        this.idType = idType;
        this.idNumber = idNumber;
        this.contactNo = contactNo;
        this.roomType = roomType;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.roomId = roomId;
    }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getIdType() { return idType; }
    public void setIdType(String idType) { this.idType = idType; }

    public String getIdNumber() { return idNumber; }
    public void setIdNumber(String idNumber) { this.idNumber = idNumber; }

    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
}