using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class UserDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Visible = false;
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            btnClearSearch.Visible = !string.IsNullOrWhiteSpace(txtSearch.Text);
            GridViewUsers.DataBind();
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            btnClearSearch.Visible = false;
            GridViewUsers.DataBind();
        }

        public void DetailsViewUser_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            ClearMessage();

            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }

            try
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["KumariCinemaDB"].ConnectionString;
#pragma warning disable 618
                using (System.Data.OracleClient.OracleConnection conn = new System.Data.OracleClient.OracleConnection(connString))
                {
                    conn.Open();
                    using (System.Data.OracleClient.OracleCommand cmd = new System.Data.OracleClient.OracleCommand("SELECT NVL(MAX(UserID), 0) + 1 FROM Users", conn))
                    {
                        decimal newId = Convert.ToDecimal(cmd.ExecuteScalar());
                        e.Values["UserID"] = newId;
                    }
                }
#pragma warning restore 618

                // Set default registration date if empty
                if (e.Values["RegistrationDate"] == null || string.IsNullOrWhiteSpace(e.Values["RegistrationDate"].ToString()))
                {
                    e.Values["RegistrationDate"] = DateTime.Now.ToString("yyyy-MM-dd");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("System Error: Could not generate a unique User ID. " + ex.Message);
                e.Cancel = true;
            }
        }

        public string GetDeleteConfirmation(object username)
        {
            if (username == null) return "return confirm('Are you sure you want to delete this user?');";
            string name = username.ToString().Replace("'", "\\'");
            return "return confirm('Are you sure you want to delete " + name + "?');";
        }

        public string GetQuickViewScript(object name, object email, object phone, object address, object joined)
        {
            string joinedStr = "";
            if (joined != null && joined != DBNull.Value)
            {
                if (joined is DateTime)
                    joinedStr = ((DateTime)joined).ToString("MMM dd, yyyy");
                else if (DateTime.TryParse(joined.ToString(), out DateTime dt))
                    joinedStr = dt.ToString("MMM dd, yyyy");
                else
                    joinedStr = joined.ToString();
            }

            return string.Format("showUserPopup(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\"); return false;",
                name?.ToString().Replace("\"", "\\\""),
                email?.ToString().Replace("\"", "\\\""),
                phone?.ToString().Replace("\"", "\\\""),
                address?.ToString().Replace("\"", "\\\""),
                joinedStr.Replace("\"", "\\\""));
        }

        public string GetEditModalScript(object id, object name, object email, object phone, object address, object regDate)
        {
            string dateStr = "";
            if (regDate != null && regDate != DBNull.Value)
            {
                if (regDate is DateTime)
                    dateStr = ((DateTime)regDate).ToString("yyyy-MM-dd");
                else if (DateTime.TryParse(regDate.ToString(), out DateTime dt))
                    dateStr = dt.ToString("yyyy-MM-dd");
                else
                    dateStr = regDate.ToString();
            }

            return string.Format("openEditModal(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\"); return false;",
                id,
                name?.ToString().Replace("\"", "\\\""),
                email?.ToString().Replace("\"", "\\\""),
                phone?.ToString().Replace("\"", "\\\""),
                address?.ToString().Replace("\"", "\\\""),
                dateStr.Replace("\"", "\\\""));
        }

        public string GetDeleteModalScript(object id, object name)
        {
            return string.Format("openDeleteModal(\"{0}\", \"{1}\"); return false;",
                id,
                name?.ToString().Replace("\"", "\\\""));
        }

        public void DetailsViewUser_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                ShowSuccessMessage("Access Granted: New user profile has been successfully encrypted and stored.");
                GridViewUsers.DataBind(); // Refresh grid
            }
            else
            {
                string msg = e.Exception.Message;
                if (msg.Contains("UNIQUE") || msg.Contains("ORA-00001"))
                {
                    ShowErrorMessage("Data Conflict: An account with this Email or Username already exists in the registry.");
                }
                else if (msg.Contains("ORA-01400"))
                {
                    ShowErrorMessage("Required Data Missing: Please ensure all fields including Email and Phone Number are filled out correctly.");
                }
                else
                {
                    ShowErrorMessage("Critical Failure: We encountered a system error while saving the profile. Please try again or contact support.");
                }
                e.ExceptionHandled = true;
            }
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceUsers.UpdateParameters["Username"].DefaultValue = txtEditUsernameModal.Text;
                SqlDataSourceUsers.UpdateParameters["Email"].DefaultValue = txtEditEmailModal.Text;
                SqlDataSourceUsers.UpdateParameters["PhoneNumber"].DefaultValue = txtEditPhoneModal.Text;
                SqlDataSourceUsers.UpdateParameters["Address"].DefaultValue = txtEditAddressModal.Text;
                SqlDataSourceUsers.UpdateParameters["RegistrationDate"].DefaultValue = txtEditRegDateModal.Text;
                SqlDataSourceUsers.UpdateParameters["UserID"].DefaultValue = hfEditUserID.Value;

                int result = SqlDataSourceUsers.Update();
                if (result > 0)
                {
                    ShowSuccessMessage("Update Confirmed: The user's profile has been successfully modified in the central registry.");
                    GridViewUsers.DataBind();
                }
                else
                {
                    ShowErrorMessage("System Error: The update request was processed but no records were changed. Please refresh and try again.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Critical Failure: We encountered a conflict while updating the profile. Details: " + ex.Message);
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceUsers.DeleteParameters["UserID"].DefaultValue = hfDeleteUserID.Value;
                int result = SqlDataSourceUsers.Delete();
                
                if (result > 0)
                {
                    ShowSuccessMessage("Identity Purged: The user profile has been permanently removed from the cinema database.");
                    GridViewUsers.DataBind();
                }
                else
                {
                    ShowErrorMessage("System Error: The deletion request was processed but the record could not be located. It may have already been removed.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Critical Failure: We encountered a database constraint preventing this deletion. Details: " + ex.Message);
            }
        }

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
