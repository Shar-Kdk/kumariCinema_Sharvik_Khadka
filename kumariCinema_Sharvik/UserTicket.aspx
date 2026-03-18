<%@ Page Title="My Tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserTicket.aspx.cs" Inherits="kumariCinema_Sharvik.UserTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>User Transaction History</h2>
            <p>Comprehensive report of ticket purchases and user activity over the last 6 months.</p>
        </div>
        <div class="page-header-actions">
             <button type="button" class="btn btn-primary btn-sm"><i class="bi bi-printer"></i> Print Report</button>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="premium-card mb-4 bg-primary bg-opacity-10 border-primary border-opacity-25">
        <div class="card-body py-4">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary mb-1"><i class="bi bi-person-search"></i> Selected User Profile</label>
                    <asp:DropDownList ID="DdlUsers" runat="server" CssClass="form-select border-primary border-opacity-50" AutoPostBack="True" 
                        DataSourceID="SqlDataSourceUsersDropdown" DataTextField="USERNAME" DataValueField="USERID">
                    </asp:DropDownList>
                </div>
                <div class="col-md-8">
                    <div class="d-flex gap-4 ms-md-4 mt-3 mt-md-0">
                         <div class="text-center">
                             <div class="text-muted extra-small text-uppercase fw-bold">Query Period</div>
                             <div class="fw-bold">Last 6 Months</div>
                         </div>
                         <div class="text-center">
                             <div class="text-muted extra-small text-uppercase fw-bold">Report Type</div>
                             <div class="fw-bold">Detailed Ledger</div>
                         </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- User Info Details -->
        <div class="col-xl-4 col-lg-5">
            <div class="premium-card h-100">
                <div class="card-header border-info border-3 border-opacity-50">
                    <i class="bi bi-card-list text-info"></i> Account Profile
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewUserInfo" runat="server" AutoGenerateRows="False" 
                        DataSourceID="SqlDataSourceUserInfo" CssClass="modern-form-table label-bold" FieldHeaderStyle-Width="100px">
                        <Fields>
                            <asp:BoundField DataField="USERNAME" HeaderText="Full Name" />
                            <asp:BoundField DataField="EMAIL" HeaderText="Email" />
                            <asp:BoundField DataField="PHONENUMBER" HeaderText="Contact" />
                            <asp:BoundField DataField="ADDRESS" HeaderText="Address" />
                            <asp:BoundField DataField="REGISTRATIONDATE" HeaderText="Member Since" DataFormatString="{0:MMMM dd, yyyy}" />
                        </Fields>
                        <EmptyDataTemplate>
                            <div class="text-center py-5">
                                <i class="bi bi-person-x display-4 text-muted opacity-25"></i>
                                <p class="text-muted mt-2">Select a user to view profile</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:DetailsView>
                </div>
            </div>
        </div>

        <!-- Ticket History -->
        <div class="col-xl-8 col-lg-7">
            <div class="premium-card h-100">
                <div class="card-header border-primary border-3 border-opacity-50">
                    <i class="bi bi-clock-history text-primary"></i> Purchase History
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewTickets" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="SqlDataSourceUserTickets" CssClass="premium-table" GridLines="None"
                        EmptyDataText="No recent transactions found.">
                        <Columns>
                            <asp:TemplateField HeaderText="Booking Date">
                                <ItemTemplate>
                                    <div class="fw-semibold"><%# Eval("BOOKINGDATE", "{0:MMM dd, yyyy}") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="ID & Movie">
                                <ItemTemplate>
                                    <div class="extra-small text-muted mb-1">TX-<%# Eval("TICKETID") %></div>
                                    <div class="fw-bold text-primary"><%# Eval("MOVIETITLE") %></div>
                                    <div class="extra-small text-muted"><%# Eval("SHOWTIME") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Commercials">
                                <ItemTemplate>
                                    <div class="fw-bold text-success">Rs. <%# Eval("TICKETPRICE") %></div>
                                    <div class="extra-small opacity-75"><%# Eval("TICKETSTATUS") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 rounded-pill px-3">Completed</span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <style>
        .label-bold tr td:first-child { font-weight: 700; color: var(--text-muted); font-size: 0.85rem; }
        .extra-small { font-size: 0.75rem; }
    </style>

    <!-- Data Sources -->
    <asp:SqlDataSource ID="SqlDataSourceUsersDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT USERID, USERNAME FROM USERS ORDER BY USERNAME">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceUserInfo" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT USERNAME, EMAIL, PHONENUMBER, ADDRESS, REGISTRATIONDATE FROM USERS WHERE USERID = :UserID">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlUsers" Name="UserID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceUserTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT b.BOOKINGDATE, t.TICKETID, t.TICKETPRICE, t.TICKETSTATUS, s.&quot;SHOW&quot; as SHOWTIME, m.TITLE as MOVIETITLE
                       FROM BOOKING_TICKET bt
                       JOIN BOOKING b ON bt.BOOKINGID = b.BOOKINGID
                       JOIN TICKET t ON bt.TICKETID = t.TICKETID
                       JOIN &quot;SHOW&quot; s ON b.SHOWID = s.SHOWID
                       JOIN MOVIE m ON s.MOVIEID = m.MOVIEID
                       WHERE bt.USERID = :UserID AND b.BOOKINGDATE >= ADD_MONTHS(SYSDATE, -6)
                       ORDER BY b.BOOKINGDATE DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlUsers" Name="UserID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
