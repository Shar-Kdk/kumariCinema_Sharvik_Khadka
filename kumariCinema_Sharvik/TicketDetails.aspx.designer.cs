namespace kumariCinema_Sharvik
{
    public partial class TicketDetails
    {
        protected global::System.Web.UI.WebControls.GridView GridViewTickets;
        protected global::System.Web.UI.WebControls.DetailsView DetailsViewTicket;
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceTickets;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceUsersDropdown;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceShowDropdown;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceTheaterDropdown;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceHallDropdown;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceSeatDropdown;
        protected global::System.Web.UI.WebControls.HiddenField hfEditTicketID;
        protected global::System.Web.UI.WebControls.HiddenField hfEditShowID;
        protected global::System.Web.UI.WebControls.TextBox txtEditPriceModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditStatusModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditTheaterModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditHallModal;
        protected global::System.Web.UI.WebControls.DropDownList DdlEditSeatModal;
        protected global::System.Web.UI.WebControls.Button btnSaveEdit;
        protected global::System.Web.UI.WebControls.HiddenField hfDeleteTicketID;
        protected global::System.Web.UI.WebControls.DropDownList DdlCancelReason;
        protected global::System.Web.UI.WebControls.ValidationSummary vsTicket;
        protected global::System.Web.UI.WebControls.Button btnConfirmDelete;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceHallDropdownEditModal;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceSeatDropdownEditModal;
        protected global::System.Web.UI.WebControls.GridView GridViewCancelled;
        protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSourceCancelledTickets;
        protected global::System.Web.UI.WebControls.LinkButton btnRefreshCancelled;
    }
}
