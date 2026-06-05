package com.library.servlet.admin;

import com.library.dao.*;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final IssueDAO issueDAO = new IssueDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String type = req.getParameter("type");
        if (type == null) type = "summary";

        req.setAttribute("reportType", type);

        switch (type) {
            case "books":
                req.setAttribute("books", bookDAO.getAllBooks());
                req.setAttribute("categories", bookDAO.getAllCategories());
                break;
            case "issues":
                req.setAttribute("issues", issueDAO.getAllIssues());
                break;
            case "overdue":
                issueDAO.updateOverdueStatus();
                req.setAttribute("issues", issueDAO.getActiveIssues());
                break;
            case "fines":
                req.setAttribute("fines", fineDAO.getAllFines());
                req.setAttribute("totalPending", fineDAO.getTotalPendingFines());
                break;
            case "members":
                req.setAttribute("members", userDAO.getAllMembers());
                break;
            case "reservations":
                req.setAttribute("reservations", reservationDAO.getAllReservations());
                break;
            default: // summary
                req.setAttribute("totalBooks", bookDAO.getTotalBooks());
                req.setAttribute("totalMembers", userDAO.getTotalMembers());
                req.setAttribute("activeIssues", issueDAO.getActiveIssueCount());
                req.setAttribute("overdueCount", issueDAO.getOverdueCount());
                req.setAttribute("pendingFines", fineDAO.getTotalPendingFines());
                req.setAttribute("reservationCount", reservationDAO.getActiveReservationCount());
                req.setAttribute("categories", bookDAO.getAllCategories());
                break;
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && user.isAdmin();
    }
}
