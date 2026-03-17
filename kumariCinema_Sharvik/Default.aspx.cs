using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OracleClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class DashboardPage : Page
    {
        public string MovieLabels = "";
        public string MovieData = "";
        public string TheaterLabels = "";
        public string TheaterData = "";
        public string ShowtimeData = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
                LoadChartData();
                LoadTopHalls();
            }
        }

        private void LoadDashboardStats()
        {
            try
            {
                string connString = ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
                
#pragma warning disable 618
                using (OracleConnection conn = new OracleConnection(connString))
                {
                    conn.Open();

                    // 1. Total Users
                    using (OracleCommand cmd = new OracleCommand("SELECT COUNT(*) FROM Users", conn))
                    {
                        lblTotalUsers.InnerText = cmd.ExecuteScalar().ToString();
                    }

                    // 2. Total Movies
                    using (OracleCommand cmd = new OracleCommand("SELECT COUNT(*) FROM Movie", conn))
                    {
                        lblTotalMovies.InnerText = cmd.ExecuteScalar().ToString();
                    }

                    // 3. Total Halls
                    using (OracleCommand cmd = new OracleCommand("SELECT COUNT(*) FROM Hall", conn))
                    {
                        lblTotalHalls.InnerText = cmd.ExecuteScalar().ToString();
                    }

                    // 4. Tickets Sold
                    using (OracleCommand cmd = new OracleCommand("SELECT COUNT(*) FROM Ticket", conn))
                    {
                        lblTicketsSold.InnerText = cmd.ExecuteScalar().ToString();
                    }
                }
#pragma warning restore 618
            }
            catch (Exception)
            {
                lblTotalUsers.InnerText = "Err";
                lblTotalMovies.InnerText = "Err";
                lblTotalHalls.InnerText = "Err";
                lblTicketsSold.InnerText = "Err";
            }
        }

        private void LoadChartData()
        {
            try
            {
                string connString = ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (OracleConnection conn = new OracleConnection(connString))
                {
                    conn.Open();

                    // Movie Sales Chart
                    using (OracleCommand cmd = new OracleCommand("SELECT m.TITLE, COUNT(bt.TICKETID) as C FROM MOVIE m JOIN \"SHOW\" s ON m.MOVIEID = s.MOVIEID JOIN BOOKING b ON s.SHOWID = b.SHOWID JOIN BOOKING_TICKET bt ON b.BOOKINGID = bt.BOOKINGID GROUP BY m.TITLE", conn))
                    {
                        using (var r = cmd.ExecuteReader())
                        {
                            var labels = new List<string>();
                            var data = new List<string>();
                            while (r.Read()) {
                                labels.Add("'" + r["TITLE"].ToString() + "'");
                                data.Add(r["C"].ToString());
                            }
                            MovieLabels = string.Join(",", labels);
                            MovieData = string.Join(",", data);
                        }
                    }

                    // Theater Sales Chart
                    using (OracleCommand cmd = new OracleCommand("SELECT t.THEATERNAME, COUNT(bt.TICKETID) as C FROM THEATER t JOIN HALL h ON t.THEATERID = h.THEATERID JOIN \"SHOW\" s ON h.HALLID = s.HALLID JOIN BOOKING b ON s.SHOWID = b.SHOWID JOIN BOOKING_TICKET bt ON b.BOOKINGID = bt.BOOKINGID GROUP BY t.THEATERNAME", conn))
                    {
                        using (var r = cmd.ExecuteReader())
                        {
                            var labels = new List<string>();
                            var data = new List<string>();
                            while (r.Read()) {
                                labels.Add("'" + r["THEATERNAME"].ToString() + "'");
                                data.Add(r["C"].ToString());
                            }
                            TheaterLabels = string.Join(",", labels);
                            TheaterData = string.Join(",", data);
                        }
                    }

                    // Showtime Data (Mocked but structure ready)
                    ShowtimeData = "0, 0, 0, 0"; // Default
                }
#pragma warning restore 618
            }
            catch { }
        }

        private void LoadTopHalls()
        {
            try
            {
                string connString = ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (OracleConnection conn = new OracleConnection(connString))
                {
                    conn.Open();
                    string sql = "SELECT * FROM (SELECT h.HALLNAME || ' (' || t.THEATERNAME || ')' as HALLNAME, COUNT(bt.TICKETID) as TICKETS " +
                                 "FROM HALL h JOIN THEATER t ON h.THEATERID = t.THEATERID " +
                                 "JOIN \"SHOW\" s ON h.HALLID = s.HALLID " +
                                 "JOIN BOOKING b ON s.SHOWID = b.SHOWID " +
                                 "JOIN BOOKING_TICKET bt ON b.BOOKINGID = bt.BOOKINGID " +
                                 "GROUP BY h.HALLNAME, t.THEATERNAME ORDER BY TICKETS DESC) WHERE ROWNUM <= 3";
                    
                    using (OracleCommand cmd = new OracleCommand(sql, conn))
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(cmd.ExecuteReader());
                        rptTopHalls.DataSource = dt;
                        rptTopHalls.DataBind();
                    }
                }
#pragma warning restore 618
            }
            catch { }
        }
    }
}