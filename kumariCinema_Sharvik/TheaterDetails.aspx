<%@ Page Title="Theater Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TheaterDetails.aspx.cs" Inherits="kumariCinema_Sharvik.TheaterDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Theater Locations</h2>
            <p>Administer the physical cinema branches and their contact details.</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-xl-4 col-lg-5">
            <!-- Add New Theater -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-pin-map-fill text-success"></i> Register Location
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewTheater" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewTheater_ItemInserted" OnItemInserting="DetailsViewTheater_ItemInserting">
                        <Fields>
                            <asp:TemplateField HeaderText="Identity">
                                <InsertItemTemplate>
                                    <label class="mb-1">Branch Name</label>
                                    <asp:TextBox ID="txtTheaterName" runat="server" Text='<%# Bind("TheaterName") %>' CssClass="form-control" placeholder="e.g. Kumari Central"></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Geography">
                                <InsertItemTemplate>
                                    <div class="row g-2">
                                        <div class="col-12 mb-2">
                                            <label class="mb-1">City</label>
                                            <asp:TextBox ID="txtCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control" placeholder="Kathmandu"></asp:TextBox>
                                        </div>
                                        <div class="col-12">
                                            <label class="mb-1">Address</label>
                                            <asp:TextBox ID="txtAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control" placeholder="Street layout"></asp:TextBox>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Activate Branch" ControlStyle-CssClass="btn btn-success w-100 mt-4" />
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3 text-center">
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold small"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-lg-7">
            <!-- Theater List -->
            <div class="premium-card">
                <div class="card-header justify-content-between">
                    <span><i class="bi bi-building-check text-success"></i> Active Branches</span>
                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 extra-small">Operational</span>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewTheaters" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="TheaterID" DataSourceID="SqlDataSourceTheaters" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="10">
                        <Columns>
                            <asp:BoundField DataField="TheaterID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Location Info">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("TheaterName") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Full Address">
                                <ItemTemplate>
                                    <div class="small fw-semibold"><%# Eval("City") %></div>
                                    <div class="extra-small text-muted"><%# Eval("Address") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditCity" runat="server" Text='<%# Bind("City") %>' CssClass="form-control form-control-sm mb-1"></asp:TextBox>
                                    <asp:TextBox ID="txtEditAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Archive this theater?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="d-flex gap-1 text-nowrap">
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success extra-small p-1 px-2">Update</asp:LinkButton>
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
        .extra-small { font-size: 0.75rem; }
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
</asp:Content>
