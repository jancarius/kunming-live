<%@ Page Title="" Language="C#" MasterPageFile="admin.master" AutoEventWireup="true" CodeFile="manageprofile.aspx.cs" Inherits="profile" %>

<%@ MasterType VirtualPath="~/admin.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!-- Cropper -->
    <link rel="stylesheet" href="https://www.kunminglive.com/dist/css/cropper.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    User Profile
                    <small>Settings
                    </small>
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="https://www.kunminglive.com/"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">User profile</li>
        </ol>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xl-3 col-md-5">
                <!-- Profile Data -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">User Info
                        </h3>
                        <div class="box-tools pull-right">
                            <button id="btnSaveProfile" type="button" class="btn btn-success btn-xs btn-flat hidden">Save</button>
                            <button id="btnCancelProfile" type="button" class="btn btn-warning btn-xs btn-flat hidden">Cancel</button>
                        </div>
                    </div>
                    <div class="box-body box-profile">
                        <asp:Image ID="imgProfileUpdate" ImageUrl="dist/img/male_placeholder.png" CssClass="profile-user-img img-responsive img-circle" AlternateText="User Profile Picture" runat="server" ClientIDMode="Static" />
                        <label id="uploadImage" class="file-upload btn btn-primary hidden" style="margin: 10px auto 0 auto; display: block;">
                            Change Profile Image
                            <input id="fileProfileImage" type="file" accept="image/*" class="form-control hidden" />
                        </label>
                        <h3 class="profile-username text-center">
                            <strong id="btnEditProfile" class="fa fa-pencil-square-o" aria-hidden="true">Edit Profile</strong>
                        </h3>
                        <div id="lblManageProfileError" class="control-label text-yellow text-bold text-center collapse"><i class="fa fa-times-circle-o"></i>&nbsp;<span id="lblManageProfileErrorText"></span></div>
                        <ul class="list-group list-group-unbordered">
                            <li class="list-group-item">
                                <div class="col-xs-4 no-padding"><strong>Display Name</strong></div>
                                <div class="col-xs-8 no-padding">
                                    <div id="lblFullName" runat="server"></div>
                                    <input id="txtFullName" type="text" class="form-control hidden" data-toggle="tooltip" data-original-title="Can Only Be Changed Once!" data-trigger="focus" />
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="col-xs-4 no-padding"><strong>Email</strong></div>
                                <div class="col-xs-8 no-padding">
                                    <div id="lblEmail" runat="server"></div>
                                    <input id="txtEmail" type="email" class="form-control hidden" data-toggle="tooltip" data-original-title="Email Must Be Confirmed" data-trigger="focus" />
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="col-xs-4 no-padding"><strong>Location</strong></div>
                                <div class="col-xs-8 no-padding">
                                    <div id="lblLocation" runat="server"></div>
                                    <input id="txtLocation" type="text" class="form-control hidden" />
                                </div>

                            </li>
                            <li class="list-group-item">
                                <div class="col-xs-4 no-padding"><strong>About Me</strong></div>
                                <div class="col-xs-8 no-padding">
                                    <div id="lblDescription" runat="server"></div>
                                    <textarea id="txtDescription" rows="4" class="form-control hidden"></textarea>
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="col-xs-4 no-padding"><strong>Measurements</strong></div>
                                <div class="col-xs-8 no-padding">
                                    <div id="lblMeasurement" runat="server"></div>
                                    <select id="ddlMeasurement" class="form-control hidden">
                                        <option value="0" <%: Master.currentUser.MeasurementEnum == global::User.Measurement.Metric ? "selected" : "" %>>Metric</option>
                                        <option value="1" <%: Master.currentUser.MeasurementEnum == global::User.Measurement.Imperial ? "selected" : "" %>>Imperial</option>
                                    </select>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>


            </div>

            <!-- Edit Box States -->
            <div class="col-xl-5 col-md-7">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Collapsed/Closed Panels
                        </h3>
                    </div>
                    <div class="box-body no-padding">
                        <table class="table">
                            <tbody id="tblEditBoxStates" runat="server">
                                <tr id="tblEditBoxStatesNone" runat="server">
                                    <td colspan="4">
                                        <h4 class="text-center text-italic">None <a href="introduction#editBoxStates">(How's it Work?)</a></h4>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Edit Classified Posts -->
                <div id="boxProfileEditClassifieds" class="box box-success" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">Your Classified Ads</h3>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body no-padding">
                        <table class="table">
                            <tbody id="tblEditClassifiedPosts" runat="server">
                                <tr id="tblEditClassifiedPostsNone" runat="server">
                                    <td colspan="3">
                                        <h4 class="text-center text-italic">None <a href="https://www.kunminglive.com/classifieds/all/add">(Post a Classified Ad)</a></h4>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="box-footer with-border">
                        <a href="https://www.kunminglive.com/classifieds/all/add" class="btn btn-sm btn-flat btn-success pull-right">Post a Classified Ad</a>
                    </div>
                </div>

                <!-- Edit Events -->
                <div id="boxProfileEditEvents" class="box box-success" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">Your Events</h3>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body no-padding">
                        <table class="table">
                            <tbody id="tblEditEvents" runat="server">
                                <tr id="tblEditEventsNone" runat="server">
                                    <td colspan="2">
                                        <h4 class="text-center text-italic">None <a href="https://www.kunminglive.com/events-calendar/add">(Submit an Event)</a></h4>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="box-footer with-border">
                        <a href="https://www.kunminglive.com/events-calendar/add" class="btn btn-sm btn-flat btn-success pull-right">Submit an Event</a>
                    </div>
                </div>

                <!-- Edit Businesses -->
                <div id="boxProfileEditBusinesses" class="box box-success" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">Your Businesses</h3>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body no-padding">
                        <table class="table">
                            <tbody id="tblEditBusinesses" runat="server">
                                <tr id="tblEditBusinessesNone" runat="server">
                                    <td colspan="2">
                                        <h4 class="text-center text-italic">None <a href="https://www.kunminglive.com/things-to-do/all/add">(Submit a Business)</a></h4>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="box-footer with-border">
                        <a href="https://www.kunminglive.com/things-to-do/all/add" class="btn btn-sm btn-flat btn-success pull-right">Submit a Business</a>
                    </div>
                </div>
            </div>

        </div>
        <!-- Profile Image Modal -->
        <div class="modal fade in" id="modalProfileImage">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span></button>
                        <h4 class="modal-title">Crop Profile Image</h4>
                    </div>
                    <div class="modal-body">
                        <img id="imgCropper" src="" style="max-width: 100%;" />
                        <div class="box-body croppie-container"></div>
                    </div>
                    <div class="modal-footer">
                        <button id="btnCancelCrop" type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                        <button id="btnSaveCrop" type="button" class="btn btn-primary">Save Changes</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <!-- Cropper -->
    <script src="https://www.kunminglive.com/dist/js/cropper.min.js"></script>
    <!-- File Upload -->
    <script src="https://www.kunminglive.com/dist/js/file-upload.min.js"></script>
    <script src="https://www.kunminglive.com/dist/js/manageprofile.js"></script>
</asp:Content>