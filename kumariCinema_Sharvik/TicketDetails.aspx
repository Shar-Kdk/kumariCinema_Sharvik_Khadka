<%@ Page Title="Sales & Inventory" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TicketDetails.aspx.cs" Inherits="kumariCinema_Sharvik.TicketDetails" %>

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
                                    <div class="row g-2">
                                        <div class="col-12">
                                            <label class="mb-1">Sales Price</label>
                                            <asp:TextBox ID="txtPrice" runat="server" Text='<%# Bind("TICKETPRICE") %>' CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <InsertItemTemplate>
                                    <label class="mb-1">Payment Status</label>
                                    <asp:DropDownList ID="DdlStatus" runat="server" CssClass="form-select" SelectedValue='<%# Bind("TICKETSTATUS") %>'>
                                        <asp:ListItem Text="Paid" Value="Paid"></asp:ListItem>
                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                        <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                                    </asp:DropDownList>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Logistics">
                                <InsertItemTemplate>
                                    <label class="mb-1">Assigned Seat</label>
                                    <asp:DropDownList ID="DdlInsertSeat" runat="server" CssClass="form-select"
                                        DataSourceID="SqlDataSourceSeatDropdown" DataTextField="SEATNUMBER" DataValueField="SEATID" 
                                        SelectedValue='<%# Bind("SEATID") %>'></asp:DropDownList>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Generate Invoice" ControlStyle-CssClass="btn btn-warning text-dark w-100 mt-4" />
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3 text-center">
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8">
            <!-- Ticket List -->
            <div class="premium-card">
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

                            <asp:TemplateField HeaderText="Valuation">
                                <ItemTemplate>
                                    <div class="fw-bold text-main">Rs. <%# Eval("TICKETPRICE") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("TICKETPRICE") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Allocation">
                                <ItemTemplate>
                                    <div class="small"><i class="bi bi-chair text-muted ms-1"></i> Seat: <%# Eval("SEATNUMBER") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DdlEditSeat" runat="server" CssClass="form-select form-select-sm"
                                        DataSourceID="SqlDataSourceSeatDropdown" DataTextField="SEATNUMBER" DataValueField="SEATID" 
                                        SelectedValue='<%# Bind("SEATID") %>'></asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%# 
                                        Eval("TICKETSTATUS").ToString() == "Paid" ? "<span class='badge bg-success-subtle text-success border border-success-subtle'>Paid</span>" :
                                        Eval("TICKETSTATUS").ToString() == "Pending" ? "<span class='badge bg-warning-subtle text-warning border border-warning-subtle'>Pending</span>" :
                                        "<span class='badge bg-danger-subtle text-danger border border-danger-subtle'>"+Eval("TICKETSTATUS")+"</span>"
                                    %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditStatus" runat="server" Text='<%# Bind("TICKETSTATUS") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Void ticket?');"><i class="bi bi-trash3"></i></asp:LinkButton>
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
        .bg-success-subtle { background-color: #f0fdf4; }
        .bg-warning-subtle { background-color: #fffbeb; }
        .bg-danger-subtle { background-color: #fef2f2; }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT t.TICKETID, t.TICKETPRICE, t.TICKETSTATUS, t.SEATID, s.SEATNUMBER FROM TICKET t LEFT JOIN SEAT s ON t.SEATID = s.SEATID ORDER BY t.TICKETID DESC" 
        DeleteCommand="DELETE FROM TICKET WHERE TICKETID = :TICKETID" 
        InsertCommand="INSERT INTO TICKET (TICKETID, TICKETPRICE, TICKETSTATUS, SEATID) VALUES (:TICKETID, :TICKETPRICE, :TICKETSTATUS, :SEATID)" 
        UpdateCommand="UPDATE TICKET SET TICKETPRICE = :TICKETPRICE, TICKETSTATUS = :TICKETSTATUS, SEATID = :SEATID WHERE TICKETID = :TICKETID">
        <DeleteParameters><asp:Parameter Name="TICKETID" Type="Decimal" /></DeleteParameters>
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

    <asp:SqlDataSource ID="SqlDataSourceSeatDropdown" runat="server" ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" SelectCommand="SELECT SEATID, SEATNUMBER FROM SEAT ORDER BY SEATNUMBER"></asp:SqlDataSource>
</asp:Content>
