using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class TheaterCityHallDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {}

        public void DetailsViewTheater_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(TheaterID), 0) + 1 FROM Theater", conn))
                    {
                        e.Values["TheaterID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                lblTheaterMessage.Text = "Error: " + ex.Message;
                lblTheaterMessage.CssClass = "text-danger fw-bold";
                e.Cancel = true;
            }
        }

        public void DetailsViewTheater_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblTheaterMessage.Text = "New theater successfully added!";
                lblTheaterMessage.CssClass = "text-success fw-bold";
                GridViewTheaters.DataBind();
                // We need to rebind the dropdown for the Hall insert form since a new theater is available
                DetailsViewHall.DataBind();
            }
            else
            {
                lblTheaterMessage.Text = "Error adding theater: " + e.Exception.Message;
                lblTheaterMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }

        public void DetailsViewHall_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(HallID), 0) + 1 FROM Hall", conn))
                    {
                        e.Values["HallID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                lblHallMessage.Text = "Error: " + ex.Message;
                lblHallMessage.CssClass = "text-danger fw-bold";
                e.Cancel = true;
            }
        }

        public void DetailsViewHall_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblHallMessage.Text = "New hall successfully added!";
                lblHallMessage.CssClass = "text-success fw-bold";
                GridViewHalls.DataBind();
            }
            else
            {
                lblHallMessage.Text = "Error adding hall: " + e.Exception.Message;
                lblHallMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }
    }
}
