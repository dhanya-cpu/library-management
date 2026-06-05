# Library Management System

A complete web-based Library Management System built with Java Servlets, JSP, and MySQL.

<img width="683" height="806" alt="image" src="https://github.com/user-attachments/assets/8fe07dba-555b-440e-8ba9-20213cae922d" />

<img width="1815" height="818" alt="image" src="https://github.com/user-attachments/assets/640dad04-22e6-4e6d-831c-ea72d0445708" />

<img width="1826" height="834" alt="image" src="https://github.com/user-attachments/assets/6678a591-9018-4fe5-90bd-d4431f967614" />


<img width="325" height="619" alt="image" src="https://github.com/user-attachments/assets/1bd2a2b0-7eee-4258-9eb7-7dd747e8c529" />





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


