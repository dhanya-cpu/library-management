<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.library.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<%@ include file="/WEB-INF/views/includes/navbar.jsp" %>

<div class="container" style="max-width:600px; margin-top:40px;">
    <div class="card">
        <div class="card-header">
            <h2>📧 Contact Us</h2>
            <p>Have a question or query? Send us a message.</p>
        </div>
        <div class="card-body">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/contact" method="post">
                <div class="form-group">
                    <label>Your Name *</label>
                    <input type="text" name="name"
                           value="<%= currentUser != null ? currentUser.getFullName() : "" %>"
                           required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email"
                           value="<%= currentUser != null ? currentUser.getEmail() : "" %>"
                           required>
                </div>
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" placeholder="Brief subject">
                </div>
                <div class="form-group">
                    <label>Message *</label>
                    <textarea name="message" rows="5" placeholder="Write your message here..." required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Message</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
