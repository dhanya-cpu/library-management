package com.library.dao;

import com.library.model.Book;
import com.library.model.Category;
import com.library.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id ORDER BY b.title";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) books.add(mapBook(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public Book getBookById(int id) {
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id WHERE b.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapBook(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Book> searchBooks(String query) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? OR c.name LIKE ? " +
                     "ORDER BY b.title";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + query + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) books.add(mapBook(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name FROM books b " +
                     "LEFT JOIN categories c ON b.category_id = c.id " +
                     "WHERE b.category_id=? ORDER BY b.title";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) books.add(mapBook(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (isbn, title, author, publisher, category_id, total_copies, available_copies, price, edition, year_published, description) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setInt(5, book.getCategoryId());
            ps.setInt(6, book.getTotalCopies());
            ps.setInt(7, book.getTotalCopies()); // available = total on add
            ps.setBigDecimal(8, book.getPrice());
            ps.setString(9, book.getEdition());
            ps.setInt(10, book.getYearPublished());
            ps.setString(11, book.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET isbn=?, title=?, author=?, publisher=?, category_id=?, " +
                     "total_copies=?, price=?, edition=?, year_published=?, description=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getPublisher());
            ps.setInt(5, book.getCategoryId());
            ps.setInt(6, book.getTotalCopies());
            ps.setBigDecimal(7, book.getPrice());
            ps.setString(8, book.getEdition());
            ps.setInt(9, book.getYearPublished());
            ps.setString(10, book.getDescription());
            ps.setInt(11, book.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Categories
    public List<Category> getAllCategories() {
        List<Category> cats = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(b.id) AS book_count FROM categories c " +
                     "LEFT JOIN books b ON c.id = b.category_id GROUP BY c.id ORDER BY c.name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Category cat = new Category(rs.getInt("id"), rs.getString("name"), rs.getString("description"));
                cat.setBookCount(rs.getInt("book_count"));
                cats.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cats;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name, description) VALUES (?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvailableCopies(int bookId, int delta, Connection conn) throws SQLException {
        String sql = "UPDATE books SET available_copies = available_copies + ? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        }
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setIsbn(rs.getString("isbn"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPublisher(rs.getString("publisher"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setCategoryName(rs.getString("category_name"));
        book.setTotalCopies(rs.getInt("total_copies"));
        book.setAvailableCopies(rs.getInt("available_copies"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setEdition(rs.getString("edition"));
        book.setYearPublished(rs.getInt("year_published"));
        book.setDescription(rs.getString("description"));
        book.setAddedAt(rs.getTimestamp("added_at"));
        return book;
    }
}
