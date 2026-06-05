package com.library.servlet.user;

import com.library.dao.BookDAO;
import com.library.dao.ReservationDAO;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/books")
public class BrowseBooksServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String search = req.getParameter("search");
        String catParam = req.getParameter("category");

        if (search != null && !search.trim().isEmpty()) {
            req.setAttribute("books", bookDAO.searchBooks(search.trim()));
            req.setAttribute("search", search);
        } else if (catParam != null && !catParam.isEmpty()) {
            int catId = Integer.parseInt(catParam);
            req.setAttribute("books", bookDAO.getBooksByCategory(catId));
            req.setAttribute("selectedCategory", catId);
        } else {
            req.setAttribute("books", bookDAO.getAllBooks());
        }

        req.setAttribute("categories", bookDAO.getAllCategories());
        req.getRequestDispatcher("/WEB-INF/views/user/books.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if ("reserve".equals(action)) {
            int bookId = Integer.parseInt(req.getParameter("bookId"));
            boolean ok = reservationDAO.reserveBook(bookId, user.getId());
            req.getSession().setAttribute("message", ok ? "Book reserved successfully! Valid for 7 days." : "Failed to reserve. You may have already reserved this book.");
        } else if ("cancelReservation".equals(action)) {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            reservationDAO.cancelReservation(reservationId, user.getId());
            req.getSession().setAttribute("message", "Reservation cancelled.");
        }
        resp.sendRedirect(req.getContextPath() + "/user/books");
    }
}
