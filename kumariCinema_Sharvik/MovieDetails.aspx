<%@ Page Title="Movie Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="MovieDetails.aspx.cs" Inherits="kumariCinema_Sharvik.MovieDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Movie Catalog</h2>
            <p>Manage film titles, genres, and release schedules.</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-xl-4 col-lg-5">
            <!-- Add New Movie -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-plus-circle-fill text-danger"></i> Register New Film
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewMovie" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="MovieID" DataSourceID="SqlDataSourceMovies" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewMovie_ItemInserted" OnItemInserting="DetailsViewMovie_ItemInserting">
                        <Fields>
                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Movie Title</label>
                                        <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' CssClass="form-control" placeholder="e.g. Inception"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                                            ErrorMessage="Title is required" 
                                            Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Duration (min)</label>
                                            <asp:TextBox ID="txtDuration" runat="server" Text='<%# Bind("Duration") %>' TextMode="Number" CssClass="form-control" placeholder="120"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvDuration" runat="server" ControlToValidate="txtDuration" 
                                                ErrorMessage="Duration is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                            <asp:RangeValidator ID="rvDuration" runat="server" ControlToValidate="txtDuration" 
                                                MinimumValue="1" MaximumValue="1000" Type="Integer"
                                                ErrorMessage="Enter a valid duration (1-1000)" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RangeValidator>
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label fw-bold">Language</label>
                                            <asp:TextBox ID="txtLanguage" runat="server" Text='<%# Bind("Language") %>' CssClass="form-control" placeholder="English"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvLanguage" runat="server" ControlToValidate="txtLanguage" 
                                                ErrorMessage="Language is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Genre / Category</label>
                                        <asp:TextBox ID="txtGenre" runat="server" Text='<%# Bind("Genre") %>' CssClass="form-control" placeholder="Action, Drama"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvGenre" runat="server" ControlToValidate="txtGenre" 
                                            ErrorMessage="Genre is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Release Date</label>
                                        <asp:TextBox ID="txtReleaseDate" runat="server" Text='<%# Bind("ReleaseDate") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvRelease" runat="server" ControlToValidate="txtReleaseDate" 
                                            ErrorMessage="Release date is required" Text="*" Display="Dynamic" CssClass="text-danger fw-bold" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                    </div>

                                    <asp:Button ID="btnInsert" runat="server" CommandName="Insert" Text="Add to Catalog" 
                                        CssClass="btn btn-danger w-100 py-2 fw-bold" ValidationGroup="VGMovieInsert" />
                                    <asp:Button ID="btnCancelInsert" runat="server" CommandName="Cancel" Text="Reset Form" 
                                        CssClass="btn btn-outline-secondary w-100 mt-2 py-2 fw-bold" CausesValidation="false" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3">
                        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center rounded-3 p-2 small fw-bold" Visible="false" EnableViewState="false"></asp:Label>
                        <asp:ValidationSummary ID="vsMovie" runat="server" ValidationGroup="VGMovieInsert" 
                            CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" 
                            HeaderText="Please correct the following:" EnableViewState="false" />
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-lg-7">
            <div class="premium-card">
                <div class="card-header justify-content-between py-3">
                    <span class="d-flex align-items-center gap-2"><i class="bi bi-film text-danger"></i> Current Film Library</span>
                    <div class="search-box">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" 
                                placeholder="Search by title or genre..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            <asp:LinkButton ID="btnClearSearch" runat="server" CssClass="btn btn-outline-secondary border-start-0" 
                                OnClick="btnClearSearch_Click" Visible="false" ToolTip="Clear Search">
                                <i class="bi bi-x-lg"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewMovies" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="MovieID" DataSourceID="SqlDataSourceMovies" 
                        CssClass="premium-table mb-0" GridLines="None"
                        AllowPaging="True" AllowSorting="False" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="MovieID" HeaderText="ID" ReadOnly="true" 
                                ItemStyle-CssClass="fw-bold text-muted extra-small px-3" ItemStyle-Width="60px" />
                            
                            <asp:TemplateField HeaderText="TITLE">
                                <ItemTemplate>
                                    <div class="fw-bold text-dark"><%# Eval("Title") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="DURATION">
                                <ItemTemplate>
                                    <span class="text-muted small">
                                        <i class="bi bi-clock me-1"></i><%# Eval("Duration") %> min
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="GENRE">
                                <ItemTemplate>
                                    <span class="badge bg-danger-subtle text-danger fw-medium px-2 py-1">
                                        <%# Eval("Genre") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ACTION">
                                <ItemTemplate>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn-action text-info" title="View Details" 
                                            onclick='<%# GetQuickViewScript(Eval("Title"), Eval("Genre"), Eval("Duration"), Eval("Language"), Eval("ReleaseDate")) %>'>
                                            <i class="bi bi-eye-fill"></i>
                                        </button>
                                        <button type="button" class="btn-action text-primary" title="Edit Movie"
                                            onclick='<%# GetEditModalScript(Eval("MovieID"), Eval("Title"), Eval("Genre"), Eval("Duration"), Eval("Language"), Eval("ReleaseDate")) %>'>
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>
                                        <button type="button" class="btn-action text-danger" title="Delete Movie" 
                                            onclick='<%# GetDeleteModalScript(Eval("MovieID"), Eval("Title")) %>'>
                                            <i class="bi bi-trash3-fill"></i>
                                        </button>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="p-3 border-top pagination-container" />
                        <HeaderStyle CssClass="table-header" />
                        <EmptyDataTemplate>
                            <div class="text-center p-5">
                                <i class="bi bi-film text-muted display-4"></i>
                                <p class="mt-3 text-muted">No movies found.</p>
                                <asp:LinkButton ID="btnResetResults" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClick="btnClearSearch_Click">Show all</asp:LinkButton>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Script specifically for this page -->
    <script type="text/javascript">
        function showMoviePopup(title, genre, duration, lang, release) {
            try {
                var titleEl = document.getElementById('modalMovieTitle');
                var genreEl = document.getElementById('modalMovieGenre');
                var durationEl = document.getElementById('modalMovieDuration');
                var langEl = document.getElementById('modalMovieLang');
                var releaseEl = document.getElementById('modalMovieRelease');

                if (titleEl) titleEl.innerText = title || '';
                if (genreEl) genreEl.innerText = genre || '';
                if (durationEl) durationEl.innerText = (duration || '0') + ' mins';
                if (langEl) langEl.innerText = lang || '';
                if (releaseEl) releaseEl.innerText = release || '';
                
                var modalEl = document.getElementById('movieViewModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (e) { console.error('Error opening view modal:', e); }
        }

        function openEditModal(id, title, genre, duration, lang, release) {
            try {
                var hf = document.getElementById('<%= hfEditMovieID.ClientID %>');
                var t = document.getElementById('<%= txtEditTitleModal.ClientID %>');
                var g = document.getElementById('<%= txtEditGenreModal.ClientID %>');
                var d = document.getElementById('<%= txtEditDurationModal.ClientID %>');
                var l = document.getElementById('<%= txtEditLangModal.ClientID %>');
                var r = document.getElementById('<%= txtEditReleaseModal.ClientID %>');

                if (hf) hf.value = id;
                if (t) t.value = title || '';
                if (g) g.value = genre || '';
                if (d) d.value = duration || '';
                if (l) l.value = lang || '';
                if (r) r.value = release || '';
                
                var modalEl = document.getElementById('movieEditModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (ex) { console.error('Error opening edit modal:', ex); }
        }

        function openDeleteModal(id, title) {
            try {
                var hf = document.getElementById('<%= hfDeleteMovieID.ClientID %>');
                var t = document.getElementById('deleteModalMovieTitle');

                if (hf) hf.value = id;
                if (t) t.innerText = title || '';

                var modalEl = document.getElementById('movieDeleteModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (e) { console.error('Error opening delete modal:', e); }
        }
    </script>

    <!-- View Modal -->
    <div class="modal fade" id="movieViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-danger text-white border-0 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-info-circle me-2"></i> Movie Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-circle" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="bi bi-film"></i>
                        </div>
                        <h4 class="mt-3 mb-0 fw-bold text-dark" id="modalMovieTitle">Movie Title</h4>
                        <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-pill small mt-2" id="modalMovieGenre">Action</span>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Duration</label>
                            <span class="d-block text-dark small" id="modalMovieDuration"></span>
                        </div>
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Language</label>
                            <span class="d-block text-dark small" id="modalMovieLang"></span>
                        </div>
                        <div class="col-12">
                            <hr class="my-2 opacity-5">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Release Date</label>
                            <span class="d-block text-dark small" id="modalMovieRelease"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0">
                    <button type="button" class="btn btn-secondary w-100" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <asp:HiddenField ID="hfEditMovieID" runat="server" />
    <div class="modal fade" id="movieEditModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-dark text-white border-0 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i> Update Movie Info</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Title</label>
                            <asp:TextBox ID="txtEditTitleModal" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Genre</label>
                            <asp:TextBox ID="txtEditGenreModal" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Duration (min)</label>
                            <asp:TextBox ID="txtEditDurationModal" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Language</label>
                            <asp:TextBox ID="txtEditLangModal" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Release Date</label>
                            <asp:TextBox ID="txtEditReleaseModal" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0 gap-2">
                    <button type="button" class="btn btn-outline-secondary flex-grow-1 py-2" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Save Changes" CssClass="btn btn-danger flex-grow-1 py-2 fw-bold" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <asp:HiddenField ID="hfDeleteMovieID" runat="server" />
    <div class="modal fade" id="movieDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3.5rem;">
                        <i class="bi bi-exclamation-octagon-fill"></i>
                    </div>
                    <h5 class="fw-bold text-dark">Confirm Deletion</h5>
                    <p class="text-muted small">Are you sure you want to delete <span id="deleteModalMovieTitle" class="fw-bold text-dark"></span>?</p>
                    
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete Movie" CssClass="btn btn-danger fw-bold py-2" OnClick="btnConfirmDelete_Click" />
                        <button type="button" class="btn btn-light py-2" data-bs-dismiss="modal">Keep It</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .bg-danger-subtle { background-color: #fef2f2; }
        .extra-small { font-size: 0.75rem; }
        .btn-action {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: #fff;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceMovies" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM Movie WHERE (:SearchTerm IS NULL OR LOWER(Title) LIKE '%' || LOWER(:SearchTerm) || '%' OR LOWER(Genre) LIKE '%' || LOWER(:SearchTerm) || '%') ORDER BY MovieID DESC" 
        CancelSelectOnNullParameter="false"
        DeleteCommand="DELETE FROM Movie WHERE MovieID = :MovieID" 
        InsertCommand="INSERT INTO Movie (MovieID, Title, Duration, Language, Genre, ReleaseDate) VALUES (:MovieID, :Title, :Duration, :Language, :Genre, TO_DATE(:ReleaseDate, 'YYYY-MM-DD'))" 
        UpdateCommand="UPDATE Movie SET Title = :Title, Duration = :Duration, Language = :Language, Genre = :Genre, ReleaseDate = TO_DATE(:ReleaseDate, 'YYYY-MM-DD') WHERE MovieID = :MovieID">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" Name="SearchTerm" PropertyName="Text" Type="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <DeleteParameters><asp:Parameter Name="MovieID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="MovieID" Type="Decimal" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Duration" Type="Decimal" />
            <asp:Parameter Name="Language" Type="String" />
            <asp:Parameter Name="Genre" Type="String" />
            <asp:Parameter Name="ReleaseDate" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="Duration" Type="Decimal" />
            <asp:Parameter Name="Language" Type="String" />
            <asp:Parameter Name="Genre" Type="String" />
            <asp:Parameter Name="ReleaseDate" Type="String" />
            <asp:Parameter Name="MovieID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
