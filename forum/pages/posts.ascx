<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.posts" CodeBehind="posts.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Controls" %>
<%@ Import Namespace="YAF.Types.Extensions" %>
<%@ Register TagPrefix="YAF" TagName="DisplayPost" Src="../controls/DisplayPost.ascx" %>
<%@ Register TagPrefix="YAF" TagName="DisplayConnect" Src="../controls/DisplayConnect.ascx" %>
<%@ Register TagPrefix="YAF" TagName="DisplayAd" Src="../controls/DisplayAd.ascx" %>
<%@ Register TagPrefix="YAF" TagName="PollList" Src="../controls/PollList.ascx" %>
<%@ Register TagPrefix="YAF" TagName="SimilarTopics" Src="../controls/SimilarTopics.ascx" %>
<YAF:PageLinks ID="PageLinks" runat="server" />
<div class="col-xs-12">
    <YAF:PollList ID="PollList" TopicId='<%# PageContext.PageTopicID %>' ShowButtons='<%# ShowPollButtons() %>' Visible='<%# PollGroupId() > 0 %>' PollGroupId='<%# PollGroupId() %>' runat="server" />
</div>
<div class="col-lg-9 col-md-12 text-right pull-right">
    <YAF:ThemeButton ID="TagFavorite1" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_TAGFAVORITE" TitleLocalizedTag="BUTTON_TAGFAVORITE_TT" />
    <YAF:ThemeButton ID="MoveTopic1" runat="server" CssClass="btn btn-success"
        OnClick="MoveTopic_Click" TextLocalizedTag="BUTTON_MOVETOPIC" TitleLocalizedTag="BUTTON_MOVETOPIC_TT" />
    <YAF:ThemeButton ID="UnlockTopic1" runat="server" CssClass="btn btn-success"
        OnClick="UnlockTopic_Click" TextLocalizedTag="BUTTON_UNLOCKTOPIC" TitleLocalizedTag="BUTTON_UNLOCKTOPIC_TT" />
    <YAF:ThemeButton ID="LockTopic1" runat="server" CssClass="btn btn-success"
        OnClick="LockTopic_Click" TextLocalizedTag="BUTTON_LOCKTOPIC" TitleLocalizedTag="BUTTON_LOCKTOPIC_TT" />
    <YAF:ThemeButton ID="DeleteTopic1" runat="server" CssClass="btn btn-success"
        OnClick="DeleteTopic_Click" OnLoad="DeleteTopic_Load" TextLocalizedTag="BUTTON_DELETETOPIC"
        TitleLocalizedTag="BUTTON_DELETETOPIC_TT" />
    <YAF:ThemeButton ID="NewTopic1" runat="server" CssClass="btn btn-success"
        OnClick="NewTopic_Click" TextLocalizedTag="BUTTON_NEWTOPIC" TitleLocalizedTag="BUTTON_NEWTOPIC_TT" />
    <YAF:ThemeButton ID="PostReplyLink1" runat="server" CssClass="btn btn-success"
        OnClick="PostReplyLink_Click" TextLocalizedTag="BUTTON_POSTREPLY" TitleLocalizedTag="BUTTON_POSTREPLY_TT" />
</div>
<div class="col-lg-3 col-md-12">
    <YAF:Pager ID="Pager" runat="server" UsePostBack="False" />
</div>
<div class="clearfix"></div>
<div class="col-xs-12">
    <div class="box box-success" style="margin-top: 15px;">
        <div class="box-header with-border">
            <div class="col-xs-8 col-xxs-12">
                <asp:HyperLink ID="TopicLink" runat="server">
                    <h4 class="no-margin">
                        <asp:Label ID="TopicTitle" runat="server" /></h4>
                </asp:HyperLink>
            </div>
            <div class="col-xs-4 col-xxs-12 text-right">
                <div id="fb-root"></div>
                <div class="hidden">
                    <asp:HyperLink ID="ShareLink" runat="server" CssClass="PopMenuLink">
                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="Share" />
                    </asp:HyperLink>
                    <YAF:PopMenu ID="ShareMenu" runat="server" Control="ShareLink" />
                </div>
                <div style="display: inline">
                    <asp:HyperLink ID="OptionsLink" runat="server">
                        <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" LocalizedTag="Options" />
                    </asp:HyperLink>
                    <asp:UpdatePanel ID="PopupMenuUpdatePanel" runat="server" style="display: inline">
                        <ContentTemplate>
                            <span id="WatchTopicID" runat="server" visible="false"></span>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <YAF:PopMenu runat="server" ID="OptionsMenu" Control="OptionsLink" />
                </div>

                <div style="display: inline">
                    <asp:PlaceHolder ID="ViewOptions" runat="server">
                        <asp:HyperLink ID="ViewLink" runat="server" CssClass="PopMenuLink">
                            <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedTag="View" />
                        </asp:HyperLink>
                    </asp:PlaceHolder>
                    <YAF:PopMenu ID="ViewMenu" runat="server" Control="ViewLink" />
                </div>

                <asp:HyperLink ID="ImageMessageLink" runat="server" CssClass="GoToLink">
                    <YAF:ThemeImage ID="LastPostedImage" runat="server" Style="border: 0" />
                </asp:HyperLink>
                <asp:HyperLink ID="ImageLastUnreadMessageLink" runat="server" CssClass="GoToLink">
                    <YAF:ThemeImage ID="LastUnreadImage" runat="server" Style="border: 0" />
                </asp:HyperLink>
            </div>
        </div>
        <div class="box-body">
            <div class="col-xs-12 no-padding">
                <asp:LinkButton ID="PrevTopic" runat="server" ToolTip='<%# this.GetText("prevtopic") %>' CssClass="PrevTopicLink" OnClick="PrevTopic_Click">
                    <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" LocalizedTag="prevtopic" />
                </asp:LinkButton>
                <asp:LinkButton ID="NextTopic" ToolTip='<%# this.GetText("nexttopic") %>' runat="server" CssClass="NextTopicLink" OnClick="NextTopic_Click">
                    <YAF:LocalizedLabel ID="LocalizedLabel8" runat="server" LocalizedTag="nexttopic" />
                </asp:LinkButton>
                <div runat="server" visible="false">
                    <asp:LinkButton ID="TrackTopic" runat="server" CssClass="header2link" OnClick="TrackTopic_Click">
                        <YAF:LocalizedLabel ID="LocalizedLabel9" runat="server" LocalizedTag="watchtopic" />
                    </asp:LinkButton>
                    <asp:LinkButton ID="EmailTopic" runat="server" CssClass="header2link" OnClick="EmailTopic_Click">
                        <YAF:LocalizedLabel ID="LocalizedLabel10" runat="server" LocalizedTag="emailtopic" />
                    </asp:LinkButton>
                    <asp:LinkButton ID="PrintTopic" runat="server" CssClass="header2link" OnClick="PrintTopic_Click">
                        <YAF:LocalizedLabel ID="LocalizedLabel11" runat="server" LocalizedTag="printtopic" />
                    </asp:LinkButton>
                    <asp:HyperLink ID="RssTopic" runat="server" CssClass="header2link">
                        <YAF:LocalizedLabel ID="LocalizedLabel12" runat="server" LocalizedTag="rsstopic" />
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</div>

<asp:Repeater ID="MessageList" runat="server" OnItemCreated="MessageList_OnItemCreated">
    <ItemTemplate>
        <div class="col-xs-12">
            <div class="box box-success">
                <%# GetThreadedRow(Container.DataItem) %>
                <YAF:DisplayPost ID="DisplayPost1" runat="server" DataRow="<%# Container.DataItem %>"
                    Visible="<%#IsCurrentMessage(Container.DataItem)%>" PostCount="<%# Container.ItemIndex %>" CurrentPage="<%# Pager.CurrentPageIndex %>" IsThreaded="<%#IsThreaded%>" />
                <YAF:DisplayAd ID="DisplayAd" runat="server" Visible="False" />
                <YAF:DisplayConnect ID="DisplayConnect" runat="server" Visible="False" />
                <div class="clearfix"></div>
            </div>
        </div>
    </ItemTemplate>
    <AlternatingItemTemplate>
        <div class="col-xs-12">
            <div class="box box-success">
                <%# GetThreadedRow(Container.DataItem) %>
                <YAF:DisplayPost ID="DisplayPostAlt" runat="server" DataRow="<%# Container.DataItem %>"
                    IsAlt="True" Visible="<%#IsCurrentMessage(Container.DataItem)%>" PostCount="<%# Container.ItemIndex %>" CurrentPage="<%# Pager.CurrentPageIndex %>" IsThreaded="<%#IsThreaded%>" />
                <YAF:DisplayAd ID="DisplayAd" runat="server" Visible="False" />
                <YAF:DisplayConnect ID="DisplayConnect" runat="server" Visible="False" />
                <div class="clearfix"></div>
            </div>
        </div>
    </AlternatingItemTemplate>
</asp:Repeater>

<asp:PlaceHolder ID="QuickReplyPlaceHolder" runat="server">
    <div class="col-xs-12">
        <div class="box box-success">
            <div class="box-body with-border">
                <YAF:DataPanel runat="server" ID="DataPanel1" AllowTitleExpandCollapse="true" TitleStyle-CssClass="header2"
                    TitleStyle-Font-Bold="true" Collapsed="true">
                    <div class="form-group no-margin" id="QuickReplyLine" runat="server">
                    </div>
                    <script>
                        var txtArea = $("#<%= QuickReplyLine.ClientID %>").find("textarea");
                        $(txtArea).attr("rows", "5");
                        $(txtArea).addClass("form-control");
                    </script>
                    <div id="CaptchaDiv" class="text-center" visible="false" runat="server">
                        <div class="form-group">
                            <label for="<%= imgCaptcha.ClientID %>" class="col-xs-4 col-xxs-12 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel13" runat="server" LocalizedTag="Captcha_Image" />
                            </label>
                            <div class="col-xs-8 col-xxs-12 text-center">
                                <asp:Image ID="imgCaptcha" runat="server" AlternateText="Captcha" />
                                <YAF:LocalizedLabel ID="LocalizedLabel14" runat="server" LocalizedTag="Captcha_Enter" />
                                <asp:TextBox ID="tbCaptcha" runat="server" />
                            </div>
                        </div>
                    </div>
                </YAF:DataPanel>
            </div>
            <table width="100%" id="tbFeeds" runat="server" visible="<%# this.Get<IPermissions>().Check(this.Get<YafBoardSettings>().PostsFeedAccess) %>">
                <tr>
                    <td>
                        <div class="box-footer with-border">
                            <asp:Button ID="QuickReply" CssClass="btn btn-success" runat="server" />
                            <asp:PlaceHolder runat="server" ID="QuickReplyWatchTopic">
                                <asp:CheckBox ID="TopicWatch" runat="server" />
                                <YAF:LocalizedLabel ID="TopicWatchLabel" runat="server" LocalizedTag="TOPICWATCH" />
                            </asp:PlaceHolder>
                            <div class="col-xs-5 text-right no-padding hidden">
                                <YAF:RssFeedLink ID="RssFeed" runat="server" FeedType="Posts" AdditionalParameters='<%# "t={0}".FormatWith(PageContext.PageTopicID) %>' TitleLocalizedTag="RSSICONTOOLTIPACTIVE" Visible="<%# this.Get<YafBoardSettings>().ShowRSSLink && this.Get<IPermissions>().Check(this.Get<YafBoardSettings>().PostsFeedAccess) %>" />
                                &nbsp; 
                                <YAF:RssFeedLink ID="AtomFeed" runat="server" FeedType="Posts" AdditionalParameters='<%# "t={0}".FormatWith(PageContext.PageTopicID) %>' IsAtomFeed="true" Visible="<%# this.Get<YafBoardSettings>().ShowAtomLink && this.Get<IPermissions>().Check(this.Get<YafBoardSettings>().PostsFeedAccess) %>" ImageThemeTag="ATOMFEED" TextLocalizedTag="ATOMFEED" TitleLocalizedTag="ATOMICONTOOLTIPACTIVE" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:PlaceHolder>

<div class="col-xs-12">
    <div class="box box-success">
        <div class="box-body">
            <YAF:ForumUsers ID="ForumUsers1" runat="server" />
        </div>
    </div>
</div>
<YAF:SimilarTopics ID="SimilarTopics" runat="server" Topic='<%# PageContext.PageTopicName %>' TopicID='<%# PageContext.PageTopicID %>'></YAF:SimilarTopics>
<div class="col-lg-3 col-md-12">
    <YAF:Pager ID="PagerBottom" runat="server" LinkedPager="Pager" UsePostBack="false" />
</div>
<div class="col-lg-9 col-md-12 text-right text-left-xxs pull-right">
    <YAF:ThemeButton ID="TagFavorite2" runat="server" CssClass="btn btn-success"
        TextLocalizedTag="BUTTON_TAGFAVORITE" TitleLocalizedTag="BUTTON_TAGFAVORITE_TT" />
    <YAF:ThemeButton ID="MoveTopic2" runat="server" CssClass="btn btn-success"
        OnClick="MoveTopic_Click" TextLocalizedTag="BUTTON_MOVETOPIC" TitleLocalizedTag="BUTTON_MOVETOPIC_TT" />
    <YAF:ThemeButton ID="UnlockTopic2" runat="server" CssClass="btn btn-success"
        OnClick="UnlockTopic_Click" TextLocalizedTag="BUTTON_UNLOCKTOPIC" TitleLocalizedTag="BUTTON_UNLOCKTOPIC_TT" />
    <YAF:ThemeButton ID="LockTopic2" runat="server" CssClass="btn btn-success"
        OnClick="LockTopic_Click" TextLocalizedTag="BUTTON_LOCKTOPIC" TitleLocalizedTag="BUTTON_LOCKTOPIC_TT" />
    <YAF:ThemeButton ID="DeleteTopic2" runat="server" CssClass="btn btn-success"
        OnClick="DeleteTopic_Click" OnLoad="DeleteTopic_Load" TextLocalizedTag="BUTTON_DELETETOPIC"
        TitleLocalizedTag="BUTTON_DELETETOPIC_TT" />
    <YAF:ThemeButton ID="NewTopic2" runat="server" CssClass="btn btn-success"
        OnClick="NewTopic_Click" TextLocalizedTag="BUTTON_NEWTOPIC" TitleLocalizedTag="BUTTON_NEWTOPIC_TT" />
    <YAF:ThemeButton ID="PostReplyLink2" runat="server" CssClass="btn btn-success"
        OnClick="PostReplyLink_Click" TextLocalizedTag="BUTTON_POSTREPLY" TitleLocalizedTag="BUTTON_POSTREPLY_TT" />
</div>
<div class="clearfix"></div>
<span class="hidden"><YAF:PageLinks ID="PageLinksBottom" runat="server" LinkedPageLinkID="PageLinks" /></span>
<asp:PlaceHolder ID="ForumJumpHolder" runat="server">
    <div id="DivForumJump">
        <YAF:LocalizedLabel ID="ForumJumpLabel" runat="server" LocalizedTag="FORUM_JUMP" />
        &nbsp;<YAF:ForumJump ID="ForumJump1" runat="server" />
        <script>$("#<%= ForumJump1.ClientID %>").addClass("form-control");</script>
    </div>
</asp:PlaceHolder>
<div id="DivPageAccess" class="smallfont hidden">
    <YAF:PageAccess ID="PageAccess1" runat="server" />
</div>
<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
