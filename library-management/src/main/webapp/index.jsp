<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Redirect to login or dashboard based on session
    Object user = session.getAttribute("user");
    if (user != null) {
        com.library.model.User u = (com.library.model.User) user;
        if (u.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
