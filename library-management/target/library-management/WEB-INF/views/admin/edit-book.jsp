<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.library.model.Book" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Book - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container" style="max-width:700px;">
    <div class="page-header">
        <h1>✏️ Edit Book</h1>
        <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">← Back</a>
    </div>
    <div class="card">
        <div class="card-body">
            <c:set var="book" value="${book}"/>
            <form action="${pageContext.request.contextPath}/admin/books" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${book.id}">
                <div class="form-row">
                    <div class="form-group">
                        <label>Title *</label>
                        <input type="text" name="title" value="${book.title}" required>
                    </div>
                    <div class="form-group">
                        <label>Author *</label>
                        <input type="text" name="author" value="${book.author}" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>ISBN *</label>
                        <input type="text" name="isbn" value="${book.isbn}" required>
                    </div>
                    <div class="form-group">
                        <label>Publisher</label>
                        <input type="text" name="publisher" value="${book.publisher}">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${cat.id == book.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Total Copies *</label>
                        <input type="number" name="totalCopies" value="${book.totalCopies}" min="1" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Price (₹)</label>
                        <input type="number" name="price" step="0.01" value="${book.price}">
                    </div>
                    <div class="form-group">
                        <label>Edition</label>
                        <input type="text" name="edition" value="${book.edition}">
                    </div>
                </div>
                <div class="form-group">
                    <label>Year Published</label>
                    <input type="number" name="yearPublished" value="${book.yearPublished}">
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="3">${book.description}</textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Book</button>
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
