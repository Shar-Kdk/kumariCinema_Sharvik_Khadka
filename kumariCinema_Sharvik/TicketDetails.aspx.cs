using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class TicketDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) 
        {
            if (!IsPostBack)
            {
                CancelExpiredReservations();
            }
        }

        private void CancelExpiredReservations()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
            #pragma warning disable 618
            using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
            {
                conn.Open();
                // Logic: Find 'Pending' tickets where show time is less than 1 hour away.
                // We'll approximate 'Morning'=10:00, 'Evening'=18:00, 'Night'=21:00 for the time check.
                string updateSql = @"
                    UPDATE ""TICKET"" t SET t.""TICKETSTATUS"" = 'Cancelled' 
                    WHERE t.""TICKETSTATUS"" = 'Pending' AND EXISTS (
                        SELECT 1 FROM ""BOOKING_TICKET"" bt
                        JOIN ""BOOKING"" b ON bt.""BOOKINGID"" = b.""BOOKINGID""
                        JOIN ""SHOW"" s ON b.""SHOWID"" = s.""SHOWID""
                        WHERE bt.""TICKETID"" = t.""TICKETID""
                        AND (s.""SHOWDATE"" + 
                             CASE s.""SHOW"" 
                               WHEN 'Morning' THEN 10/24 
                               WHEN 'Evening' THEN 18/24 
                               WHEN 'Night' THEN 21/24 
                               ELSE 12/24 
                             END) < (SYSDATE + 1/24)
                    )";
                using (var cmd = new System.Data.OracleClient.OracleCommand(updateSql, conn))
                {
                    cmd.ExecuteNonQuery();
                }
                if (GridViewCancelled != null)
                {
                    GridViewCancelled.DataBind();
                }
            }
            #pragma warning restore 618
        }

        public void DdlInsertTheater_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlHall = (DropDownList)DetailsViewTicket.FindControl("DdlInsertHall");
            DropDownList ddlSeat = (DropDownList)DetailsViewTicket.FindControl("DdlInsertSeat");
            if (ddlHall != null)
            {
                ddlHall.Items.Clear();
                ddlHall.Items.Add(new ListItem("-- Select Hall --", ""));
                ddlHall.DataBind();
            }
            if (ddlSeat != null)
            {
                ddlSeat.Items.Clear();
                ddlSeat.Items.Add(new ListItem("-- Select Seat --", ""));
            }
        }

        public void DdlInsertShow_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlShow = (DropDownList)sender;
            TextBox txtPrice = (TextBox)DetailsViewTicket.FindControl("txtPrice");
            
            if (ddlShow != null && !string.IsNullOrEmpty(ddlShow.SelectedValue) && txtPrice != null)
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
                #pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    string sql = "SELECT SHOWPRICE, ISHOLIDAY, ISNEWRELEASE FROM \"SHOW\" WHERE SHOWID = :SID";
                    using (var cmd = new System.Data.OracleClient.OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add("SID", System.Data.OracleClient.OracleType.Number).Value = ddlShow.SelectedValue;
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                decimal basePrice = reader.GetDecimal(0);
                                string isHoliday = reader.IsDBNull(1) ? "No" : reader.GetString(1);
                                string isNewRelease = reader.IsDBNull(2) ? "No" : reader.GetString(2);

                                decimal finalPrice = basePrice;
                                if (isHoliday == "Yes") finalPrice += 100;
                                if (isNewRelease == "Yes") finalPrice += 150;

                                txtPrice.Text = finalPrice.ToString("F2");
                            }
                        }
                    }
                }
                #pragma warning restore 618
            }

            // Also reset seats when show changes as availability depends on show
            DropDownList ddlSeat = (DropDownList)DetailsViewTicket.FindControl("DdlInsertSeat");
            if (ddlSeat != null)
            {
                ddlSeat.Items.Clear();
                ddlSeat.Items.Add(new ListItem("-- Select Seat --", ""));
                ddlSeat.DataBind();
            }
        }

        public void DdlInsertHall_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlSeat = (DropDownList)DetailsViewTicket.FindControl("DdlInsertSeat");
            if (ddlSeat != null)
            {
                ddlSeat.Items.Clear();
                ddlSeat.Items.Add(new ListItem("-- Select Seat --", ""));
                ddlSeat.DataBind();
            }
        }

        public void DdlEditTheaterModal_SelectedIndexChanged(object sender, EventArgs e)
        {
            DdlEditHallModal.Items.Clear();
            DdlEditHallModal.Items.Add(new ListItem("-- Select Hall --", ""));
            DdlEditHallModal.DataBind();
            
            DdlEditSeatModal.Items.Clear();
            DdlEditSeatModal.Items.Add(new ListItem("-- Select Seat --", ""));
        }

        public void DdlEditHallModal_SelectedIndexChanged(object sender, EventArgs e)
        {
            DdlEditSeatModal.Items.Clear();
            DdlEditSeatModal.Items.Add(new ListItem("-- Select Seat --", ""));
            DdlEditSeatModal.DataBind();
        }

        public string GetEditModalScript(object id, object price, object status, object seatId, object showId)
        {
            return string.Format("openEditModal('{0}', '{1}', '{2}', '{3}', '{4}'); return false;",
                id, price, status, seatId, showId);
        }

        public string GetSpecificShowTime(object showTime)
        {
            if (showTime == null) return "12:00";
            string s = showTime.ToString();
            if (s == "Morning") return "10:00";
            if (s == "Evening") return "18:00";
            if (s == "Night") return "21:00";
            return "12:00";
        }

        public string GetViewModalScript(object id, object movie, object user, object seat, object price, object status, object date, object time, object theater, object hall)
        {
            return string.Format("showTicketReceipt('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}'); return false;",
                id, 
                movie != null ? movie.ToString().Replace("'", "\\'") : "", 
                user != null ? user.ToString().Replace("'", "\\'") : "", 
                seat, 
                price, 
                status, 
                date != null ? Convert.ToDateTime(date).ToString("MMM dd, yyyy") : "", 
                time, 
                theater != null ? theater.ToString().Replace("'", "\\'") : "", 
                hall != null ? hall.ToString().Replace("'", "\\'") : "");
        }

        public string GetDeleteModalScript(object id)
        {
            return string.Format("openDeleteModal('{0}'); return false;", id);
        }

        public string GetStatusBadge(object status)
        {
            if (status == null) return "";
            string s = status.ToString();
            if (s == "Paid") return "<span class='badge bg-success-subtle text-success extra-small border border-success-subtle'>Paid</span>";
            if (s == "Pending") return "<span class='badge bg-warning-subtle text-warning extra-small border border-warning-subtle'>Pending</span>";
            return string.Format("<span class='badge bg-danger-subtle text-danger extra-small border border-danger-subtle'>{0}</span>", s);
        }

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

                DropDownList ddlSeat = (DropDownList)DetailsViewTicket.FindControl("DdlInsertSeat");
                if (ddlSeat != null && !string.IsNullOrEmpty(ddlSeat.SelectedValue))
                {
                    e.Values["SEATID"] = Convert.ToDecimal(ddlSeat.SelectedValue);
                }

                // Final check for seat availability to prevent race conditions
                DropDownList ddlShow = (DropDownList)DetailsViewTicket.FindControl("DdlInsertShow");
                if (ddlShow != null && !string.IsNullOrEmpty(ddlShow.SelectedValue) && ddlSeat != null && !string.IsNullOrEmpty(ddlSeat.SelectedValue))
                {
                    decimal showId = Convert.ToDecimal(ddlShow.SelectedValue);
                    decimal seatId = Convert.ToDecimal(ddlSeat.SelectedValue);

                    using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                    {
                        conn.Open();
                        string checkSql = @"SELECT COUNT(*) FROM TICKET t 
                                            JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID 
                                            JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID 
                                            WHERE b.SHOWID = :p_sid AND t.SEATID = :p_seatid AND t.TICKETSTATUS != 'Cancelled'";
                        using (var cmdCheck = new System.Data.OracleClient.OracleCommand(checkSql, conn))
                        {
                            cmdCheck.Parameters.Add("p_sid", System.Data.OracleClient.OracleType.Number).Value = showId;
                            cmdCheck.Parameters.Add("p_seatid", System.Data.OracleClient.OracleType.Number).Value = seatId;
                            
                            int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                            if (count > 0)
                            {
                                lblMessage.Text = "Error: This seat is no longer available for the selected show.";
                                lblMessage.CssClass = "text-danger fw-bold";
                                e.Cancel = true;
                                return;
                            }
                        }
                    }
                }
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
                try
                {
                    decimal ticketId = Convert.ToDecimal(e.Values["TICKETID"]);
                    decimal price = Convert.ToDecimal(e.Values["TICKETPRICE"]);
                    
                    DropDownList ddlUser = (DropDownList)DetailsViewTicket.FindControl("DdlInsertUser");
                    DropDownList ddlShow = (DropDownList)DetailsViewTicket.FindControl("DdlInsertShow");
                    
                    if (ddlUser != null && ddlShow != null && !string.IsNullOrEmpty(ddlUser.SelectedValue))
                    {
                        decimal userId = Convert.ToDecimal(ddlUser.SelectedValue);
                        decimal showId = Convert.ToDecimal(ddlShow.SelectedValue);
                        
                        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                        using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                        {
                            conn.Open();
                            
                            decimal bookingId = 0;
                            using (var cmdSeq = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(BOOKINGID), 0) + 1 FROM BOOKING", conn))
                            {
                                bookingId = Convert.ToDecimal(cmdSeq.ExecuteScalar());
                            }

                            string currentTime = DateTime.Now.ToString("HH:mm");

                            using (var cmdBooking = new System.Data.OracleClient.OracleCommand(
                                "INSERT INTO BOOKING (BOOKINGID, BOOKINGDATE, BOOKINGTIME, TOTALAMOUNT, BOOKINGSTATUS, SHOWID) " +
                                "VALUES (:p_bid, SYSDATE, :p_btime, :p_amt, 'Confirmed', :p_sid)", conn))
                            {
                                cmdBooking.Parameters.Add("p_bid", System.Data.OracleClient.OracleType.Number).Value = bookingId;
                                cmdBooking.Parameters.Add("p_btime", System.Data.OracleClient.OracleType.VarChar).Value = currentTime;
                                cmdBooking.Parameters.Add("p_amt", System.Data.OracleClient.OracleType.Number).Value = price;
                                cmdBooking.Parameters.Add("p_sid", System.Data.OracleClient.OracleType.Number).Value = showId;
                                cmdBooking.ExecuteNonQuery();
                            }

                            using (var cmdUB = new System.Data.OracleClient.OracleCommand(
                                "INSERT INTO USER_BOOKING (USERID, BOOKINGID) VALUES (:p_uid, :p_bid)", conn))
                            {
                                cmdUB.Parameters.Add("p_uid", System.Data.OracleClient.OracleType.Number).Value = userId;
                                cmdUB.Parameters.Add("p_bid", System.Data.OracleClient.OracleType.Number).Value = bookingId;
                                cmdUB.ExecuteNonQuery();
                            }

                            using (var cmdBT = new System.Data.OracleClient.OracleCommand(
                                "INSERT INTO BOOKING_TICKET (TICKETID, USERID, BOOKINGID) VALUES (:p_tid, :p_uid, :p_bid)", conn))
                            {
                                cmdBT.Parameters.Add("p_tid", System.Data.OracleClient.OracleType.Number).Value = ticketId;
                                cmdBT.Parameters.Add("p_uid", System.Data.OracleClient.OracleType.Number).Value = userId;
                                cmdBT.Parameters.Add("p_bid", System.Data.OracleClient.OracleType.Number).Value = bookingId;
                                cmdBT.ExecuteNonQuery();
                            }
                        }
#pragma warning restore 618
                    }

                    lblMessage.Text = "Ticket generated and linked successfully!";
                    lblMessage.CssClass = "bg-success-subtle text-success p-2 rounded small fw-bold d-block text-center";
                    lblMessage.Visible = true;
                    GridViewTickets.DataBind();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Ticket created, but bridge linking failed: " + ex.Message;
                    lblMessage.CssClass = "bg-warning-subtle text-warning p-2 rounded small fw-bold d-block text-center";
                    lblMessage.Visible = true;
                }
            }
            else
            {
                lblMessage.Text = "Error: " + e.Exception.Message;
                lblMessage.CssClass = "bg-danger-subtle text-danger p-2 rounded small fw-bold d-block text-center";
                lblMessage.Visible = true;
                e.ExceptionHandled = true;
            }
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ticketId = Convert.ToDecimal(hfEditTicketID.Value);
                decimal seatId = Convert.ToDecimal(DdlEditSeatModal.SelectedValue);
                decimal showId = Convert.ToDecimal(hfEditShowID.Value);

                // Final check for seat availability (excluding current ticket)
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    string checkSql = @"SELECT COUNT(*) FROM TICKET t 
                                        JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID 
                                        JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID 
                                        WHERE b.SHOWID = :p_sid AND t.SEATID = :p_seatid AND t.TICKETSTATUS != 'Cancelled' AND t.TICKETID != :p_tid";
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand(checkSql, conn))
                    {
                        cmdCheck.Parameters.Add("p_sid", System.Data.OracleClient.OracleType.Number).Value = showId;
                        cmdCheck.Parameters.Add("p_seatid", System.Data.OracleClient.OracleType.Number).Value = seatId;
                        cmdCheck.Parameters.Add("p_tid", System.Data.OracleClient.OracleType.Number).Value = ticketId;
                        
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            lblMessage.Text = "Update failed: This seat is already taken for this show.";
                            lblMessage.CssClass = "text-danger fw-bold";
                            return;
                        }
                    }
                }
#pragma warning restore 618

                SqlDataSourceTickets.UpdateParameters["TICKETID"].DefaultValue = hfEditTicketID.Value;
                SqlDataSourceTickets.UpdateParameters["TICKETPRICE"].DefaultValue = txtEditPriceModal.Text;
                SqlDataSourceTickets.UpdateParameters["TICKETSTATUS"].DefaultValue = DdlEditStatusModal.SelectedValue;
                SqlDataSourceTickets.UpdateParameters["SEATID"].DefaultValue = DdlEditSeatModal.SelectedValue;

                int result = SqlDataSourceTickets.Update();
                if (result > 0)
                {
                    lblMessage.Text = "Ticket details updated successfully!";
                    lblMessage.CssClass = "bg-success-subtle text-success p-2 rounded small fw-bold d-block text-center";
                    lblMessage.Visible = true;
                    GridViewTickets.DataBind();
                    GridViewCancelled.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Update failed: " + ex.Message;
                lblMessage.CssClass = "bg-danger-subtle text-danger p-2 rounded small fw-bold d-block text-center";
                lblMessage.Visible = true;
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
                decimal ticketId = Convert.ToDecimal(hfDeleteTicketID.Value);
                string reason = DdlCancelReason.SelectedValue;

                #pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    
                    // 1. Get new Cancellation ID
                    decimal cancelId = 0;
                    using (var cmdSeq = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(CANCELLATIONID), 0) + 1 FROM CANCELLATION", conn))
                    {
                        cancelId = Convert.ToDecimal(cmdSeq.ExecuteScalar());
                    }

                    // 2. Insert into CANCELLATION
                    using (var cmdCancel = new System.Data.OracleClient.OracleCommand(
                        "INSERT INTO CANCELLATION (CANCELLATIONID, CANCELLATIONDATE, REASON) VALUES (:p_cid, SYSDATE, :p_reason)", conn))
                    {
                        cmdCancel.Parameters.Add("p_cid", System.Data.OracleClient.OracleType.Number).Value = cancelId;
                        cmdCancel.Parameters.Add("p_reason", System.Data.OracleClient.OracleType.VarChar).Value = reason;
                        cmdCancel.ExecuteNonQuery();
                    }

                    // 3. Update TICKET status and link to CANCELLATION
                    using (var cmdTicket = new System.Data.OracleClient.OracleCommand(
                        "UPDATE TICKET SET TICKETSTATUS = 'Cancelled', CANCELLATIONID = :p_cid WHERE TICKETID = :p_tid", conn))
                    {
                        cmdTicket.Parameters.Add("p_cid", System.Data.OracleClient.OracleType.Number).Value = cancelId;
                        cmdTicket.Parameters.Add("p_tid", System.Data.OracleClient.OracleType.Number).Value = ticketId;
                        cmdTicket.ExecuteNonQuery();
                    }
                }
                #pragma warning restore 618

                lblMessage.Text = "Ticket cancelled and seat released successfully.";
                lblMessage.CssClass = "bg-success-subtle text-success p-2 rounded small fw-bold d-block text-center";
                lblMessage.Visible = true;
                GridViewTickets.DataBind();
                GridViewCancelled.DataBind();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Cancellation failed: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }
        protected void btnRefreshCancelled_Click(object sender, EventArgs e)
        {
            GridViewCancelled.DataBind();
        }
    }
}
