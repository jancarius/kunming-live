<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.topics" CodeBehind="topics.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Register TagPrefix="YAF" TagName="ForumList" Src="../controls/ForumList.ascx" %>
<%@ Register TagPrefix="YAF" TagName="TopicLine" Src="../controls/TopicLine.ascx" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<asp:PlaceHolder runat="server" ID="SubForums" Visible="false">
    <div class="col-xs-12">
        <div class="box box-success">
            <div class="box-header">
                <strong><%=GetSubForumTitle()%></strong>
            </div>
            <div class="box-body">
                <div class="col-xs-7 col-xxs-6 no-padding">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="FORUM" />
                    </strong>
                </div>
                <div class="hidden">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="moderators" />
                    </strong>
                </div>
                <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                    <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="topics" />
                </div>
                <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                    <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="posts" />
                </div>
                <div class="col-xs-3 no-padding hidden-xxs">
                    <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" LocalizedTag="lastpost" />
                </div>
                <YAF:ForumList AltLastPost="<%# this.LastPostImageTT %>" runat="server" ID="ForumList" />
            </div>
        </div>
    </div>
</asp:PlaceHolder>
<div class="col-xs-6 col-xxs-12 text-right pull-right" style="margin-bottom:20px;">
    <YAF:ThemeButton ID="moderate1" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_MODERATE" TitleLocalizedTag="BUTTON_MODERATE_TT" />
    <YAF:ThemeButton ID="NewTopic1" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_NEWTOPIC" TitleLocalizedTag="BUTTON_NEWTOPIC_TT" OnClick="NewTopic_Click" />
</div>
<div class="col-xs-6 col-xxs-12">
    <YAF:Pager runat="server" ID="Pager" UsePostBack="False" />
</div>
<div class="clearfix"></div>
<div class="col-xs-12">
    <div class="box box-success">
        <div class="box-header with-border">
            <strong>
                <asp:Label ID="PageTitle" runat="server"></asp:Label>
            </strong>
        </div>
        <div class="box-body">
            <div class="col-xs-12">
                <div class="col-xs-7 col-xxs-6 no-padding">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedTag="topics" />
                    </strong>
                </div>
                <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel8" runat="server" LocalizedTag="replies" />
                    </strong>
                </div>
                <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel9" runat="server" LocalizedTag="views" />
                    </strong>
                </div>
                <div class="col-xs-3 hidden-xxs no-padding">
                    <strong>
                        <YAF:LocalizedLabel ID="LocalizedLabel10" runat="server" LocalizedTag="lastpost" />
                    </strong>
                </div>
            </div>
            <div class="col-xs-12">
                <asp:Repeater ID="Announcements" runat="server">
                    <ItemTemplate>
                        <YAF:TopicLine runat="server" AltLastPost="<%# this.LastPostImageTT %>" DataRow="<%# Container.DataItem %>" />
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Repeater ID="TopicList" runat="server">
                    <ItemTemplate>
                        <YAF:TopicLine runat="server" AltLastPost="<%# this.LastPostImageTT %>" DataRow="<%# Container.DataItem %>" />
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <div style="background: #f4f4f4; padding: 5px;">
                            <YAF:TopicLine runat="server" IsAlt="True" AltLastPost="<%# this.LastPostImageTT %>" DataRow="<%# Container.DataItem %>" />
                        </div>
                    </AlternatingItemTemplate>
                </asp:Repeater>
            </div>
            <div class="col-xs-12 pad margin">
                <YAF:ForumUsers runat="server" />
                <script>$(".yafactiveusers").parent().css("padding", "0");</script>
            </div>
        </div>
        <div class="box-footer with-border valign">
            <div class="col-xs-5 col-xxs-12 no-padding form-horizontal">
                <div class="form-group no-margin">
                    <label for="<%= ShowList.ClientID %>" class="col-xs-5 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel11" runat="server" LocalizedTag="showtopics" />
                    </label>
                    <div class="col-xs-7">
                        <asp:DropDownList ID="ShowList" runat="server" AutoPostBack="True" CssClass="form-control" />
                    </div>
                </div>
            </div>
            <div class="col-xs-7 col-xxs-12 text-right text-left-xxs">
                <asp:LinkButton ID="WatchForum" runat="server" /><span id="WatchForumID" runat="server"
                    visible="false" /><span id="delimiter1" runat="server" visible="<%# this.WatchForum.Text.Length > 0 %>"> | </span>
                <asp:LinkButton runat="server" ID="MarkRead" />
                <YAF:RssFeedLink ID="RssFeed" runat="server" FeedType="Topics" ShowSpacerBefore="true"
                    Visible="<%# PageContext.BoardSettings.ShowRSSLink && this.Get<IPermissions>().Check(PageContext.BoardSettings.TopicsFeedAccess) %>" TitleLocalizedTag="RSSICONTOOLTIPFORUM" />
                <YAF:RssFeedLink ID="AtomFeed" runat="server" FeedType="Topics" ShowSpacerBefore="true" IsAtomFeed="true" Visible="<%# PageContext.BoardSettings.ShowAtomLink && this.Get<IPermissions>().Check(PageContext.BoardSettings.TopicsFeedAccess) %>" ImageThemeTag="ATOMFEED" TextLocalizedTag="ATOMFEED" TitleLocalizedTag="ATOMICONTOOLTIPACTIVE" />
            </div>
        </div>
    </div>
</div>
<div class="col-xs-6 col-xxs-12 text-right pull-right" style="margin-bottom: 20px;">
    <YAF:ThemeButton ID="moderate2" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_MODERATE" TitleLocalizedTag="BUTTON_MODERATE_TT" />
    <YAF:ThemeButton ID="NewTopic2" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_NEWTOPIC" TitleLocalizedTag="BUTTON_NEWTOPIC_TT" OnClick="NewTopic_Click" />
</div>
<div class="col-xs-6 col-xxs-12">
    <div class="box box-success pager-content">
        <div class="box-body">
            <YAF:Pager ID="PagerBottom" runat="server" LinkedPager="Pager" UsePostBack="False" />
        </div>
    </div>
    <script>
        if ($("<%= PagerBottom.ClientID %>").length == 0) {
            $(".pager-content").addClass("hidden");
        }
    </script>
    <asp:PlaceHolder ID="ForumSearchHolder" runat="server" Visible="false">
        <div class="box box-success form-horizontal">
            <div class="box-body">
                <label for="<%= forumSearch.ClientID %>" class="col-xs-3 col-xxs-12 control-label" style="padding-left: 0; padding-right: 0;">
                    <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" LocalizedTag="SEARCH_FORUM" />
                </label>
                <div class="col-xs-7 col-xxs-9">
                    <asp:TextBox ID="forumSearch" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-xs-2 col-xxs-3 no-padding">
                    <YAF:ThemeButton ID="forumSearchOK" runat="server" CssClass="btn btn-small btn-success"
                        TextLocalizedTag="OK" TitleLocalizedTag="OK_TT" OnClick="ForumSearch_Click" />
                </div>
            </div>
        </div>
    </asp:PlaceHolder>
    <div class="clearfix"></div>
    <asp:PlaceHolder ID="ForumJumpHolder" runat="server">
        <div class="box box-success form-horizontal">
            <div class="box-body">
                <label for="<%= ForumJump1.ClientID %>" class="col-xs-3 col-xxs-12 control-label" style="padding-left: 0; padding-right: 0;">
                    <YAF:LocalizedLabel ID="ForumJumpLabel" runat="server" LocalizedTag="FORUM_JUMP" />
                </label>
                <div class="col-xs-9 col-xxs-12">
                    <YAF:ForumJump ID="ForumJump1" runat="server" />
                    <script>$("#<%= ForumJump1.ClientID %>").addClass("form-control");</script>
                </div>
            </div>
        </div>
    </asp:PlaceHolder>
</div>
<div class="clearItem"></div>
<div id="DivIconLegend" class="hidden">
    <YAF:IconLegend ID="IconLegend1" runat="server" Visible="false" />
</div>
<div id="DivPageAccess" class="smallfont hidden">
    <YAF:PageAccess ID="PageAccess1" runat="server" />
</div>
<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
