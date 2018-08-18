<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Controls.ForumList"
    EnableViewState="false" CodeBehind="ForumList.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Extensions" %>
<%@ Register TagPrefix="YAF" TagName="ForumLastPost" Src="ForumLastPost.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumModeratorList" Src="ForumModeratorList.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumSubForumList" Src="ForumSubForumList.ascx" %>
<asp:Repeater ID="ForumList1" runat="server" OnItemCreated="ForumList1_ItemCreated">
    <ItemTemplate>
        <div class="valign pad">
            <div class="col-xs-7 col-xxs-6 no-padding">
                <div class="pull-left" style="padding: 0 5px 5px 0;">
                    <YAF:ThemeImage ID="ThemeForumIcon" Visible="false" runat="server" />
                    <img id="ForumImage1" class="" src="" alt="image" visible="false" runat="server" style="border-width: 0px;" />
                </div>
                <div class="forumheading">
                    <strong><%# GetForumLink((System.Data.DataRow)Container.DataItem) %></strong>
                </div>
                <div class="forumviewing hidden">
                    <%# GetViewing(Container.DataItem) %>
                </div>
                <div class="subforumheading" runat="server" visible='<%# DataBinder.Eval(Container.DataItem, "[\"Description\"]").ToString().IsSet() %>'>
                    <%# Page.HtmlEncode(DataBinder.Eval(Container.DataItem, "[\"Description\"]")) %>
                </div>
                <span id="ModListMob_Span" class="description" visible="false" runat="server">
                    <YAF:ForumModeratorList ID="ForumModeratorListMob" Visible="false" runat="server" />
                </span>
                <YAF:ForumSubForumList ID="SubForumList" runat="server" DataSource='<%# GetSubforums( (System.Data.DataRow)Container.DataItem ) %>'
                    Visible='<%# HasSubforums((System.Data.DataRow)Container.DataItem) %>' />
            </div>
            <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                <%# Topics(Container.DataItem) %>
            </div>
            <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                <%# Posts(Container.DataItem) %>
            </div>
            <div class="col-xs-3 no-padding hidden-xxs">
                <YAF:ForumLastPost DataRow="<%# Container.DataItem %>" Visible='<%# (((System.Data.DataRow)Container.DataItem)["RemoteURL"] == DBNull.Value) %>'
                    ID="lastPost" runat="server" />
            </div>
        </div>
    </ItemTemplate>
    <AlternatingItemTemplate>
        <div class="valign pad" style="background: #f4f4f4;">
            <div class="col-xs-7 col-xxs-6 no-padding">
                <div class="pull-left" style="padding: 0 5px 5px 0;">
                    <YAF:ThemeImage ID="ThemeForumIcon" Visible="false" runat="server" />
                    <img id="ForumImage1" class="" src="" alt="image" visible="false" runat="server" style="border-width: 0px;" />
                </div>
                <div class="forumheading">
                    <strong><%# GetForumLink((System.Data.DataRow)Container.DataItem) %></strong>
                </div>
                <div class="forumviewing hidden">
                    <%# GetViewing(Container.DataItem) %>
                </div>
                <div class="subforumheading" runat="server" visible='<%# DataBinder.Eval(Container.DataItem, "[\"Description\"]").ToString().IsSet() %>'>
                    <%# Page.HtmlEncode(DataBinder.Eval(Container.DataItem, "[\"Description\"]")) %>
                </div>
                <span id="ModListMob_Span" class="description" visible="false" runat="server">
                    <YAF:ForumModeratorList ID="ForumModeratorListMob" Visible="false" runat="server" />
                </span>
                <YAF:ForumSubForumList ID="SubForumList" runat="server" DataSource='<%# GetSubforums( (System.Data.DataRow)Container.DataItem ) %>'
                    Visible='<%# HasSubforums((System.Data.DataRow)Container.DataItem) %>' />
            </div>
            <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                <%# Topics(Container.DataItem) %>
            </div>
            <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                <%# Posts(Container.DataItem) %>
            </div>
            <div class="col-xs-3 no-padding hidden-xxs">
                <YAF:ForumLastPost DataRow="<%# Container.DataItem %>" Visible='<%# (((System.Data.DataRow)Container.DataItem)["RemoteURL"] == DBNull.Value) %>'
                    ID="lastPost" runat="server" />
            </div>
        </div>
    </AlternatingItemTemplate>
</asp:Repeater>
