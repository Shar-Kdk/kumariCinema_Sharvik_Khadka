using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class ShowtimesDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {}

        public string GetSpecificShowTime(object showTime)
        {
            if (showTime == null || showTime == DBNull.Value) return "12:00";
            string s = showTime.ToString();
            if (s == "Morning") return "10:00";
            if (s == "Evening") return "18:00";
            if (s == "Night") return "21:00";
            return "12:00";
        }

        public string GetBadgeHtml(object value, string type)
        {
            if (value == null || value.ToString() != "Yes") return "";
            if (type == "New") return "<span class='badge bg-warning text-dark' style='font-size: 0.6rem; padding: 1px 4px; border-radius: 4px;'>New</span>";
            if (type == "Holiday") return "<span class='badge bg-danger text-white' style='font-size: 0.6rem; padding: 1px 4px; border-radius: 4px;'>Holiday</span>";
            return "";
        }

        public string GetViewModalScript(object movie, object hall, object date, object time, object price, object holiday, object release)
        {
            string dateStr = "";
            if (date != null && date != DBNull.Value)
            {
                if (date is DateTime)
                    dateStr = ((DateTime)date).ToString("yyyy-MM-dd");
                else if (DateTime.TryParse(date.ToString(), out DateTime dt))
                    dateStr = dt.ToString("yyyy-MM-dd");
                else
                    dateStr = date.ToString();
            }

            string specTime = GetSpecificShowTime(time);

            return string.Format("openViewModal(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\", \"{6}\", \"{7}\"); return false;",
                movie?.ToString().Replace("\"", "\\\""),
                hall?.ToString().Replace("\"", "\\\""),
                dateStr, time, specTime, price, holiday, release);
        }

        public string GetEditModalScript(object id, object date, object time, object price, object movieId, object hallId, object holiday, object release)
        {
            string dateStr = "";
            if (date != null && date != DBNull.Value)
            {
                if (date is DateTime)
                    dateStr = ((DateTime)date).ToString("yyyy-MM-dd");
                else if (DateTime.TryParse(date.ToString(), out DateTime dt))
                    dateStr = dt.ToString("yyyy-MM-dd");
                else
                    dateStr = date.ToString();
            }

            return string.Format("openEditModal(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\", \"{6}\", \"{7}\"); return false;",
                id, dateStr, time, price, movieId, hallId, holiday, release);
        }

        public string GetDeleteModalScript(object id, object title, object time)
        {
            return string.Format("openDeleteModal(\"{0}\", \"{1}\", \"{2}\"); return false;",
                id, 
                title?.ToString().Replace("\"", "\\\""),
                time?.ToString());
        }

        public void DetailsViewShow_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    
                    // Check for duplicate show
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM \"SHOW\" WHERE SHOWDATE = TO_DATE(:SDATE, 'YYYY-MM-DD') AND \"SHOW\" = :STIME AND HALLID = :HID", conn))
                    {
                        string dateStr = "";
                        if (e.Values["SHOWDATE"] != null)
                        {
                            if (DateTime.TryParse(e.Values["SHOWDATE"].ToString(), out DateTime dt))
                                dateStr = dt.ToString("yyyy-MM-dd");
                            else
                                dateStr = e.Values["SHOWDATE"].ToString();
                        }
                        cmdCheck.Parameters.AddWithValue("SDATE", dateStr);
                        cmdCheck.Parameters.AddWithValue("STIME", e.Values["SHOWTIME"]);
                        cmdCheck.Parameters.AddWithValue("HID", e.Values["HALLID"]);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            lblMessage.Text = "A showtime already exists at this date and time in the selected hall.";
                            lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                            lblMessage.Visible = true;
                            e.Cancel = true;
                            return;
                        }
                    }

                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(SHOWID), 0) + 1 FROM \"SHOW\"", conn))
                    {
                        e.Values["SHOWID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
                
                // Read Special Flags from Checkboxes
                CheckBox chkHoliday = (CheckBox)DetailsViewShow.FindControl("chkInsertHoliday");
                CheckBox chkNewRelease = (CheckBox)DetailsViewShow.FindControl("chkInsertNew");
                
                e.Values["ISHOLIDAY"] = (chkHoliday != null && chkHoliday.Checked) ? "Yes" : "No";
                e.Values["ISNEWRELEASE"] = (chkNewRelease != null && chkNewRelease.Checked) ? "Yes" : "No";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                lblMessage.Visible = true;
                e.Cancel = true;
            }
        }

        public void DetailsViewShow_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                lblMessage.Text = "New showtime scheduled successfully!";
                lblMessage.CssClass = "alert alert-success extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                lblMessage.Visible = true;
                GridViewShows.DataBind();
            }
            else
            {
                lblMessage.Text = "Scheduling failed: " + e.Exception.Message;
                lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                lblMessage.Visible = true;
                e.ExceptionHandled = true;
            }
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM \"SHOW\" WHERE SHOWDATE = TO_DATE(:SDATE, 'YYYY-MM-DD') AND \"SHOW\" = :STIME AND HALLID = :HID AND SHOWID != :SID", conn))
                    {
                        string dateStr = txtEditDateModal.Text;
                        if (DateTime.TryParse(dateStr, out DateTime dt))
                            dateStr = dt.ToString("yyyy-MM-dd");

                        cmdCheck.Parameters.AddWithValue("SDATE", dateStr);
                        cmdCheck.Parameters.AddWithValue("STIME", DdlEditTimeModal.SelectedValue);
                        cmdCheck.Parameters.AddWithValue("HID", DdlEditHallModal.SelectedValue);
                        cmdCheck.Parameters.AddWithValue("SID", hfEditShowID.Value);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            lblMessage.Text = "A showtime already exists at this date and time in the selected hall.";
                            lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                            lblMessage.Visible = true;
                            return;
                        }
                    }
                }
#pragma warning restore 618

                SqlDataSourceShows.UpdateParameters["SHOWID"].DefaultValue = hfEditShowID.Value;
                SqlDataSourceShows.UpdateParameters["SHOWDATE"].DefaultValue = txtEditDateModal.Text;
                SqlDataSourceShows.UpdateParameters["SHOWTIME"].DefaultValue = DdlEditTimeModal.SelectedValue;
                SqlDataSourceShows.UpdateParameters["SHOWPRICE"].DefaultValue = txtEditPriceModal.Text;
                SqlDataSourceShows.UpdateParameters["MOVIEID"].DefaultValue = DdlEditMovieModal.SelectedValue;
                SqlDataSourceShows.UpdateParameters["HALLID"].DefaultValue = DdlEditHallModal.SelectedValue;
                SqlDataSourceShows.UpdateParameters["ISHOLIDAY"].DefaultValue = chkEditHoliday.Checked ? "Yes" : "No";
                SqlDataSourceShows.UpdateParameters["ISNEWRELEASE"].DefaultValue = chkEditNew.Checked ? "Yes" : "No";

                int result = SqlDataSourceShows.Update();
                if (result > 0)
                {
                    lblMessage.Text = "Showtime updated successfully!";
                    lblMessage.CssClass = "alert alert-success extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                    lblMessage.Visible = true;
                    GridViewShows.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Update failed: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                lblMessage.Visible = true;
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                SqlDataSourceShows.DeleteParameters["SHOWID"].DefaultValue = hfDeleteShowID.Value;
                int result = SqlDataSourceShows.Delete();
                if (result > 0)
                {
                    lblMessage.Text = "Showtime cancelled successfully.";
                    lblMessage.CssClass = "alert alert-success extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                    lblMessage.Visible = true;
                    GridViewShows.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Delete failed: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2 d-block";
                lblMessage.Visible = true;
            }
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string filter = btn.CommandArgument;

            // Reset all buttons styling
            btnFilterAll.CssClass = "btn btn-outline-secondary btn-sm";
            btnFilterToday.CssClass = "btn btn-outline-secondary btn-sm";
            btnFilterThisWeek.CssClass = "btn btn-outline-secondary btn-sm";

            // Highlight active button
            btn.CssClass += " active";

            string baseQuery = "SELECT s.SHOWID, s.SHOWDATE, s.\"SHOW\" AS SHOWTIME, s.SHOWPRICE, s.ISHOLIDAY, s.ISNEWRELEASE, s.MOVIEID, s.HALLID, m.TITLE as MovieTitle, h.HALLNAME as HallName FROM \"SHOW\" s LEFT JOIN MOVIE m ON s.MOVIEID = m.MOVIEID LEFT JOIN HALL h ON s.HALLID = h.HALLID";
            string orderBy = " ORDER BY s.SHOWDATE DESC";

            if (filter == "Today")
            {
                SqlDataSourceShows.SelectCommand = baseQuery + " WHERE TRUNC(s.SHOWDATE) = TRUNC(SYSDATE)" + orderBy;
            }
            else if (filter == "Week")
            {
                SqlDataSourceShows.SelectCommand = baseQuery + " WHERE TRUNC(s.SHOWDATE) >= TRUNC(SYSDATE) AND TRUNC(s.SHOWDATE) < TRUNC(SYSDATE) + 7" + orderBy;
            }
            else
            {
                SqlDataSourceShows.SelectCommand = baseQuery + orderBy;
            }

            GridViewShows.DataBind();
        }
    }
}
