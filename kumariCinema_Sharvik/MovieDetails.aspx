<%@ Page Title="Movie Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="MovieDetails.aspx.cs" Inherits="kumariCinema_Sharvik.MovieDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>Movie Catalog</h2>
            <p>Manage film titles, genres, and release schedules.</p>
        </div>
        <div class="page-header-actions">
             <button type="button" class="btn btn-outline-secondary btn-sm"><i class="bi bi-filter"></i> Filter</button>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-4">
            <!-- Add New Movie -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-plus-circle-fill text-danger"></i> Add New Movie
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewMovie" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="MovieID" DataSourceID="SqlDataSourceMovies" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewMovie_ItemInserted" OnItemInserting="DetailsViewMovie_ItemInserting">
                        <Fields>
                            <asp:TemplateField HeaderText="Movie Title">
                                <InsertItemTemplate>
                                    <label class="mb-1">Title</label>
                                    <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>' CssClass="form-control" placeholder="e.g. Inception"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title required" Display="Dynamic" CssClass="text-danger small" ValidationGroup="VGMovieInsert"></asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Screening Info">
                                <InsertItemTemplate>
                                    <div class="row g-2">
                                        <div class="col-6">
                                            <label class="mb-1">Duration (min)</label>
                                            <asp:TextBox ID="txtDuration" runat="server" Text='<%# Bind("Duration") %>' TextMode="Number" CssClass="form-control" placeholder="120"></asp:TextBox>
                                        </div>
                                        <div class="col-6">
                                            <label class="mb-1">Language</label>
                                            <asp:TextBox ID="txtLanguage" runat="server" Text='<%# Bind("Language") %>' CssClass="form-control" placeholder="English"></asp:TextBox>
                                        </div>
                                    </div>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Category">
                                <InsertItemTemplate>
                                    <label class="mb-1">Genre</label>
                                    <asp:TextBox ID="txtGenre" runat="server" Text='<%# Bind("Genre") %>' CssClass="form-control" placeholder="Action, Drama"></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Launch Details">
                                <InsertItemTemplate>
                                    <label class="mb-1">Release Date</label>
                                    <asp:TextBox ID="txtReleaseDate" runat="server" Text='<%# Bind("ReleaseDate") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                                </InsertItemTemplate>
                            </asp:TemplateField>

                            <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Add to Catalog" ControlStyle-CssClass="btn btn-danger w-100 mt-4" ValidationGroup="VGMovieInsert" />
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3 text-center">
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8">
            <!-- Movie List -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-film text-danger"></i> Current Film Library
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewMovies" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="MovieID" DataSourceID="SqlDataSourceMovies" 
                        CssClass="premium-table" GridLines="None"
                        AllowPaging="True" AllowSorting="True" PageSize="10">
                        <Columns>
                            <asp:BoundField DataField="MovieID" HeaderText="ID" ReadOnly="true" ItemStyle-CssClass="fw-bold text-muted extra-small px-3" />
                            
                            <asp:TemplateField HeaderText="Movie Info">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-danger-subtle text-danger rounded d-flex align-items-center justify-content-center" style="width: 40px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-camera-reels-fill"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold text-main"><%# Eval("Title") %></div>
                                            <div class="extra-small text-muted"><%# Eval("Genre") %> • <%# Eval("Duration") %> mins</div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditTitle" runat="server" Text='<%# Bind("Title") %>' CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Language" HeaderText="Language" SortExpression="Language" />
                            
                            <asp:TemplateField HeaderText="Release" SortExpression="ReleaseDate">
                                <ItemTemplate>
                                    <div class="small fw-semibold"><%# Eval("ReleaseDate", "{0:MMM dd, yyyy}") %></div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditDate" runat="server" Text='<%# Bind("ReleaseDate") %>' TextMode="Date" CssClass="form-control form-control-sm"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-secondary p-1"><i class="bi bi-pencil-square"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-sm btn-outline-danger p-1" OnClientClick="return confirm('Delete movie?');"><i class="bi bi-trash3"></i></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success py-1 px-2" style="font-size: 0.75rem;">Save</asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-secondary py-1 px-2" style="font-size: 0.75rem;">Exit</asp:LinkButton>
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
        .bg-danger-subtle { background-color: #fef2f2; }
        .extra-small { font-size: 0.75rem; }
    </style>

    <asp:SqlDataSource ID="SqlDataSourceMovies" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM Movie ORDER BY MovieID DESC" 
        DeleteCommand="DELETE FROM Movie WHERE MovieID = :MovieID" 
        InsertCommand="INSERT INTO Movie (MovieID, Title, Duration, Language, Genre, ReleaseDate) VALUES (:MovieID, :Title, :Duration, :Language, :Genre, TO_DATE(:ReleaseDate, 'YYYY-MM-DD'))" 
        UpdateCommand="UPDATE Movie SET Title = :Title, Duration = :Duration, Language = :Language, Genre = :Genre, ReleaseDate = TO_DATE(:ReleaseDate, 'YYYY-MM-DD') WHERE MovieID = :MovieID">
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
