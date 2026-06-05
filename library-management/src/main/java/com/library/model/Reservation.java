package com.library.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Reservation {
    private int id;
    private int bookId;
    private String bookTitle;
    private String bookIsbn;
    private String bookAuthor;
    private int memberId;
    private String memberName;
    private Timestamp reservationDate;
    private Date expiryDate;
    private String status; // "active", "fulfilled", "cancelled", "expired"

    public Reservation() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookIsbn() { return bookIsbn; }
    public void setBookIsbn(String bookIsbn) { this.bookIsbn = bookIsbn; }

    public String getBookAuthor() { return bookAuthor; }
    public void setBookAuthor(String bookAuthor) { this.bookAuthor = bookAuthor; }

    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    public Timestamp getReservationDate() { return reservationDate; }
    public void setReservationDate(Timestamp reservationDate) { this.reservationDate = reservationDate; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isExpired() {
        if (!"active".equals(status)) return false;
        Date today = new Date(System.currentTimeMillis());
        return expiryDate != null && today.after(expiryDate);
    }
}
