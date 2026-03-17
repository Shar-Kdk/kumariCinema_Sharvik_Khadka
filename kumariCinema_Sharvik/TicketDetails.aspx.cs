using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class TicketDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {}

        public void DetailsViewTicket_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(TICKETID), 0) + 1 FROM TICKET", conn))
                    {
                        e.Values["TICKETID"] = Convert.ToDecimal(cmd.ExecuteScalar());
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

        public void DetailsViewTicket_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblMessage.Text = "New ticket successfully added!";
                lblMessage.CssClass = "text-success fw-bold";
                GridViewTickets.DataBind();
            }
            else
            {
                lblMessage.Text = "Error adding ticket: " + e.Exception.Message;
                lblMessage.CssClass = "text-danger fw-bold";
                e.ExceptionHandled = true;
            }
        }
    }
}
