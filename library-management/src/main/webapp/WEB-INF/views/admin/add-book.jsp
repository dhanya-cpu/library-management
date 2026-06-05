<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Book - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container" style="max-width:700px;">
    <div class="page-header">
        <h1>➕ Add New Book</h1>
        <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">← Back</a>
    </div>
    <div class="card">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/books" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label>Title *</label>
                        <input type="text" name="title" required>
                    </div>
                    <div class="form-group">
                        <label>Author *</label>
                        <input type="text" name="author" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>ISBN *</label>
                        <input type="text" name="isbn" required>
                    </div>
                    <div class="form-group">
                        <label>Publisher</label>
                        <input type="text" name="publisher">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <option value="">-- Select Category --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Total Copies *</label>
                        <input type="number" name="totalCopies" value="1" min="1" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Price (₹)</label>
                        <input type="number" name="price" step="0.01" min="0">
                    </div>
                    <div class="form-group">
                        <label>Edition</label>
                        <input type="text" name="edition" placeholder="e.g. 3rd Edition">
                    </div>
                </div>
                <div class="form-group">
                    <label>Year Published</label>
                    <input type="number" name="yearPublished" min="1800" max="2030">
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="3"></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Book</button>
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
