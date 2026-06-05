package com.library.dao;

import com.library.model.BookIssue;
import com.library.model.Fine;
import com.library.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    private static final double FINE_PER_DAY = 2.00;
    private static final int MAX_ISSUE_DAYS = 14;

    // Issue a book (with transaction)
    public boolean issueBook(int bookId, int memberId, int adminId) {
        String checkSql = "SELECT available_copies FROM books WHERE id=?";
        String issueSql = "INSERT INTO book_issues (book_id, member_id, issue_date, due_date, issued_by) VALUES (?,?,CURDATE(), DATE_ADD(CURDATE(), INTERVAL ? DAY),?)";
        String updateSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id=?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Check availability
                PreparedStatement check = conn.prepareStatement(checkSql);
                check.setInt(1, bookId);
                ResultSet rs = check.executeQuery();
                if (!rs.next() || rs.getInt(1) < 1) {
                    conn.rollback();
                    return false;
                }

                // Check member doesn't already have this book
                PreparedStatement dupCheck = conn.prepareStatement(
                    "SELECT id FROM book_issues WHERE book_id=? AND member_id=? AND status='issued'");
                dupCheck.setInt(1, bookId);
                dupCheck.setInt(2, memberId);
                if (dupCheck.executeQuery().next()) {
                    conn.rollback();
                    return false;
                }

                // Insert issue record
                PreparedStatement issue = conn.prepareStatement(issueSql);
                issue.setInt(1, bookId);
                issue.setInt(2, memberId);
                issue.setInt(3, MAX_ISSUE_DAYS);
                issue.setInt(4, adminId);
                issue.executeUpdate();

                // Update available copies
                PreparedStatement update = conn.prepareStatement(updateSql);
                update.setInt(1, bookId);
                update.executeUpdate();

                // Cancel any reservation for this member+book
                PreparedStatement cancelRes = conn.prepareStatement(
                    "UPDATE reservations SET status='fulfilled' WHERE book_id=? AND member_id=? AND status='active'");
                cancelRes.setInt(1, bookId);
                cancelRes.setInt(2, memberId);
                cancelRes.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Return a book (with fine calculation)
    public boolean returnBook(int issueId) {
        String getIssueSql = "SELECT * FROM book_issues WHERE id=? AND status='issued'";
        String returnSql = "UPDATE book_issues SET return_date=CURDATE(), status='returned' WHERE id=?";
        String updateBookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id=?";
        String fineSql = "INSERT INTO fines (issue_id, member_id, fine_amount) VALUES (?,?,?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                PreparedStatement getIssue = conn.prepareStatement(getIssueSql);
                getIssue.setInt(1, issueId);
                ResultSet rs = getIssue.executeQuery();
                if (!rs.next()) {
                    conn.rollback();
                    return false;
                }

                int bookId = rs.getInt("book_id");
                int memberId = rs.getInt("member_id");
                Date dueDate = rs.getDate("due_date");

                // Mark as returned
                PreparedStatement ret = conn.prepareStatement(returnSql);
                ret.setInt(1, issueId);
                ret.executeUpdate();

                // Update available copies
                PreparedStatement upd = conn.prepareStatement(updateBookSql);
                upd.setInt(1, bookId);
                upd.executeUpdate();

                // Calculate fine if overdue
                Date today = new Date(System.currentTimeMillis());
                if (today.after(dueDate)) {
                    long diffMs = today.getTime() - dueDate.getTime();
                    long overdueDays = diffMs / (1000 * 60 * 60 * 24);
                    BigDecimal fine = BigDecimal.valueOf(overdueDays * FINE_PER_DAY);

                    PreparedStatement finePs = conn.prepareStatement(fineSql);
                    finePs.setInt(1, issueId);
                    finePs.setInt(2, memberId);
                    finePs.setBigDecimal(3, fine);
                    finePs.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BookIssue> getAllIssues() {
        return getIssues(null, null);
    }

    public List<BookIssue> getIssuesByMember(int memberId) {
        return getIssues(memberId, null);
    }

    public List<BookIssue> getActiveIssues() {
        return getIssues(null, "issued");
    }

    private List<BookIssue> getIssues(Integer memberId, String status) {
        List<BookIssue> issues = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT bi.*, b.title AS book_title, b.isbn AS book_isbn, " +
            "u.full_name AS member_name, u.username AS member_username, " +
            "a.full_name AS issued_by_name " +
            "FROM book_issues bi " +
            "JOIN books b ON bi.book_id = b.id " +
            "JOIN users u ON bi.member_id = u.id " +
            "LEFT JOIN users a ON bi.issued_by = a.id WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (memberId != null) { sql.append(" AND bi.member_id=?"); params.add(memberId); }
        if (status != null) { sql.append(" AND bi.status=?"); params.add(status); }
        sql.append(" ORDER BY bi.issue_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) issues.add(mapIssue(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }

    public BookIssue getIssueById(int id) {
        String sql = "SELECT bi.*, b.title AS book_title, b.isbn AS book_isbn, " +
                     "u.full_name AS member_name, u.username AS member_username, " +
                     "a.full_name AS issued_by_name FROM book_issues bi " +
                     "JOIN books b ON bi.book_id = b.id " +
                     "JOIN users u ON bi.member_id = u.id " +
                     "LEFT JOIN users a ON bi.issued_by = a.id WHERE bi.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapIssue(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getActiveIssueCount() {
        String sql = "SELECT COUNT(*) FROM book_issues WHERE status='issued'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOverdueCount() {
        String sql = "SELECT COUNT(*) FROM book_issues WHERE status='issued' AND due_date < CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Update overdue status
    public void updateOverdueStatus() {
        String sql = "UPDATE book_issues SET status='overdue' WHERE status='issued' AND due_date < CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private BookIssue mapIssue(ResultSet rs) throws SQLException {
        BookIssue issue = new BookIssue();
        issue.setId(rs.getInt("id"));
        issue.setBookId(rs.getInt("book_id"));
        issue.setBookTitle(rs.getString("book_title"));
        issue.setBookIsbn(rs.getString("book_isbn"));
        issue.setMemberId(rs.getInt("member_id"));
        issue.setMemberName(rs.getString("member_name"));
        issue.setMemberUsername(rs.getString("member_username"));
        issue.setIssueDate(rs.getDate("issue_date"));
        issue.setDueDate(rs.getDate("due_date"));
        issue.setReturnDate(rs.getDate("return_date"));
        issue.setStatus(rs.getString("status"));
        issue.setIssuedBy(rs.getInt("issued_by"));
        issue.setIssuedByName(rs.getString("issued_by_name"));
        return issue;
    }
}
