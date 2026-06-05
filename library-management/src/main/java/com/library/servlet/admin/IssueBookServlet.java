package com.library.servlet.admin;

import com.library.dao.BookDAO;
import com.library.dao.IssueDAO;
import com.library.dao.UserDAO;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/issue")
public class IssueBookServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        req.setAttribute("issues", issueDAO.getAllIssues());
        req.setAttribute("books", bookDAO.getAllBooks());
        req.setAttribute("members", userDAO.getAllMembers());
        req.getRequestDispatcher("/WEB-INF/views/admin/issue-book.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        User admin = (User) req.getSession().getAttribute("user");

        if ("issue".equals(action)) {
            int bookId = Integer.parseInt(req.getParameter("bookId"));
            int memberId = Integer.parseInt(req.getParameter("memberId"));
            boolean ok = issueDAO.issueBook(bookId, memberId, admin.getId());
            req.getSession().setAttribute("message", ok ? "Book issued successfully." : "Failed to issue. Book may be unavailable or already issued to this member.");
        } else if ("return".equals(action)) {
            int issueId = Integer.parseInt(req.getParameter("issueId"));
            boolean ok = issueDAO.returnBook(issueId);
            req.getSession().setAttribute("message", ok ? "Book returned successfully." : "Failed to process return.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/issue");
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && user.isAdmin();
    }
}
