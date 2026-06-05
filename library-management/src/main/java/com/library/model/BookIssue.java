package com.library.model;

import java.sql.Date;

public class BookIssue {
    private int id;
    private int bookId;
    private String bookTitle;
    private String bookIsbn;
    private int memberId;
    private String memberName;
    private String memberUsername;
    private Date issueDate;
    private Date dueDate;
    private Date returnDate;
    private String status; // "issued", "returned", "overdue"
    private int issuedBy;
    private String issuedByName;

    public BookIssue() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookIsbn() { return bookIsbn; }
    public void setBookIsbn(String bookIsbn) { this.bookIsbn = bookIsbn; }

    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    public String getMemberUsername() { return memberUsername; }
    public void setMemberUsername(String memberUsername) { this.memberUsername = memberUsername; }

    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getIssuedBy() { return issuedBy; }
    public void setIssuedBy(int issuedBy) { this.issuedBy = issuedBy; }

    public String getIssuedByName() { return issuedByName; }
    public void setIssuedByName(String issuedByName) { this.issuedByName = issuedByName; }

    public boolean isOverdue() {
        if ("returned".equals(status)) return false;
        Date today = new Date(System.currentTimeMillis());
        return dueDate != null && today.after(dueDate);
    }

    public long getOverdueDays() {
        if (!isOverdue()) return 0;
        Date today = new Date(System.currentTimeMillis());
        long diff = today.getTime() - dueDate.getTime();
        return diff / (1000 * 60 * 60 * 24);
    }
}
