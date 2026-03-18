# 🎬 Kumari Cinemas - Cinema Management System

A premium, modern Cinema Management System built with **ASP.NET WebForms**, **C#**, and **Oracle Database (SQL)**. This application provides a comprehensive administrative dashboard and transactional logs for managing theaters, shows, and ticket bookings.

## 🚀 Key Features

### 1. **Intuitive Administrative Dashboard**
- **Sales Analytics**: Real-time bar charts showing ticket sales per movie title.
- **Theater Traffic**: Doughnut charts visualizing distribution across different cinema locations.
- **Top Performers**: Leaderboard of the highest-revenue-generating cinema halls.
- **Dashboard Counters**: Live tracking of total customers, active movies, and revenue.

### 2. **Advanced Ticket Management**
- **Automated Cancellation**: **1-hour policy** that voids 'Pending' reservations automatically a hour before showtime to maximize seat availability.
- **Soft Deletion**: All ticket cancellations require a reason and are preserved for auditing rather than being hard-deleted.
- **Transaction Visibility**: Detailed receipt views and editable ticket states via premium Bootstrap modals.
- **Seat Occupancy Reporting**: Real-time percentage-based occupancy tracking, filtering specifically for paid/confirmed seats.

### 3. **Comprehensive Reporting System**
- **User Transaction History**: 6-month historical overview of all ticket purchases.
- **Movie Deployments**: Hall-by-hall programming schedule with dynamic pricing visibility.
- **Cinema Hall Analytics**: Top 3 high-performer insights for any selected movie title.

## 🛠️ Tech Stack
*   **Frontend**: ASP.NET WebForms, Bootstrap 5, Chart.js (Graphical Dashboards), BI Icons.
*   **Backend**: C#.NET, Oracle SQL (Parameterized Queries).
*   **Database**: Oracle 19c (Local instance).

## 📂 Project Structure
*   `Default.aspx`: Premium Dashboard with analytics.
*   `TicketDetails.aspx`: Main transaction console with automatic cleanup logic.
*   `UserTicket.aspx`: 6-month historical ledger.
*   `MovieHallOccupancy.aspx`: Performance-tier reporting.
*   `TheaterCityHallMovie.aspx`: Deployment and screening schedules.

## 📝 Configuration
The project uses the `KumariCinemaDB` connection string in `Web.config`.

---
*Built with ❤️ for Kumari Cinemas.*
