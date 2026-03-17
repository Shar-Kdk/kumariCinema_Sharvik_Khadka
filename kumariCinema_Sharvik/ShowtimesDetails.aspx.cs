using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class ShowtimesDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {}

        public void DetailsViewShow_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(SHOWID), 0) + 1 FROM \"SHOW\"", conn))
                    {
                        e.Values["SHOWID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.Cancel = true;
            }
        }

        public void DetailsViewShow_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblMessage.Text = "New showtime successfully added!";
                lblMessage.CssClass = "text-success fw-bold";
                GridViewShows.DataBind();
            }
            else
            {
                lblMessage.Text = "Error adding showtime: " + e.Exception.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }
    }
}
