<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="kumariCinema_Sharvik.DashboardPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="page-header">
        <div class="page-header-info">
            <h2>Welcome Back, Admin</h2>
            <p>Heres whats happening at Kumari Cinemas today.</p>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-5">
        <div class="col-xl-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-card-icon bg-primary-subtle text-primary">
                    <i class="bi bi-people-fill"></i>
                </div>
                <h3 id="lblTotalUsers" runat="server">0</h3>
                <p>Total Customers</p>
                <div class="mt-2 extra-small text-success fw-bold"><i class="bi bi-arrow-up"></i> 12% increase</div>
            </div>
        </div>
        <div class="col-xl-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-card-icon bg-danger-subtle text-danger">
                    <i class="bi bi-film"></i>
                </div>
                <h3 id="lblTotalMovies" runat="server">0</h3>
                <p>Movies Showing</p>
                <div class="mt-2 extra-small text-muted fw-bold">Active in catalogs</div>
            </div>
        </div>
        <div class="col-xl-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-card-icon bg-success-subtle text-success">
                    <i class="bi bi-building"></i>
                </div>
                <h3 id="lblTotalHalls" runat="server">0</h3>
                <p>Cinema Halls</p>
                <div class="mt-2 extra-small text-muted fw-bold">Across all locations</div>
            </div>
        </div>
        <div class="col-xl-3 col-sm-6">
            <div class="stat-card">
                <div class="stat-card-icon bg-warning-subtle text-warning">
                    <i class="bi bi-ticket-perforated-fill"></i>
                </div>
                <h3 id="lblTicketsSold" runat="server">0</h3>
                <p>Tickets Sold</p>
                <div class="mt-2 extra-small text-success fw-bold"><i class="bi bi-cash"></i> +Rs. 14,200 today</div>
            </div>
        </div>
    </div>

    <!-- Analytics Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-bar-chart-line-fill text-primary"></i> Performance Overview
                </div>
                <div class="card-body">
                    <h6 class="text-muted small mb-4">Ticket Sales per Movie (Primary Catalog)</h6>
                    <canvas id="barChart" height="120"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="premium-card h-100">
                <div class="card-header">
                    <i class="bi bi-pie-chart-fill text-danger"></i> Theater Traffic
                </div>
                <div class="card-body">
                    <canvas id="pieChart" height="220"></canvas>
                    <div class="mt-4">
                         <div class="d-flex justify-content-between mb-2 small">
                             <span class="text-muted">Peak Hours</span>
                             <span class="fw-bold">6:00 PM - 9:00 PM</span>
                         </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-4">
             <div class="premium-card h-100">
                <div class="card-header">
                    <i class="bi bi-clock-history text-info"></i> Showtime Slots
                </div>
                <div class="card-body">
                    <canvas id="radarChart" height="220"></canvas>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-stars text-warning"></i> Top Performing Halls
                </div>
                <div class="card-body p-0">
                    <table class="premium-table">
                        <thead>
                            <tr>
                                <th>Rank</th>
                                <th>Hall Detail</th>
                                <th>Revenue Status</th>
                                <th class="text-end">Ticket Volume</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTopHalls" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 80px;"><span class="badge bg-primary-subtle text-primary">#<%# Container.ItemIndex + 1 %></span></td>
                                        <td>
                                            <div class="fw-bold"><%# Eval("HALLNAME") %></div>
                                            <div class="text-muted extra-small">Optimized Seating</div>
                                        </td>
                                        <td>
                                            <div class="progress" style="height: 6px; width: 100px;">
                                                <div class="progress-bar bg-success" style="width: 85%"></div>
                                            </div>
                                        </td>
                                        <td class="text-end fw-bold"><%# Eval("TICKETS") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <style>
        .bg-primary-subtle { background-color: rgba(59, 130, 246, 0.1); }
        .bg-danger-subtle { background-color: rgba(239, 68, 68, 0.1); }
        .bg-success-subtle { background-color: rgba(16, 185, 129, 0.1); }
        .bg-warning-subtle { background-color: rgba(245, 158, 11, 0.1); }
    </style>

    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const chartFont = { family: "'Plus Jakarta Sans', sans-serif", size: 11 };

            new Chart(document.getElementById('barChart'), {
                type: 'bar',
                data: {
                    labels: [<%= MovieLabels %>],
                    datasets: [{
                        label: 'Tickets Sold',
                        data: [<%= MovieData %>],
                        backgroundColor: '#3b82f6',
                        borderRadius: 8,
                        hoverBackgroundColor: '#2563eb'
                    }]
                },
                options: {
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#f1f5f9' }, ticks: { font: chartFont } },
                        x: { grid: { display: false }, ticks: { font: chartFont } }
                    }
                }
            });

            new Chart(document.getElementById('pieChart'), {
                type: 'doughnut',
                data: {
                    labels: [<%= TheaterLabels %>],
                    datasets: [{
                        data: [<%= TheaterData %>],
                        backgroundColor: ['#3b82f6', '#ef4444', '#f59e0b', '#10b981', '#06b6d4'],
                        borderWidth: 0,
                        hoverOffset: 10
                    }]
                },
                options: {
                    cutout: '70%',
                    plugins: { 
                        legend: { position: 'bottom', labels: { font: chartFont, usePointStyle: true, padding: 20 } }
                    }
                }
            });

            new Chart(document.getElementById('radarChart'), {
                type: 'polarArea',
                data: {
                    labels: ['Morning', 'Afternoon', 'Evening', 'Night'],
                    datasets: [{
                        data: [<%= ShowtimeData %>],
                        backgroundColor: [
                            'rgba(59, 130, 246, 0.6)',
                            'rgba(245, 158, 11, 0.6)',
                            'rgba(6, 182, 212, 0.6)',
                            'rgba(139, 92, 246, 0.6)'
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    plugins: { 
                        legend: { position: 'bottom', labels: { font: chartFont, usePointStyle: true, padding: 20 } }
                    },
                    scales: {
                        r: { grid: { color: '#f1f5f9' }, ticks: { display: false } }
                    }
                }
            });
        });
    </script>
</asp:Content>
