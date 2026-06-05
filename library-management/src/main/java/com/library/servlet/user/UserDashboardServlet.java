package com.library.servlet.user;

import com.library.dao.*;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (user.isAdmin()) { resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); return; }

        req.setAttribute("myIssues", issueDAO.getIssuesByMember(user.getId()));
        req.setAttribute("myFines", fineDAO.getFinesByMember(user.getId()));
        req.setAttribute("myReservations", reservationDAO.getReservationsByMember(user.getId()));
        req.setAttribute("pendingFines", fineDAO.getMemberPendingFines(user.getId()));

        req.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(req, resp);
    }
}
