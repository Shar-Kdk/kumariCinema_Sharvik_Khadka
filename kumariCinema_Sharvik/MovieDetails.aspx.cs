using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class MovieDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void DetailsViewMovie_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (System.Data.OracleClient.OracleConnection conn = new System.Data.OracleClient.OracleConnection(connString))
                {
                    conn.Open();
                    using (System.Data.OracleClient.OracleCommand cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(MovieID), 0) + 1 FROM Movie", conn))
                    {
                        decimal newId = Convert.ToDecimal(cmd.ExecuteScalar());
                        e.Values["MovieID"] = newId;
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

        public void DetailsViewMovie_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblMessage.Text = "New movie successfully added!";
                lblMessage.CssClass = "text-success fw-bold";
                GridViewMovies.DataBind();
            }
            else
            {
                lblMessage.Text = "Error adding movie: " + e.Exception.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }
    }
}
