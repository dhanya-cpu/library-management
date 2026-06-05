package com.library.servlet.admin;

import com.library.dao.FineDAO;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/fines")
public class ManageFinesServlet extends HttpServlet {

    private final FineDAO fineDAO = new FineDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        req.setAttribute("fines", fineDAO.getAllFines());
        req.setAttribute("totalPending", fineDAO.getTotalPendingFines());
        req.getRequestDispatcher("/WEB-INF/views/admin/fines.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        int fineId = Integer.parseInt(req.getParameter("fineId"));

        if ("pay".equals(action)) {
            BigDecimal amount = new BigDecimal(req.getParameter("amount"));
            boolean ok = fineDAO.payFine(fineId, amount);
            req.getSession().setAttribute("message", ok ? "Fine payment recorded." : "Payment failed.");
        } else if ("waive".equals(action)) {
            boolean ok = fineDAO.waiveFine(fineId);
            req.getSession().setAttribute("message", ok ? "Fine waived." : "Waiver failed.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/fines");
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && user.isAdmin();
    }
}
