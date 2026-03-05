# Ocean View Reservation System (v2.0) 🌊🏨

A secure, Java-based web application designed to manage hotel reservations, room configurations, and staff administration. Built using the Jakarta EE stack and Maven.

## 🚀 Project Overview
Ocean View Reservation System provides a streamlined interface for hotel staff and managers. It handles the complete lifecycle of a guest's stay, from initial booking and room assignment to secure checkout and billing.

## ✨ Key Features
* **Secure Authentication:** Role-based access (Manager/Staff) with brute-force protection (Account Lockout after 3 failed attempts).
* **Reservation Management:** Dynamic search, booking, updating, and deletion of guest records.
* **Inventory Control:** Real-time room status tracking (Available/Booked/Cleaning).
* **Administrative Audit Log:** Tracking of all critical changes made by administrators for transparency.
* **Automated Status Updates:** SQL-driven cleanup of expired reservations to free up rooms automatically.

## 🛠 Tech Stack
* **Backend:** Java 17, Jakarta Servlets 6.1
* **Database:** MySQL 8.0
* **Build Tool:** Maven
* **Testing:** JUnit 5, Mockito (with Static Mocking)
* **Frontend:** JSP, CSS3, JavaScript
* **CI/CD:** GitHub Actions (Maven Build & Dependency Submission)

## 🧪 Testing Architecture
Version 2.0 introduces a comprehensive testing suite. We utilized **Mockito** to perform:
* **Unit Testing:** Isolated testing of Servlets using Mockito mocks for `HttpServletRequest`, `Response`, and `HttpSession`.
* **Static Mocking:** Intercepting JDBC `DBConnection` calls to test database logic without requiring a live server.
* **Dependency Injection:** Refactored Servlets to support constructor-based injection for better testability.

## 👤 Author
Anuradha Gamage - *Initial Work & Architecture*
