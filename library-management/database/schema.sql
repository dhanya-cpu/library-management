-- Library Management System - Database Schema
-- Run this script in MySQL to set up the database

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Users table (both admin and members)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    role ENUM('admin', 'member') DEFAULT 'member',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Book categories
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Books table
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150) NOT NULL,
    publisher VARCHAR(150),
    category_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    price DECIMAL(10,2),
    edition VARCHAR(50),
    year_published INT,
    description TEXT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Book issues (lending records)
CREATE TABLE IF NOT EXISTS book_issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('issued', 'returned', 'overdue') DEFAULT 'issued',
    issued_by INT,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (member_id) REFERENCES users(id),
    FOREIGN KEY (issued_by) REFERENCES users(id)
);

-- Fines table
CREATE TABLE IF NOT EXISTS fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT NOT NULL,
    member_id INT NOT NULL,
    fine_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('pending', 'paid', 'waived') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMP NULL,
    FOREIGN KEY (issue_id) REFERENCES book_issues(id),
    FOREIGN KEY (member_id) REFERENCES users(id)
);

-- Advance bookings (reservations)
CREATE TABLE IF NOT EXISTS reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE NOT NULL,
    status ENUM('active', 'fulfilled', 'cancelled', 'expired') DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (member_id) REFERENCES users(id)
);

-- Contact/query messages
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200),
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (member_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Fine rate configuration
CREATE TABLE IF NOT EXISTS fine_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fine_per_day DECIMAL(5,2) DEFAULT 2.00,
    max_issue_days INT DEFAULT 14,
    max_books_per_member INT DEFAULT 5,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default config
INSERT INTO fine_config (fine_per_day, max_issue_days, max_books_per_member) 
VALUES (2.00, 14, 5)
ON DUPLICATE KEY UPDATE fine_per_day = fine_per_day;

-- Insert default categories
INSERT INTO categories (name, description) VALUES
('Fiction', 'Novels, short stories, and other fictional works'),
('Non-Fiction', 'Biographies, essays, and factual writing'),
('Science & Technology', 'Books on science, engineering, and technology'),
('History', 'Historical accounts and analyses'),
('Mathematics', 'Mathematics textbooks and reference books'),
('Computer Science', 'Programming, algorithms, and computing'),
('Literature', 'Classic and contemporary literature'),
('Business', 'Business, management, and economics'),
('Medicine', 'Medical and health-related books'),
('Arts', 'Art, music, and cultural studies')
ON DUPLICATE KEY UPDATE name = name;

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 
 'System Administrator', 'admin@library.com', '0000000000', 'admin')
ON DUPLICATE KEY UPDATE username = username;

-- Sample books
INSERT INTO books (isbn, title, author, publisher, category_id, total_copies, available_copies, price, year_published) VALUES
('978-0-06-112008-4', 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott', 7, 3, 3, 12.99, 1960),
('978-0-7432-7356-5', '1984', 'George Orwell', 'Secker & Warburg', 1, 4, 4, 10.99, 1949),
('978-0-7432-7357-2', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner', 7, 2, 2, 9.99, 1925),
('978-0-13-468599-1', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 6, 5, 5, 35.99, 2008),
('978-0-201-63361-0', 'Design Patterns', 'Gang of Four', 'Addison-Wesley', 6, 3, 3, 45.99, 1994),
('978-0-13-110362-7', 'The C Programming Language', 'Kernighan & Ritchie', 'Prentice Hall', 6, 4, 4, 40.00, 1988)
ON DUPLICATE KEY UPDATE isbn = isbn;
