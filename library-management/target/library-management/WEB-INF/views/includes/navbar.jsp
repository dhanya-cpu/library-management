<%@ page import="com.library.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String cp = request.getContextPath();
    String uri = request.getRequestURI();
%>
<nav class="navbar">
    <div class="nav-brand">
        <a href="<%= cp %>/"><span>📚</span> LibraryMS</a>
    </div>
    <div class="nav-links">
        <% if (navUser != null && navUser.isAdmin()) { %>
            <a href="<%= cp %>/admin/dashboard" class="<%= uri.contains("/admin/dashboard") ? "active" : "" %>">Dashboard</a>
            <a href="<%= cp %>/admin/books" class="<%= uri.contains("/admin/books") ? "active" : "" %>">Books</a>
            <a href="<%= cp %>/admin/members" class="<%= uri.contains("/admin/members") ? "active" : "" %>">Members</a>
            <a href="<%= cp %>/admin/issue" class="<%= uri.contains("/admin/issue") ? "active" : "" %>">Issue/Return</a>
            <a href="<%= cp %>/admin/fines" class="<%= uri.contains("/admin/fines") ? "active" : "" %>">Fines</a>
            <a href="<%= cp %>/admin/reports" class="<%= uri.contains("/admin/reports") ? "active" : "" %>">Reports</a>
        <% } else if (navUser != null) { %>
            <a href="<%= cp %>/user/dashboard" class="<%= uri.contains("/user/dashboard") ? "active" : "" %>">Dashboard</a>
            <a href="<%= cp %>/user/books" class="<%= uri.contains("/user/books") ? "active" : "" %>">Browse Books</a>
            <a href="<%= cp %>/contact" class="<%= uri.contains("/contact") ? "active" : "" %>">Contact</a>
        <% } else { %>
            <a href="<%= cp %>/login">Login</a>
            <a href="<%= cp %>/register">Register</a>
        <% } %>
    </div>
    <div class="nav-user">
        <% if (navUser != null) { %>
            <span class="user-badge <%= navUser.isAdmin() ? "admin" : "member" %>">
                <%= navUser.isAdmin() ? "Admin" : "Member" %>
            </span>
            <span class="user-name"><%= navUser.getFullName() %></span>
            <a href="<%= cp %>/logout" class="btn btn-outline btn-sm">Logout</a>
        <% } %>
    </div>
</nav>
