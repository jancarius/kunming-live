<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.search" CodeBehind="search.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Constants" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Utils" %>
<%@ Import Namespace="YAF.Types.Extensions" %>
<%@ Import Namespace="YAF.Types.Models" %>
<%@ Register TagPrefix="YAF" TagName="DialogBox" Src="../controls/DialogBox.ascx" %>
<%@ Register Namespace="nStuff.UpdateControls" Assembly="nStuff.UpdateControls" TagPrefix="nStuff" %>
<YAF:PageLinks ID="PageLinks" runat="server" />
<script type="text/javascript">
    function EndRequestHandler(sender, args) {
        jQuery().YafModalDialog.Close({ Dialog: '#<%=LoadingModal.ClientID%>' });
    }
    function ShowLoadingDialog() {
        jQuery().YafModalDialog.Show({ Dialog: '#<%=LoadingModal.ClientID%>', ImagePath: '<%=YafForumInfo.GetURLToContent("images/")%>' });
    }
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
</script>
<nStuff:UpdateHistory ID="UpdateHistory" runat="server" OnNavigate="OnUpdateHistoryNavigate" />
<div class="col-xs-12">
    <div class="box box-success">
        <div class="box-header with-border">
            <YAF:LocalizedLabel runat="server" LocalizedTag="title" />
        </div>
        <div class="box-body form-horizontal">
            <div class="form-group">
                <label for="<%= txtSearchStringWhat.ClientID %>" class="col-sm-3 control-label">
                    <YAF:LocalizedLabel runat="server" LocalizedTag="KEYWORDS" />
                </label>
                <div class="col-sm-5">
                    <asp:TextBox ID="txtSearchStringWhat" runat="server" CssClass="form-control" />
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="listSearchWhat" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="form-group">
                <label for="<%= txtSearchStringFromWho.ClientID %>" class="col-sm-3 control-label">
                    <YAF:LocalizedLabel runat="server" LocalizedTag="postedby" />
                </label>
                <div class="col-sm-5">
                    <asp:TextBox ID="txtSearchStringFromWho" runat="server" CssClass="form-control" />
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="listSearchFromWho" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="col-sm-12">
                <YAF:CollapsibleImage ID="CollapsibleImage" runat="server" BorderWidth="0"
                    ImageAlign="Bottom" PanelID='MoreOptions'
                    AttachedControlID="MoreOptions" ToolTip='<%# this.GetText("COMMON", "SHOWHIDE") %>'
                    DefaultState="Collapsed" OnClick="CollapsibleImage_OnClick" />
                <YAF:LocalizedLabel runat="server" LocalizedTag="SEARCH_OPTIONS" />
            </div>
            <asp:PlaceHolder ID="MoreOptions" runat="server">
                <div class="form-group">
                    <label for="<%= listForum.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel runat="server" LocalizedTag="SEARCH_IN" />
                    </label>
                    <div class="col-sm-9">
                        <asp:DropDownList ID="listForum" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= TitleOnly.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel runat="server" LocalizedTag="SEARCH_TITLEORBOTH" />
                    </label>
                    <div class="col-sm-9">
                        <asp:DropDownList ID="TitleOnly" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= listResInPage.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel runat="server" LocalizedTag="SEARCH_RESULTS" />
                    </label>
                    <div class="col-sm-9">
                        <asp:DropDownList ID="listResInPage" runat="server" CssClass="form-control" />
                    </div>
                </div>
            </asp:PlaceHolder>
            <div class="col-sm-12 text-center">
                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="Search_Click"
                    OnClientClick="ShowLoadingDialog(); return true;" Visible="false" />
                <asp:Button ID="btnSearchExt1" runat="server" CssClass="pbutton hidden" Visible="false"
                    OnClick="SearchExt1_Click" />
                <asp:Button ID="btnSearchExt2" runat="server" CssClass="pbutton hidden" Visible="false"
                    OnClick="SearchExt2_Click" />
            </div>
        </div>
    </div>
</div>

<div class="col-xs-12">
    <div class="box box-success">
        <asp:UpdatePanel ID="SearchUpdatePanel" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnSearch" />
            </Triggers>
            <ContentTemplate>
                <YAF:Pager runat="server" ID="Pager" OnPageChange="Pager_PageChange" />
                <asp:Repeater ID="SearchRes" runat="server" OnItemDataBound="SearchRes_ItemDataBound">
                    <HeaderTemplate>
                        <div class="box-header with-border">
                            <strong>
                                <YAF:LocalizedLabel runat="server" LocalizedTag="RESULTS" />
                            </strong>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="box-body">
                            <div class="col-xs-12 text-center">
                                <h4>
                                    <strong>
                                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="topic" />
                                    </strong><a title='<%# this.GetText("COMMON", "VIEW_TOPIC") %>' href="<%# YafBuildLink.GetLink(ForumPages.posts,"t={0}", Container.DataItem.ToType<SearchResult>().TopicID) %>">
                                        <%# HtmlEncode(Container.DataItem.ToType<SearchResult>().Topic) %>
                        
                                    </a>
                                    <a id="AncPost" href="<%# YafBuildLink.GetLink(ForumPages.posts,"m={0}#post{0}",Container.DataItem.ToType<SearchResult>().MessageID) %>" runat="server">&nbsp;
                                <img id="ImgPost" runat="server" title='<%#  this.GetText("GO_LAST_POST") %>' alt='<%#  this.GetText("GO_TO_LASTPOST") %>' src='<%#  GetThemeContents("ICONS", "ICON_LATEST") %>' />
                                    </a>
                                    <a name="<%# Container.DataItem.ToType<SearchResult>().MessageID %>" /><strong>
                                        <YAF:UserLink ID="UserLink1" runat="server" UserID='<%# Container.DataItem.ToType<SearchResult>().UserID %>' />
                                    </strong>
                                    <YAF:OnlineStatusImage ID="OnlineStatusImage" runat="server" Visible='<%# this.Get<YafBoardSettings>().ShowUserOnlineStatus && !UserMembershipHelper.IsGuestUser( Container.DataItem.ToType<SearchResult>().UserID )%>'
                                        Style="vertical-align: bottom" UserID='<%# Container.DataItem.ToType<SearchResult>().UserID %>' />
                                    <strong>
                                        <YAF:LocalizedLabel runat="server" LocalizedTag="POSTED" />
                                    </strong>
                                    <YAF:DisplayDateTime ID="LastVisitDateTime" runat="server" DateTime='<%# Container.DataItem.ToType<SearchResult>().Posted %>'></YAF:DisplayDateTime>
                                </h4>
                            </div>
                            <div class="col-xs-12">
                                <YAF:MessagePostData ID="MessagePostPrimary" runat="server" ShowAttachments="false"
                                    ShowSignature="false" HighlightWords="<%# this.HighlightSearchWords %>" SearchResult="<%# Container.DataItem.ToType<SearchResult>() %>">
                                </YAF:MessagePostData>
                            </div>
                        </div>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <div class="box-body" style="background-color: #f4f4f4;">
                            <div class="clearfix"></div>
                            <div class="col-sm-12 text-center">
                                <h4>
                                    <strong>
                                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="topic" />
                                    </strong><a title='<%# this.GetText("COMMON", "VIEW_TOPIC") %>' href="<%# YafBuildLink.GetLink(ForumPages.posts,"t={0}", Container.DataItem.ToType<SearchResult>().TopicID) %>">
                                        <%# HtmlEncode(Container.DataItem.ToType<SearchResult>().Topic) %>
                                    </a>
                                    <a id="AncPost" href="<%# YafBuildLink.GetLink(ForumPages.posts,"m={0}#post{0}",Container.DataItem.ToType<SearchResult>().MessageID) %>" runat="server">&nbsp;
                                <img id="ImgPost" runat="server" title='<%#  this.GetText("GO_LAST_POST") %>' alt='<%#  this.GetText("GO_TO_LASTPOST") %>' src='<%#  GetThemeContents("ICONS", "ICON_LATEST") %>' />
                                    </a>
                                    <a name="<%# Container.DataItem.ToType<SearchResult>().MessageID %>" /><strong>
                                        <YAF:UserLink ID="UserLink1" runat="server" UserID='<%# Container.DataItem.ToType<SearchResult>().UserID %>' />
                                    </strong>
                                    <YAF:OnlineStatusImage ID="OnlineStatusImage" runat="server" Visible='<%# this.Get<YafBoardSettings>().ShowUserOnlineStatus && !UserMembershipHelper.IsGuestUser( Container.DataItem.ToType<SearchResult>().UserID )%>'
                                        Style="vertical-align: bottom" UserID='<%# Container.DataItem.ToType<SearchResult>().UserID %>' />
                                    <strong>
                                        <YAF:LocalizedLabel runat="server" LocalizedTag="POSTED" />
                                    </strong>
                                    <YAF:DisplayDateTime ID="LastVisitDateTime" runat="server" DateTime='<%# Container.DataItem.ToType<SearchResult>().Posted %>'></YAF:DisplayDateTime>
                                </h4>
                            </div>
                            <div class="col-sm-12">
                                <YAF:MessagePostData ID="MessagePostPrimary" runat="server" ShowAttachments="false"
                                    ShowSignature="false" HighlightWords="<%# this.HighlightSearchWords %>" SearchResult="<%# Container.DataItem.ToType<SearchResult>() %>">
                                </YAF:MessagePostData>
                            </div>
                        </div>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:PlaceHolder ID="NoResults" runat="Server" Visible="false">
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <strong>
                                <YAF:LocalizedLabel runat="server" LocalizedTag="RESULTS" />
                            </strong>
                        </div>
                        <div class="box-body">
                            <YAF:LocalizedLabel runat="server" LocalizedTag="NO_SEARCH_RESULTS" />
                        </div>
                        <div class="box-footer with-border"></div>
                    </div>
                </asp:PlaceHolder>
                <YAF:Pager ID="Pager1" runat="server" LinkedPager="Pager" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>

<YAF:MessageBox ID="LoadingModal" runat="server"></YAF:MessageBox>

<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
