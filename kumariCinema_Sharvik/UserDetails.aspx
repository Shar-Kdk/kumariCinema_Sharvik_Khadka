<%@ Page Title="User Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="UserDetails.aspx.cs" Inherits="kumariCinema_Sharvik.UserDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div class="page-header-info">
            <h2>User Management</h2>
            <p>Maintain your cinema's audience and staff database.</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-xl-4 col-lg-5">
            <!-- Add New User Form -->
            <div class="premium-card">
                <div class="card-header">
                    <i class="bi bi-person-plus-fill text-primary"></i> Register New User
                </div>
                <div class="card-body">
                    <asp:DetailsView ID="DetailsViewUser" runat="server" AutoGenerateRows="False" 
                        DataKeyNames="UserID" DataSourceID="SqlDataSourceUsers" DefaultMode="Insert" 
                        CssClass="modern-form-table" GridLines="None"
                        OnItemInserted="DetailsViewUser_ItemInserted" OnItemInserting="DetailsViewUser_ItemInserting">
                        <Fields>
                            <asp:TemplateField>
                                <InsertItemTemplate>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Full Name</label>
                                        <asp:TextBox ID="txtUsername" runat="server" Text='<%# Bind("Username") %>' CssClass="form-control" placeholder="Enter name"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" 
                                            ErrorMessage="The user's full name is required for registration." 
                                            Text="*" Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Password</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="txtPassword" runat="server" Text='<%# Bind("Password") %>' TextMode="Password" 
                                                CssClass="form-control border-end-0" placeholder="********"></asp:TextBox>
                                            <button class="btn btn-outline-secondary border-start-0" type="button" onclick="togglePasswordVisibility(this)">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                                            ErrorMessage="A password is required to secure this account." 
                                            Text="*" Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Email Address</label>
                                        <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' CssClass="form-control" placeholder="user@example.com"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                            ErrorMessage="An email address is required for communication and login." 
                                            Text="*" Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                                            ErrorMessage="The email address provided is not in a valid format (e.g., name@domain.com)." 
                                            Text="*" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
                                            Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RegularExpressionValidator>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Phone Number</label>
                                        <asp:TextBox ID="txtPhone" runat="server" Text='<%# Bind("PhoneNumber") %>' CssClass="form-control" placeholder="98XXXXXXXX"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" 
                                            ErrorMessage="A phone number is required for account security." 
                                            Text="*" Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" 
                                            ErrorMessage="Phone numbers must be 10 digits and start with 98 or 97 for local compatibility." 
                                            Text="*" ValidationExpression="^(98|97)\d{8}$" 
                                            Display="Dynamic" CssClass="text-danger fw-bold"
                                            ValidationGroup="VGUserInsert"></asp:RegularExpressionValidator>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Office/Home Address</label>
                                        <asp:TextBox ID="txtAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control" placeholder="City, Street, Ward"></asp:TextBox>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Registration Date</label>
                                        <asp:TextBox ID="txtRegDate" runat="server" Text='<%# Bind("RegistrationDate") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>

                                    <asp:Button ID="btnRegister" runat="server" CommandName="Insert" Text="Create Account" 
                                        CssClass="btn btn-primary w-100 py-2 fw-bold" ValidationGroup="VGUserInsert" 
                                        OnClientClick="var msg = document.querySelector('.bg-danger-subtle, .bg-success-subtle, #MainContent_lblMessage'); if(msg) msg.style.display='none';" />
                                    <asp:Button ID="btnCancelInsert" runat="server" CommandName="Cancel" Text="Reset Form" 
                                        CssClass="btn btn-outline-secondary w-100 mt-2 py-2 fw-bold" CausesValidation="false" />
                                </InsertItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                    <div class="mt-3">
                        <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center rounded-3 p-2 small fw-bold" Visible="false"></asp:Label>
                        <asp:ValidationSummary ID="vsUser" runat="server" ValidationGroup="VGUserInsert" 
                            CssClass="alert alert-danger extra-small border-0 shadow-none py-2 px-3 mt-2" 
                            HeaderText="Please correct the following:" />
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-lg-7">
            <!-- User List -->
            <div class="premium-card">
                <div class="card-header justify-content-between py-3">
                    <span class="d-flex align-items-center gap-2"><i class="bi bi-people-fill text-primary"></i> Registered Users</span>
                    <div class="search-box">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" 
                                placeholder="Search by name or email..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            <asp:LinkButton ID="btnClearSearch" runat="server" CssClass="btn btn-outline-secondary border-start-0" 
                                OnClick="btnClearSearch_Click" Visible="false" ToolTip="Clear Search">
                                <i class="bi bi-x-lg"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridViewUsers" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="UserID" DataSourceID="SqlDataSourceUsers" 
                        CssClass="premium-table mb-0" GridLines="None"
                        AllowPaging="True" AllowSorting="False" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="UserID" HeaderText="ID" ItemStyle-CssClass="fw-bold text-muted small px-3 text-center" HeaderStyle-CssClass="text-center" ItemStyle-Width="60px" ReadOnly="true" />
                            
                            <asp:TemplateField HeaderText="username">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center gap-3 py-1">
                                        <div class="avatar-circle bg-primary-subtle text-primary border border-primary-subtle">
                                            <%# Eval("Username").ToString().Substring(0,1).ToUpper() %>
                                        </div>
                                        <div>
                                            <div class="fw-bold text-dark"><%# Eval("Username") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="address and phone number">
                                <ItemTemplate>
                                    <div class="d-flex flex-column gap-1">
                                        <span class="text-dark small"><i class="bi bi-geo-alt text-muted me-2"></i><%# Eval("Address") %></span>
                                        <span class="text-dark small"><i class="bi bi-phone text-muted me-2"></i><%# Eval("PhoneNumber") %></span>
                                        <span class="text-muted extra-small"><i class="bi bi-envelope text-muted me-2"></i><%# Eval("Email") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="member since">
                                <ItemTemplate>
                                    <span class="badge bg-light text-secondary border fw-medium px-2 py-1">
                                        <%# Eval("RegistrationDate", "{0:MMM dd, yyyy}") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="action">
                                <ItemTemplate>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn-action text-info" title="Quick View" 
                                            onclick='<%# GetQuickViewScript(Eval("Username"), Eval("Email"), Eval("PhoneNumber"), Eval("Address"), Eval("RegistrationDate")) %>'>
                                            <i class="bi bi-eye-fill"></i>
                                        </button>
                                        <button type="button" class="btn-action text-primary" title="Edit Profile"
                                            onclick='<%# GetEditModalScript(Eval("UserID"), Eval("Username"), Eval("Email"), Eval("PhoneNumber"), Eval("Address"), Eval("RegistrationDate")) %>'>
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>
                                        <button type="button" class="btn-action text-danger" title="Delete Account" 
                                            onclick='<%# GetDeleteModalScript(Eval("UserID"), Eval("Username")) %>'>
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
                                <i class="bi bi-person-exclamation text-muted display-4"></i>
                                <p class="mt-3 text-muted">No users found matching your search criteria.</p>
                                <asp:LinkButton ID="btnResetResults" runat="server" CssClass="btn btn-sm btn-outline-primary" OnClick="btnClearSearch_Click">View All Users</asp:LinkButton>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Script specifically for this page -->
    <script type="text/javascript">
        function showUserPopup(name, email, phone, address, joined) {
            try {
                var nameEl = document.getElementById('modalUserName');
                var emailEl = document.getElementById('modalUserEmail');
                var phoneEl = document.getElementById('modalUserPhone');
                var addressEl = document.getElementById('modalUserAddress');
                var joinedEl = document.getElementById('modalUserJoined');

                if (nameEl) nameEl.innerText = name || '';
                if (emailEl) emailEl.innerText = email || '';
                if (phoneEl) phoneEl.innerText = phone || '';
                if (addressEl) addressEl.innerText = address || '';
                if (joinedEl) joinedEl.innerText = joined || '';
                
                var modalEl = document.getElementById('userViewModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (e) { console.error('Error opening view modal:', e); }
        }

        function openEditModal(id, name, email, phone, address, regDate) {
            try {
                var hf = document.getElementById('<%= hfEditUserID.ClientID %>');
                var u = document.getElementById('<%= txtEditUsernameModal.ClientID %>');
                var e = document.getElementById('<%= txtEditEmailModal.ClientID %>');
                var p = document.getElementById('<%= txtEditPhoneModal.ClientID %>');
                var a = document.getElementById('<%= txtEditAddressModal.ClientID %>');
                var r = document.getElementById('<%= txtEditRegDateModal.ClientID %>');

                if (hf) hf.value = id;
                if (u) u.value = name || '';
                if (e) e.value = email || '';
                if (p) p.value = phone || '';
                if (a) a.value = address || '';
                if (r) r.value = regDate || '';
                
                var modalEl = document.getElementById('userEditModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (ex) { console.error('Error opening edit modal:', ex); }
        }

        function openDeleteModal(id, name) {
            try {
                var hf = document.getElementById('<%= hfDeleteUserID.ClientID %>');
                var n = document.getElementById('deleteModalUserName');

                if (hf) hf.value = id;
                if (n) n.innerText = name || '';

                var modalEl = document.getElementById('userDeleteModal');
                if (modalEl) {
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modal.show();
                }
            } catch (e) { console.error('Error opening delete modal:', e); }
        }

        function togglePasswordVisibility(btn) {
            // Find the input element within the same input-group
            var inputGroup = btn.closest('.input-group');
            var input = inputGroup.querySelector('input');
            var icon = btn.querySelector('i');
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        }
    </script>

    <style>
        .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
        }
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
    
    <!-- View Modal -->
    <div class="modal fade" id="userViewModal" tabindex="-1" aria-labelledby="userViewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-primary text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="userViewModalLabel"><i class="bi bi-person-circle me-2"></i> User Profile</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle" style="width: 70px; height: 70px; font-size: 2rem; font-weight: 800;">
                            <span id="modalUserNameIcon">?</span>
                        </div>
                        <h4 class="mt-3 mb-0 fw-bold text-dark" id="modalUserName">User Name</h4>
                        <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill small mt-2">Active Member</span>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Email Registry</label>
                            <span class="d-block text-dark small" id="modalUserEmail"></span>
                        </div>
                        <div class="col-6">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Contact Line</label>
                            <span class="d-block text-dark small" id="modalUserPhone"></span>
                        </div>
                        <div class="col-12">
                            <hr class="my-2 opacity-5">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Current Address</label>
                            <span class="d-block text-dark small" id="modalUserAddress"></span>
                        </div>
                        <div class="col-12">
                            <label class="extra-small text-muted text-uppercase fw-bold d-block mb-1">Loyalty Since</label>
                            <span class="d-block text-dark small" id="modalUserJoined"></span>
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
    <asp:HiddenField ID="hfEditUserID" runat="server" />
    <div class="modal fade" id="userEditModal" tabindex="-1" aria-labelledby="userEditModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-dark text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="userEditModalLabel"><i class="bi bi-pencil-square me-2"></i> Update User Information</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Full Name</label>
                            <asp:TextBox ID="txtEditUsernameModal" runat="server" CssClass="form-control" placeholder="Update name"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Email Address</label>
                            <asp:TextBox ID="txtEditEmailModal" runat="server" CssClass="form-control" placeholder="Update email"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Phone Number</label>
                            <asp:TextBox ID="txtEditPhoneModal" runat="server" CssClass="form-control" placeholder="Update phone"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">Registration Date</label>
                            <asp:TextBox ID="txtEditRegDateModal" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold text-muted">Office/Home Address</label>
                            <asp:TextBox ID="txtEditAddressModal" runat="server" CssClass="form-control" placeholder="Update address"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 pt-0 gap-2">
                    <button type="button" class="btn btn-outline-secondary flex-grow-1 py-2" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Save Changes" CssClass="btn btn-primary flex-grow-1 py-2 fw-bold" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <asp:HiddenField ID="hfDeleteUserID" runat="server" />
    <div class="modal fade" id="userDeleteModal" tabindex="-1" aria-labelledby="userDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center">
                <div class="modal-body p-4">
                    <div class="text-danger mb-3" style="font-size: 3.5rem;">
                        <i class="bi bi-exclamation-octagon-fill"></i>
                    </div>
                    <h5 class="fw-bold text-dark">Confirm Deletion</h5>
                    <p class="text-muted small">Are you sure you want to permanently delete <span id="deleteModalUserName" class="fw-bold text-dark"></span>? This action cannot be undone.</p>
                    
                    <div class="d-grid gap-2 mt-4">
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete Account" CssClass="btn btn-danger fw-bold py-2" OnClick="btnConfirmDelete_Click" />
                        <button type="button" class="btn btn-light py-2" data-bs-dismiss="modal">Keep Account</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        // Update the icon letter when opening the modal
        document.getElementById('userViewModal').addEventListener('show.bs.modal', function () {
            var name = document.getElementById('modalUserName').innerText;
            document.getElementById('modalUserNameIcon').innerText = name.charAt(0).toUpperCase();
        });
    </script>

    <asp:SqlDataSource ID="SqlDataSourceUsers" runat="server" 
        ConnectionString="<%$ ConnectionStrings:KumariCinemaDB %>" 
        ProviderName="<%$ ConnectionStrings:KumariCinemaDB.ProviderName %>" 
        SelectCommand="SELECT * FROM Users WHERE (:SearchTerm IS NULL OR LOWER(Username) LIKE '%' || LOWER(:SearchTerm) || '%' OR LOWER(Email) LIKE '%' || LOWER(:SearchTerm) || '%') ORDER BY UserID DESC" 
        CancelSelectOnNullParameter="false"
        DeleteCommand="DELETE FROM Users WHERE UserID = :UserID" 
        InsertCommand="INSERT INTO Users (UserID, Username, Password, Email, PhoneNumber, Address, RegistrationDate) VALUES (:UserID, :Username, :Password, :Email, :PhoneNumber, :Address, TO_DATE(:RegistrationDate, 'YYYY-MM-DD'))" 
        UpdateCommand="UPDATE Users SET Username = :Username, Email = :Email, PhoneNumber = :PhoneNumber, Address = :Address, RegistrationDate = TO_DATE(:RegistrationDate, 'YYYY-MM-DD') WHERE UserID = :UserID">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" Name="SearchTerm" PropertyName="Text" Type="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <DeleteParameters><asp:Parameter Name="UserID" Type="Decimal" /></DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="UserID" Type="Decimal" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="PhoneNumber" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="RegistrationDate" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="PhoneNumber" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="RegistrationDate" Type="String" />
            <asp:Parameter Name="UserID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
