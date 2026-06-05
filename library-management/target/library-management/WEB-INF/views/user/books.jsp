<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Books - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>
<div class="container">
    <div class="page-header">
        <h1>📚 Browse Books</h1>
    </div>

    <% String msg = (String) session.getAttribute("message");
       if (msg != null) { session.removeAttribute("message"); %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <!-- Search -->
    <div class="search-bar">
        <form method="get" action="${pageContext.request.contextPath}/user/books">
            <input type="text" name="search" placeholder="Search by title, author, ISBN, or category..."
                   value="${search}" class="search-input">
            <button type="submit" class="btn btn-primary">Search</button>
            <c:if test="${not empty search}">
                <a href="${pageContext.request.contextPath}/user/books" class="btn btn-outline">Clear</a>
            </c:if>
        </form>
    </div>

    <!-- Category Filter -->
    <div class="filter-bar">
        <span>Browse by category:</span>
        <a href="${pageContext.request.contextPath}/user/books" class="filter-tag">All</a>
        <c:forEach var="cat" items="${categories}">
            <a href="?category=${cat.id}"
               class="filter-tag ${selectedCategory == cat.id ? 'active' : ''}">
                ${cat.name} (${cat.bookCount})
            </a>
        </c:forEach>
    </div>

    <!-- Book Cards Grid -->
    <div class="books-grid">
        <c:forEach var="book" items="${books}">
            <div class="book-card ${not book.available ? 'unavailable' : ''}"
                 onclick="toggleDetail('detail-${book.id}')" style="cursor:pointer;">
                <div class="book-cover">
                    <span class="book-icon">📖</span>
                    <span class="book-copies-badge">${book.availableCopies}/${book.totalCopies}</span>
                </div>
                <div class="book-info">
                    <h3 class="book-title">${book.title}</h3>
                    <p class="book-author">by ${book.author}</p>
                    <span class="book-category">${book.categoryName}</span>
                    <div class="book-meta">
                        <span>ISBN: ${book.isbn}</span>
                        <c:if test="${book.yearPublished > 0}"><span>${book.yearPublished}</span></c:if>
                        <c:if test="${not empty book.publisher}"><span>${book.publisher}</span></c:if>
                    </div>
                    <div class="availability-row">
                        <c:choose>
                            <c:when test="${book.available}">
                                <span class="avail-badge available">✅ ${book.availableCopies} Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="avail-badge not-available">❌ Not Available</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Expandable detail panel -->
                    <div id="detail-${book.id}" class="book-detail-panel" style="display:none;" onclick="event.stopPropagation()">
                        <c:if test="${not empty book.description}">
                            <p class="book-desc">${book.description}</p>
                        </c:if>
                        <c:if test="${not empty book.edition}">
                            <p class="detail-line"><strong>Edition:</strong> ${book.edition}</p>
                        </c:if>
                        <c:if test="${book.price != null}">
                            <p class="detail-line"><strong>Price:</strong> ₹${book.price}</p>
                        </c:if>
                        <div style="margin-top:10px;">
                            <c:choose>
                                <c:when test="${book.available}">
                                    <p class="detail-line" style="color:#16a34a; font-weight:600;">
                                        ✅ Available to borrow — visit the library counter to issue this book.
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/user/books">
                                        <input type="hidden" name="action" value="reserve">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <button type="submit" class="btn btn-sm btn-primary btn-block">
                                            🔖 Reserve This Book
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty books}">
            <div class="no-results">
                <p>No books found matching your search.</p>
                <a href="${pageContext.request.contextPath}/user/books" class="btn btn-outline">View All Books</a>
            </div>
        </c:if>
    </div>

    <script>
        function toggleDetail(id) {
            var panel = document.getElementById(id);
            var allPanels = document.querySelectorAll('.book-detail-panel');
            allPanels.forEach(function(p) {
                if (p.id !== id) { p.style.display = 'none'; }
            });
            panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
        }
    </script>
</div>
</body>
</html>
