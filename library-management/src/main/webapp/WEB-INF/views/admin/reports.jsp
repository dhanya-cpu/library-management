<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        @media print { .navbar, .report-nav, .no-print { display: none !important; } }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📊 Reports</h1>
        <button onclick="window.print()" class="btn btn-outline no-print">🖨️ Print Report</button>
    </div>

    <!-- Report Navigation -->
    <div class="report-nav no-print">
        <a href="?type=summary" class="${reportType == 'summary' ? 'active' : ''}">Summary</a>
        <a href="?type=books" class="${reportType == 'books' ? 'active' : ''}">Books</a>
        <a href="?type=issues" class="${reportType == 'issues' ? 'active' : ''}">All Issues</a>
        <a href="?type=overdue" class="${reportType == 'overdue' ? 'active' : ''}">Overdue</a>
        <a href="?type=fines" class="${reportType == 'fines' ? 'active' : ''}">Fines</a>
        <a href="?type=members" class="${reportType == 'members' ? 'active' : ''}">Members</a>
        <a href="?type=reservations" class="${reportType == 'reservations' ? 'active' : ''}">Reservations</a>
    </div>

    <!-- Summary Report -->
    <c:if test="${reportType == 'summary'}">
        <h2>Library Summary Report</h2>
        <div class="stats-grid">
            <div class="stat-card blue"><div class="stat-icon">📚</div><div class="stat-info"><h3>${totalBooks}</h3><p>Total Books</p></div></div>
            <div class="stat-card green"><div class="stat-icon">👥</div><div class="stat-info"><h3>${totalMembers}</h3><p>Active Members</p></div></div>
            <div class="stat-card orange"><div class="stat-icon">📖</div><div class="stat-info"><h3>${activeIssues}</h3><p>Active Issues</p></div></div>
            <div class="stat-card red"><div class="stat-icon">⚠️</div><div class="stat-info"><h3>${overdueCount}</h3><p>Overdue</p></div></div>
            <div class="stat-card purple"><div class="stat-icon">💰</div><div class="stat-info"><h3>₹${pendingFines}</h3><p>Pending Fines</p></div></div>
            <div class="stat-card teal"><div class="stat-icon">🔖</div><div class="stat-info"><h3>${reservationCount}</h3><p>Reservations</p></div></div>
        </div>
        <h3 style="margin-top:20px;">Books by Category</h3>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>Category</th><th>Book Count</th></tr></thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}">
                        <tr><td>${cat.name}</td><td>${cat.bookCount}</td></tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Books Report -->
    <c:if test="${reportType == 'books'}">
        <h2>Books Inventory Report</h2>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>#</th><th>Title</th><th>Author</th><th>ISBN</th><th>Category</th><th>Total</th><th>Available</th><th>Price</th></tr></thead>
                <tbody>
                    <c:forEach var="book" items="${books}" varStatus="st">
                        <tr>
                            <td>${st.count}</td><td>${book.title}</td><td>${book.author}</td>
                            <td>${book.isbn}</td><td>${book.categoryName}</td>
                            <td>${book.totalCopies}</td><td>${book.availableCopies}</td>
                            <td>₹${book.price}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Issues Report -->
    <c:if test="${reportType == 'issues' or reportType == 'overdue'}">
        <h2><c:choose><c:when test="${reportType == 'overdue'}">Overdue Books Report</c:when><c:otherwise>All Issues Report</c:otherwise></c:choose></h2>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>#</th><th>Book</th><th>Member</th><th>Issue Date</th><th>Due Date</th><th>Return Date</th><th>Status</th></tr></thead>
                <tbody>
                    <c:forEach var="issue" items="${issues}" varStatus="st">
                        <tr>
                            <td>${st.count}</td><td>${issue.bookTitle}</td><td>${issue.memberName}</td>
                            <td>${issue.issueDate}</td><td>${issue.dueDate}</td>
                            <td>${issue.returnDate != null ? issue.returnDate : '-'}</td>
                            <td><span class="badge badge-${issue.status == 'returned' ? 'secondary' : issue.overdue ? 'danger' : 'success'}">${issue.status}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Fines Report -->
    <c:if test="${reportType == 'fines'}">
        <h2>Fines Report — Total Pending: ₹${totalPending}</h2>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>#</th><th>Member</th><th>Book</th><th>Fine</th><th>Paid</th><th>Outstanding</th><th>Status</th><th>Date</th></tr></thead>
                <tbody>
                    <c:forEach var="fine" items="${fines}" varStatus="st">
                        <tr>
                            <td>${st.count}</td><td>${fine.memberName}</td><td>${fine.bookTitle}</td>
                            <td>₹${fine.fineAmount}</td><td>₹${fine.paidAmount}</td>
                            <td>₹${fine.outstandingAmount}</td>
                            <td><span class="badge badge-${fine.status == 'paid' ? 'success' : fine.status == 'waived' ? 'secondary' : 'danger'}">${fine.status}</span></td>
                            <td>${fine.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Members Report -->
    <c:if test="${reportType == 'members'}">
        <h2>Members Report</h2>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>#</th><th>Name</th><th>Username</th><th>Email</th><th>Phone</th><th>Status</th><th>Joined</th></tr></thead>
                <tbody>
                    <c:forEach var="m" items="${members}" varStatus="st">
                        <tr>
                            <td>${st.count}</td><td>${m.fullName}</td><td>${m.username}</td>
                            <td>${m.email}</td><td>${m.phone}</td>
                            <td><span class="badge badge-${m.active ? 'success' : 'danger'}">${m.active ? 'Active' : 'Inactive'}</span></td>
                            <td>${m.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Reservations Report -->
    <c:if test="${reportType == 'reservations'}">
        <h2>Reservations Report</h2>
        <div class="table-responsive">
            <table class="table">
                <thead><tr><th>#</th><th>Book</th><th>Member</th><th>Reserved On</th><th>Expires</th><th>Status</th></tr></thead>
                <tbody>
                    <c:forEach var="res" items="${reservations}" varStatus="st">
                        <tr>
                            <td>${st.count}</td><td>${res.bookTitle}</td><td>${res.memberName}</td>
                            <td>${res.reservationDate}</td><td>${res.expiryDate}</td>
                            <td><span class="badge badge-${res.status == 'active' ? 'success' : 'secondary'}">${res.status}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>
</body>
</html>
