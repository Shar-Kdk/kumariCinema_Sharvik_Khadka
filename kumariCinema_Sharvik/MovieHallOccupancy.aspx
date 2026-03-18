<%@ Page Title="Occupancy Insights" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MovieHallOccupancy.aspx.cs" Inherits="kumariCinema_Sharvik.MovieHallOccupancy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Occupancy Analytics</h2>
            <p>Analyze hall performance and ticket distribution for specific movie titles.</p>
        </div>
        <div class="page-header-actions">
             <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill"><i class="bi bi-fire"></i> Trending Data</span>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="premium-card mb-4 bg-white shadow-sm border-start border-danger border-5">
        <div class="card-body py-4">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <label class="form-label fw-bold text-danger extra-small uppercase mb-2"><i class="bi bi-film"></i> Select Target Movie</label>
                    <asp:DropDownList ID="DdlMovies" runat="server" CssClass="form-select border-danger border-opacity-25" AutoPostBack="True" 
                        DataSourceID="SqlDataSourceMovieDropdown" DataTextField="TITLE" DataValueField="MOVIEID">
                    </asp:DropDownList>
                </div>
                <div class="col-md-6 text-md-end mt-3 mt-md-0">
                    <div class="text-muted small">Comparative Analysis Mode</div>
                    <div class="fw-extrabold text-danger h5 mb-0">Top 3 Performance Tiers</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Data Grid -->
    <div class="row g-4">
        <div class="col-xl-8 col-lg-10">
            <div class="premium-card">
                <div class="card-header justify-content-between">
                    <span><i class="bi bi-bar-chart-fill text-danger"></i> High-Performing Hall Assets</span>
                    <i class="bi bi-info-circle text-muted" title="Based on total tickets sold for the selected title"></i>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewOccupancy" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="SqlDataSourceOccupancy" CssClass="premium-table" GridLines="None"
                        EmptyDataText="No ticket data available for this movie yet.">
                        <Columns>
                            <asp:TemplateField HeaderText="Rank">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center justify-content-center bg-danger bg-opacity-10 text-danger rounded-circle fw-bold" style="width: 35px; height: 35px;">
                                        <%# Container.DataItemIndex + 1 %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Asset Location">
                                <ItemTemplate>
                                    <div class="fw-bold text-main"><%# Eval("HALLNAME") %></div>
                                    <div class="extra-small text-muted"><i class="bi bi-building"></i> <%# Eval("THEATERNAME") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Traffic Volume">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="progress flex-grow-1" style="height: 10px; min-width: 120px;">
                                            <div class="progress-bar bg-danger shadow-sm" style='<%# "width: " + Eval("OCCUPANCY_PERCENT") + "%;" %>'></div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-danger font-monospace"><%# Eval("OCCUPANCY_PERCENT") %>% Occupancy</div>
                                            <div class="extra-small text-muted"><%# Eval("PAID_TICKETS") %> Paid / <%# Eval("CAPACITY") %> Capacity</div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <style>
        .fw-extrabold { font-weight: 800; }
        .uppercase { text-transform: uppercase; }
        .font-monospace { font-family: 'JetBrains Mono', 'Courier New', monospace; }
        .extra-small { font-size: 0.75rem; }
        .bg-danger-subtle { background-color: #fef2f2; }
    </style>

    <!-- Data Sources -->
    <asp:SqlDataSource ID="SqlDataSourceMovieDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT MOVIEID, TITLE FROM MOVIE ORDER BY TITLE">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceOccupancy" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM (
                         SELECT h.HALLNAME, t.THEATERNAME, 
                                COUNT(CASE WHEN ti.TICKETSTATUS = 'Confirmed' THEN 1 END) as PAID_TICKETS,
                                h.CAPACITY,
                                ROUND((COUNT(CASE WHEN ti.TICKETSTATUS = 'Confirmed' THEN 1 END) / h.CAPACITY) * 100, 1) as OCCUPANCY_PERCENT
                         FROM THEATER t
                         JOIN HALL h ON t.THEATERID = h.THEATERID
                         JOIN &quot;SHOW&quot; s ON h.HALLID = s.HALLID
                         JOIN BOOKING b ON s.SHOWID = b.SHOWID
                         JOIN BOOKING_TICKET bt ON b.BOOKINGID = bt.BOOKINGID
                         JOIN TICKET ti ON bt.TICKETID = ti.TICKETID
                         WHERE s.MOVIEID = :MovieID
                         GROUP BY h.HALLNAME, t.THEATERNAME, h.CAPACITY
                         ORDER BY OCCUPANCY_PERCENT DESC
                       ) WHERE ROWNUM <= 3">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlMovies" Name="MovieID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
