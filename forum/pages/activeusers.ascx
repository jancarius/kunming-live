<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.activeusers" CodeBehind="activeusers.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Core.Services" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Utils.Helpers" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<div class="box box-success">
    <div class="box-header with-border">
        <strong>
            <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="title" />
        </strong>
    </div>
    <div class="box-body">
        <asp:Repeater ID="UserList" runat="server">
            <HeaderTemplate>
                <table width="100%" cellspacing="1" cellpadding="0" id="ActiveUsers">
                    <tr>
                        <td>
                            <div class="col-xs-2 col-xxs-3 no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="username" />
                                </strong>
                            </div>
                            <div class="col-xs-2 col-xxs-3 no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabelLatestActions" runat="server" LocalizedTag="latest_action" />
                                </strong>
                            </div>
                            <div class="col-xs-2 col-xxs-3 no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="logged_in" />
                                </strong>
                            </div>
                            <div class="col-xs-2 hidden-xxs no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="last_active" />
                                </strong>
                            </div>
                            <div class="col-xs-1 hidden-xxs no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" LocalizedTag="active" />
                                </strong>
                            </div>
                            <div class="col-xs-1 hidden-xxs no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedTag="browser" />
                                </strong>
                            </div>
                            <div class="col-xs-1 hidden-xxs no-padding">
                                <strong>
                                    <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" LocalizedTag="platform" />
                                </strong>
                            </div>
                            <div class="col-xs-1 col-xxs-3 no-padding">
                                <table width="100%">
                                    <tr>
                                        <th id="Iptd_header1" runat="server" visible='<%# this.PageContext.IsAdmin %>'>
                                            <strong>IP</strong>
                                        </th>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
            <ItemTemplate>
                <div class="col-xs-12">
                    <br />
                </div>
                <div class="col-xs-2 col-xxs-3 no-padding">
                    <YAF:UserLink ID="NameLink" runat="server" ReplaceName='<%# this.Get<YafBoardSettings>().EnableDisplayName
                        ? Eval("UserDisplayName")
                        : Eval("UserName") %>'
                        CrawlerName='<%# Convert.ToInt32(Eval("IsCrawler")) > 0 ? Eval("Browser").ToString() : String.Empty %>'
                        UserID='<%# Convert.ToInt32(Eval("UserID")) %>'
                        Style='<%# Eval("Style").ToString() %>' />
                    <asp:PlaceHolder ID="HiddenPlaceHolder" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsHidden"))%>'>(<YAF:LocalizedLabel ID="Hidden" LocalizedTag="HIDDEN" runat="server" />
                        )
                    </asp:PlaceHolder>
                </div>
                <div class="col-xs-2 col-xxs-3 no-padding">
                    <YAF:ActiveLocation ID="ActiveLocation2" UserID='<%# Convert.ToInt32((Eval("UserID") == DBNull.Value)? 0 : Eval("UserID")) %>'
                        UserName='<%# Eval("UserName") %>' HasForumAccess='<%# Convert.ToBoolean(Eval("HasForumAccess")) %>' ForumPage='<%# Eval("ForumPage") %>'
                        ForumID='<%# Convert.ToInt32((Eval("ForumID") == DBNull.Value)? 0 : Eval("ForumID")) %>' ForumName='<%# Eval("ForumName") %>'
                        TopicID='<%# Convert.ToInt32((Eval("TopicID") == DBNull.Value)? 0 : Eval("TopicID")) %>' TopicName='<%# Eval("TopicName") %>'
                        LastLinkOnly="false" runat="server">
                    </YAF:ActiveLocation>
                </div>
                <div class="col-xs-2 col-xxs-3 no-padding">
                    <%# this.Get<IDateTime>().FormatTime((DateTime)((System.Data.DataRowView)Container.DataItem)["Login"]) %>
                </div>
                <div class="col-xs-2 hidden-xxs no-padding">
                    <%# this.Get<IDateTime>().FormatTime((DateTime)((System.Data.DataRowView)Container.DataItem)["LastActive"]) %>
                </div>
                <div class="col-xs-1 hidden-xxs no-padding">
                    <%# this.Get<ILocalization>().GetTextFormatted("minutes", ((System.Data.DataRowView)Container.DataItem)["Active"])%>
                </div>
                <div class="col-xs-1 hidden-xxs no-padding">
                    <%# Eval("Browser") %>
                </div>
                <div class="col-xs-1 hidden-xxs no-padding">
                    <%# Eval("Platform") %>
                </div>
                <div class="col-xs-1 col-xxs-3 no-padding">
                    <table width="100%">
                        <tr>
                            <td id="Iptd1" class="post" runat="server" visible='<%# this.PageContext.IsAdmin %>'>
                                <a id="Iplink1" href='<%# string.Format(this.PageContext.BoardSettings.IPInfoPageURL,IPHelper.GetIp4Address(Eval("IP").ToString())) %>'
                                    title='<%# this.GetText("COMMON","TT_IPDETAILS") %>' target="_blank" runat="server">
                                    <%# IPHelper.GetIp4Address(Eval("IP").ToString())%></a>
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
                <div class="box-footer">
                    <div id="ActiveUsersPager" class="col-xs-12 text-center valign">
                        <div class="col-xs-3 no-padding">
                            <a href="#" class="first pagelink"><span>&lt;&lt;</span></a>
                            <a href="#" class="prev pagelink"><span>&lt;</span></a>
                        </div>
                        <div class="col-xs-4 no-padding">
                            <input type="text" class="form-control" />
                        </div>
                        <div class="col-xs-5 no-padding">
                            <a href="#" class="next pagelink"><span>&gt;</span></a>
                            <a href="#" class="last pagelink"><span>&gt;&gt;</span></a>
                            <select class="pagesize">
                                <option selected="selected" value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                            </select>
                        </div>
                    </div>
                    <span class="hidden">
                        <YAF:ThemeButton ID="btnReturn" runat="server" CssClass="yafcssbigbutton rightItem"
                            TextLocalizedPage="COMMON" TextLocalizedTag="OK" TitleLocalizedPage="COMMON" TitleLocalizedTag="OK" OnClick="Return_Click" />
                    </span>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    <div id="DivSmartScroller">
        <YAF:SmartScroller ID="SmartScroller1" runat="server" />
    </div>
