package com.library.dao;

import com.library.model.Reservation;
import com.library.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean reserveBook(int bookId, int memberId) {
        // Check if already reserved by this member
        String checkSql = "SELECT id FROM reservations WHERE book_id=? AND member_id=? AND status='active'";
        String insertSql = "INSERT INTO reservations (book_id, member_id, expiry_date) " +
                           "VALUES (?, ?, DATE_ADD(CURDATE(), INTERVAL 7 DAY))";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check = conn.prepareStatement(checkSql);
            check.setInt(1, bookId);
            check.setInt(2, memberId);
            if (check.executeQuery().next()) return false; // already reserved

            PreparedStatement insert = conn.prepareStatement(insertSql);
            insert.setInt(1, bookId);
            insert.setInt(2, memberId);
            return insert.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelReservation(int reservationId, int memberId) {
        String sql = "UPDATE reservations SET status='cancelled' WHERE id=? AND member_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Reservation> getReservationsByMember(int memberId) {
        return getReservations(memberId, null);
    }

    public List<Reservation> getAllReservations() {
        return getReservations(null, null);
    }

    public List<Reservation> getActiveReservations() {
        return getReservations(null, "active");
    }

    private List<Reservation> getReservations(Integer memberId, String status) {
        List<Reservation> reservations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, b.title AS book_title, b.isbn AS book_isbn, b.author AS book_author, " +
            "u.full_name AS member_name FROM reservations r " +
            "JOIN books b ON r.book_id = b.id " +
            "JOIN users u ON r.member_id = u.id WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (memberId != null) { sql.append(" AND r.member_id=?"); params.add(memberId); }
        if (status != null) { sql.append(" AND r.status=?"); params.add(status); }
        sql.append(" ORDER BY r.reservation_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) reservations.add(mapReservation(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public void expireOldReservations() {
        String sql = "UPDATE reservations SET status='expired' WHERE status='active' AND expiry_date < CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getActiveReservationCount() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status='active'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Reservation mapReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setBookId(rs.getInt("book_id"));
        r.setBookTitle(rs.getString("book_title"));
        r.setBookIsbn(rs.getString("book_isbn"));
        r.setBookAuthor(rs.getString("book_author"));
        r.setMemberId(rs.getInt("member_id"));
        r.setMemberName(rs.getString("member_name"));
        r.setReservationDate(rs.getTimestamp("reservation_date"));
        r.setExpiryDate(rs.getDate("expiry_date"));
        r.setStatus(rs.getString("status"));
        return r;
    }
}
