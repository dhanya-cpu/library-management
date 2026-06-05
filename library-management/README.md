# Library Management System

A complete web-based Library Management System built with Java Servlets, JSP, and MySQL.

## Features

### Admin Module
- Dashboard with real-time statistics (books, members, issues, fines, reservations)
- Manage Books — Add, edit, delete books; track copies
- Manage Members — Add, edit, activate/deactivate members
- Issue & Return Books — Issue books to members, process returns with auto fine calculation
- Fine Management — View, collect, or waive fines
- Reports — Summary, books inventory, issue history, overdue list, fines, members, reservations (printable)

### Member Module
- Personal dashboard showing issued books, reservations, fines
- Browse books by category or search (title, author, ISBN)
- Reserve unavailable books (valid 7 days)
- Cancel own reservations
- View fine history
- Contact Us form for queries

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Java 11 |
| Web | Servlet 4.0 + JSP 2.3 |
| Template | JSTL 1.2 |
| Database | MySQL 8 |
| Build | Maven |
| Password | BCrypt |
| Server | Apache Tomcat 9+ |

## Setup Instructions

### Prerequisites
- JDK 11+
- Maven 3.6+
- MySQL 8+
- Apache Tomcat 9 or 10

### Step 1: Database Setup
```sql
-- Run the schema file in MySQL
mysql -u root -p < database/schema.sql
```
Or open MySQL Workbench and execute `database/schema.sql`.

### Step 2: Configure Database Connection
Edit `src/main/java/com/library/util/DBConnection.java`:
```java
private static final String PASSWORD = "your_mysql_password";
```

### Step 3: Build
```bash
mvn clean package
```
This generates `target/library-management.war`

### Step 4: Deploy
Copy `library-management.war` to Tomcat's `webapps/` folder and start Tomcat.

### Step 5: Access
Open browser: `http://localhost:8080/library-management`

### Default Admin Login
| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | `admin123` |

## Project Structure

```
library-management/
├── database/
│   └── schema.sql              # MySQL schema + seed data
├── src/main/
│   ├── java/com/library/
│   │   ├── dao/                # Database Access Objects
│   │   │   ├── UserDAO.java
│   │   │   ├── BookDAO.java
│   │   │   ├── IssueDAO.java
│   │   │   ├── FineDAO.java
│   │   │   └── ReservationDAO.java
│   │   ├── model/              # Java Beans (POJOs)
│   │   │   ├── User.java
│   │   │   ├── Book.java
│   │   │   ├── BookIssue.java
│   │   │   ├── Fine.java
│   │   │   ├── Reservation.java
│   │   │   └── Category.java
│   │   ├── servlet/            # HTTP Servlets
│   │   │   ├── LoginServlet.java
│   │   │   ├── LogoutServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── admin/
│   │   │   │   ├── AdminDashboardServlet.java
│   │   │   │   ├── ManageBooksServlet.java
│   │   │   │   ├── ManageMembersServlet.java
│   │   │   │   ├── IssueBookServlet.java
│   │   │   │   ├── ManageFinesServlet.java
│   │   │   │   └── ReportServlet.java
│   │   │   └── user/
│   │   │       ├── UserDashboardServlet.java
│   │   │       ├── BrowseBooksServlet.java
│   │   │       └── ContactServlet.java
│   │   └── util/
│   │       └── DBConnection.java
│   └── webapp/
│       ├── css/style.css
│       ├── index.jsp
│       └── WEB-INF/
│           ├── web.xml
│           └── views/
│               ├── login.jsp
│               ├── register.jsp
│               ├── contact.jsp
│               ├── includes/navbar.jsp
│               ├── admin/           # Admin JSP views
│               └── user/            # Member JSP views
└── pom.xml
```

## Business Rules

- Default issue period: **14 days**
- Fine rate: **₹2 per day** after due date
- Fine is auto-calculated on book return
- Reservations expire after **7 days**
- A member cannot issue the same book twice simultaneously
- Passwords are hashed with BCrypt
