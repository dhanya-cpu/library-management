package com.library.servlet.admin;

import com.library.dao.*;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final IssueDAO issueDAO = new IssueDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Update statuses
        issueDAO.updateOverdueStatus();
        reservationDAO.expireOldReservations();

        req.setAttribute("totalBooks", bookDAO.getTotalBooks());
        req.setAttribute("totalMembers", userDAO.getTotalMembers());
        req.setAttribute("activeIssues", issueDAO.getActiveIssueCount());
        req.setAttribute("overdueCount", issueDAO.getOverdueCount());
        req.setAttribute("pendingFines", fineDAO.getTotalPendingFines());
        req.setAttribute("reservationCount", reservationDAO.getActiveReservationCount());
        req.setAttribute("recentIssues", issueDAO.getActiveIssues());

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
