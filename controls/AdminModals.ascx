<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminModals.ascx.cs" Inherits="controls_AdminModals" %>

<%@ Register TagPrefix="hwa" TagName="WYSIHTML5" Src="~/controls/WYSIHTML5.ascx" %>
<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>

<!-- Create Blog Post Modal -->
<div class="modal fade in" id="modalCreateBlogPost">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">Write a Blog Post</h4>
            </div>
            <div class="modal-body">
                <div class="form-horizontal">
                    <div class="form-group">
                        <div class="row container-fluid">
                            <div id="lblBlogPostError" class="control-label text-red text-bold collapse" style="text-align: left!important;">&nbsp;<i class="fa fa-times-circle-o"></i><span id="lblBlogPostErrorText"></span></div>
                            <label for="txtBlogPostTitle" class="col-sm-1 control-label">Title</label>
                            <div class="col-sm-5">
                                <input id="txtBlogPostTitle" type="text" class="form-control" placeholder="Title..." />
                            </div>
                            <label for="txtBlogPostDescription" class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-4">
                                <input id="txtBlogPostDescription" type="text" class="form-control" placeholder="Description..." />
                            </div>
                        </div>
                        <div class="row container-fluid" style="margin-top: 8px;">
                            <label for="txtBlogPostTags" class="col-sm-1 control-label">Tags</label>
                            <div class="col-sm-11">
                                <input id="txtBlogPostTags" type="text" />
                            </div>
                        </div>
                        <div class="row container-fluid" style="margin-top: 8px;">
                            <label for="ddlBlogPostType" class="col-sm-1 control-label">Type</label>
                            <div class="col-sm-4">
                                <select id="ddlBlogPostType" class="form-control" runat="server">
                                    <option value="" disabled selected>Type...</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 no-padding">
                    <hwa:WYSIHTML5 ID="wysihtml5AdminBlogPost" ToolbarID="adminBlogPostToolbar" TextareaID="adminBlogPostTextarea" ToggleHTML="true" runat="server" />
                </div>
                <div class="col-xs-12 no-padding">
                    <hwa:ImageUploads ID="newBlogPostImageUpload" LimitImages="false" AutoSavePath="dist/img/blog" runat="server" />
                </div>
                <div class="clearfix"></div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelBlogPost" type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                <button id="btnSubmitBlogPost" type="button" class="btn btn-primary">Post</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- Create Tip/Trick Modal -->
<div class="modal fade in" id="modalCreateTip">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">Add a New Tip / Trick</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <div id="lblNewTipError" class="control-label text-red text-bold collapse">&nbsp;<i class="fa fa-times-circle-o"></i><span id="lblNewTipErrorText"></span></div>
                    <div class="col-xs-6">
                        <label for="txtTipTitle" class="control-label">Title</label>
                        <input id="txtTipTitle" type="text" class="form-control" placeholder="Title..." />
                    </div>
                    <div id="tipsImageUploadMain" class="col-xs-6">
                        <hwa:ImageUploads ID="ctlTipsImageUploadMain" runat="server" MultipleImages="false" />
                    </div>
                    <div class="col-xs-12">
                        <label for="wysihtml5TipsTricks" class="control-label">Details</label>
                        <hwa:WYSIHTML5 ID="wysihtml5TipsTricks" runat="server" ToolbarID="tipsToolbar" TextareaID="tipsTextarea" ToggleHTML="true" />
                    </div>
                    <div id="tipsImageUploadIncludes" class="col-xs-12">
                        <hwa:ImageUploads ID="ctlTipsImageUploadIncludes" LimitImages="false" runat="server" AutoSavePath="dist/img/tips" />
                    </div>
                </div>
                <div class="clearfix"></div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelNewTip" type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                <button id="btnSubmitNewTip" type="button" class="btn btn-primary">Create</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- Create Page Modal -->
<div class="modal fade in" id="modalCreatePage">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">Add a New Page</h4>
            </div>
            <div class="modal-body">
                <div class="form-horizontal">
                    <div class="form-group">
                        <div class="row container-fluid">
                            <label for="txtPageDescription" class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-4">
                                <input id="txtPageDescription" type="text" class="form-control" placeholder="Description..." tabindex="200" />
                            </div>
                            <label for="txtPageLink" class="col-sm-2 control-label">Page Link</label>
                            <div class="col-sm-4">
                                <input id="txtPageLink" type="text" class="form-control" placeholder="Page Link..." tabindex="201" />
                            </div>
                        </div>
                        <div class="row container-fluid text-center icheck" style="margin-top: 8px;">
                            <label for="chkAdministratorAccess">
                                <input id="chkAdministratorAccess" type="checkbox" tabindex="202">
                                Administrator Only Access
                            </label>
                            <label for="chkUserAccess">
                                <input id="chkUserAccess" type="checkbox" tabindex="203">
                                User Only Access
                            </label>
                        </div>
                    </div>
                </div>
                <table class="table table-striped">
                    <tbody id="pnlExistingPages" runat="server">
                        <tr>
                            <th>Title</th>
                            <th>Link</th>
                            <th class="text-center">User</th>
                            <th class="text-center">Admin</th>
                        </tr>
                    </tbody>
                </table>
                <div class="clearfix"></div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelNewPage" type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                <button id="btnSubmitNewPage" type="button" class="btn btn-primary">Create</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- Approve Event Modal -->
<div class="modal fade in" id="modalApproveEvent">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">Approve Events</h4>
            </div>
            <div class="modal-body no-padding">
                <table class="table table-condensed">
                    <tbody id="tblApproveEvents" runat="server">
                        <tr>
                            <th class="col-xs-3">Username</th>
                            <th class="col-xs-4">Title</th>
                            <th class="col-xs-3">View Link</th>
                            <th class="col-xs-1"></th>
                            <th class="col-xs-1"></th>
                        </tr>
                    </tbody>
                </table>
                <div class="clearfix"></div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelApproveEvents" type="button" class="btn btn-default pull-right" data-dismiss="modal">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<script src="https://www.kunminglive.com/dist/js/adminmodals.js"></script>
