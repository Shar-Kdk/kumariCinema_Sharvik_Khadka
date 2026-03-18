<%@ Page Title="Ticket Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TicketDetails.aspx.cs" Inherits="kumariCinema_Sharvik.TicketDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Inventory Management</h2>
            <p>Track sold tickets, seat assignments, and payment status.</p>
        </div>
        <div class="page-header-actions">
             <button type="button" class="btn btn-warning text-dark btn-sm"><i class="bi bi-file-earmark-spreadsheet"></i> Export Sales</button>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-4">
            <!-- Add New Ticket -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-ticket-perforated-fill text-warning"></i> Generate Ticket
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewTicket" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="TICKETID" DataSourceID="SqlDataSourceTickets" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewTicket_ItemInserted" OnItemInserting="DetailsViewTicket_ItemInserting">
                        <Fields>
                            <asp:TemplateField HeaderText="Commercial">
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="mb-1 form-label fw-bold small text-muted">Ticket Sales Price</label>
                                        <asp:TextBox ID="txtPrice" runat="server" Text='<%# Bind("TICKETPRICE") %>' CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice"
                                            ErrorMessage="Sales price is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-3">
                                        <label class="mb-1 form-label fw-bold small text-muted">Initial Status</label>
                                        <asp:DropDownList ID="DdlStatus" runat="server" CssClass="form-select" SelectedValue='<%# Bind("TICKETSTATUS") %>'>
                                            <asp:ListItem Text="Paid" Value="Paid"></asp:ListItem>
                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Customer">
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="mb-1 form-label fw-bold small text-muted">Select Recipient</label>
                                        <asp:DropDownList ID="DdlInsertUser" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceUsersDropdown" DataTextField="USERNAME" DataValueField="USERID"
                                            AppendDataBoundItems="true">
                                            <asp:ListItem Text="-- Select Customer --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="DdlInsertUser" InitialValue=""
                                            ErrorMessage="Customer is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Screening">
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="mb-1 form-label fw-bold small text-muted">Select Showtime</label>
                                        <asp:DropDownList ID="DdlInsertShow" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceShowDropdown" DataTextField="SHOW_DISPLAY" DataValueField="SHOWID"
                                            AutoPostBack="True" AppendDataBoundItems="true" OnSelectedIndexChanged="DdlInsertShow_SelectedIndexChanged">
                                            <asp:ListItem Text="-- Select Movie Slot --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvShow" runat="server" ControlToValidate="DdlInsertShow" InitialValue=""
                                            ErrorMessage="Showtime is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Logistics">
                                <InsertItemTemplate>
                                    <div class="mb-2">
                                        <label class="mb-1 form-label fw-bold small text-muted">Select Theater</label>
                                        <asp:DropDownList ID="DdlInsertTheater" runat="server" CssClass="form-select mb-2"
                                            DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="THEATERNAME" DataValueField="THEATERID"
                                            AutoPostBack="True" AppendDataBoundItems="true" OnSelectedIndexChanged="DdlInsertTheater_SelectedIndexChanged">
                                            <asp:ListItem Text="-- Select Theater --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvTheater" runat="server" ControlToValidate="DdlInsertTheater" InitialValue=""
                                            ErrorMessage="Theater is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-2">
                                        <label class="mb-1 form-label fw-bold small text-muted">Select Hall</label>
                                        <asp:DropDownList ID="DdlInsertHall" runat="server" CssClass="form-select mb-2"
                                            DataSourceID="SqlDataSourceHallDropdown" DataTextField="HALLNAME" DataValueField="HALLID"
                                            AutoPostBack="True" AppendDataBoundItems="true" OnSelectedIndexChanged="DdlInsertHall_SelectedIndexChanged">
                                            <asp:ListItem Text="-- Select Hall --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvHall" runat="server" ControlToValidate="DdlInsertHall" InitialValue=""
                                            ErrorMessage="Hall is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-2">
                                        <label class="mb-1 form-label fw-bold small text-muted">Assign Seat</label>
                                        <asp:DropDownList ID="DdlInsertSeat" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceSeatDropdown" DataTextField="SEATNUMBER" DataValueField="SEATID"
                                            AppendDataBoundItems="true">
                                            <asp:ListItem Text="-- Select Seat --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvSeat" runat="server" ControlToValidate="DdlInsertSeat" InitialValue=""
                                            ErrorMessage="Seat assignment is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTicketInsert"></asp:RequiredFieldValidator>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <asp:Button ID="btnInsert" runat="server" CommandName="Insert" Text="Generate Ticket" 
                                        CssClass="btn btn-primary w-100 py-2 fw-bold" ValidationGroup="VGTicketInsert" />
                                    <asp:Button ID="btnCancel" runat="server" CommandName="Cancel" Text="Reset Form" 
                                        CssClass="btn btn-outline-secondary w-100 mt-2 py-2 fw-bold" CausesValidation="false" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3">
                        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center rounded-3 p-2 small fw-bold" Visible="false" EnableViewState="false"></asp:Label>
                        <asp:ValidationSummary ID="vsTicket" runat="server" ValidationGroup="VGTicketInsert" 
                            CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" 
                            HeaderText="Please correct the following:" EnableViewState="false" />
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8">
            <!-- Ticket List -->
            <div class="premium-card mb-4">
                <div class="card-header">
                    <i class="bi bi-reception-4 text-warning"></i> Sales Transaction Logs
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewTickets" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="TICKETID" DataSourceID="SqlDataSourceTickets" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="10">
                        <Columns>
                            <asp:BoundField DataField="TICKETID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />

                             <asp:TemplateField HeaderText="Booking & Show">
                                <ItemTemplate>
                                    <div class="fw-bold text-primary small"><%# Eval("MOVIETITLE") %></div>
                                    <div class="extra-small text-muted">
                                        <i class="bi bi-clock"></i> <%# Eval("SHOWTIME") %> (<%# GetSpecificShowTime(Eval("SHOWTIME")) %>) | 
                                        <i class="bi bi-calendar"></i> <%# Eval("SHOWDATE", "{0:MMM dd}") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Customer">
                                <ItemTemplate>
                                    <div class="small fw-semibold"><%# Eval("USERNAME") %></div>
                                    <div class="extra-small text-muted">ID: <%# Eval("USERID") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Allocation">
                                <ItemTemplate>
                                    <div class="small"><i class="bi bi-chair text-muted ms-1"></i> <%# Eval("SEATNUMBER") %></div>
                                    <div class="extra-small text-info"><%# Eval("THEATERNAME") %> - <%# Eval("HALLNAME") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Commercials">
                                <ItemTemplate>
                                    <div class="fw-bold text-success">Rs. <%# Eval("TICKETPRICE") %></div>
                                    <%# GetStatusBadge(Eval("TICKETSTATUS")) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-sm btn-outline-info p-1" title="View Details"
                                            onclick="<%# GetViewModalScript(Eval("TICKETID"), Eval("MOVIETITLE"), Eval("USERNAME"), Eval("SEATNUMBER"), Eval("TICKETPRICE"), Eval("TICKETSTATUS"), Eval("SHOWDATE"), Eval("SHOWTIME"), Eval("THEATERNAME"), Eval("HALLNAME")) %>">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-primary p-1" title="Edit Ticket"
                                            onclick="<%# GetEditModalScript(Eval("TICKETID"), Eval("TICKETPRICE"), Eval("TICKETSTATUS"), Eval("SEATID"), Eval("SHOWID")) %>">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger p-1" title="Void Ticket"
                                            onclick="<%# GetDeleteModalScript(Eval("TICKETID")) %>">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Cancellation Report Section -->
            <div class="premium-card border-danger-subtle shadow-sm">
                <div class="card-header bg-danger-subtle text-danger py-2 d-flex justify-content-between align-items-center">
                    <div>
                        <i class="bi bi-file-earmark-x-fill me-2"></i> Cancellation Report
                        <span class="badge bg-danger ms-2 extra-small">Voided & Expired</span>
                    </div>
                    <asp:LinkButton ID="btnRefreshCancelled" runat="server" CssClass="btn btn-link btn-sm text-danger p-0" OnClick="btnRefreshCancelled_Click">
                        <i class="bi bi-arrow-clockwise"></i>
                    </asp:LinkButton>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewCancelled" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="SqlDataSourceCancelledTickets" 
                        CssClass="premium-table mb-0" GridLines="None"
                        AllowPaging="True" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="TICKETID" HeaderText="TRX ID" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            <asp:TemplateField HeaderText="Film & Schedule">
                                <ItemTemplate>
                                    <div class="small text-dark fw-bold"><%# Eval("MOVIETITLE") %></div>
                                    <div class="extra-small text-muted"><%# Eval("SHOWDATE", "{0:MMM dd}") %> | <%# Eval("SHOWTIME") %> (<%# GetSpecificShowTime(Eval("SHOWTIME")) %>)</div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Seat">
                                <ItemTemplate>
                                    <span class="badge bg-light text-dark border extra-small"><%# Eval("SEATNUMBER") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reason / Date">
                                <ItemTemplate>
                                    <div class="extra-small text-danger fw-medium"><%# Eval("CANCEL_REASON") ?? "Seat Released" %></div>
                                    <div class="extra-small text-muted italic">Payment <%# Eval("TICKETSTATUS") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="p-4 text-center text-muted italic small">
                                <i class="bi bi-check-circle me-1"></i> No recently cancelled bookings.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- View Modal -->
    <div class="modal fade" id="ticketViewModal" tabindex="-1" aria-labelledby="ticketViewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-info text-dark border-0 py-3">
                    <h5 class="modal-title fw-bold" id="ticketViewModalLabel"><i class="bi bi-ticket-detailed me-2"></i> Ticket Receipt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-info-subtle text-info rounded-circle mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="bi bi-ticket-perforated"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-0" id="vMovieTitle">Movie Title</h4>
                        <p class="text-muted small" id="vTicketID">TX-#000</p>
                    </div>
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Customer</label>
                            <span class="d-block text-dark small fw-semibold" id="vCustomer">Name</span>
                        </div>
                        <div class="col-6 text-end">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Status</label>
                            <span id="vStatus" class="badge bg-success-subtle text-success px-2 py-1 rounded-pill extra-small">Paid</span>
                        </div>
                        <div class="col-12"><hr class="my-1 opacity-5"></div>
                        <div class="col-4">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Theater</label>
                            <span class="d-block text-dark small" id="vTheater">Theater</span>
                        </div>
                        <div class="col-4">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Hall</label>
                            <span class="d-block text-dark small" id="vHall">Hall</span>
                        </div>
                        <div class="col-4">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Seat</label>
                            <span class="d-block text-dark fw-bold" id="vSeat">A1</span>
                        </div>
                        <div class="col-12"><hr class="my-1 opacity-5"></div>
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Schedule</label>
                            <span class="d-block text-dark small" id="vSchedule">Date | Time</span>
                        </div>
                        <div class="col-6 text-end">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Sale Amount</label>
                            <span class="d-block text-success fw-bold h5 mb-0" id="vPrice">Rs. 0</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0">
                    <button type="button" class="btn btn-secondary w-100" data-bs-dismiss="modal">Close Receipt</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <asp:HiddenField ID="hfEditTicketID" runat="server" />
    <asp:HiddenField ID="hfEditShowID" runat="server" />
    <div class="modal fade" id="ticketEditModal" tabindex="-1" aria-labelledby="ticketEditModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-dark text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="ticketEditModalLabel"><i class="bi bi-pencil-square me-2"></i> Update Ticket Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Sales Price (Rs.)</label>
                            <asp:TextBox ID="txtEditPriceModal" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Payment Status</label>
                            <asp:DropDownList ID="DdlEditStatusModal" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Paid" Value="Paid"></asp:ListItem>
                                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Select Theater</label>
                            <asp:DropDownList ID="DdlEditTheaterModal" runat="server" CssClass="form-select mb-2"
                                DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="THEATERNAME" DataValueField="THEATERID"
                                AutoPostBack="True" AppendDataBoundItems="true" OnSelectedIndexChanged="DdlEditTheaterModal_SelectedIndexChanged">
                                <asp:ListItem Text="-- Select Theater --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Select Hall</label>
                            <asp:DropDownList ID="DdlEditHallModal" runat="server" CssClass="form-select mb-2"
                                DataSourceID="SqlDataSourceHallDropdownEditModal" DataTextField="HALLNAME" DataValueField="HALLID"
                                AutoPostBack="True" AppendDataBoundItems="true" OnSelectedIndexChanged="DdlEditHallModal_SelectedIndexChanged">
                                <asp:ListItem Text="-- Select Hall --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Assigned Seat</label>
                            <asp:DropDownList ID="DdlEditSeatModal" runat="server" CssClass="form-select"
                                DataSourceID="SqlDataSourceSeatDropdownEditModal" DataTextField="SEATNUMBER" DataValueField="SEATID"
                                AppendDataBoundItems="true">
                                <asp:ListItem Text="-- Select Seat --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0 gap-2">
                    <button type="button" class="btn btn-outline-secondary flex-grow-1 py-2" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Save Changes" CssClass="btn btn-primary flex-grow-1 py-2 fw-bold" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <asp:HiddenField ID="hfDeleteTicketID" runat="server" />
    <div class="modal fade" id="ticketDeleteModal" tabindex="-1" aria-labelledby="ticketDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3.5rem;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <h5 class="fw-bold text-dark">Confirm Cancellation</h5>
                    <p class="text-muted small">Are you sure you want to void ticket ID #<span id="deleteTicketID" class="fw-bold text-dark"></span>? This will release the seat.</p>
                    
                    <div class="mb-3 text-start">
                        <label class="form-label extra-small fw-bold text-muted mb-1">Cancellation Reason</label>
                        <asp:DropDownList ID="DdlCancelReason" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Text="Customer Request" Value="Customer Request"></asp:ListItem>
                            <asp:ListItem Text="Payment Failed" Value="Payment Failed"></asp:ListItem>
                            <asp:ListItem Text="Duplicate Booking" Value="Duplicate Booking"></asp:ListItem>
                            <asp:ListItem Text="Technical Error" Value="Technical Error"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Void Ticket" CssClass="btn btn-danger fw-bold py-2" OnClick="btnConfirmDelete_Click" />
                        <button type="button" class="btn btn-light py-2" data-bs-dismiss="modal">Keep Ticket</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openEditModal(id, price, status, seatId, showId) {
            try {
                document.getElementById('<%= hfEditTicketID.ClientID %>').value = id;
                document.getElementById('<%= hfEditShowID.ClientID %>').value = showId;
                document.getElementById('<%= txtEditPriceModal.ClientID %>').value = price;
                document.getElementById('<%= DdlEditStatusModal.ClientID %>').value = status;
                document.getElementById('<%= DdlEditSeatModal.ClientID %>').value = seatId;
                
                var modal = new bootstrap.Modal(document.getElementById('ticketEditModal'));
                modal.show();
            } catch (e) { console.error('Error:', e); }
        }

        function openDeleteModal(id) {
            try {
                document.getElementById('<%= hfDeleteTicketID.ClientID %>').value = id;
                document.getElementById('deleteTicketID').innerText = id;
                
                var modal = new bootstrap.Modal(document.getElementById('ticketDeleteModal'));
                modal.show();
            } catch (e) { console.error('Error:', e); }
        }
    </script>

    <style>
        .extra-small { font-size: 0.7rem; }
        .bg-success-subtle { background-color: #f0fdf4; }
        .bg-warning-subtle { background-color: #fffbeb; }
        .bg-danger-subtle { background-color: #fef2f2; }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT t.TICKETID, t.TICKETPRICE, t.TICKETSTATUS, t.SEATID, s.SEATNUMBER, u.USERNAME, u.USERID, m.TITLE as MOVIETITLE, sh.&quot;SHOW&quot; as SHOWTIME, sh.SHOWDATE, h.HALLNAME, th.THEATERNAME, b.SHOWID
                       FROM TICKET t 
                       LEFT JOIN SEAT s ON t.SEATID = s.SEATID 
                       LEFT JOIN HALL h ON s.HALLID = h.HALLID
                       LEFT JOIN THEATER th ON h.THEATERID = th.THEATERID
                       LEFT JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID
                       LEFT JOIN USERS u ON bt.USERID = u.USERID
                       LEFT JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID
                       LEFT JOIN &quot;SHOW&quot; sh ON b.SHOWID = sh.SHOWID
                       LEFT JOIN MOVIE m ON sh.MOVIEID = m.MOVIEID
                       ORDER BY t.TICKETID DESC" 
        InsertCommand="INSERT INTO TICKET (TICKETID, TICKETPRICE, TICKETSTATUS, SEATID) VALUES (:TICKETID, :TICKETPRICE, :TICKETSTATUS, :SEATID)" 
        UpdateCommand="UPDATE TICKET SET TICKETPRICE = :TICKETPRICE, TICKETSTATUS = :TICKETSTATUS, SEATID = :SEATID WHERE TICKETID = :TICKETID">
        <InsertParameters>
            <asp:Parameter Name="TICKETID" Type="Decimal" />
            <asp:Parameter Name="TICKETPRICE" Type="Decimal" />
            <asp:Parameter Name="TICKETSTATUS" Type="String" />
            <asp:Parameter Name="SEATID" Type="Decimal" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="TICKETPRICE" Type="Decimal" />
            <asp:Parameter Name="TICKETSTATUS" Type="String" />
            <asp:Parameter Name="SEATID" Type="Decimal" />
            <asp:Parameter Name="TICKETID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceUsersDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT USERID, USERNAME FROM USERS ORDER BY USERNAME">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceShowDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT s.SHOWID, s.SHOWPRICE, s.ISHOLIDAY, s.ISNEWRELEASE, (m.TITLE || ' (' || s.&quot;SHOW&quot; || ' ' || CASE s.&quot;SHOW&quot; WHEN 'Morning' THEN '10:00' WHEN 'Evening' THEN '18:00' WHEN 'Night' THEN '21:00' ELSE '' END || ' - ' || TO_CHAR(s.SHOWDATE, 'Mon DD') || ')') as SHOW_DISPLAY 
                       FROM &quot;SHOW&quot; s 
                       JOIN MOVIE m ON s.MOVIEID = m.MOVIEID 
                       ORDER BY s.SHOWDATE DESC">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceTheaterDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT THEATERID, THEATERNAME FROM THEATER ORDER BY THEATERNAME">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceHallDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT HALLID, HALLNAME FROM HALL WHERE THEATERID = :THEATERID ORDER BY HALLNAME">
        <SelectParameters>
            <asp:ControlParameter ControlID="DetailsViewTicket$DdlInsertTheater" Name="THEATERID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceSeatDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT SEATID, SEATNUMBER FROM SEAT WHERE HALLID = :HALLID AND SEATID NOT IN (SELECT t.SEATID FROM TICKET t JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID WHERE b.SHOWID = :SHOWID AND t.TICKETSTATUS != 'Cancelled') ORDER BY SEATNUMBER">
        <SelectParameters>
            <asp:ControlParameter ControlID="DetailsViewTicket$DdlInsertHall" Name="HALLID" PropertyName="SelectedValue" Type="Decimal" />
            <asp:ControlParameter ControlID="DetailsViewTicket$DdlInsertShow" Name="SHOWID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceHallDropdownEditModal" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT HALLID, HALLNAME FROM HALL WHERE THEATERID = :THEATERID ORDER BY HALLNAME">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlEditTheaterModal" Name="THEATERID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceSeatDropdownEditModal" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT SEATID, SEATNUMBER FROM SEAT WHERE HALLID = :HALLID AND SEATID NOT IN (SELECT t.SEATID FROM TICKET t JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID WHERE b.SHOWID = :SHOWID AND t.TICKETSTATUS != 'Cancelled' AND t.TICKETID != :TID) ORDER BY SEATNUMBER">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlEditHallModal" Name="HALLID" PropertyName="SelectedValue" Type="Decimal" />
            <asp:ControlParameter ControlID="hfEditShowID" Name="SHOWID" PropertyName="Value" Type="Decimal" />
            <asp:ControlParameter ControlID="hfEditTicketID" Name="TID" PropertyName="Value" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceCancelledTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="/* Linked Tickets */
                       SELECT t.TICKETID, t.TICKETSTATUS, s.SEATNUMBER, m.TITLE as MOVIETITLE, sh.SHOWDATE, sh.&quot;SHOW&quot; as SHOWTIME, c.REASON as CANCEL_REASON
                       FROM TICKET t 
                       LEFT JOIN CANCELLATION c ON t.CANCELLATIONID = c.CANCELLATIONID
                       LEFT JOIN SEAT s ON t.SEATID = s.SEATID 
                       LEFT JOIN BOOKING_TICKET bt ON t.TICKETID = bt.TICKETID
                       LEFT JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID
                       LEFT JOIN &quot;SHOW&quot; sh ON b.SHOWID = sh.SHOWID
                       LEFT JOIN MOVIE m ON sh.MOVIEID = m.MOVIEID
                       WHERE t.TICKETSTATUS = 'Cancelled' 
                          OR UPPER(t.TICKETSTATUS) = 'CANCELLED' 
                          OR t.CANCELLATIONID IS NOT NULL 
                       
                       UNION ALL
                       
                       /* Standalone Cancellations */
                       SELECT c.CANCELLATIONID as TICKETID, 'Unknown' as TICKETSTATUS, 'N/A' as SEATNUMBER, 'General Cancellation' as MOVIETITLE, c.CANCELLATIONDATE as SHOWDATE, 'N/A' as SHOWTIME, c.REASON as CANCEL_REASON
                       FROM CANCELLATION c
                       WHERE NOT EXISTS (SELECT 1 FROM TICKET t WHERE t.CANCELLATIONID = c.CANCELLATIONID)
                       
                       ORDER BY TICKETID DESC">
    </asp:SqlDataSource>
    <script type="text/javascript">
        function showTicketReceipt(id, movie, customer, seat, price, status, date, time, theater, hall) {
            try {
                document.getElementById('vTicketID').innerText = 'TX-#' + id;
                document.getElementById('vMovieTitle').innerText = movie || 'N/A';
                document.getElementById('vCustomer').innerText = customer || 'N/A';
                document.getElementById('vSeat').innerText = seat || 'N/A';
                document.getElementById('vPrice').innerText = 'Rs. ' + price;
                document.getElementById('vTheater').innerText = theater || 'N/A';
                document.getElementById('vHall').innerText = hall || 'N/A';
                document.getElementById('vSchedule').innerText = date + ' | ' + time;

                var statusBadge = document.getElementById('vStatus');
                statusBadge.innerText = status;
                statusBadge.className = 'badge px-2 py-1 rounded-pill extra-small ' + 
                    (status === 'Paid' ? 'bg-success-subtle text-success' : 
                     status === 'Pending' ? 'bg-warning-subtle text-warning' : 'bg-danger-subtle text-danger');

                var modal = new bootstrap.Modal(document.getElementById('ticketViewModal'));
                modal.show();
            } catch (e) { console.error('Error opening view modal:', e); }
        }

        function openEditModal(id, price, status, seatId, showId) {
            try {
                document.getElementById('<%= hfEditTicketID.ClientID %>').value = id;
                document.getElementById('<%= hfEditShowID.ClientID %>').value = showId;
                document.getElementById('<%= txtEditPriceModal.ClientID %>').value = price || '';
                document.getElementById('<%= DdlEditStatusModal.ClientID %>').value = status || 'Pending';
                document.getElementById('<%= DdlEditSeatModal.ClientID %>').value = seatId;
                
                var modal = new bootstrap.Modal(document.getElementById('ticketEditModal'));
                modal.show();
            } catch (ex) { console.error('Error opening edit modal:', ex); }
        }

        function openDeleteModal(id) {
            try {
                document.getElementById('<%= hfDeleteTicketID.ClientID %>').value = id;
                document.getElementById('deleteTicketID').innerText = id;
                var modal = new bootstrap.Modal(document.getElementById('ticketDeleteModal'));
                modal.show();
            } catch (e) { console.error('Error opening delete modal:', e); }
        }
    </script>
</asp:Content>
