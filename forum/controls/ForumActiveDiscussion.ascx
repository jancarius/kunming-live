<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="YAF.Controls.ForumActiveDiscussion" CodeBehind="ForumActiveDiscussion.ascx.cs" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%--<asp:UpdatePanel ID="UpdateStatsPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>--%>
        <div id="boxActiveUsers_4" class="box box-success" runat="server">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">
                    <YAF:LocalizedLabel ID="ActiveDiscussionHeader" runat="server" LocalizedTag="ACTIVE_DISCUSSIONS" />
                </h3>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <asp:PlaceHolder runat="server" ID="ActiveDiscussionPlaceHolder">
                <div class="box-body">
                    <div class="col-xs-12">
                        <YAF:LocalizedLabel ID="LatestPostsHeader" runat="server" LocalizedTag="LATEST_POSTS" />
                    </div>
                    <asp:Repeater runat="server" ID="LatestPosts" OnItemDataBound="LatestPosts_ItemDataBound">
                        <ItemTemplate>
                            <div class="col-xs-8">
                                <asp:Image ID="NewPostIcon" runat="server" CssClass="topicStatusIcon" />
                                &nbsp;<strong><asp:HyperLink ID="TextMessageLink" runat="server" /></strong>
                                &nbsp;<YAF:LocalizedLabel ID="ByLabel" runat="server" LocalizedTag="BY" LocalizedPage="TOPICS" />
                                &nbsp;<YAF:UserLink ID="LastUserLink" runat="server" />
                                &nbsp;(<asp:HyperLink ID="ForumLink" runat="server" />)
                            </div>
                            <div class="col-xs-4 hidden-xxs">
                                <YAF:DisplayDateTime ID="LastPostDate" runat="server" Format="BothTopic" />
                                <asp:HyperLink ID="ImageMessageLink" runat="server">
                                    <YAF:ThemeImage ID="LastPostedImage" runat="server" Style="border: 0" />
                                </asp:HyperLink>
                                <asp:HyperLink ID="ImageLastUnreadMessageLink" runat="server">
                                    <YAF:ThemeImage ID="LastUnreadImage" runat="server" Style="border: 0" />
                                </asp:HyperLink>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:PlaceHolder>
            <YAF:RssFeedLink ID="RssFeed" runat="server" FeedType="LatestPosts" TitleLocalizedTag="RSSICONTOOLTIPACTIVE" Visible="false" />
            <YAF:RssFeedLink ID="AtomFeed" runat="server" FeedType="LatestPosts" IsAtomFeed="true" ImageThemeTag="ATOMFEED" TextLocalizedTag="ATOMFEED" TitleLocalizedTag="ATOMICONTOOLTIPFORUM" Visible="false" />
            <YAF:CollapsibleImage ID="CollapsibleImage" runat="server" BorderWidth="0" Style="vertical-align: middle" PanelID='ActiveDiscussions' AttachedControlID="ActiveDiscussionPlaceHolder" Visible="false" />
        </div>
<%--    </ContentTemplate>
</asp:UpdatePanel>--%>
