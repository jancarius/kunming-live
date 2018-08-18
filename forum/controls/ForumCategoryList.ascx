<%@ Control Language="C#" AutoEventWireup="true" Inherits="YAF.Controls.ForumCategoryList"
    CodeBehind="ForumCategoryList.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Constants" %>
<%@ Import Namespace="YAF.Utils" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Register TagPrefix="YAF" TagName="ForumList" Src="ForumList.ascx" %>
<asp:UpdatePanel ID="UpdatePanelCategory" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="box box-success">
            <asp:Repeater ID="CategoryList" runat="server">
                <HeaderTemplate>
                    <div class="box-header with-border">
                        <div class="col-xs-7 col-xxs-6 no-padding">
                            <strong>
                                <YAF:LocalizedLabel ID="ForumHeaderLabel" runat="server" LocalizedTag="FORUM" />
                            </strong>
                        </div>
                        <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                            <strong>
                                <YAF:LocalizedLabel ID="TopicsHeaderLabel" runat="server" LocalizedTag="TOPICS" />
                            </strong>
                        </div>
                        <div class="col-xs-1 col-xxs-3 text-right-xxs no-padding">
                            <strong>
                                <YAF:LocalizedLabel ID="PostsHeaderLabel" runat="server" LocalizedTag="POSTS" />
                            </strong>
                        </div>
                        <div class="col-xs-3 no-padding hidden-xxs">
                            <strong>
                                <YAF:LocalizedLabel ID="LastPostHeaderLabel" runat="server" LocalizedTag="LASTPOST" />
                            </strong>
                        </div>
                    </div>
                    <div class="box-body">
                </HeaderTemplate>
                <ItemTemplate>
                    <YAF:ForumList runat="server" Visible="true" ID="forumList" DataSource='<%# ((System.Data.DataRowView)Container.DataItem).Row.GetChildRows("FK_Forum_Category") %>' />
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                    <div class="box-footer text-right">
                        <asp:LinkButton runat="server" OnClick="MarkAll_Click" ID="MarkAll" Text='<%# this.GetText("MARKALL") %>' />
                        <YAF:RssFeedLink ID="RssFeed1" runat="server" FeedType="Forum" AdditionalParameters='<%# this.PageContext.PageCategoryID != 0 ? string.Format("c={0}", this.PageContext.PageCategoryID) : null %>'
                            ShowSpacerBefore="true" Visible="<%# PageContext.BoardSettings.ShowRSSLink && this.Get<IPermissions>().Check(PageContext.BoardSettings.ForumFeedAccess) %>"
                            TitleLocalizedTag="RSSICONTOOLTIPFORUM" />
                        <YAF:RssFeedLink ID="AtomFeed1" runat="server" FeedType="Forum" AdditionalParameters='<%# this.PageContext.PageCategoryID != 0 ? string.Format("c={0}", this.PageContext.PageCategoryID) : null %>'
                            ShowSpacerBefore="true" IsAtomFeed="true" Visible="<%# PageContext.BoardSettings.ShowAtomLink && this.Get<IPermissions>().Check(PageContext.BoardSettings.ForumFeedAccess) %>"
                            ImageThemeTag="ATOMFEED" TextLocalizedTag="ATOMFEED" TitleLocalizedTag="ATOMICONTOOLTIPFORUM" />
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
