package com.library.servlet.admin;

import com.library.dao.UserDAO;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/members")
public class ManageMembersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if ("view".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("member", userDAO.getUserById(id));
            req.getRequestDispatcher("/WEB-INF/views/admin/view-member.jsp").forward(req, resp);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("member", userDAO.getUserById(id));
            req.getRequestDispatcher("/WEB-INF/views/admin/edit-member.jsp").forward(req, resp);
        } else if ("toggle".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            User member = userDAO.getUserById(id);
            if (member != null) {
                member.setActive(!member.isActive());
                userDAO.updateUser(member);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/members");
        } else if ("add".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/views/admin/add-member.jsp").forward(req, resp);
        } else {
            req.setAttribute("members", userDAO.getAllMembers());
            req.getRequestDispatcher("/WEB-INF/views/admin/members.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            User user = new User();
            user.setUsername(req.getParameter("username"));
            user.setPassword(req.getParameter("password"));
            user.setFullName(req.getParameter("fullName"));
            user.setEmail(req.getParameter("email"));
            user.setPhone(req.getParameter("phone"));
            user.setAddress(req.getParameter("address"));
            user.setRole("member");

            boolean ok = userDAO.register(user);
            req.getSession().setAttribute("message", ok ? "Member added successfully." : "Failed. Username or email may already exist.");
        } else if ("update".equals(action)) {
            User user = userDAO.getUserById(Integer.parseInt(req.getParameter("id")));
            if (user != null) {
                user.setFullName(req.getParameter("fullName"));
                user.setEmail(req.getParameter("email"));
                user.setPhone(req.getParameter("phone"));
                user.setAddress(req.getParameter("address"));
                userDAO.updateUser(user);
                req.getSession().setAttribute("message", "Member updated successfully.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/members");
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && user.isAdmin();
    }
}
