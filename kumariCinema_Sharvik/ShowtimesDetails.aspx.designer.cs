namespace kumariCinema_Sharvik
{
    public partial class ShowtimesDetails
    {
        protected global::System.Web.UI.WebControls.GridView GridViewShows;
        protected global::System.Web.UI.WebControls.DetailsView DetailsViewShow;
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceShows;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceMovieDropdown;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceHallDropdown;
        protected global::System.Web.UI.WebControls.HiddenField hfEditShowID;
        protected global::System.Web.UI.WebControls.TextBox txtEditDateModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditTimeModal;
        protected global::System.Web.UI.WebControls.TextBox txtEditPriceModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditMovieModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditHallModal;
        protected global::System.Web.UI.WebControls.CheckBox chkEditHoliday;
        protected global::System.Web.UI.WebControls.CheckBox chkEditNew;
        protected global::System.Web.UI.WebControls.Button btnSaveEdit;
        protected global::System.Web.UI.WebControls.HiddenField hfDeleteShowID;
        protected global::System.Web.UI.WebControls.LinkButton btnFilterAll;
        protected global::System.Web.UI.WebControls.LinkButton btnFilterToday;
        protected global::System.Web.UI.WebControls.LinkButton btnFilterThisWeek;
        protected global::System.Web.UI.WebControls.Button btnConfirmDelete;
    }
}
