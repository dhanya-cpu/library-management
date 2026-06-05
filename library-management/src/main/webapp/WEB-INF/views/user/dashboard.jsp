<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.library.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Dashboard - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <%
        User currentUser = (User) session.getAttribute("user");
    %>
    <div class="page-header">
        <h1>My Dashboard</h1>
        <p>Welcome, <%= currentUser.getFullName() %>!</p>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Pending Fines Warning -->
    <c:if test="${pendingFines > 0}">
        <div class="alert alert-warning">
            ⚠️ You have outstanding fines of <strong>₹${pendingFines}</strong>. Please contact the librarian to clear them.
        </div>
    </c:if>

    <!-- My Issued Books -->
    <div class="section-header">
        <h2>📖 My Issued Books</h2>
        <a href="${pageContext.request.contextPath}/user/books" class="btn btn-primary btn-sm">Browse Books</a>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr><th>Book Title</th><th>Issue Date</th><th>Due Date</th><th>Status</th></tr>
            </thead>
            <tbody>
                <c:forEach var="issue" items="${myIssues}">
                    <c:if test="${issue.status != 'returned'}">
                        <tr class="${issue.overdue ? 'row-danger' : ''}">
                            <td><strong>${issue.bookTitle}</strong></td>
                            <td>${issue.issueDate}</td>
                            <td>${issue.dueDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${issue.overdue}">
                                        <span class="badge badge-danger">Overdue (${issue.overdueDays} days)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-success">Active</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${empty myIssues}">
                    <tr><td colspan="4" class="text-center">No books currently issued.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- My Reservations -->
    <div class="section-header" style="margin-top:25px;">
        <h2>🔖 My Reservations</h2>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr><th>Book</th><th>Reserved On</th><th>Expires</th><th>Status</th><th>Action</th></tr>
            </thead>
            <tbody>
                <c:forEach var="res" items="${myReservations}">
                    <tr>
                        <td>${res.bookTitle}</td>
                        <td>${res.reservationDate}</td>
                        <td>${res.expiryDate}</td>
                        <td><span class="badge badge-${res.status == 'active' ? 'success' : 'secondary'}">${res.status}</span></td>
                        <td>
                            <c:if test="${res.status == 'active'}">
                                <form method="post" action="${pageContext.request.contextPath}/user/books" style="display:inline">
                                    <input type="hidden" name="action" value="cancelReservation">
                                    <input type="hidden" name="reservationId" value="${res.id}">
                                    <button type="submit" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Cancel this reservation?')">Cancel</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty myReservations}">
                    <tr><td colspan="5" class="text-center">No reservations.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- My Fines -->
    <div class="section-header" style="margin-top:25px;">
        <h2>💰 My Fines</h2>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr><th>Book</th><th>Fine Amount</th><th>Paid</th><th>Outstanding</th><th>Status</th></tr>
            </thead>
            <tbody>
                <c:forEach var="fine" items="${myFines}">
                    <tr>
                        <td>${fine.bookTitle}</td>
                        <td>₹${fine.fineAmount}</td>
                        <td>₹${fine.paidAmount}</td>
                        <td class="${fine.outstandingAmount > 0 ? 'text-danger' : ''}">₹${fine.outstandingAmount}</td>
                        <td><span class="badge badge-${fine.status == 'paid' ? 'success' : fine.status == 'waived' ? 'secondary' : 'danger'}">${fine.status}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty myFines}">
                    <tr><td colspan="5" class="text-center">No fines.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div style="margin-top:20px; text-align:center;">
        <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">📧 Contact Library</a>
    </div>
</div>
</body>
</html>
