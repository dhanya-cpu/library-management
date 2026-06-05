<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Books - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📚 Manage Books</h1>
        <a href="${pageContext.request.contextPath}/admin/books?action=add" class="btn btn-primary">+ Add Book</a>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Search -->
    <div class="search-bar">
        <form method="get" action="${pageContext.request.contextPath}/admin/books">
            <input type="text" name="search" placeholder="Search by title, author, ISBN, or category..."
                   value="${search}" class="search-input">
            <button type="submit" class="btn btn-primary">Search</button>
            <c:if test="${not empty search}">
                <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">Clear</a>
            </c:if>
        </form>
    </div>

    <!-- Category Filter -->
    <div class="filter-bar">
        <span>Filter by category:</span>
        <a href="${pageContext.request.contextPath}/admin/books" class="filter-tag">All</a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/admin/books?category=${cat.id}" class="filter-tag">${cat.name}</a>
        </c:forEach>
    </div>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Category</th>
                    <th>Total</th>
                    <th>Available</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${books}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${book.title}</strong>
                            <c:if test="${not empty book.edition}">
                                <small class="text-muted"> (${book.edition})</small>
                            </c:if>
                        </td>
                        <td>${book.author}</td>
                        <td>${book.isbn}</td>
                        <td><span class="badge badge-info">${book.categoryName}</span></td>
                        <td>${book.totalCopies}</td>
                        <td>
                            <c:choose>
                                <c:when test="${book.availableCopies > 0}">
                                    <span class="badge badge-success">${book.availableCopies}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">0</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-cell">
                            <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}"
                               class="btn btn-sm btn-info">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/books?action=delete&id=${book.id}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Delete this book permanently?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty books}">
                    <tr><td colspan="8" class="text-center">No books found.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
