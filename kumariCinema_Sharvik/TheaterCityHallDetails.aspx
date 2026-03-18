<%@ Page Title="Infrastructure Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TheaterCityHallDetails.aspx.cs" Inherits="kumariCinema_Sharvik.TheaterCityHallDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Theater Infrastructure</h2>
            <p>Configure your cinema locations and individual screening halls.</p>
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center rounded-3 p-2 small fw-bold" Visible="false" EnableViewState="false"></asp:Label>

    <!-- THEATER MANAGEMENT -->
    <div class="row mb-5">
        <!-- Add Theater Form -->
        <div class="col-xl-4 mb-4 mb-xl-0">
            <div class="premium-card h-100">
                <div class="card-header border-bottom bg-white py-3">
                    <h6 class="m-0 fw-bold text-main d-flex align-items-center"><i class="bi bi-building-fill text-success me-2"></i> Register New Theater</h6>
                </div>
                <div class="card-body p-4">
                    <asp:DetailsView ID="DetailsViewTheater" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" DefaultMode="Insert" 
                        CssClass="modern-form-table w-100" GridLines="None"
                        OnItemInserted="DetailsViewTheater_ItemInserted" OnItemInserting="DetailsViewTheater_ItemInserting">
                        <Fields>
                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Theater Name</label>
                                        <asp:TextBox ID="txtTheaterName" runat="server" Text='<%# Bind("TheaterName") %>' CssClass="form-control" placeholder="e.g. Kumari Central"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvTheaterName" runat="server" ControlToValidate="txtTheaterName" 
                                            ErrorMessage="Branch name is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">City</label>
                                        <asp:TextBox ID="txtCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control" placeholder="e.g. Kathmandu"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" 
                                            ErrorMessage="City is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label fw-semibold small text-muted">Address</label>
                                        <asp:TextBox ID="txtAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control" placeholder="e.g. New Baneshwor, Kathmandu"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" 
                                            ErrorMessage="Address is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <asp:Button ID="btnInsertTheater" runat="server" CommandName="Insert" Text="Add Branch" CssClass="btn btn-success w-100 py-2 fw-medium" ValidationGroup="VGTheaterInsert" />
                                    <asp:Button ID="btnCancelTheater" runat="server" CommandName="Cancel" Text="Reset Form" CssClass="btn btn-outline-secondary w-100 mt-2 py-2 fw-bold" CausesValidation="false" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <asp:ValidationSummary ID="vsTheaterInsert" runat="server" ValidationGroup="VGTheaterInsert" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                    <asp:Label ID="lblTheaterMessage" runat="server" Visible="false" EnableViewState="false"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Theater List -->
        <div class="col-xl-8">
            <div class="premium-card h-100">
                <div class="card-header justify-content-between align-items-center py-3">
                    <span class="d-flex align-items-center m-0 fw-bold text-main gap-2"><i class="bi bi-list-stars text-success"></i> Active Branches</span>
                    <div class="search-box">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearchTheater" runat="server" CssClass="form-control border-start-0 ps-0" 
                                placeholder="Search by name or city..." AutoPostBack="true" OnTextChanged="txtSearchTheater_TextChanged"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewTheaters" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" 
                        CssClass="premium-table mb-0" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="TheaterID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Branch Name">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="avatar-circle bg-success-subtle text-success border border-success-subtle" style="width: 30px; height: 30px; font-size: 0.8rem;">
                                            <%# !string.IsNullOrEmpty(Eval("TheaterName")?.ToString()) ? Eval("TheaterName").ToString().Substring(0,1).ToUpper() : "?" %>
                                        </div>
                                        <div class="fw-bold text-main"><%# Eval("TheaterName") %></div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Location Details">
                                <ItemTemplate>
                                    <div class="extra-small text-muted"><i class="bi bi-geo-alt"></i> <%# Eval("City") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-signpost-2"></i> <%# Eval("Address") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <div class="d-flex gap-2">
                                        <asp:LinkButton ID="lnkViewTheater" runat="server" CssClass="btn-action text-info" ToolTip="Quick View"
                                            OnClientClick='<%# GetTheaterViewScript(Eval("TheaterName"), Eval("City"), Eval("Address")) %>'>
                                            <i class="bi bi-eye-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkEditTheater" runat="server" CssClass="btn btn-sm btn-outline-primary p-1" ToolTip="Edit Branch"
                                            OnClientClick='<%# GetTheaterEditScript(Eval("TheaterID"), Eval("TheaterName"), Eval("City"), Eval("Address")) %>'>
                                            <i class="bi bi-pencil-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkDeleteTheater" runat="server" CssClass="btn btn-sm btn-outline-danger p-1" ToolTip="Deactivate"
                                            OnClientClick='<%# GetTheaterDeleteScript(Eval("TheaterID"), Eval("TheaterName")) %>'>
                                            <i class="bi bi-trash3-fill"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- HALL MANAGEMENT -->
    <div class="row mb-5">
        <!-- Add Hall Form -->
        <div class="col-xl-4 mb-4 mb-xl-0">
            <div class="premium-card h-100">
                <div class="card-header border-bottom bg-white py-3">
                    <h6 class="m-0 fw-bold text-main d-flex align-items-center"><i class="bi bi-grid-3x3-gap-fill text-primary me-2"></i> Register New Hall</h6>
                </div>
                <div class="card-body p-4">
                    <asp:DetailsView ID="DetailsViewHall" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="HallID" DataSourceID="SqlDataSourceHalls" DefaultMode="Insert" 
                        CssClass="modern-form-table w-100" GridLines="None"
                        OnItemInserted="DetailsViewHall_ItemInserted" OnItemInserting="DetailsViewHall_ItemInserting">
                        <Fields>
                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Hall Name</label>
                                        <asp:TextBox ID="txtHallName" runat="server" Text='<%# Bind("HallName") %>' CssClass="form-control" placeholder="e.g. IMAX Hall"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvHallName" runat="server" ControlToValidate="txtHallName" 
                                            ErrorMessage="Hall name is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Total Seats/Capacity</label>
                                        <asp:TextBox ID="txtCapacity" runat="server" Text='<%# Bind("Capacity") %>' TextMode="Number" CssClass="form-control" placeholder="e.g. 200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvCapacity" runat="server" ControlToValidate="txtCapacity" 
                                            ErrorMessage="Capacity is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallInsert"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rvCapacity" runat="server" ControlToValidate="txtCapacity" 
                                            MinimumValue="1" MaximumValue="1000" Type="Integer"
                                            ErrorMessage="Capacity must be between 1 and 1000" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallInsert"></asp:RangeValidator>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label fw-semibold small text-muted">Select Location</label>
                                        <asp:DropDownList ID="DdlInsertTheater" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="TheaterName" DataValueField="TheaterID" 
                                            SelectedValue='<%# Bind("TheaterID") %>' AppendDataBoundItems="true">
                                            <asp:ListItem Text="-- Select Theater --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvInsertTheater" runat="server" ControlToValidate="DdlInsertTheater" 
                                            InitialValue="" ErrorMessage="Theater selection is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <asp:Button ID="btnInsertHall" runat="server" CommandName="Insert" Text="Save Hall" CssClass="btn btn-primary w-100 py-2 fw-medium" ValidationGroup="VGHallInsert" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <asp:ValidationSummary ID="vsHallInsert" runat="server" ValidationGroup="VGHallInsert" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                    <asp:Label ID="lblHallMessage" runat="server" Visible="false" EnableViewState="false"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Hall List -->
        <div class="col-xl-8">
            <div class="premium-card h-100">
                <div class="card-header justify-content-between py-3">
                    <span class="d-flex align-items-center gap-2 m-0 fw-bold text-main"><i class="bi bi-grid"></i> Screening Halls</span>
                    <asp:DropDownList ID="DdlFilterTheater" runat="server" CssClass="form-select form-select-sm" 
                        style="width: auto; min-width: 220px;" AutoPostBack="true" 
                        DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="TheaterName" DataValueField="TheaterID" 
                        AppendDataBoundItems="true" OnSelectedIndexChanged="DdlFilterTheater_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select a Theater to view halls --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewHalls" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="HallID" DataSourceID="SqlDataSourceHalls" 
                        CssClass="premium-table mb-0" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="HallID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Hall Info">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("HallName") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-people"></i> Capacity: <%# Eval("Capacity") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Theater">
                                <ItemTemplate><span class="badge bg-light text-dark border"><%# Eval("TheaterName") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-2">
                                        <asp:LinkButton ID="lnkViewHall" runat="server" CssClass="btn-action text-info" ToolTip="Quick View"
                                            OnClientClick='<%# GetHallViewScript(Eval("HallName"), Eval("Capacity"), Eval("TheaterName")) %>'>
                                            <i class="bi bi-eye-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkEditHall" runat="server" CssClass="btn btn-sm btn-outline-secondary p-1" ToolTip="Edit Hall"
                                            OnClientClick='<%# GetHallEditScript(Eval("HallID"), Eval("HallName"), Eval("Capacity"), Eval("TheaterID")) %>'>
                                            <i class="bi bi-pencil-square"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkDeleteHall" runat="server" CssClass="btn btn-sm btn-outline-danger p-1" ToolTip="Delete Hall"
                                            OnClientClick='<%# GetHallDeleteScript(Eval("HallID"), Eval("HallName")) %>'>
                                            <i class="bi bi-trash3"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center p-5">
                                <i class="bi bi-grid-3x3-gap text-muted" style="font-size: 3rem;"></i>
                                <h5 class="mt-3 text-dark fw-bold">Select a Theater</h5>
                                <p class="text-muted small">Choose a theater from the dropdown above to view or manage its screening halls.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>

                </div>
            </div>
        </div>
    </div>


    <!-- SEAT MANAGEMENT -->
    <div class="row mb-5">
        <!-- Add Seat Form -->
        <div class="col-xl-4 mb-4 mb-xl-0">
            <div class="premium-card h-100">
                <div class="card-header border-bottom bg-white py-3">
                    <h6 class="m-0 fw-bold text-main d-flex align-items-center"><i class="bi bi-grid-fill text-warning me-2"></i> Register New Seat</h6>
                </div>
                <div class="card-body p-4">
                    <asp:DetailsView ID="DetailsViewSeat" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="SeatID" DataSourceID="SqlDataSourceSeats" DefaultMode="Insert" 
                        CssClass="modern-form-table w-100" GridLines="None"
                        OnItemInserted="DetailsViewSeat_ItemInserted" OnItemInserting="DetailsViewSeat_ItemInserting">
                        <Fields>
                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Seat Number</label>
                                        <asp:TextBox ID="txtSeatNumber" runat="server" Text='<%# Bind("SeatNumber") %>' CssClass="form-control" placeholder="e.g. A1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvSeatNumber" runat="server" ControlToValidate="txtSeatNumber" 
                                            ErrorMessage="Seat number is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGSeatInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Row Number</label>
                                        <asp:TextBox ID="txtRowNumber" runat="server" Text='<%# Bind("RowNumber") %>' CssClass="form-control" placeholder="e.g. A"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvRowNumber" runat="server" ControlToValidate="txtRowNumber" 
                                            ErrorMessage="Row number is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGSeatInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small text-muted">Initial Status</label>
                                        <asp:DropDownList ID="ddlSeatStatus" runat="server" CssClass="form-select" SelectedValue='<%# Bind("SeatStatus") %>'>
                                            <asp:ListItem Text="Available" Value="Available"></asp:ListItem>
                                            <asp:ListItem Text="Reserved" Value="Reserved"></asp:ListItem>
                                            <asp:ListItem Text="Maintenance" Value="Maintenance"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label fw-semibold small text-muted">Assign to Hall</label>
                                        <asp:DropDownList ID="DdlInsertHall" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceHallDropdown" DataTextField="HallName" DataValueField="HallID" 
                                            AppendDataBoundItems="true">
                                            <asp:ListItem Text="-- Select Hall --" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvInsertHall" runat="server" ControlToValidate="DdlInsertHall" 
                                            InitialValue="" ErrorMessage="Hall selection is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGSeatInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <asp:Button ID="btnInsert" runat="server" CommandName="Insert" Text="Save Seat" CssClass="btn btn-primary w-100 py-2 fw-medium" ValidationGroup="VGSeatInsert" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <asp:ValidationSummary ID="vsSeatInsert" runat="server" ValidationGroup="VGSeatInsert" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                    <asp:Label ID="lblSeatMessage" runat="server" Visible="false" EnableViewState="false"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Seat List -->
        <div class="col-xl-8">
            <div class="premium-card h-100">
                <div class="card-header justify-content-between align-items-center py-3">
                    <span class="d-flex align-items-center m-0 fw-bold text-main gap-2"><i class="bi bi-view-stacked"></i> Seat Inventory</span>
                    <div class="d-flex gap-2">
                        <asp:DropDownList ID="DdlFilterHall" runat="server" CssClass="form-select form-select-sm w-auto" 
                            DataSourceID="SqlDataSourceHallDropdown" DataTextField="HallName" DataValueField="HallID" 
                            AppendDataBoundItems="true" AutoPostBack="true">
                            <asp:ListItem Text="-- Select a Hall to view seats --" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:ListView ID="ListViewSeats" runat="server" DataSourceID="SqlDataSourceSeats" DataKeyNames="SeatID">
                        <EmptyDataTemplate>
                            <div class="text-center p-5">
                                <i class="bi bi-ui-checks-grid text-muted" style="font-size: 3rem;"></i>
                                <h5 class="mt-3 text-dark fw-bold">Select a Hall</h5>
                                <p class="text-muted small">Choose a hall from the dropdown above to view or manage its seat inventory.</p>
                            </div>
                        </EmptyDataTemplate>
                        <LayoutTemplate>
                            <!-- Headers for the two columns -->
                            <div class="row px-4 pt-3 pb-2 border-bottom bg-light bg-opacity-50 text-muted extra-small fw-bold letter-spacing text-uppercase m-0">
                                <div class="col-6 d-flex">
                                    <div style="width: 50px;">ID</div>
                                    <div style="flex: 1;">Seat Info</div>
                                    <div style="width: 100px;">Status</div>
                                    <div style="width: 70px; text-align: right;">Actions</div>
                                </div>
                                <div class="col-6 d-flex">
                                    <div style="width: 50px;">ID</div>
                                    <div style="flex: 1;">Seat Info</div>
                                    <div style="width: 100px;">Status</div>
                                    <div style="width: 70px; text-align: right;">Actions</div>
                                </div>
                            </div>
                            
                            <!-- Items wrapper -->
                            <div class="seat-columns px-4 py-3">
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                            </div>

                            <!-- Pager -->
                            <div class="p-3 border-top d-flex justify-content-center bg-white rounded-bottom">
                                <asp:DataPager ID="DataPagerSeats" runat="server" PageSize="24">
                                    <Fields>
                                        <asp:NumericPagerField ButtonCount="10" 
                                            CurrentPageLabelCssClass="badge bg-primary px-2 py-1 mx-1 text-white text-decoration-none" 
                                            NumericButtonCssClass="text-decoration-none mx-1 text-primary" 
                                            NextPreviousButtonCssClass="text-decoration-none mx-1 text-primary" />
                                    </Fields>
                                </asp:DataPager>
                            </div>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <div class="seat-item d-flex align-items-center justify-content-between p-3 border-bottom" style="break-inside: avoid;">
                                <div class="d-flex align-items-center flex-grow-1">
                                    <div class="fw-bold text-muted extra-small" style="width: 50px;"><%# Eval("SeatID") %></div>
                                    <div style="flex: 1;">
                                        <div class="fw-bold text-dark"><%# Eval("SeatNumber") %></div>
                                        <div class="extra-small text-muted"><i class="bi bi-grip-horizontal"></i> Row <%# Eval("RowNumber") %></div>
                                    </div>
                                    <div style="width: 120px;">
                                        <span class='badge <%# Eval("SeatStatus").ToString() == "Available" ? "bg-success-subtle text-success" : Eval("SeatStatus").ToString() == "Reserved" ? "bg-warning-subtle text-warning" : "bg-danger-subtle text-danger" %> border py-1 px-2 fw-medium'>
                                            <%# Eval("SeatStatus") %>
                                        </span>
                                    </div>
                                </div>
                                <div class="d-flex gap-2" style="width: 100px; justify-content: flex-end;">
                                    <asp:LinkButton ID="lnkViewSeat" runat="server" CssClass="btn-action text-info" ToolTip="Quick View"
                                        OnClientClick='<%# GetSeatViewScript(Eval("SeatNumber"), Eval("RowNumber"), Eval("SeatStatus")) %>'>
                                        <i class="bi bi-eye-fill"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkEditSeat" runat="server" CssClass="btn btn-sm btn-outline-secondary p-1" ToolTip="Edit Seat"
                                        OnClientClick='<%# GetSeatEditScript(Eval("SeatID"), Eval("SeatNumber"), Eval("RowNumber"), Eval("SeatStatus"), Eval("HallID")) %>'>
                                        <i class="bi bi-pencil-square"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lnkDeleteSeat" runat="server" CssClass="btn btn-sm btn-outline-danger p-1" ToolTip="Delete Seat"
                                        OnClientClick='<%# GetSeatDeleteScript(Eval("SeatID"), Eval("SeatNumber")) %>'>
                                        <i class="bi bi-trash3"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:ListView>
                </div>
            </div>
        </div>
    </div>

    <!-- Theater Modals -->
    <div class="modal fade" id="theaterViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-success text-white border-0 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-info-circle me-2"></i> Branch Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <div class="avatar-circle bg-success-subtle text-success mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                        <i class="bi bi-building"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-1" id="vTheaterName"></h4>
                    <p class="text-muted small mb-4" id="vTheaterCity"></p>
                    <div class="bg-light p-3 rounded-3 text-start">
                        <label class="extra-small text-uppercase fw-bold text-muted d-block mb-1">Full Address</label>
                        <p class="small text-dark mb-0" id="vTheaterAddress"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfEditTheaterID" runat="server" />
    <div class="modal fade" id="theaterEditModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Edit Branch</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Branch Name</label>
                        <asp:TextBox ID="txtEditTheaterNameModal" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditTheaterName" runat="server" ControlToValidate="txtEditTheaterNameModal" 
                            ErrorMessage="Branch name is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterEdit"></asp:RequiredFieldValidator>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">City</label>
                        <asp:TextBox ID="txtEditTheaterCityModal" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditCity" runat="server" ControlToValidate="txtEditTheaterCityModal" 
                            ErrorMessage="City is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterEdit"></asp:RequiredFieldValidator>
                    </div>
                    <div>
                        <label class="form-label small fw-bold">Address</label>
                        <asp:TextBox ID="txtEditTheaterAddressModal" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditAddress" runat="server" ControlToValidate="txtEditTheaterAddressModal" 
                            ErrorMessage="Address is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGTheaterEdit"></asp:RequiredFieldValidator>
                    </div>
                    <asp:ValidationSummary ID="vsTheaterEdit" runat="server" ValidationGroup="VGTheaterEdit" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                </div>
                <div class="modal-footer border-0 p-3 pt-0">
                    <asp:Button ID="btnSaveTheaterEdit" runat="server" Text="Save Changes" CssClass="btn btn-primary w-100 py-2 fw-bold" OnClick="btnSaveTheaterEdit_Click" ValidationGroup="VGTheaterEdit" />
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfDeleteTheaterID" runat="server" />
    <div class="modal fade" id="theaterDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3rem;"><i class="bi bi-exclamation-triangle-fill"></i></div>
                    <h5 class="fw-bold">Remove Branch?</h5>
                    <p class="text-muted small">Deactivate <span id="delTheaterName" class="fw-bold text-dark"></span>? This may affect linked halls.</p>
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmTheaterDelete" runat="server" Text="Deactivate Branch" CssClass="btn btn-danger fw-bold" OnClick="btnConfirmTheaterDelete_Click" />
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Keep Branch</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hall Modals -->
    <asp:HiddenField ID="hfEditHallID" runat="server" />
    <div class="modal fade" id="hallEditModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Edit Hall</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Hall Name</label>
                        <asp:TextBox ID="txtEditHallNameModal" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditHallName" runat="server" ControlToValidate="txtEditHallNameModal" 
                            ErrorMessage="Hall name is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallEdit"></asp:RequiredFieldValidator>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Capacity</label>
                        <asp:TextBox ID="txtEditHallCapModal" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditCapacity" runat="server" ControlToValidate="txtEditHallCapModal" 
                            ErrorMessage="Capacity is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallEdit"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="rvEditCapacity" runat="server" ControlToValidate="txtEditHallCapModal" 
                            MinimumValue="1" MaximumValue="1000" Type="Integer"
                            ErrorMessage="Capacity must be between 1 and 1000" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGHallEdit"></asp:RangeValidator>
                    </div>
                    <div>
                        <label class="form-label small fw-bold">Theater</label>
                        <asp:DropDownList ID="DdlEditHallTheaterModal" runat="server" CssClass="form-select"
                            DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="TheaterName" DataValueField="TheaterID">
                        </asp:DropDownList>
                    </div>
                    <asp:ValidationSummary ID="vsHallEdit" runat="server" ValidationGroup="VGHallEdit" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                </div>
                <div class="modal-footer border-0 p-3 pt-0">
                    <asp:Button ID="btnSaveHallEdit" runat="server" Text="Save Changes" CssClass="btn btn-primary w-100 py-2 fw-bold" OnClick="btnSaveHallEdit_Click" ValidationGroup="VGHallEdit" />
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfDeleteHallID" runat="server" />
    <div class="modal fade" id="hallDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3rem;"><i class="bi bi-exclamation-circle-fill"></i></div>
                    <h5 class="fw-bold">Delete Hall?</h5>
                    <p class="text-muted small">Remove <span id="delHallName" class="fw-bold text-dark"></span>? All associated seats will also be affected.</p>
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmHallDelete" runat="server" Text="Delete Hall" CssClass="btn btn-danger fw-bold" OnClick="btnConfirmHallDelete_Click" />
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Seat Modals -->
    <asp:HiddenField ID="hfEditSeatID" runat="server" />
    <div class="modal fade" id="seatEditModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-warning text-dark border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Edit Seat</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Seat Number</label>
                            <asp:TextBox ID="txtEditSeatNumModal" runat="server" CssClass="form-control" placeholder="e.g. A1"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEditSeatNum" runat="server" ControlToValidate="txtEditSeatNumModal" 
                                ErrorMessage="Seat number is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGSeatEdit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold">Row</label>
                            <asp:TextBox ID="txtEditSeatRowModal" runat="server" CssClass="form-control" placeholder="e.g. A"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEditSeatRow" runat="server" ControlToValidate="txtEditSeatRowModal" 
                                ErrorMessage="Row is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGSeatEdit"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold">Status</label>
                            <asp:DropDownList ID="DdlEditSeatStatusModal" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Available" Value="Available"></asp:ListItem>
                                <asp:ListItem Text="Reserved" Value="Reserved"></asp:ListItem>
                                <asp:ListItem Text="Maintenance" Value="Maintenance"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold">Hall</label>
                            <asp:DropDownList ID="DdlEditSeatHallModal" runat="server" CssClass="form-select"
                                DataSourceID="SqlDataSourceHallDropdown" DataTextField="HallName" DataValueField="HallID">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <asp:ValidationSummary ID="vsSeatEdit" runat="server" ValidationGroup="VGSeatEdit" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                </div>
                <div class="modal-footer border-0 p-3 pt-0">
                    <asp:Button ID="btnSaveSeatEdit" runat="server" Text="Update Seat" CssClass="btn btn-warning text-dark w-100 py-2 fw-bold" OnClick="btnSaveSeatEdit_Click" ValidationGroup="VGSeatEdit" />
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfDeleteSeatID" runat="server" />
    <div class="modal fade" id="seatDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3rem;"><i class="bi bi-trash3-fill"></i></div>
                    <h5 class="fw-bold">Remove Seat?</h5>
                    <p class="text-muted small">Are you sure you want to delete seat <span id="delSeatNum" class="fw-bold text-dark"></span>?</p>
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmSeatDelete" runat="server" Text="Remove Seat" CssClass="btn btn-danger fw-bold" OnClick="btnConfirmSeatDelete_Click" />
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- VIEW modales (Theater, Hall, Seat) based on User Profile design -->
    <div class="modal fade" id="theaterViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 12px; overflow: hidden;">
                <div class="bg-primary text-white p-3 d-flex justify-content-between align-items-center">
                    <div class="fw-bold m-0 d-flex align-items-center gap-2"><i class="bi bi-building"></i> Branch Profile</div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" style="font-size: 0.8rem;"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <div class="avatar-circle mx-auto mb-3 bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 d-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem; border-radius: 50%;">
                        <span id="vTheaterLetter">B</span>
                    </div>
                    <h4 class="fw-bold mb-1 text-dark" id="vTheaterName">Branch Name</h4>
                    <div class="small fw-medium text-success mb-4">Active Branch</div>
                    
                    <div class="row text-start gx-4 gy-4 border-top pt-4">
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Location City</div>
                            <div class="text-dark fw-medium small" id="vTheaterCity">City Name</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Status</div>
                            <div class="text-dark fw-medium small">Operational</div>
                        </div>
                        <div class="col-12 border-top pt-3">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Complete Address</div>
                            <div class="text-dark fw-medium small" id="vTheaterAddress">Full Address</div>
                        </div>
                    </div>
                </div>
                <div class="p-4 pt-0 bg-white">
                    <button type="button" class="btn btn-secondary w-100 py-2 fw-medium" data-bs-dismiss="modal" style="background-color: #6c757d; border-color: #6c757d; border-radius: 6px;">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="hallViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 12px; overflow: hidden;">
                <div class="bg-primary text-white p-3 d-flex justify-content-between align-items-center">
                    <div class="fw-bold m-0 d-flex align-items-center gap-2"><i class="bi bi-grid-3x3-gap-fill"></i> Hall Profile</div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" style="font-size: 0.8rem;"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <div class="avatar-circle mx-auto mb-3 bg-info bg-opacity-10 text-info border border-info border-opacity-25 d-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem; border-radius: 50%;">
                        <span id="vHallLetter">H</span>
                    </div>
                    <h4 class="fw-bold mb-1 text-dark" id="vHallName">Hall Name</h4>
                    <div class="small fw-medium text-success mb-4">Active Hall</div>
                    
                    <div class="row text-start gx-4 gy-4 border-top pt-4">
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Total Capacity</div>
                            <div class="text-dark fw-medium small" id="vHallCapacity">0 Seats</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Main Branch</div>
                            <div class="text-dark fw-medium small" id="vHallTheater">Theater Name</div>
                        </div>
                    </div>
                </div>
                <div class="p-4 pt-0 bg-white">
                    <button type="button" class="btn btn-secondary w-100 py-2 fw-medium" data-bs-dismiss="modal" style="background-color: #6c757d; border-color: #6c757d; border-radius: 6px;">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="seatViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 12px; overflow: hidden;">
                <div class="bg-primary text-white p-3 d-flex justify-content-between align-items-center">
                    <div class="fw-bold m-0 d-flex align-items-center gap-2"><i class="bi bi-vinyl-fill"></i> Seat Profile</div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" style="font-size: 0.8rem;"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <div class="avatar-circle mx-auto mb-3 bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 d-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem; border-radius: 50%;">
                        <i class="bi bi-ui-checks-grid"></i>
                    </div>
                    <h4 class="fw-bold mb-1 text-dark" id="vSeatNumTitle">Seat Number</h4>
                    <div class="small fw-medium mb-4" id="vSeatStatusSubtitle">Seat Status</div>
                    
                    <div class="row text-start gx-4 gy-4 border-top pt-4">
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Seat Identifier</div>
                            <div class="text-dark fw-medium small" id="vSeatNumber">0</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Row Level</div>
                            <div class="text-dark fw-medium small" id="vSeatRow">A</div>
                        </div>
                    </div>
                </div>
                <div class="p-4 pt-0 bg-white">
                    <button type="button" class="btn btn-secondary w-100 py-2 fw-medium" data-bs-dismiss="modal" style="background-color: #6c757d; border-color: #6c757d; border-radius: 6px;">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function showTheaterView(name, city, addr) {
            try {
                document.getElementById('vTheaterLetter').innerText = name ? name.charAt(0).toUpperCase() : '?';
                document.getElementById('vTheaterName').innerText = name;
                document.getElementById('vTheaterCity').innerText = city;
                document.getElementById('vTheaterAddress').innerText = addr;
                new bootstrap.Modal(document.getElementById('theaterViewModal')).show();
            } catch (e) { console.error(e); }
        }

        function showHallView(name, capacity, theaterName) {
            try {
                document.getElementById('vHallLetter').innerText = name ? name.charAt(0).toUpperCase() : '?';
                document.getElementById('vHallName').innerText = name;
                document.getElementById('vHallCapacity').innerText = capacity + " Seats";
                document.getElementById('vHallTheater').innerText = theaterName;
                new bootstrap.Modal(document.getElementById('hallViewModal')).show();
            } catch (e) { console.error(e); }
        }

        function showSeatView(seatNum, rowNum, status) {
            try {
                document.getElementById('vSeatNumTitle').innerText = seatNum;
                document.getElementById('vSeatStatusSubtitle').innerText = status;
                document.getElementById('vSeatNumber').innerText = seatNum;
                document.getElementById('vSeatRow').innerText = "Row " + rowNum;
                new bootstrap.Modal(document.getElementById('seatViewModal')).show();
            } catch (e) { console.error(e); }
        }

        function openTheaterEdit(id, name, city, addr) {
            try {
                document.getElementById('<%= hfEditTheaterID.ClientID %>').value = id;
                document.getElementById('<%= txtEditTheaterNameModal.ClientID %>').value = name;
                document.getElementById('<%= txtEditTheaterCityModal.ClientID %>').value = city;
                document.getElementById('<%= txtEditTheaterAddressModal.ClientID %>').value = addr;
                new bootstrap.Modal(document.getElementById('theaterEditModal')).show();
            } catch (e) { console.error(e); }
        }

        function openTheaterDelete(id, name) {
            try {
                document.getElementById('<%= hfDeleteTheaterID.ClientID %>').value = id;
                document.getElementById('delTheaterName').innerText = name;
                new bootstrap.Modal(document.getElementById('theaterDeleteModal')).show();
            } catch (e) { console.error(e); }
        }

        function openHallEdit(id, name, cap, theaterId) {
            try {
                document.getElementById('<%= hfEditHallID.ClientID %>').value = id;
                document.getElementById('<%= txtEditHallNameModal.ClientID %>').value = name;
                document.getElementById('<%= txtEditHallCapModal.ClientID %>').value = cap;
                document.getElementById('<%= DdlEditHallTheaterModal.ClientID %>').value = theaterId;
                new bootstrap.Modal(document.getElementById('hallEditModal')).show();
            } catch (e) { console.error(e); }
        }

        function openHallDelete(id, name) {
            try {
                document.getElementById('<%= hfDeleteHallID.ClientID %>').value = id;
                document.getElementById('delHallName').innerText = name;
                new bootstrap.Modal(document.getElementById('hallDeleteModal')).show();
            } catch (e) { console.error(e); }
        }

        function openSeatEdit(id, num, row, status, hallId) {
            try {
                document.getElementById('<%= hfEditSeatID.ClientID %>').value = id;
                document.getElementById('<%= txtEditSeatNumModal.ClientID %>').value = num;
                document.getElementById('<%= txtEditSeatRowModal.ClientID %>').value = row;
                document.getElementById('<%= DdlEditSeatStatusModal.ClientID %>').value = status;
                document.getElementById('<%= DdlEditSeatHallModal.ClientID %>').value = hallId;
                new bootstrap.Modal(document.getElementById('seatEditModal')).show();
            } catch (e) { console.error(e); }
        }

        function openSeatDelete(id, num) {
            try {
                document.getElementById('<%= hfDeleteSeatID.ClientID %>').value = id;
                document.getElementById('delSeatNum').innerText = num;
                new bootstrap.Modal(document.getElementById('seatDeleteModal')).show();
            } catch (e) { console.error(e); }
        }

        // Auto-fade success/error messages after 4 seconds
        document.addEventListener('DOMContentLoaded', function () {
            var el = document.getElementById('<%= lblMessage.ClientID %>');
            if (el && el.offsetParent !== null) {
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease, max-height 0.6s ease';
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
                el.style.maxHeight = el.scrollHeight + 'px';
                el.style.overflow = 'hidden';
                setTimeout(function () {
                    el.style.opacity = '0';
                    el.style.transform = 'translateY(-10px)';
                    el.style.maxHeight = '0';
                    el.style.padding = '0';
                    el.style.marginTop = '0';
                    el.style.border = 'none';
                }, 4000);
            }
        });
    </script>

    <style>
        .extra-small { font-size: 0.7rem; }
        .text-nowrap { white-space: nowrap; }

        /* Two-Column ListView CSS */
        .seat-columns {
            column-count: 2;
            column-gap: 40px;
        }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceTheaters" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM Theater WHERE (:SearchTerm IS NULL OR LOWER(TheaterName) LIKE '%' || LOWER(:SearchTerm) || '%' OR LOWER(City) LIKE '%' || LOWER(:SearchTerm) || '%') ORDER BY TheaterID DESC" 
        CancelSelectOnNullParameter="false"
        DeleteCommand="DELETE FROM Theater WHERE TheaterID = :TheaterID" 
        InsertCommand="INSERT INTO Theater (TheaterID, TheaterName, City, Address) VALUES (:TheaterID, :TheaterName, :City, :Address)" 
        UpdateCommand="UPDATE Theater SET TheaterName = :TheaterName, City = :City, Address = :Address WHERE TheaterID = :TheaterID">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearchTheater" Name="SearchTerm" PropertyName="Text" Type="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <DeleteParameters><asp:Parameter Name="TheaterID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="TheaterID" Type="Decimal" />
            <asp:Parameter Name="TheaterName" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="TheaterName" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="TheaterID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceHalls" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT h.*, t.TheaterName FROM Hall h LEFT JOIN Theater t ON h.TheaterID = t.TheaterID WHERE h.TheaterID = :FilterTheaterID ORDER BY h.HallID DESC" 
        CancelSelectOnNullParameter="true"

        DeleteCommand="DELETE FROM Hall WHERE HallID = :HallID" 
        InsertCommand="INSERT INTO Hall (HallID, HallName, Capacity, TheaterID) VALUES (:HallID, :HallName, :Capacity, :TheaterID)" 
        UpdateCommand="UPDATE Hall SET HallName = :HallName, Capacity = :Capacity, TheaterID = :TheaterID WHERE HallID = :HallID">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlFilterTheater" Name="FilterTheaterID" PropertyName="SelectedValue" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <DeleteParameters><asp:Parameter Name="HallID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="HallID" Type="Decimal" />
            <asp:Parameter Name="HallName" Type="String" />
            <asp:Parameter Name="Capacity" Type="Decimal" />
            <asp:Parameter Name="TheaterID" Type="Decimal" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="HallName" Type="String" />
            <asp:Parameter Name="Capacity" Type="Decimal" />
            <asp:Parameter Name="TheaterID" Type="Decimal" />
            <asp:Parameter Name="HallID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceTheaterDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT TheaterID, TheaterName FROM Theater ORDER BY TheaterName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceSeats" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT s.SeatID, s.SeatNumber, s.RowNumber, s.SeatStatus, s.HallID, h.HallName FROM Seat s LEFT JOIN Hall h ON s.HallID = h.HallID WHERE s.HallID = :FilterHallID ORDER BY s.RowNumber, TO_NUMBER(REGEXP_REPLACE(s.SeatNumber, '[^0-9]', ''))" 
        CancelSelectOnNullParameter="true"
        DeleteCommand="DELETE FROM Seat WHERE SeatID = :SeatID" 
        InsertCommand="INSERT INTO Seat (SeatID, SeatNumber, RowNumber, SeatStatus, HallID) VALUES (:SeatID, :SeatNumber, :RowNumber, :SeatStatus, :HallID)" 
        UpdateCommand="UPDATE Seat SET SeatNumber = :SeatNumber, RowNumber = :RowNumber, SeatStatus = :SeatStatus, HallID = :HallID WHERE SeatID = :SeatID">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlFilterHall" Name="FilterHallID" PropertyName="SelectedValue" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <DeleteParameters><asp:Parameter Name="SeatID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="SeatID" Type="Decimal" />
            <asp:Parameter Name="SeatNumber" Type="String" />
            <asp:Parameter Name="RowNumber" Type="String" />
            <asp:Parameter Name="SeatStatus" Type="String" />
            <asp:Parameter Name="HallID" Type="Decimal" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="SeatNumber" Type="String" />
            <asp:Parameter Name="RowNumber" Type="String" />
            <asp:Parameter Name="SeatStatus" Type="String" />
            <asp:Parameter Name="HallID" Type="Decimal" />
            <asp:Parameter Name="SeatID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceHallDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT HallID, HallName FROM Hall WHERE TheaterID = :FilterTheaterID ORDER BY HallName"
        CancelSelectOnNullParameter="true">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlFilterTheater" Name="FilterTheaterID" PropertyName="SelectedValue" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceAllHalls" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT HallID, HallName FROM Hall ORDER BY HallName">
    </asp:SqlDataSource>

</asp:Content>

