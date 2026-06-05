<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Fines - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>💰 Manage Fines</h1>
        <div class="stat-inline">
            Total Pending: <strong class="text-danger">₹${totalPending}</strong>
        </div>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Member</th>
                    <th>Book</th>
                    <th>Fine Amount</th>
                    <th>Paid</th>
                    <th>Outstanding</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="fine" items="${fines}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td>${fine.memberName}</td>
                        <td>${fine.bookTitle}</td>
                        <td>₹${fine.fineAmount}</td>
                        <td>₹${fine.paidAmount}</td>
                        <td class="${fine.outstandingAmount > 0 ? 'text-danger' : ''}">
                            ₹${fine.outstandingAmount}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${fine.status == 'paid'}">
                                    <span class="badge badge-success">Paid</span>
                                </c:when>
                                <c:when test="${fine.status == 'waived'}">
                                    <span class="badge badge-secondary">Waived</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Pending</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${fine.createdAt}</td>
                        <td class="action-cell">
                            <c:if test="${fine.status == 'pending'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/fines"
                                      style="display:inline" class="pay-form">
                                    <input type="hidden" name="fineId" value="${fine.id}">
                                    <input type="hidden" name="action" value="pay">
                                    <input type="number" name="amount" step="0.01" min="0.01"
                                           max="${fine.outstandingAmount}" placeholder="Amount"
                                           class="inline-input" required>
                                    <button type="submit" class="btn btn-sm btn-success">Pay</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/fines"
                                      style="display:inline">
                                    <input type="hidden" name="fineId" value="${fine.id}">
                                    <input type="hidden" name="action" value="waive">
                                    <button type="submit" class="btn btn-sm btn-outline"
                                            onclick="return confirm('Waive this fine?')">Waive</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty fines}">
                    <tr><td colspan="9" class="text-center">No fines recorded.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
