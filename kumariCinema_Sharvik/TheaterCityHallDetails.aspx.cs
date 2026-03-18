using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class TheaterCityHallDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) 
        {
            if (!IsPostBack)
            {
                ClearMessage();
                string status = Request.QueryString["status"];
                if (status == "theater_added") ShowSuccessMessage("New branch registered successfully!");
                else if (status == "theater_updated") ShowSuccessMessage("Branch updated successfully!");
                else if (status == "theater_deleted") ShowSuccessMessage("Branch deleted successfully.");
                else if (status == "hall_added") ShowSuccessMessage("New hall added successfully!");
                else if (status == "hall_updated") ShowSuccessMessage("Hall updated successfully!");
                else if (status == "hall_deleted") ShowSuccessMessage("Hall deleted successfully.");
                else if (status == "seat_added") ShowSuccessMessage("New seat added successfully!");
                else if (status == "seat_updated") ShowSuccessMessage("Seat updated successfully!");
                else if (status == "seat_deleted") ShowSuccessMessage("Seat removed successfully.");
            }
        }

        protected void txtSearchTheater_TextChanged(object sender, EventArgs e)
        {
            GridViewTheaters.DataBind();
        }

        protected void DdlFilterTheater_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Clear old items and re-add default option before rebinding
            DdlFilterHall.Items.Clear();
            DdlFilterHall.Items.Add(new ListItem("-- Select a Hall to view seats --", ""));
            DdlFilterHall.DataBind();

            // Also rebind the insert dropdown in the seat form so it gets the filtered halls
            DropDownList ddlInsertHall = (DropDownList)DetailsViewSeat.FindControl("DdlInsertHall");
            if (ddlInsertHall != null)
            {
                ddlInsertHall.Items.Clear();
                ddlInsertHall.Items.Add(new ListItem("-- Select Hall --", ""));
                ddlInsertHall.DataBind();
            }

            // Seats will auto-clear since DdlFilterHall is back to empty value
            ListViewSeats.DataBind();
        }

        public string GetTheaterViewScript(object name, object city, object address)
        {
            return string.Format("showTheaterView(\"{0}\", \"{1}\", \"{2}\"); return false;",
                name?.ToString().Replace("\"", "\\\""),
                city?.ToString().Replace("\"", "\\\""),
                address?.ToString().Replace("\"", "\\\""));
        }

        public string GetTheaterEditScript(object id, object name, object city, object address)
        {
            return string.Format("openTheaterEdit(\"{0}\", \"{1}\", \"{2}\", \"{3}\"); return false;",
                id,
                name?.ToString().Replace("\"", "\\\""),
                city?.ToString().Replace("\"", "\\\""),
                address?.ToString().Replace("\"", "\\\""));
        }

        public string GetTheaterDeleteScript(object id, object name)
        {
            return string.Format("openTheaterDelete(\"{0}\", \"{1}\"); return false;",
                id,
                name?.ToString().Replace("\"", "\\\""));
        }

        // ========== THEATER INSERT ==========
        public void DetailsViewTheater_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            ClearMessage();
            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();

                    // Check for duplicate theater name
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Theater WHERE LOWER(TheaterName) = LOWER(:TheaterName)", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("TheaterName", e.Values["TheaterName"]?.ToString() ?? "");
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A branch with this name already exists.");
                            e.Cancel = true;
                            return;
                        }
                    }

                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(TheaterID), 0) + 1 FROM Theater", conn))
                    {
                        e.Values["TheaterID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error: " + ex.Message);
                e.Cancel = true;
            }
        }

        public void DetailsViewTheater_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?status=theater_added");
            }
            else
            {
                ShowErrorMessage("Error registering branch: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }

        // ========== HALL INSERT ==========
        public void DetailsViewHall_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            ClearMessage();
            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();

                    // Check for duplicate hall name within the same theater
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Hall WHERE LOWER(HallName) = LOWER(:HallName) AND TheaterID = :TheaterID", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("HallName", e.Values["HallName"]?.ToString() ?? "");
                        cmdCheck.Parameters.AddWithValue("TheaterID", e.Values["TheaterID"] ?? (object)DBNull.Value);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A hall with this name already exists in the selected branch.");
                            e.Cancel = true;
                            return;
                        }
                    }

                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(HallID), 0) + 1 FROM Hall", conn))
                    {
                        e.Values["HallID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error: " + ex.Message);
                e.Cancel = true;
            }
        }

        public void DetailsViewHall_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?status=hall_added");
            }
            else
            {
                ShowErrorMessage("Error adding hall: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }

        // ========== SEAT INSERT ==========
        public void DetailsViewSeat_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            ClearMessage();
            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }
            try
            {
                // Set HallID from the insert dropdown (since we removed Bind)
                DropDownList ddlHall = (DropDownList)DetailsViewSeat.FindControl("DdlInsertHall");
                if (ddlHall != null)
                {
                    e.Values["HallID"] = ddlHall.SelectedValue;
                }

                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();

                    // Check for duplicate seat number within the same hall
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Seat WHERE LOWER(SeatNumber) = LOWER(:SeatNumber) AND HallID = :HallID", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("SeatNumber", e.Values["SeatNumber"]?.ToString() ?? "");
                        cmdCheck.Parameters.AddWithValue("HallID", e.Values["HallID"] ?? (object)DBNull.Value);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A seat with this number already exists in the selected hall.");
                            e.Cancel = true;
                            return;
                        }
                    }

                    using (var cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(SeatID), 0) + 1 FROM Seat", conn))
                    {
                        e.Values["SeatID"] = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }
#pragma warning restore 618
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error: " + ex.Message);
                e.Cancel = true;
            }
        }


        public void DetailsViewSeat_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?status=seat_added");
            }
            else
            {
                ShowErrorMessage("Error adding seat: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }

        // ========== SCRIPT HELPERS ==========
        public string GetHallViewScript(object name, object cap, object theaterName)
        {
            return string.Format("showHallView(\"{0}\", \"{1}\", \"{2}\"); return false;",
                name?.ToString().Replace("\"", "\\\""),
                cap,
                theaterName?.ToString().Replace("\"", "\\\""));
        }

        public string GetSeatViewScript(object num, object row, object status)
        {
            return string.Format("showSeatView(\"{0}\", \"{1}\", \"{2}\"); return false;",
                num?.ToString().Replace("\"", "\\\""),
                row?.ToString().Replace("\"", "\\\""),
                status?.ToString().Replace("\"", "\\\""));
        }

        public string GetHallEditScript(object id, object name, object cap, object theaterId)
        {
            return string.Format("openHallEdit(\"{0}\", \"{1}\", \"{2}\", \"{3}\"); return false;",
                id, 
                name?.ToString().Replace("\"", "\\\""),
                cap,
                theaterId);
        }

        public string GetHallDeleteScript(object id, object name)
        {
            return string.Format("openHallDelete(\"{0}\", \"{1}\"); return false;",
                id, 
                name?.ToString().Replace("\"", "\\\""));
        }

        public string GetSeatEditScript(object id, object num, object row, object status, object hallId)
        {
            return string.Format("openSeatEdit(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\"); return false;",
                id, num, row, status, hallId);
        }

        public string GetSeatDeleteScript(object id, object num)
        {
            return string.Format("openSeatDelete(\"{0}\", \"{1}\"); return false;",
                id, num);
        }

        // ========== HALL EDIT & DELETE ==========
        protected void btnSaveHallEdit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            ClearMessage();
            try
            {
                string hallId = hfEditHallID.Value;
                string newHallName = txtEditHallNameModal.Text;
                string newTheaterId = DdlEditHallTheaterModal.SelectedValue;

                // Check for duplicate hall name within the same theater (excluding current hall)
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Hall WHERE LOWER(HallName) = LOWER(:HallName) AND TheaterID = :TheaterID AND HallID != :HallID", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("HallName", newHallName);
                        cmdCheck.Parameters.AddWithValue("TheaterID", newTheaterId);
                        cmdCheck.Parameters.AddWithValue("HallID", hallId);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A hall with this name already exists in the selected branch.");
                            return;
                        }
                    }
                }
#pragma warning restore 618

                SqlDataSourceHalls.UpdateParameters["HallID"].DefaultValue = hallId;
                SqlDataSourceHalls.UpdateParameters["HallName"].DefaultValue = newHallName;
                SqlDataSourceHalls.UpdateParameters["Capacity"].DefaultValue = txtEditHallCapModal.Text;
                SqlDataSourceHalls.UpdateParameters["TheaterID"].DefaultValue = newTheaterId;

                int result = SqlDataSourceHalls.Update();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=hall_updated");
                }
                else
                {
                    ShowErrorMessage("No changes were made.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Update failed: " + ex.Message);
            }
        }

        protected void btnConfirmHallDelete_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceHalls.DeleteParameters["HallID"].DefaultValue = hfDeleteHallID.Value;
                int result = SqlDataSourceHalls.Delete();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=hall_deleted");
                }
                else
                {
                    ShowErrorMessage("Hall not found.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Delete failed: " + ex.Message);
            }
        }

        // ========== SEAT EDIT & DELETE ==========
        protected void btnSaveSeatEdit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            ClearMessage();
            try
            {
                string seatId = hfEditSeatID.Value;
                string newSeatNum = txtEditSeatNumModal.Text;
                string newHallId = DdlEditSeatHallModal.SelectedValue;

                // Check for duplicate seat number within the same hall (excluding current seat)
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Seat WHERE LOWER(SeatNumber) = LOWER(:SeatNumber) AND HallID = :HallID AND SeatID != :SeatID", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("SeatNumber", newSeatNum);
                        cmdCheck.Parameters.AddWithValue("HallID", newHallId);
                        cmdCheck.Parameters.AddWithValue("SeatID", seatId);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A seat with this number already exists in the selected hall.");
                            return;
                        }
                    }
                }
#pragma warning restore 618

                SqlDataSourceSeats.UpdateParameters["SeatID"].DefaultValue = seatId;
                SqlDataSourceSeats.UpdateParameters["SeatNumber"].DefaultValue = newSeatNum;
                SqlDataSourceSeats.UpdateParameters["RowNumber"].DefaultValue = txtEditSeatRowModal.Text;
                SqlDataSourceSeats.UpdateParameters["SeatStatus"].DefaultValue = DdlEditSeatStatusModal.SelectedValue;
                SqlDataSourceSeats.UpdateParameters["HallID"].DefaultValue = newHallId;

                int result = SqlDataSourceSeats.Update();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=seat_updated");
                }
                else
                {
                    ShowErrorMessage("No changes were made.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Update failed: " + ex.Message);
            }
        }

        protected void btnConfirmSeatDelete_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceSeats.DeleteParameters["SeatID"].DefaultValue = hfDeleteSeatID.Value;
                int result = SqlDataSourceSeats.Delete();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=seat_deleted");
                }
                else
                {
                    ShowErrorMessage("Seat not found.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Delete failed: " + ex.Message);
            }
        }

        // ========== THEATER EDIT & DELETE ==========
        protected void btnSaveTheaterEdit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            ClearMessage();
            try
            {
                string theaterId = hfEditTheaterID.Value;
                string newTheaterName = txtEditTheaterNameModal.Text;

                // Check for duplicate theater name (excluding current theater)
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmdCheck = new System.Data.OracleClient.OracleCommand("SELECT COUNT(*) FROM Theater WHERE LOWER(TheaterName) = LOWER(:TheaterName) AND TheaterID != :TheaterID", conn))
                    {
                        cmdCheck.Parameters.AddWithValue("TheaterName", newTheaterName);
                        cmdCheck.Parameters.AddWithValue("TheaterID", theaterId);
                        int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A branch with this name already exists.");
                            return;
                        }
                    }
                }
#pragma warning restore 618

                SqlDataSourceTheaters.UpdateParameters["TheaterID"].DefaultValue = theaterId;
                SqlDataSourceTheaters.UpdateParameters["TheaterName"].DefaultValue = newTheaterName;
                SqlDataSourceTheaters.UpdateParameters["City"].DefaultValue = txtEditTheaterCityModal.Text;
                SqlDataSourceTheaters.UpdateParameters["Address"].DefaultValue = txtEditTheaterAddressModal.Text;

                int result = SqlDataSourceTheaters.Update();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=theater_updated");
                }
                else
                {
                    ShowErrorMessage("No changes were made.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Update failed: " + ex.Message);
            }
        }

        protected void btnConfirmTheaterDelete_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceTheaters.DeleteParameters["TheaterID"].DefaultValue = hfDeleteTheaterID.Value;
                int result = SqlDataSourceTheaters.Delete();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=theater_deleted");
                }
                else
                {
                    ShowErrorMessage("Branch not found.");
                }
            }
            catch (Exception)
            {
                ShowErrorMessage("Delete failed. Branch might be linked to halls.");
            }
        }

        // ========== MESSAGE HELPERS (exactly like MovieDetails) ==========
        private void ShowSuccessMessage(string text)
        {
            lblMessage.Text = "<i class='bi bi-check-circle-fill me-2'></i>" + text;
            lblMessage.CssClass = "d-block text-center rounded-3 p-3 small fw-bold bg-success bg-opacity-10 text-success border border-success border-opacity-25 mt-3";
            lblMessage.Visible = true;
        }

        private void ShowErrorMessage(string text)
        {
            lblMessage.Text = "<i class='bi bi-exclamation-triangle-fill me-2'></i>" + text;
            lblMessage.CssClass = "d-block text-center rounded-3 p-3 small fw-bold bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 mt-3";
            lblMessage.Visible = true;
        }

        private void ClearMessage()
        {
            lblMessage.Text = string.Empty;
            lblMessage.Visible = false;
        }
    }
}
