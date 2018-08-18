<%@ Page Title="" Language="C#" MasterPageFile="admin.master" AutoEventWireup="true" CodeFile="controltower.aspx.cs" Inherits="controltower" %>
<%@ MasterType VirtualPath="~/admin.master" %>
<%@ Register TagPrefix="YAF" TagName="ActiveDiscussions" Src="~/forum/controls/ForumActiveDiscussion.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Control Tower
                    <small>Dashboard</small>
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="https://www.kunminglive.com/"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">Dashboard</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div style="position:relative;">
                    <div class="col-md-3 col-sm-6 col-xs-3<%-- col-xxs-6--%> small-pad-xs">
                        <div class="small-box bg-aqua clickable">
                            <div class="inner">
                                <h3 id="lblYourPosts" runat="server">0</h3>
                                <p>Your&nbsp; Replies&nbsp;</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-comments"></i>
                            </div>
                            <%--<a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>--%>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6 col-xs-3<%-- col-xxs-6--%> small-pad-xs">
                        <div class="small-box bg-green clickable">
                            <div class="inner">
                                <h3 id="lblYourReviews" runat="server">0</h3>
                                <p>Your Reviews</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-pencil"></i>
                            </div>
                            <%--<a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>--%>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6 col-xs-3<%-- col-xxs-6--%> small-pad-xs">
                        <div class="small-box bg-yellow clickable">
                            <div class="inner">
                                <h3 id="lblYourTodo" runat="server">0</h3>
                                <p>Your&nbsp; Saved&nbsp;</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-list"></i>
                            </div>
                            <%--<a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>--%>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6 col-xs-3<%-- col-xxs-6--%> small-pad-xs">
                        <div class="small-box bg-red clickable">
                            <div class="inner">
                                <h3 id="lblYourEvents" runat="server">0</h3>
                                <p>Your&nbsp; Events&nbsp;</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-calendar"></i>
                            </div>
                            <%--<a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>--%>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </section>

    <section id="connectedSortable1" class="col-md-7 col-xs-12 connectedSortable ui-sortable" runat="server">
        <div id="boxRecentBlogs_1" class="box box-success box-state" runat="server">
            <div class="box-header ui-sortable-handle draggable">
                <h3 class="box-title">Recent Blogs</h3>
                <small>and Articles</small>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body no-padding">
                <table id="tblBlogPosts" class="table table-hover">
                    <tbody id="tblBlogPostsBody" runat="server">
                    </tbody>
                </table>
            </div>
            <div class="box-footer with-border text-right">
                <a href="https://www.kunminglive.com/blog-articles" class="btn btn-success btn-flat">View All Posts</a>
            </div>
        </div>

        <div id="boxBusinesses_4" class="box box-success" runat="server">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">Businesses</h3>
                <small>Top Rated</small>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body no-padding">
                <div class="container-fluid">
                    <div class="row">
                        <div id="tblBusinessesBody" runat="server">
                        </div>
                    </div>
                </div>
            </div>
            <div class="box-footer with-border">
                <a id="btnViewBusinesses" href="https://www.kunminglive.com/things-to-do/all" class="btn btn-success btn-flat pull-right">View All Businesses</a>
            </div>
        </div>

        <YAF:ActiveDiscussions ID="yafActiveDiscussions" runat="server" DisplayNumber="5"></YAF:ActiveDiscussions>
    </section>

    <section id="connectedSortable2" class="col-md-5 col-xs-12 connectedSortable ui-sortable" runat="server">
        <div id="boxEventsCalendar_3" class="box box-solid bg-green-gradient box-state" runat="server">
            <div class="box-header ui-sortable-handle draggable">
                <i class="fa fa-calendar"></i>
                <h3 class="box-title">Events
                    <small>Calendar</small>
                </h3>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-success btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-success btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body">
                <div id="controlTowerCalendar"></div>
                <a id="btnViewEvents" href="https://www.kunminglive.com/events-calendar" class="btn btn-default btn-flat pull-right">View All Events</a>
            </div>
            <asp:HiddenField ID="hiddenEventData" runat="server" />
        </div>

        <div id="boxBucketList_2" class="box box-success box-state" runat="server">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">Saved Items</h3>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body">
                <ul id="lstTodoItems" class="todo-list ui-sortable" runat="server">
                    <h3 id="noTodoItems" class="text-center" runat="server"><i>No Items</i></h3>
                </ul>
                <ul id="lstTodoItemsDone" class="todo-list ui-sortable" style="display:none;" runat="server">
                    <h3 id="noTodoItemsDone" class="text-center" runat="server"><i>No Items</i></h3>
                </ul>
                <div id="pnlTodoItemButtons" style="display:none;">
                    <button id="btnTodoItemsDone" type="button" class="btn btn-sm btn-primary margin">Done</button>
                    <button id="btnTodoItemsDelete" type="button" class="btn btn-sm btn-danger margin pull-right">Delete</button>
                </div>
                <div id="pnlTodoItemButtonsDone" style="display:none;">
                    <button id="btnTodoItemsUndone" type="button" class="btn btn-sm btn-primary margin">Undo Completed</button>
                </div>
            </div>
            <div class="box-footer with-border">
                <button id="btnViewCompletedTodo" type="button" class="btn btn-success btn-flat pull-right">View Completed</button>
            </div>
        </div>

        <div id="boxClassifiedPosts_5" class="box box-success" runat="server">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">Classifieds</h3>
                <small>Most Recent</small>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body no-padding">
                <table id="tblClassifieds" class="table table-hover">
                    <tbody id="tblClassifiedsBody" runat="server">
                    </tbody>
                </table>
            </div>
            <div class="box-footer with-border">
                <a id="btnViewClassifieds" href="https://www.kunminglive.com/classifieds/all" class="btn btn-success btn-flat pull-right">View All Classifieds</a>
            </div>
        </div>

        <div id="boxRecentUsers_6" class="box box-success" runat="server">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">Users</h3>
                <small>Recent Activity</small>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body no-padding">
                <table id="tblRecentUsers" class="table table-hover">
                    <tbody id="tblRecentUsersBody" runat="server">
                        <tr>
                            <td><h4 class="text-center text-italic">No Active Users</h4></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="server">
    <script src="https://www.kunminglive.com/dist/js/controltower.js"></script>
</asp:Content>
