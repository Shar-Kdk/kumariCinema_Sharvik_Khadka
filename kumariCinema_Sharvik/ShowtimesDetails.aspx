<%@ Page Title="Showtimes Scheduling" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ShowtimesDetails.aspx.cs" Inherits="kumariCinema_Sharvik.ShowtimesDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Screening Schedule</h2>
            <p>Manage showtimes, pricing, and theater availability.</p>
        </div>
        <div class="page-header-actions">
             <div class="btn-group">
                 <button type="button" class="btn btn-outline-secondary btn-sm">Today</button>
                 <button type="button" class="btn btn-outline-secondary btn-sm">This Week</button>
             </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-4 col-lg-5">
            <!-- Add New Show -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-calendar-event-fill text-info"></i> Schedule New Show
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewShow" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="SHOWID" DataSourceID="SqlDataSourceShows" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewShow_ItemInserted" OnItemInserting="DetailsViewShow_ItemInserting">
                        <Fields>
                            <asp:TemplateField HeaderText="Timing">
                                <InsertItemTemplate>
                                    <div class="row g-2">
                                        <div class="col-7">
                                            <label class="mb-1">Show Date</label>
                                            <asp:TextBox ID="txtShowDate" runat="server" Text='<%# Bind("SHOWDATE") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="col-5">
                                            <label class="mb-1">Time</label>
                                            <asp:TextBox ID="txtShowTime" runat="server" Text='<%# Bind("SHOWTIME") %>' TextMode="Time" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Tariff">
                                <InsertItemTemplate>
                                    <label class="mb-1">Ticket Price (Rs.)</label>
                                    <asp:TextBox ID="txtPrice" runat="server" Text='<%# Bind("SHOWPRICE") %>' TextMode="Number" CssClass="form-control" step="0.01" placeholder="450"></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Special Flags">
                                <InsertItemTemplate>
                                    <div class="d-flex gap-3 mt-1">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="chkHoliday">
                                            <label class="form-check-label small" for="chkHoliday">Holiday</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="chkNew">
                                            <label class="form-check-label small" for="chkNew">New Release</label>
                                        </div>
                                    </div>
                                    <!-- Hidden fields for actual binding if needed, or handled in code-behind -->
                                    <asp:HiddenField ID="hdnHoliday" runat="server" Value='<%# Bind("ISHOLIDAY") %>' />
                                    <asp:HiddenField ID="hdnNew" runat="server" Value='<%# Bind("ISNEWRELEASE") %>' />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Booking Detail">
                                <InsertItemTemplate>
                                    <label class="mb-1">Select Movie</label>
                                    <asp:DropDownList ID="DdlInsertMovie" runat="server" CssClass="form-select mb-2"
                                        DataSourceID="SqlDataSourceMovieDropdown" DataTextField="TITLE" DataValueField="MOVIEID" 
                                        SelectedValue='<%# Bind("MOVIEID") %>'></asp:DropDownList>
                                    
                                    <label class="mb-1">Select Hall</label>
                                    <asp:DropDownList ID="DdlInsertHall" runat="server" CssClass="form-select"
                                        DataSourceID="SqlDataSourceHallDropdown" DataTextField="HALLNAME" DataValueField="HALLID" 
                                        SelectedValue='<%# Bind("HALLID") %>'></asp:DropDownList>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Update Schedule" ControlStyle-CssClass="btn btn-info text-white w-100 mt-4" />
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3 text-center">
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-lg-7">
            <!-- Show List -->
            <div class="premium-card">
                <div class="card-header justify-content-between">
                    <span><i class="bi bi-clock-fill text-info"></i> Upcoming Screenings</span>
                    <span class="badge bg-info-subtle text-info border border-info-subtle extra-small">Live Sync</span>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewShows" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="SHOWID" DataSourceID="SqlDataSourceShows" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="10">
                        <Columns>
                            <asp:BoundField DataField="SHOWID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />

                            <asp:TemplateField HeaderText="Time & Date">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("SHOWTIME") %></div>
                                    <div class="extra-small text-muted"><%# Eval("SHOWDATE", "{0:MMM dd, yyyy}") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditDate" runat="server" Text='<%# Bind("SHOWDATE") %>' TextMode="Date" CssClass="form-control form-control-sm mb-1"></asp:TextBox>
                                    <asp:TextBox ID="txtEditTime" runat="server" Text='<%# Bind("SHOWTIME") %>' TextMode="Time" CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Feature & Venue">
                                <ItemTemplate>
                                    <div class="fw-semibold text-primary small"><%# Eval("MovieTitle") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-geo-alt"></i> <%# Eval("HallName") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DdlEditMovie" runat="server" CssClass="form-select form-select-sm mb-1"
                                        DataSourceID="SqlDataSourceMovieDropdown" DataTextField="TITLE" DataValueField="MOVIEID" 
                                        SelectedValue='<%# Bind("MOVIEID") %>'></asp:DropDownList>
                                    <asp:DropDownList ID="DdlEditHall" runat="server" CssClass="form-select form-select-sm"
                                        DataSourceID="SqlDataSourceHallDropdown" DataTextField="HALLNAME" DataValueField="HALLID" 
                                        SelectedValue='<%# Bind("HALLID") %>'></asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Pricing">
                                <ItemTemplate>
                                    <div class="fw-bold text-success font-monospace">Rs. <%# Eval("SHOWPRICE") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("SHOWPRICE") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1" style="min-width: 80px;">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Cancel screening?');"><i class="bi bi-x-square"></i></asp:LinkButton>
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
        .font-monospace { font-family: 'JetBrains Mono', 'Courier New', monospace; }
        .bg-info-subtle { background-color: #ecfeff; }
        .extra-small { font-size: 0.7rem; }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceShows" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT s.SHOWID, s.SHOWDATE, s.&quot;SHOW&quot; AS SHOWTIME, s.SHOWPRICE, s.ISHOLIDAY, s.ISNEWRELEASE, s.MOVIEID, s.HALLID, m.TITLE as MovieTitle, h.HALLNAME as HallName FROM &quot;SHOW&quot; s LEFT JOIN MOVIE m ON s.MOVIEID = m.MOVIEID LEFT JOIN HALL h ON s.HALLID = h.HALLID ORDER BY s.SHOWDATE DESC" 
        DeleteCommand="DELETE FROM &quot;SHOW&quot; WHERE SHOWID = :SHOWID" 
        InsertCommand="INSERT INTO &quot;SHOW&quot; (SHOWID, SHOWDATE, &quot;SHOW&quot;, SHOWPRICE, ISHOLIDAY, ISNEWRELEASE, MOVIEID, HALLID) VALUES (:SHOWID, TO_DATE(:SHOWDATE, 'YYYY-MM-DD'), :SHOWTIME, :SHOWPRICE, :ISHOLIDAY, :ISNEWRELEASE, :MOVIEID, :HALLID)" 
        UpdateCommand="UPDATE &quot;SHOW&quot; SET SHOWDATE = TO_DATE(:SHOWDATE, 'YYYY-MM-DD'), &quot;SHOW&quot; = :SHOWTIME, SHOWPRICE = :SHOWPRICE, ISHOLIDAY = :ISHOLIDAY, MOVIEID = :MOVIEID, HALLID = :HALLID WHERE SHOWID = :SHOWID">
        <DeleteParameters><asp:Parameter Name="SHOWID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="SHOWID" Type="Decimal" />
            <asp:Parameter Name="SHOWDATE" Type="String" />
            <asp:Parameter Name="SHOWTIME" Type="String" />
            <asp:Parameter Name="SHOWPRICE" Type="Decimal" />
            <asp:Parameter Name="ISHOLIDAY" Type="String" />
            <asp:Parameter Name="ISNEWRELEASE" Type="String" />
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
            <asp:Parameter Name="HALLID" Type="Decimal" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="SHOWDATE" Type="String" />
            <asp:Parameter Name="SHOWTIME" Type="String" />
            <asp:Parameter Name="SHOWPRICE" Type="Decimal" />
            <asp:Parameter Name="ISHOLIDAY" Type="String" />
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
            <asp:Parameter Name="HALLID" Type="Decimal" />
            <asp:Parameter Name="SHOWID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceMovieDropdown" runat="server" ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" SelectCommand="SELECT MOVIEID, TITLE FROM MOVIE ORDER BY TITLE"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceHallDropdown" runat="server" ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" SelectCommand="SELECT h.HALLID, h.HALLNAME || ' (' || t.THEATERNAME || ')' AS HALLNAME FROM HALL h LEFT JOIN THEATER t ON h.THEATERID = t.THEATERID ORDER BY h.HALLNAME"></asp:SqlDataSource>
</asp:Content>
