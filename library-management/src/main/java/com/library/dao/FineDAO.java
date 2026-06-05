package com.library.dao;

import com.library.model.Fine;
import com.library.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {

    public List<Fine> getAllFines() {
        return getFines(null, null);
    }

    public List<Fine> getFinesByMember(int memberId) {
        return getFines(memberId, null);
    }

    public List<Fine> getPendingFines() {
        return getFines(null, "pending");
    }

    private List<Fine> getFines(Integer memberId, String status) {
        List<Fine> fines = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT f.*, u.full_name AS member_name, b.title AS book_title " +
            "FROM fines f " +
            "JOIN users u ON f.member_id = u.id " +
            "JOIN book_issues bi ON f.issue_id = bi.id " +
            "JOIN books b ON bi.book_id = b.id WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (memberId != null) { sql.append(" AND f.member_id=?"); params.add(memberId); }
        if (status != null) { sql.append(" AND f.status=?"); params.add(status); }
        sql.append(" ORDER BY f.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) fines.add(mapFine(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }

    public boolean payFine(int fineId, BigDecimal amount) {
        String sql = "UPDATE fines SET paid_amount = paid_amount + ?, " +
                     "status = CASE WHEN paid_amount + ? >= fine_amount THEN 'paid' ELSE status END, " +
                     "paid_at = CASE WHEN paid_amount + ? >= fine_amount THEN NOW() ELSE paid_at END " +
                     "WHERE id=? AND status='pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setBigDecimal(2, amount);
            ps.setBigDecimal(3, amount);
            ps.setInt(4, fineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean waiveFine(int fineId) {
        String sql = "UPDATE fines SET status='waived' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public BigDecimal getTotalPendingFines() {
        String sql = "SELECT COALESCE(SUM(fine_amount - paid_amount), 0) FROM fines WHERE status='pending'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getMemberPendingFines(int memberId) {
        String sql = "SELECT COALESCE(SUM(fine_amount - paid_amount), 0) FROM fines WHERE member_id=? AND status='pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private Fine mapFine(ResultSet rs) throws SQLException {
        Fine fine = new Fine();
        fine.setId(rs.getInt("id"));
        fine.setIssueId(rs.getInt("issue_id"));
        fine.setMemberId(rs.getInt("member_id"));
        fine.setMemberName(rs.getString("member_name"));
        fine.setBookTitle(rs.getString("book_title"));
        fine.setFineAmount(rs.getBigDecimal("fine_amount"));
        fine.setPaidAmount(rs.getBigDecimal("paid_amount"));
        fine.setStatus(rs.getString("status"));
        fine.setCreatedAt(rs.getTimestamp("created_at"));
        fine.setPaidAt(rs.getTimestamp("paid_at"));
        return fine;
    }
}
