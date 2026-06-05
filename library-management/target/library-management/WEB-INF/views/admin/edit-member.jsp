<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Member - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container" style="max-width:600px;">
    <div class="page-header">
        <h1>✏️ Edit Member</h1>
        <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline">← Back</a>
    </div>
    <div class="card">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/members" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${member.id}">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" value="${member.username}" disabled class="disabled-input">
                </div>
                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="fullName" value="${member.fullName}" required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" value="${member.email}" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" name="phone" value="${member.phone}">
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" value="${member.address}">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Member</button>
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
