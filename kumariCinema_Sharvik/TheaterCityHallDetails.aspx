<%@ Page Title="Infrastructure Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TheaterCityHallDetails.aspx.cs" Inherits="kumariCinema_Sharvik.TheaterCityHallDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Theater Infrastructure</h2>
            <p>Configure your cinema locations and individual screening halls.</p>
        </div>
    </div>

    <div class="row">
        <!-- THEATER MANAGEMENT -->
        <div class="col-xl-6">
            <div class="premium-card">
                <div class="card-header justify-content-between">
                    <span><i class="bi bi-geo-alt-fill text-success"></i> Cinemas</span>
                    <button type="button" class="btn btn-sm btn-outline-secondary p-1 px-2 extra-small" onclick="document.getElementById('theaterInsertRow').classList.toggle('d-none')">Add New</button>
                </div>
                <div id="theaterInsertRow" class="d-none border-bottom bg-light bg-opacity-50">
                    <div class="p-4">
                        <asp:DetailsView ID="DetailsViewTheater" runat="server" AutoGenerateRows="False" 
                            DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" DefaultMode="Insert" 
                            CssClass="modern-form-table" GridLines="None"
                            OnItemInserted="DetailsViewTheater_ItemInserted" OnItemInserting="DetailsViewTheater_ItemInserting">
                            <Fields>
                                <asp:TemplateField HeaderText="Cinema Name">
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="txtTheaterName" runat="server" Text='<%# Bind("TheaterName") %>' CssClass="form-control" placeholder="Theater Name"></asp:TextBox>
                                    </InsertItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Location">
                                    <InsertItemTemplate>
                                        <div class="row g-2">
                                            <div class="col-6"><asp:TextBox ID="txtCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control" placeholder="City"></asp:TextBox></div>
                                            <div class="col-6"><asp:TextBox ID="txtAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control" placeholder="Address"></asp:TextBox></div>
                                        </div>
                                    </InsertItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Save Theater" ControlStyle-CssClass="btn btn-success w-100 mt-3" />
                            </Fields>
                        </asp:DetailsView>
                        <asp:Label ID="lblTheaterMessage" runat="server" CssClass="text-success small fw-bold d-block mt-2"></asp:Label>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewTheaters" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="TheaterID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Theater Info">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("TheaterName") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-geo-alt"></i> <%# Eval("City") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("TheaterName") %>' CssClass="form-control form-control-sm mb-1"></asp:TextBox>
                                    <asp:TextBox ID="txtEditCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Address" HeaderText="Address" SortExpression="Address" />
                            
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Delete theater?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="d-flex gap-1 text-nowrap">
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success extra-small p-1 px-2">Save</asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-secondary extra-small p-1 px-2">Exit</asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- HALL MANAGEMENT -->
        <div class="col-xl-6">
            <div class="premium-card">
                <div class="card-header justify-content-between">
                    <span><i class="bi bi-grid-3x3-gap-fill text-primary"></i> Screening Halls</span>
                    <button type="button" class="btn btn-sm btn-outline-secondary p-1 px-2 extra-small" onclick="document.getElementById('hallInsertRow').classList.toggle('d-none')">Add New</button>
                </div>
                <div id="hallInsertRow" class="d-none border-bottom bg-light bg-opacity-50">
                    <div class="p-4">
                        <asp:DetailsView ID="DetailsViewHall" runat="server" AutoGenerateRows="False" 
                            DataKeyNames="HallID" DataSourceID="SqlDataSourceHalls" DefaultMode="Insert" 
                            CssClass="modern-form-table" GridLines="None"
                            OnItemInserted="DetailsViewHall_ItemInserted" OnItemInserting="DetailsViewHall_ItemInserting">
                            <Fields>
                                <asp:TemplateField HeaderText="Hall Details">
                                    <InsertItemTemplate>
                                        <div class="row g-2">
                                            <div class="col-8">
                                                <label class="mb-1">Hall Name</label>
                                                <asp:TextBox ID="txtHallName" runat="server" Text='<%# Bind("HallName") %>' CssClass="form-control" placeholder="e.g. IMAX Hall"></asp:TextBox>
                                            </div>
                                            <div class="col-4">
                                                <label class="mb-1">Seats</label>
                                                <asp:TextBox ID="txtCapacity" runat="server" Text='<%# Bind("Capacity") %>' TextMode="Number" CssClass="form-control" placeholder="200"></asp:TextBox>
                                            </div>
                                        </div>
                                    </InsertItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Parent Theater">
                                    <InsertItemTemplate>
                                        <label class="mb-1 small text-muted">Select Location</label>
                                        <asp:DropDownList ID="DdlInsertTheater" runat="server" CssClass="form-select"
                                            DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="TheaterName" DataValueField="TheaterID" 
                                            SelectedValue='<%# Bind("TheaterID") %>'>
                                        </asp:DropDownList>
                                    </InsertItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Finalize Hall" ControlStyle-CssClass="btn btn-primary w-100 mt-3" />
                            </Fields>
                        </asp:DetailsView>
                        <asp:Label ID="lblHallMessage" runat="server" CssClass="text-success small fw-bold d-block mt-2"></asp:Label>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewHalls" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="HallID" DataSourceID="SqlDataSourceHalls" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="HallID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Hall Info">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("HallName") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-people"></i> Capacity: <%# Eval("Capacity") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditHall" runat="server" Text='<%# Bind("HallName") %>' CssClass="form-control form-control-sm mb-1"></asp:TextBox>
                                    <asp:TextBox ID="txtEditCap" runat="server" Text='<%# Bind("Capacity") %>' TextMode="Number" CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Theater">
                                <ItemTemplate><span class="badge bg-light text-dark border"><%# Eval("TheaterName") %></span></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DdlEditTheater" runat="server" CssClass="form-select form-select-sm"
                                        DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="TheaterName" DataValueField="TheaterID" 
                                        SelectedValue='<%# Bind("TheaterID") %>'>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Delete hall?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="d-flex gap-1 text-nowrap">
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success extra-small p-1 px-2">Save</asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-secondary extra-small p-1 px-2">Exit</asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <style>
        .extra-small { font-size: 0.7rem; }
        .text-nowrap { white-space: nowrap; }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceTheaters" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM Theater ORDER BY TheaterID DESC" 
        DeleteCommand="DELETE FROM Theater WHERE TheaterID = :TheaterID" 
        InsertCommand="INSERT INTO Theater (TheaterID, TheaterName, City, Address) VALUES (:TheaterID, :TheaterName, :City, :Address)" 
        UpdateCommand="UPDATE Theater SET TheaterName = :TheaterName, City = :City, Address = :Address WHERE TheaterID = :TheaterID">
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
        SelectCommand="SELECT h.*, t.TheaterName FROM Hall h LEFT JOIN Theater t ON h.TheaterID = t.TheaterID ORDER BY h.HallID DESC" 
        DeleteCommand="DELETE FROM Hall WHERE HallID = :HallID" 
        InsertCommand="INSERT INTO Hall (HallID, HallName, Capacity, TheaterID) VALUES (:HallID, :HallName, :Capacity, :TheaterID)" 
        UpdateCommand="UPDATE Hall SET HallName = :HallName, Capacity = :Capacity, TheaterID = :TheaterID WHERE HallID = :HallID">
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
</asp:Content>
