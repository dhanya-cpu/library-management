<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Members - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>👥 Manage Members</h1>
        <a href="${pageContext.request.contextPath}/admin/members?action=add" class="btn btn-primary">+ Add Member</a>
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
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Joined</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${members}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${m.fullName}</strong></td>
                        <td>${m.username}</td>
                        <td>${m.email}</td>
                        <td>${m.phone}</td>
                        <td>
                            <c:choose>
                                <c:when test="${m.active}">
                                    <span class="badge badge-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${m.createdAt}</td>
                        <td class="action-cell">
                            <a href="${pageContext.request.contextPath}/admin/members?action=edit&id=${m.id}"
                               class="btn btn-sm btn-info">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/members?action=toggle&id=${m.id}"
                               class="btn btn-sm ${m.active ? 'btn-warning' : 'btn-success'}">
                                ${m.active ? 'Deactivate' : 'Activate'}
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty members}">
                    <tr><td colspan="8" class="text-center">No members registered.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
