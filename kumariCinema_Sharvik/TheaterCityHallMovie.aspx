<%@ Page Title="Theater Schedule" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TheaterCityHallMovie.aspx.cs" Inherits="kumariCinema_Sharvik.TheaterCityHallMovie" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Theater Deployment</h2>
            <p>Monitor movie programming and screening schedules across your cinema network.</p>
        </div>
        <div class="page-header-actions">
             <button type="button" class="btn btn-primary btn-sm"><i class="bi bi-calendar3"></i> Full Calendar</button>
        </div>
    </div>

    <!-- Filter Dashboard -->
    <div class="premium-card mb-4 border-start border-warning border-5">
        <div class="card-body py-4">
            <div class="row align-items-center">
                <div class="col-md-5">
                    <label class="form-label fw-bold text-dark small mb-2"><i class="bi bi-building"></i> Select Cinema Location</label>
                    <asp:DropDownList ID="DdlTheaters" runat="server" CssClass="form-select border-warning border-opacity-25" AutoPostBack="True" 
                        DataSourceID="SqlDataSourceTheaterDropdown" DataTextField="THEATERNAME" DataValueField="THEATERID">
                    </asp:DropDownList>
                </div>
                <div class="col-md-7">
                    <div class="d-flex justify-content-md-end gap-3 mt-3 mt-md-0">
                        <div class="p-2 px-3 bg-light rounded-3 text-center border">
                            <div class="extra-small text-muted fw-bold uppercase">Active Programs</div>
                            <div class="fw-extrabold text-main">Sync Live</div>
                        </div>
                         <div class="p-2 px-3 bg-light rounded-3 text-center border">
                            <div class="extra-small text-muted fw-bold uppercase">Timezone</div>
                            <div class="fw-extrabold text-main">Asia/Kathmandu</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Schedule Table -->
    <div class="premium-card">
        <div class="card-header">
            <i class="bi bi-projector-fill text-warning"></i> Screen Programming Schedule
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="GridViewSchedule" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSourceSchedule" CssClass="premium-table" GridLines="None"
                EmptyDataText="No active programs scheduled for this cinema.">
                <Columns>
                    <asp:TemplateField HeaderText="Hall Asset">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-2">
                                <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                    <i class="bi bi-cpu"></i>
                                </div>
                                <span class="fw-bold"><%# Eval("HALLNAME") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Operating Film">
                        <ItemTemplate>
                            <div class="text-primary fw-semibold"><%# Eval("TITLE") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Programming">
                        <ItemTemplate>
                            <div class="fw-bold"><%# Eval("SHOWTIME") %></div>
                            <div class="extra-small text-muted"><%# Eval("SHOWDATE", "{0:MMM dd, yyyy}") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Pricing">
                        <ItemTemplate>
                            <span class="badge bg-light text-success border border-success-subtle px-3 py-2 font-monospace">Rs. <%# Eval("SHOWPRICE") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <style>
        .fw-extrabold { font-weight: 800; }
        .uppercase { text-transform: uppercase; }
        .font-monospace { font-family: 'JetBrains Mono', 'Courier New', monospace; }
        .extra-small { font-size: 0.75rem; }
    </style>

    <!-- Data Sources -->
    <asp:SqlDataSource ID="SqlDataSourceTheaterDropdown" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT THEATERID, THEATERNAME FROM THEATER ORDER BY THEATERNAME">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceSchedule" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT h.HALLNAME, m.TITLE, s.SHOWDATE, s.&quot;SHOW&quot; as SHOWTIME, s.SHOWPRICE 
                       FROM THEATER t
                       JOIN HALL h ON t.THEATERID = h.THEATERID
                       JOIN &quot;SHOW&quot; s ON h.HALLID = s.HALLID
                       JOIN MOVIE m ON s.MOVIEID = m.MOVIEID
                       WHERE t.THEATERID = :TheaterID
                       ORDER BY s.SHOWDATE DESC, s.&quot;SHOW&quot; ASC">
        <SelectParameters>
            <asp:ControlParameter ControlID="DdlTheaters" Name="TheaterID" PropertyName="SelectedValue" Type="Decimal" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
