<%@ Page Title="" Language="C#" MasterPageFile="admin.master" AutoEventWireup="true" CodeFile="blog.aspx.cs" Inherits="blog" %>
<%@ Register TagPrefix="kl" TagName="UserComments" Src="~/controls/UserComments.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="bower_components/bootstrap-daterangepicker/daterangepicker.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Blog Posts
                    <small>and Articles / News</small>
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="controltower.aspx"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">Blog / Articles</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="col-xl-3 col-md-4 col-xs-12 pull-right no-pad-right">
                    <div id="blogDetails" class="box box-success blog-post box-state" style="z-index:100;margin-bottom:0;" runat="server">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <span class="head">Filter</span>
                                <small>Post Details</small>
                            </h3>
                            <div class="pull-right box-tools">
                                <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <button id="btnCloseBlogDetails" type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="form-group col-lg-5 col-md-4 col-xs-2 col-xxs-5 text-center no-padding">
                                <label class="control-label"># of Posts</label>
                                <input id="txtNumPosts" type="text" class="form-control" style="width: 40px; margin: 0 auto;" maxlength="2" value="10" />
                            </div>
                            <div class="form-group text-center no-padding col-lg-7 col-md-8 col-xs-4 col-xxs-7">
                                <label class="control-label">Article Type:</label><br />
                                <a href="#" class="btn btn-default btn-circle bg-blue type-filters" style="font-size: 15px;" data-blog_type="2" data-toggle="tooltip" data-original-title="Blog Posts"><i class='fa fa-envelope'></i></a>
                                <a href="#" class="btn btn-default btn-circle bg-navy type-filters" style="font-size: 15px;" data-blog_type="1" data-toggle="tooltip" data-original-title="Articles"><i class='fa fa-newspaper-o'></i></a>
                                <a href="#" class="btn btn-default btn-circle bg-red-active type-filters" style="font-size: 15px;" data-blog_type="0" data-toggle="tooltip" data-original-title="Announcements"><i class='fa fa-bullhorn'></i></a>
                                <a href="#" class="btn btn-default btn-circle bg-yellow-active type-filters" style="font-size: 15px;" data-blog_type="3" data-toggle="tooltip" data-original-title="Updates"><i class='fa fa-pencil-square'></i></a>
                            </div>
                            <div class="form-group text-center no-padding col-md-12 col-xs-6 col-xxs-12">
                                <label class="control-label">Date Range</label>
                                <div class="input-group" style="width: 205px; margin: 0px auto;">
                                    <div class="input-group-addon"><i class="fa fa-calendar"></i></div>
                                    <input id="txtDateRangeFilter" type="text" class="form-control pull-right" />
                                </div>
                            </div>
                            <div class="col-xs-12 text-center">
                                <label class="control-label">Tags:</label><br />
                                <asp:PlaceHolder ID="phTags" runat="server"></asp:PlaceHolder>
                            </div>
                        </div>
                        <div class="box-footer with-border text-right">
                            <button id="btnFilterPosts" type="button" class="btn btn-success btn-sm">Filter</button>
                            <button id="btnFilterPostsClear" type="button" class="btn btn-warning btn-sm">Clear</button>
                        </div>
                    </div>
                </div>
                <ul id="timeline" class="timeline" runat="server">
                </ul>
                <button id='btnLoadMorePosts' type='button' class='btn btn-block btn-default' style='width:88%;margin-left:12%;position:relative;top:-30px;'>Load More...</button>
            </div>
        </div>
    </section>

    <!-- Show Blog Modal -->
    <div class="modal fade in" id="modalShowBlogDetails">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body no-padding" style="position:initial;">
                    <div id="showBlogContent" class="col-xs-12">
                    </div>
                    <div class='user-block col-sm-6 col-xs-12'>
                        <img src='/dist/img/profile/male_placeholder.png' class='img-circle' alt='Blog Post Author' />
                        <span class='username'>
                            <a href='#' target="_blank"></a>
                        </span>
                        <span class='description'></span>
                    </div>
                    <div class='col-sm-6 col-xs-12 social-auth-links text-right no-margin text-nowrap' data-post_id='null'>
                        <button type='button' class='btn btn-social-icon btn-weixin btn-flat'><i class='fa fa-weixin'></i></button>
                        <button type='button' class='btn btn-social-icon btn-weibo btn-flat'><i class='fa fa-weibo'></i></button>
                        <button type='button' class='btn btn-social-icon btn-facebook btn-flat'><i class='fa fa-facebook'></i></button>
                        <button type='button' class='btn btn-social-icon btn-twitter btn-flat'><i class='fa fa-twitter'></i></button>
                        <button type='button' class='btn btn-social-icon btn-linkedin btn-flat'><i class='fa fa-linkedin'></i></button>
                        <div class="clearfix"></div>
                    </div>
                    <div class='col-xs-12 blog-tags'>
                        <strong style='font-size:16px;'>Tags:</strong>&nbsp;
                    </div>
                    <div class="col-xs-12" style="position:initial;">
                        <button id="showUserComments" type="button" class="btn btn-block btn-primary"><i class="fa fa-users"></i>&nbsp;View Comments (<span id="showUserReviewCount">0</span>)</button>
                        <div id="pnlShowUserComments" style="display:none;">
                            <kl:UserComments ID="showUserReviews" runat="server" Rating="false" Multiple="true" TableName="blog_posts" />
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelShowEvent" type="button" class="btn btn-default pull-right" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hiddenIDParam" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script src="bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
    <script src="dist/js/blog.js"></script>
</asp:Content>
