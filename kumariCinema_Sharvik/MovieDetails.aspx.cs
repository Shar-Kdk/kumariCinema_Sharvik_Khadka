using System;
using System.Web.UI.WebControls;

namespace kumariCinema_Sharvik
{
    public partial class MovieDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ClearMessage();
                string status = Request.QueryString["status"];
                if (status == "added") ShowSuccessMessage("Movie added successfully!");
                else if (status == "updated") ShowSuccessMessage("Movie updated successfully!");
                else if (status == "deleted") ShowSuccessMessage("Movie deleted successfully.");
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            btnClearSearch.Visible = !string.IsNullOrWhiteSpace(txtSearch.Text);
            GridViewMovies.DataBind();
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            btnClearSearch.Visible = false;
            GridViewMovies.DataBind();
        }

        public string GetQuickViewScript(object title, object genre, object duration, object lang, object release)
        {
            string dateStr = "";
            if (release != null && release != DBNull.Value)
            {
                if (release is DateTime)
                    dateStr = ((DateTime)release).ToString("MMM dd, yyyy");
                else if (DateTime.TryParse(release.ToString(), out DateTime dt))
                    dateStr = dt.ToString("MMM dd, yyyy");
                else
                    dateStr = release.ToString();
            }

            return string.Format("showMoviePopup(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\"); return false;",
                title?.ToString().Replace("\"", "\\\""),
                genre?.ToString().Replace("\"", "\\\""),
                duration?.ToString(),
                lang?.ToString().Replace("\"", "\\\""),
                dateStr.Replace("\"", "\\\""));
        }

        public string GetEditModalScript(object id, object title, object genre, object duration, object lang, object release)
        {
            string dateStr = "";
            if (release != null && release != DBNull.Value)
            {
                if (release is DateTime)
                    dateStr = ((DateTime)release).ToString("yyyy-MM-dd");
                else if (DateTime.TryParse(release.ToString(), out DateTime dt))
                    dateStr = dt.ToString("yyyy-MM-dd");
                else
                    dateStr = release.ToString();
            }

            return string.Format("openEditModal(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\"); return false;",
                id,
                title?.ToString().Replace("\"", "\\\""),
                genre?.ToString().Replace("\"", "\\\""),
                duration?.ToString(),
                lang?.ToString().Replace("\"", "\\\""),
                dateStr.Replace("\"", "\\\""));
        }

        public string GetDeleteModalScript(object id, object title)
        {
            return string.Format("openDeleteModal(\"{0}\", \"{1}\"); return false;",
                id,
                title?.ToString().Replace("\"", "\\\""));
        }

        public void DetailsViewMovie_ItemInserting(object sender, DetailsViewInsertEventArgs e)
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

                    // Check for duplicate title
                    string title = e.Values["Title"]?.ToString()?.Trim();
                    using (System.Data.OracleClient.OracleCommand checkCmd = new System.Data.OracleClient.OracleCommand(
                        "SELECT COUNT(*) FROM Movie WHERE UPPER(Title) = UPPER(:title)", conn))
                    {
                        checkCmd.Parameters.Add(":title", title);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowErrorMessage("A movie with the title '" + title + "' already exists.");
                            e.Cancel = true;
                            return;
                        }
                    }

                    // Generate new ID
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
                ShowErrorMessage("Error: " + ex.Message);
                e.Cancel = true;
            }
        }

        public void DetailsViewMovie_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?status=added");
            }
            else
            {
                ShowErrorMessage("Error adding movie: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceMovies.UpdateParameters["Title"].DefaultValue = txtEditTitleModal.Text;
                SqlDataSourceMovies.UpdateParameters["Genre"].DefaultValue = txtEditGenreModal.Text;
                SqlDataSourceMovies.UpdateParameters["Duration"].DefaultValue = txtEditDurationModal.Text;
                SqlDataSourceMovies.UpdateParameters["Language"].DefaultValue = txtEditLangModal.Text;
                SqlDataSourceMovies.UpdateParameters["ReleaseDate"].DefaultValue = txtEditReleaseModal.Text;
                SqlDataSourceMovies.UpdateParameters["MovieID"].DefaultValue = hfEditMovieID.Value;

                int result = SqlDataSourceMovies.Update();
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=updated");
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

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            ClearMessage();
            try
            {
                SqlDataSourceMovies.DeleteParameters["MovieID"].DefaultValue = hfDeleteMovieID.Value;
                int result = SqlDataSourceMovies.Delete();
                
                if (result > 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath + "?status=deleted");
                }
                else
                {
                    ShowErrorMessage("Movie not found.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Delete failed. It might be linked to other records.");
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
