<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Member - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container" style="max-width:600px;">
    <div class="page-header">
        <h1>👤 Add New Member</h1>
        <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline">← Back</a>
    </div>
    <div class="card">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/members" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label>Username *</label>
                        <input type="text" name="username" required>
                    </div>
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="fullName" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" name="phone">
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Member</button>
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
