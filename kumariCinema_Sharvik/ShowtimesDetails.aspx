<%@ Page Title="Showtime Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ShowtimesDetails.aspx.cs" Inherits="kumariCinema_Sharvik.ShowtimesDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Screening Schedule</h2>
            <p>Manage showtimes, pricing, and theater availability.</p>
        </div>
        <div class="page-header-actions">
             <div class="btn-group shadow-sm">
                 <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="btn btn-outline-secondary btn-sm active" OnClick="btnFilter_Click" CommandArgument="All">All</asp:LinkButton>
                 <asp:LinkButton ID="btnFilterToday" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnFilter_Click" CommandArgument="Today">Today</asp:LinkButton>
                 <asp:LinkButton ID="btnFilterThisWeek" runat="server" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnFilter_Click" CommandArgument="Week">This Week</asp:LinkButton>
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
                                            <label class="mb-1 form-label fw-semibold small text-muted">Show Date</label>
                                            <asp:TextBox ID="txtShowDate" runat="server" Text='<%# Bind("SHOWDATE") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvShowDate" runat="server" ControlToValidate="txtShowDate" 
                                                ErrorMessage="Date is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGShowInsert"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-5">
                                            <label class="mb-1 form-label fw-semibold small text-muted">Time</label>
                                            <asp:DropDownList ID="DdlShowTime" runat="server" CssClass="form-select" SelectedValue='<%# Bind("SHOWTIME") %>'>
                                                <asp:ListItem Text="-- Select --" Value="" />
                                                <asp:ListItem Text="Morning (10:00)" Value="Morning" />
                                                <asp:ListItem Text="Evening (18:00)" Value="Evening" />
                                                <asp:ListItem Text="Night (21:00)" Value="Night" />
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvShowTime" runat="server" ControlToValidate="DdlShowTime" InitialValue="" 
                                                ErrorMessage="Time is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGShowInsert"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Show price">
                                <InsertItemTemplate>
                                    <label class="mb-1 form-label fw-semibold small text-muted">Ticket Price (Rs.)</label>
                                    <asp:TextBox ID="txtPrice" runat="server" Text='<%# Bind("SHOWPRICE") %>' TextMode="Number" CssClass="form-control" step="0.01" placeholder="e.g. 450"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" 
                                        ErrorMessage="Price is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGShowInsert"></asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="">
                                <InsertItemTemplate>
                                    <div class="d-flex gap-4 mt-1">
                                        <div class="form-check d-flex align-items-center gap-2">
                                            <asp:CheckBox ID="chkInsertHoliday" runat="server" CssClass="form-check-input-custom" />
                                            <asp:Label ID="lblInsertHoliday" runat="server" AssociatedControlID="chkInsertHoliday" CssClass="form-check-label small text-muted">Holiday</asp:Label>
                                        </div>
                                        <div class="form-check d-flex align-items-center gap-2">
                                            <asp:CheckBox ID="chkInsertNew" runat="server" CssClass="form-check-input-custom" />
                                            <asp:Label ID="lblInsertNew" runat="server" AssociatedControlID="chkInsertNew" CssClass="form-check-label small text-muted">New Release</asp:Label>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Booking Detail">
                                <InsertItemTemplate>
                                    <div class="row g-2">
                                        <div class="col-6">
                                            <label class="mb-1 form-label fw-semibold small text-muted">Select Movie</label>
                                            <asp:DropDownList ID="DdlInsertMovie" runat="server" CssClass="form-select mb-2"
                                                DataSourceID="SqlDataSourceMovieDropdown" DataTextField="TITLE" DataValueField="MOVIEID" 
                                                SelectedValue='<%# Bind("MOVIEID") %>' AppendDataBoundItems="true">
                                                <asp:ListItem Text="-- Select --" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvInsertMovie" runat="server" ControlToValidate="DdlInsertMovie" InitialValue="" 
                                                ErrorMessage="Movie selection is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGShowInsert"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-6">
                                            <label class="mb-1 form-label fw-semibold small text-muted">Select Hall</label>
                                            <asp:DropDownList ID="DdlInsertHall" runat="server" CssClass="form-select"
                                                DataSourceID="SqlDataSourceHallDropdown" DataTextField="HALLNAME" DataValueField="HALLID" 
                                                SelectedValue='<%# Bind("HALLID") %>' AppendDataBoundItems="true">
                                                <asp:ListItem Text="-- Select --" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvInsertHall" runat="server" ControlToValidate="DdlInsertHall" InitialValue="" 
                                                ErrorMessage="Hall selection is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGShowInsert"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <asp:Button ID="btnInsertShow" runat="server" CommandName="Insert" Text="Add Show" CssClass="btn btn-info text-white w-100 py-2 fw-medium mt-3" ValidationGroup="VGShowInsert" />
                                    <asp:Button ID="btnCancelShow" runat="server" CommandName="Cancel" Text="Reset Form" CssClass="btn btn-outline-secondary w-100 mt-2 py-2 fw-bold" CausesValidation="false" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <asp:ValidationSummary ID="vsShowInsert" runat="server" ValidationGroup="VGShowInsert" CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" DisplayMode="BulletList" />
                    <asp:Label ID="lblMessage" runat="server" Visible="false" EnableViewState="false"></asp:Label>
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
                                    <div class="fw-bold text-main">
                                        <i class="bi bi-clock me-1 text-muted"></i><%# Eval("SHOWTIME") %>
                                        <span class="text-muted small fw-normal"> (<%# GetSpecificShowTime(Eval("SHOWTIME")) %>)</span>
                                    </div>
                                    <div class="extra-small text-muted"><i class="bi bi-calendar3 me-1"></i><%# Eval("SHOWDATE", "{0:MMM dd, yyyy}") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Feature & Venue">
                                <ItemTemplate>
                                    <div class="fw-semibold text-primary small d-flex align-items-center gap-1">
                                        <%# Eval("MovieTitle") %><%# GetBadgeHtml(Eval("ISNEWRELEASE"), "New") %>
                                    </div>
                                    <div class="extra-small text-muted d-flex align-items-center gap-2">
                                        <span><i class="bi bi-geo-alt"></i> <%# Eval("HallName") %></span><%# GetBadgeHtml(Eval("ISHOLIDAY"), "Holiday") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Pricing">
                                <ItemTemplate>
                                    <div class="fw-bold text-success font-monospace">Rs. <%# Eval("SHOWPRICE") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-2" style="justify-content: flex-end;">
                                        <button type="button" class="btn-action text-info" title="Quick View" style="background: none; border: none; padding: 0;"
                                            onclick='<%# GetViewModalScript(Eval("MovieTitle"), Eval("HallName"), Eval("SHOWDATE"), Eval("SHOWTIME"), Eval("SHOWPRICE"), Eval("ISHOLIDAY"), Eval("ISNEWRELEASE")) %>'>
                                            <i class="bi bi-eye-fill"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary p-1" title="Edit Schedule"
                                            onclick='<%# GetEditModalScript(Eval("SHOWID"), Eval("SHOWDATE"), Eval("SHOWTIME"), Eval("SHOWPRICE"), Eval("MOVIEID"), Eval("HALLID"), Eval("ISHOLIDAY"), Eval("ISNEWRELEASE")) %>'>
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger p-1" title="Cancel Screening"
                                            onclick='<%# GetDeleteModalScript(Eval("SHOWID"), Eval("MovieTitle"), Eval("SHOWTIME")) %>'>
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="p-3 border-top pagination-container" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <asp:HiddenField ID="hfEditShowID" runat="server" />
    <div class="modal fade" id="showEditModal" tabindex="-1" aria-labelledby="showEditModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-info text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="showEditModalLabel"><i class="bi bi-calendar-event me-2"></i> Update Screening</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-7">
                            <label class="form-label small fw-bold text-muted">Show Date</label>
                            <asp:TextBox ID="txtEditDateModal" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-5">
                            <label class="form-label small fw-bold text-muted">Show Time</label>
                            <asp:DropDownList ID="DdlEditTimeModal" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Morning (10:00)" Value="Morning" />
                                <asp:ListItem Text="Evening (18:00)" Value="Evening" />
                                <asp:ListItem Text="Night (21:00)" Value="Night" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Ticket Price (Rs.)</label>
                            <asp:TextBox ID="txtEditPriceModal" runat="server" TextMode="Number" step="0.01" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Movie</label>
                            <asp:DropDownList ID="DdlEditMovieModal" runat="server" CssClass="form-select"
                                DataSourceID="SqlDataSourceMovieDropdown" DataTextField="TITLE" DataValueField="MOVIEID">
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Hall</label>
                            <asp:DropDownList ID="DdlEditHallModal" runat="server" CssClass="form-select"
                                DataSourceID="SqlDataSourceHallDropdown" DataTextField="HALLNAME" DataValueField="HALLID">
                            </asp:DropDownList>
                        </div>
                        <div class="col-12 mt-3">
                            <label class="form-label small fw-bold text-muted mb-2">Special Flags</label>
                            <div class="d-flex gap-4 p-2 bg-light rounded border border-dashed">
                                <div class="form-check d-flex align-items-center gap-2 mb-0">
                                    <asp:CheckBox ID="chkEditHoliday" runat="server" CssClass="form-check-input-custom" />
                                    <asp:Label ID="lblEditHoliday" runat="server" AssociatedControlID="chkEditHoliday" CssClass="form-check-label mb-0 small fw-bold text-dark">Holiday</asp:Label>
                                </div>
                                <div class="form-check d-flex align-items-center gap-2 mb-0">
                                    <asp:CheckBox ID="chkEditNew" runat="server" CssClass="form-check-input-custom" />
                                    <asp:Label ID="lblEditNew" runat="server" AssociatedControlID="chkEditNew" CssClass="form-check-label mb-0 small fw-bold text-dark">New Release</asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0 gap-2">
                    <button type="button" class="btn btn-outline-secondary flex-grow-1 py-2" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Update Schedule" CssClass="btn btn-info text-white flex-grow-1 py-2 fw-bold" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <asp:HiddenField ID="hfDeleteShowID" runat="server" />
    <div class="modal fade" id="showDeleteModal" tabindex="-1" aria-labelledby="showDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3.5rem;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                    </div>
                    <h5 class="fw-bold text-dark">Cancel Screening?</h5>
                    <p class="text-muted small">Are you sure you want to remove <span id="deleteShowMovie" class="fw-bold text-dark"></span> at <span id="deleteShowTime" class="fw-bold text-dark"></span>? This will affect booking availability.</p>
                    
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Confirm Cancellation" CssClass="btn btn-danger fw-bold py-2" OnClick="btnConfirmDelete_Click" />
                        <button type="button" class="btn btn-light py-2" data-bs-dismiss="modal">Keep Screening</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- View Modal -->
    <div class="modal fade" id="showViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 12px; overflow: hidden;">
                <div class="bg-primary text-white p-3 d-flex justify-content-between align-items-center">
                    <div class="fw-bold m-0 d-flex align-items-center gap-2"><i class="bi bi-film"></i> Screening Details</div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" style="font-size: 0.8rem;"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <div class="avatar-circle mx-auto mb-3 bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 d-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2.5rem; border-radius: 50%;">
                        <i class="bi bi-ticket-perforated"></i>
                    </div>
                    <h4 class="fw-bold mb-1 text-dark" id="vShowMovie">Movie Title</h4>
                    <div class="small fw-medium text-success mb-4" id="vShowHall">Hall Name</div>
                    
                    <div class="row text-start gx-4 gy-4 border-top pt-4">
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Screening Date</div>
                            <div class="text-dark fw-medium small" id="vShowDate">Date</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Time Slot</div>
                            <div class="text-dark fw-medium small" id="vShowTime">Time</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Ticket Price</div>
                            <div class="text-dark fw-medium small font-monospace text-success fw-bold" id="vShowPrice">Rs. 0</div>
                        </div>
                        <div class="col-6">
                            <div class="text-muted mb-1" style="font-size: 0.75rem; letter-spacing: 0.5px; font-weight: 600; text-transform: uppercase;">Status</div>
                            <div id="vShowFlags"></div>
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
        function openViewModal(movie, hall, dateStr, timeStr, specTime, price, isHoliday, isNew) {
            try {
                document.getElementById('vShowMovie').innerText = movie;
                document.getElementById('vShowHall').innerText = hall;
                // Parse date for better display format
                var dateObj = new Date(dateStr);
                document.getElementById('vShowDate').innerText = isNaN(dateObj.getTime()) ? dateStr : dateObj.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
                document.getElementById('vShowTime').innerText = timeStr + " (" + specTime + ")";
                document.getElementById('vShowPrice').innerText = "Rs. " + parseFloat(price).toFixed(2);
                
                var flagsHtml = "";
                if (isHoliday === "Yes") flagsHtml += '<span class="badge bg-danger me-1">Holiday</span>';
                if (isNew === "Yes") flagsHtml += '<span class="badge bg-warning text-dark">New Release</span>';
                if (!flagsHtml) flagsHtml = '<span class="text-muted small">None</span>';
                document.getElementById('vShowFlags').innerHTML = flagsHtml;
                
                var modal = new bootstrap.Modal(document.getElementById('showViewModal'));
                modal.show();
            } catch (e) { console.error('Error:', e); }
        }

        function openEditModal(id, date, time, price, movieId, hallId, isHoliday, isNew) {
            try {
                document.getElementById('<%= hfEditShowID.ClientID %>').value = id;
                document.getElementById('<%= txtEditDateModal.ClientID %>').value = date;
                document.getElementById('<%= DdlEditTimeModal.ClientID %>').value = time;
                document.getElementById('<%= txtEditPriceModal.ClientID %>').value = price;
                document.getElementById('<%= DdlEditMovieModal.ClientID %>').value = movieId;
                document.getElementById('<%= DdlEditHallModal.ClientID %>').value = hallId;
                
                document.getElementById('<%= chkEditHoliday.ClientID %>').checked = (isHoliday === "Yes");
                document.getElementById('<%= chkEditNew.ClientID %>').checked = (isNew === "Yes");
                
                var modal = new bootstrap.Modal(document.getElementById('showEditModal'));
                modal.show();
            } catch (e) { console.error('Error:', e); }
        }

        function openDeleteModal(id, movie, time) {
            try {
                document.getElementById('<%= hfDeleteShowID.ClientID %>').value = id;
                document.getElementById('deleteShowMovie').innerText = movie;
                document.getElementById('deleteShowTime').innerText = time;
                
                var modal = new bootstrap.Modal(document.getElementById('showDeleteModal'));
                modal.show();
            } catch (e) { console.error('Error:', e); }
        }
    </script>

    <style>
        .font-monospace { font-family: 'JetBrains Mono', 'Courier New', monospace; }
        .bg-info-subtle { background-color: #ecfeff; }
        .extra-small { font-size: 0.7rem; }
        
        /* Custom checkbox alignment */
        .form-check-input-custom input {
            width: 1.1rem;
            height: 1.1rem;
            cursor: pointer;
            border-radius: 4px;
            border: 1.5px solid #cbd5e1;
        }
        .form-check-input-custom input:checked {
            background-color: #06b6d4;
            border-color: #06b6d4;
        }
        .form-check-label {
            cursor: pointer;
            user-select: none;
            font-weight: 500;
        }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceShows" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT s.SHOWID, s.SHOWDATE, s.&quot;SHOW&quot; AS SHOWTIME, s.SHOWPRICE, s.ISHOLIDAY, s.ISNEWRELEASE, s.MOVIEID, s.HALLID, m.TITLE as MovieTitle, h.HALLNAME as HallName FROM &quot;SHOW&quot; s LEFT JOIN MOVIE m ON s.MOVIEID = m.MOVIEID LEFT JOIN HALL h ON s.HALLID = h.HALLID ORDER BY s.SHOWDATE DESC" 
        DeleteCommand="BEGIN DELETE FROM TICKET WHERE TICKETID IN (SELECT TICKETID FROM BOOKING_TICKET WHERE BOOKINGID IN (SELECT BOOKINGID FROM BOOKING WHERE SHOWID = :SHOWID)); DELETE FROM BOOKING_TICKET WHERE BOOKINGID IN (SELECT BOOKINGID FROM BOOKING WHERE SHOWID = :SHOWID); DELETE FROM USER_BOOKING WHERE BOOKINGID IN (SELECT BOOKINGID FROM BOOKING WHERE SHOWID = :SHOWID); DELETE FROM BOOKING WHERE SHOWID = :SHOWID; DELETE FROM &quot;SHOW&quot; WHERE SHOWID = :SHOWID; END;" 
        InsertCommand="INSERT INTO &quot;SHOW&quot; (SHOWID, SHOWDATE, &quot;SHOW&quot;, SHOWPRICE, ISHOLIDAY, ISNEWRELEASE, MOVIEID, HALLID) VALUES (:SHOWID, TO_DATE(:SHOWDATE, 'YYYY-MM-DD'), :SHOWTIME, :SHOWPRICE, :ISHOLIDAY, :ISNEWRELEASE, :MOVIEID, :HALLID)" 
        UpdateCommand="UPDATE &quot;SHOW&quot; SET SHOWDATE = TO_DATE(:SHOWDATE, 'YYYY-MM-DD'), &quot;SHOW&quot; = :SHOWTIME, SHOWPRICE = :SHOWPRICE, ISHOLIDAY = :ISHOLIDAY, ISNEWRELEASE = :ISNEWRELEASE, MOVIEID = :MOVIEID, HALLID = :HALLID WHERE SHOWID = :SHOWID">
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
            <asp:Parameter Name="ISNEWRELEASE" Type="String" />
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
            <asp:Parameter Name="HALLID" Type="Decimal" />
            <asp:Parameter Name="SHOWID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceMovieDropdown" runat="server" ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" SelectCommand="SELECT MOVIEID, TITLE FROM MOVIE ORDER BY TITLE"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceHallDropdown" runat="server" ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" SelectCommand="SELECT h.HALLID, h.HALLNAME || ' (' || t.THEATERNAME || ')' AS HALLNAME FROM HALL h LEFT JOIN THEATER t ON h.THEATERID = t.THEATERID ORDER BY h.HALLNAME"></asp:SqlDataSource>
</asp:Content>
