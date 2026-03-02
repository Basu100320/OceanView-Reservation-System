package dao;

import db.DBConnection;
import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY reservation_no DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Reservation res = new Reservation();
                res.setReservationNo(rs.getString("reservation_no"));
                res.setGuestName(rs.getString("guest_name"));
                res.setAddress(rs.getString("address"));
                res.setIdType(rs.getString("id_type"));
                res.setIdNumber(rs.getString("id_number"));
                res.setContactNo(rs.getString("contact_no"));
                res.setRoomType(rs.getString("room_type"));
                res.setCheckInDate(rs.getString("check_in"));
                res.setCheckOutDate(rs.getString("check_out"));
                list.add(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String generateNextReservationID() {
        String nextId = "OV-1001";
        String sql = "SELECT reservation_no FROM reservations ORDER BY reservation_no DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("reservation_no");
                int numericPart = Integer.parseInt(lastId.substring(3));
                numericPart++;
                nextId = "OV-" + numericPart;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return nextId;
    }

    public int getAvailableRoomID(String type) {
        int roomId = -1;
        String sql = "SELECT room_id FROM rooms WHERE room_type = ? AND status = 'Available' LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, type);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) { roomId = rs.getInt("room_id"); }
        } catch (SQLException e) { e.printStackTrace(); }
        return roomId;
    }

    public void updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, status);
            pst.setInt(2, roomId);
            pst.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public boolean addReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (reservation_no, guest_name, address, id_type, id_number, contact_no, room_type, check_in, check_out, room_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, reservation.getReservationNo());
            pst.setString(2, reservation.getGuestName());
            pst.setString(3, reservation.getAddress());
            pst.setString(4, reservation.getIdType());
            pst.setString(5, reservation.getIdNumber());
            pst.setString(6, reservation.getContactNo());
            pst.setString(7, reservation.getRoomType());
            pst.setString(8, reservation.getCheckInDate());
            pst.setString(9, reservation.getCheckOutDate());
            pst.setInt(10, reservation.getRoomId());
            return pst.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Reservation getReservationByID(String resId) {
        Reservation res = null;
        String sql = "SELECT * FROM reservations WHERE reservation_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, resId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                res = new Reservation();
                res.setReservationNo(rs.getString("reservation_no"));
                res.setGuestName(rs.getString("guest_name"));

                // Mewa add kala nisa dan null wenne na:
                res.setAddress(rs.getString("address"));

                res.setIdType(rs.getString("id_type"));
                res.setIdNumber(rs.getString("id_number"));

                res.setContactNo(rs.getString("contact_no"));

                res.setRoomType(rs.getString("room_type"));
                res.setCheckInDate(rs.getString("check_in"));
                res.setCheckOutDate(rs.getString("check_out"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return res;
    }

    public double getRoomPrice(String roomType) {
        double price = 0;
        String sql = "SELECT price_per_night FROM rooms WHERE room_type = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, roomType);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) { price = rs.getDouble("price_per_night"); }
        } catch (SQLException e) { e.printStackTrace(); }
        return price;
    }

    public boolean updateReservation(Reservation res) {
        String sql = "UPDATE reservations SET guest_name=?, address=?, id_type=?, id_number=?, contact_no=?, room_type=?, check_in=?, check_out=? WHERE reservation_no=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, res.getGuestName());
            pst.setString(2, res.getAddress());
            pst.setString(3, res.getIdType());
            pst.setString(4, res.getIdNumber());
            pst.setString(5, res.getContactNo());
            pst.setString(6, res.getRoomType());
            pst.setString(7, res.getCheckInDate());
            pst.setString(8, res.getCheckOutDate());
            pst.setString(9, res.getReservationNo());
            return pst.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteReservation(String resId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String findRoomSql = "SELECT room_type FROM reservations WHERE reservation_no = ?";
            String roomType = "";
            try (PreparedStatement pst1 = conn.prepareStatement(findRoomSql)) {
                pst1.setString(1, resId);
                ResultSet rs = pst1.executeQuery();
                if (rs.next()) { roomType = rs.getString("room_type"); }
            }

            String deleteSql = "DELETE FROM reservations WHERE reservation_no = ?";
            try (PreparedStatement pst2 = conn.prepareStatement(deleteSql)) {
                pst2.setString(1, resId);
                pst2.executeUpdate();
            }

            String updateRoomSql = "UPDATE rooms SET status = 'Available' WHERE room_type = ? AND status = 'Booked' LIMIT 1";
            try (PreparedStatement pst3 = conn.prepareStatement(updateRoomSql)) {
                pst3.setString(1, roomType);
                pst3.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public void autoUpdateRoomStatus() {
        String sql = "UPDATE rooms r " +
                "JOIN reservations res ON r.room_id = res.room_id " +
                "SET r.status = 'Available' " +
                "WHERE res.check_out < CURRENT_DATE AND r.status = 'Booked'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) { e.printStackTrace(); }
    }
}