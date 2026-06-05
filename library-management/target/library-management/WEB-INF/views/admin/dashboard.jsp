<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.library.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>

<div class="container">
    <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p>Welcome back, <%= ((User)session.getAttribute("user")).getFullName() %></p>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <div class="stat-card blue">
            <div class="stat-icon">📚</div>
            <div class="stat-info">
                <h3>${totalBooks}</h3>
                <p>Total Books</p>
            </div>
        </div>
        <div class="stat-card green">
            <div class="stat-icon">👥</div>
            <div class="stat-info">
                <h3>${totalMembers}</h3>
                <p>Active Members</p>
            </div>
        </div>
        <div class="stat-card orange">
            <div class="stat-icon">📖</div>
            <div class="stat-info">
                <h3>${activeIssues}</h3>
                <p>Books Issued</p>
            </div>
        </div>
        <div class="stat-card red">
            <div class="stat-icon">⚠️</div>
            <div class="stat-info">
                <h3>${overdueCount}</h3>
                <p>Overdue Books</p>
            </div>
        </div>
        <div class="stat-card purple">
            <div class="stat-icon">💰</div>
            <div class="stat-info">
                <h3>₹${pendingFines}</h3>
                <p>Pending Fines</p>
            </div>
        </div>
        <div class="stat-card teal">
            <div class="stat-icon">🔖</div>
            <div class="stat-info">
                <h3>${reservationCount}</h3>
                <p>Reservations</p>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="section-header">
        <h2>Quick Actions</h2>
    </div>
    <div class="quick-actions">
        <a href="${pageContext.request.contextPath}/admin/books?action=add" class="action-btn">
            <span>➕</span> Add Book
        </a>
        <a href="${pageContext.request.contextPath}/admin/members?action=add" class="action-btn">
            <span>👤</span> Add Member
        </a>
        <a href="${pageContext.request.contextPath}/admin/issue" class="action-btn">
            <span>📤</span> Issue Book
        </a>
        <a href="${pageContext.request.contextPath}/admin/fines" class="action-btn">
            <span>💳</span> Manage Fines
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="action-btn">
            <span>📊</span> Reports
        </a>
    </div>

    <!-- Recent Issues -->
    <div class="section-header" style="margin-top:30px;">
        <h2>Currently Issued Books</h2>
        <a href="${pageContext.request.contextPath}/admin/issue" class="btn btn-outline btn-sm">View All</a>
    </div>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Book</th>
                    <th>Member</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="issue" items="${recentIssues}" begin="0" end="9">
                    <tr>
                        <td>${issue.bookTitle}</td>
                        <td>${issue.memberName}</td>
                        <td>${issue.issueDate}</td>
                        <td>${issue.dueDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${issue.overdue}">
                                    <span class="badge badge-danger">Overdue</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">Active</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/issue" style="display:inline">
                                <input type="hidden" name="action" value="return">
                                <input type="hidden" name="issueId" value="${issue.id}">
                                <button type="submit" class="btn btn-sm btn-warning"
                                        onclick="return confirm('Mark this book as returned?')">Return</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentIssues}">
                    <tr><td colspan="6" class="text-center">No active issues.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
