package com.library.servlet.user;

import com.library.model.User;
import com.library.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            req.setAttribute("error", "Name, email, and message are required.");
            req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
            return;
        }

        User user = (User) req.getSession().getAttribute("user");
        String sql = "INSERT INTO contact_messages (member_id, name, email, subject, message) VALUES (?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, user != null ? user.getId() : null);
            ps.setString(2, name.trim());
            ps.setString(3, email.trim());
            ps.setString(4, subject);
            ps.setString(5, message.trim());
            ps.executeUpdate();
            req.setAttribute("success", "Your message has been sent. We'll get back to you soon!");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to send message. Please try again.");
        }

        req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
    }
}
