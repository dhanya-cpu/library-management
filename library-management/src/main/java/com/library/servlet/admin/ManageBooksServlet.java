package com.library.servlet.admin;

import com.library.dao.BookDAO;
import com.library.model.Book;
import com.library.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/books")
public class ManageBooksServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("book", bookDAO.getBookById(id));
            req.setAttribute("categories", bookDAO.getAllCategories());
            req.getRequestDispatcher("/WEB-INF/views/admin/edit-book.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean deleted = bookDAO.deleteBook(id);
            req.getSession().setAttribute("message", deleted ? "Book deleted successfully." : "Cannot delete book (may have active issues).");
            resp.sendRedirect(req.getContextPath() + "/admin/books");
        } else if ("add".equals(action)) {
            req.setAttribute("categories", bookDAO.getAllCategories());
            req.getRequestDispatcher("/WEB-INF/views/admin/add-book.jsp").forward(req, resp);
        } else {
            String search = req.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                req.setAttribute("books", bookDAO.searchBooks(search.trim()));
                req.setAttribute("search", search);
            } else {
                req.setAttribute("books", bookDAO.getAllBooks());
            }
            req.setAttribute("categories", bookDAO.getAllCategories());
            req.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        Book book = new Book();

        if (req.getParameter("id") != null && !req.getParameter("id").isEmpty()) {
            book.setId(Integer.parseInt(req.getParameter("id")));
        }
        book.setIsbn(req.getParameter("isbn"));
        book.setTitle(req.getParameter("title"));
        book.setAuthor(req.getParameter("author"));
        book.setPublisher(req.getParameter("publisher"));
        book.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));

        String totalCopies = req.getParameter("totalCopies");
        book.setTotalCopies(totalCopies != null && !totalCopies.isEmpty() ? Integer.parseInt(totalCopies) : 1);

        String price = req.getParameter("price");
        if (price != null && !price.isEmpty()) book.setPrice(new BigDecimal(price));

        book.setEdition(req.getParameter("edition"));
        String year = req.getParameter("yearPublished");
        if (year != null && !year.isEmpty()) book.setYearPublished(Integer.parseInt(year));
        book.setDescription(req.getParameter("description"));

        boolean success;
        if ("add".equals(action)) {
            success = bookDAO.addBook(book);
            req.getSession().setAttribute("message", success ? "Book added successfully." : "Failed to add book. ISBN may already exist.");
        } else {
            success = bookDAO.updateBook(book);
            req.getSession().setAttribute("message", success ? "Book updated successfully." : "Failed to update book.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && user.isAdmin();
    }
}
