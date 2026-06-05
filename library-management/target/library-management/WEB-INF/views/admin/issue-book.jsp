<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Issue / Return Books - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📤 Issue / Return Books</h1>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <div class="two-col">
        <!-- Issue Book Form -->
        <div class="card">
            <div class="card-header"><h3>📤 Issue a Book</h3></div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/issue" method="post">
                    <input type="hidden" name="action" value="issue">
                    <div class="form-group">
                        <label>Select Book *</label>
                        <select name="bookId" required>
                            <option value="">-- Select Book --</option>
                            <c:forEach var="book" items="${books}">
                                <option value="${book.id}" ${book.availableCopies < 1 ? 'disabled' : ''}>
                                    ${book.title} - ${book.author}
                                    (${book.availableCopies} available)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Select Member *</label>
                        <select name="memberId" required>
                            <option value="">-- Select Member --</option>
                            <c:forEach var="member" items="${members}">
                                <option value="${member.id}">${member.fullName} (${member.username})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <p class="text-muted" style="font-size:0.85rem;">Issue period: 14 days. Fine: ₹2/day after due date.</p>
                    <button type="submit" class="btn btn-primary btn-block">Issue Book</button>
                </form>
            </div>
        </div>

        <!-- Return Book Form -->
        <div class="card">
            <div class="card-header"><h3>📥 Return a Book</h3></div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/issue" method="post">
                    <input type="hidden" name="action" value="return">
                    <div class="form-group">
                        <label>Select Issue Record *</label>
                        <select name="issueId" required>
                            <option value="">-- Select Active Issue --</option>
                            <c:forEach var="issue" items="${issues}">
                                <c:if test="${issue.status == 'issued' or issue.status == 'overdue'}">
                                    <option value="${issue.id}">
                                        ${issue.bookTitle} → ${issue.memberName}
                                        (Due: ${issue.dueDate})
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <p class="text-muted" style="font-size:0.85rem;">Fine will be auto-calculated on return if overdue.</p>
                    <button type="submit" class="btn btn-warning btn-block">Process Return</button>
                </form>
            </div>
        </div>
    </div>

    <!-- All Issues Table -->
    <div class="section-header" style="margin-top:30px;">
        <h2>All Issue Records</h2>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Book</th>
                    <th>Member</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="issue" items="${issues}" varStatus="st">
                    <tr class="${issue.overdue ? 'row-danger' : ''}">
                        <td>${st.count}</td>
                        <td>${issue.bookTitle}</td>
                        <td>${issue.memberName}</td>
                        <td>${issue.issueDate}</td>
                        <td>${issue.dueDate}</td>
                        <td>${issue.returnDate != null ? issue.returnDate : '-'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${issue.status == 'returned'}">
                                    <span class="badge badge-secondary">Returned</span>
                                </c:when>
                                <c:when test="${issue.overdue}">
                                    <span class="badge badge-danger">Overdue</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">Active</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${issue.status != 'returned'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/issue" style="display:inline">
                                    <input type="hidden" name="action" value="return">
                                    <input type="hidden" name="issueId" value="${issue.id}">
                                    <button type="submit" class="btn btn-sm btn-warning"
                                            onclick="return confirm('Mark as returned?')">Return</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty issues}">
                    <tr><td colspan="8" class="text-center">No issue records.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
