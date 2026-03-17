using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class TheaterDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        public void DetailsViewTheater_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (System.Data.OracleClient.OracleConnection conn = new System.Data.OracleClient.OracleConnection(connString))
                {
                    conn.Open();
                    using (System.Data.OracleClient.OracleCommand cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(TheaterID), 0) + 1 FROM Theater", conn))
                    {
                        decimal newId = Convert.ToDecimal(cmd.ExecuteScalar());
                        e.Values["TheaterID"] = newId;
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error generating ID: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.Cancel = true;
            }
        }

        public void DetailsViewTheater_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblMessage.Text = "New theater successfully added!";
                lblMessage.CssClass = "text-success fw-bold";
                GridViewTheaters.DataBind();
            }
            else
            {
                lblMessage.Text = "Error adding theater: " + e.Exception.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }
    }
}
