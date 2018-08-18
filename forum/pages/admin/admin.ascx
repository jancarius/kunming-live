<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.Admin.admin"
    CodeBehind="admin.ascx.cs" %>
<%@ Import Namespace="YAF.Utils" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Utils.Helpers" %>
<%@ Import Namespace="YAF.Types.Extensions" %>
<span class="hidden">
    <YAF:PageLinks ID="PageLinks" runat="server" />
</span>
<YAF:AdminMenu ID="Adminmenu1" runat="server">
    <asp:PlaceHolder ID="UpdateHightlight" runat="server" Visible="false">
        <div class="alert alert-info alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>">
            <h4><i class="icon fa fa-info"></i>Alert!</h4>
            <asp:HyperLink ID="UpdateLinkHighlight" runat="server" Target="_blank"></asp:HyperLink>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="UpdateWarning" runat="server" Visible="false">
        <div class="alert alert-warning alert-dismissible" style="margin-bottom: 20px; padding: 0 .7em;">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
            <h4><i class="icon fa fa-ban"></i>Alert!</h4>
            <asp:HyperLink ID="UpdateLinkWarning" runat="server" Target="_blank"></asp:HyperLink>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server" ID="UnverifiedUsersHolder">
        <div id="UnverifiedUsers" class="box box-success">
            <div class="box-header with-border">
                <strong>
                    <YAF:LocalizedLabel ID="LocalizedLabel19" runat="server" LocalizedTag="HEADER2" LocalizedPage="ADMIN_ADMIN" />
                </strong>
            </div>
            <div class="box-body">
                <asp:Repeater ID="UserList" runat="server" OnItemCommand="UserList_ItemCommand">
                    <HeaderTemplate>
                        <div class="col-xs-2 col-xxs-4 no-padding">
                            <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="ADMIN_NAME"
                                LocalizedPage="ADMIN_ADMIN" />
                        </div>
                        <div class="col-xs-3 col-xxs-4 no-padding">
                            <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedTag="ADMIN_EMAIL"
                                LocalizedPage="ADMIN_ADMIN" />
                        </div>
                        <div class="col-xs-2 hidden-xxs no-padding">
                            <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="LOCATION" />
                        </div>
                        <div class="col-xs-2 hidden-xxs no-padding">
                            <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" LocalizedTag="ADMIN_JOINED"
                                LocalizedPage="ADMIN_ADMIN" />
                        </div>
                        <div class="col-xs-3 col-xxs-4 no-padding">
                            <br />
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-xs-2 col-xxs-4 no-padding">
                            <YAF:UserLink ID="UnverifiedUserLink" UserID='<%# Eval("UserID") %>' Style='<%# Eval("Style") %>' runat="server" />
                        </div>
                        <div class="col-xs-3 col-xxs-4 no-padding">
                            <%# Eval("Email") %>
                        </div>
                        <div class="col-xs-2 hidden-xxs no-padding">
                            <%# this.SetLocation(Eval("Name").ToString())%>
                        </div>
                        <div class="col-xs-2 hidden-xxs no-padding">
                            <%# this.Get<IDateTime>().FormatDateTime((DateTime)this.Eval("Joined")) %>
                        </div>
                        <div class="col-xs-3 col-xxs-4 no-padding">
                            <asp:LinkButton runat="server" CommandName="resendEmail" CommandArgument='<%# Eval("Email") + ";" + Eval("Name") %>'
                                CssClass="btn btn-success btn-xs">
                                <YAF:LocalizedLabel ID="LocalizedLabel20" runat="server" LocalizedTag="ADMIN_RESEND_EMAIL"
                                    LocalizedPage="ADMIN_ADMIN" />
                            </asp:LinkButton>
                            <asp:LinkButton OnLoad="Approve_Load" runat="server" CommandName="approve" CommandArgument='<%# Eval("UserID") %>'
                                CssClass="btn btn-success btn-xs">
                                <YAF:LocalizedLabel ID="LocalizedLabel8" runat="server" LocalizedTag="ADMIN_APPROVE"
                                    LocalizedPage="ADMIN_ADMIN">
                                </YAF:LocalizedLabel>
                            </asp:LinkButton>
                            <asp:LinkButton OnLoad="Delete_Load" runat="server" CommandName="delete" CommandArgument='<%# Eval("UserID") %>'
                                CssClass="btn btn-success btn-xs">
                                <YAF:LocalizedLabel ID="LocalizedLabel22" runat="server" LocalizedTag="ADMIN_DELETE"
                                    LocalizedPage="ADMIN_ADMIN" />
                            </asp:LinkButton>
                        </div>
                        <div class="clearfix"></div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div id="UnverifiedUsersPager" class="col-xs-12 text-center">
                            <a href="#" class="first pagelink"><span>&lt;&lt;</span></a>
                            <a href="#" class="prev pagelink"><span>&lt;</span></a>
                            <input type="text" class="pagedisplay" />
                            <a href="#" class="next pagelink"><span>&gt;</span></a>
                            <a href="#" class="last pagelink"><span>&gt;&gt;</span></a>
                            <select class="pagesize">
                                <option selected="selected" value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                            </select>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
            <div class="box-footer with-border text-center">
                <asp:Button OnLoad="ApproveAll_Load" CommandName="approveall" CssClass="btn btn-success" runat="server" />
                <asp:Button OnLoad="DeleteAll_Load" CommandName="deleteall" CssClass="btn btn-success" runat="server" />
                <asp:TextBox ID="DaysOld" runat="server" MaxLength="5" Text="14" CssClass="form-control d-inline-block" Width="70" type="number"></asp:TextBox>
            </div>
        </div>
    </asp:PlaceHolder>
    <div class="box box-success">
        <div class="box-header">
            <strong><YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="HEADER3" LocalizedPage="ADMIN_ADMIN" /></strong>
            <span runat="server" id="boardSelector" visible='<%# this.PageContext.IsHostAdmin %>'>
                <asp:DropDownList ID="BoardStatsSelect" runat="server" DataTextField="Name" DataValueField="BoardID"
                    OnSelectedIndexChanged="BoardStatsSelect_Changed" AutoPostBack="true" CssClass="form-control" Width="150" />
            </span>
        </div>
        <div class="box-body">
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel18" runat="server" LocalizedTag="NUM_POSTS"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="NumPosts" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel17" runat="server" LocalizedTag="POSTS_DAY"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="DayPosts" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel16" runat="server" LocalizedTag="NUM_TOPICS"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="NumTopics" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel15" runat="server" LocalizedTag="TOPICS_DAY"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="DayTopics" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel14" runat="server" LocalizedTag="NUM_USERS"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="NumUsers" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel13" runat="server" LocalizedTag="USERS_DAY"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="DayUsers" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel12" runat="server" LocalizedTag="BOARD_STARTED"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="BoardStart" runat="server"></asp:Label>
            </div>
            <div class="col-xs-3 no-padding">
                <YAF:LocalizedLabel ID="LocalizedLabel11" runat="server" LocalizedTag="SIZE_DATABASE"
                    LocalizedPage="ADMIN_ADMIN" />
            </div>
            <div class="col-xs-3 no-padding">
                <asp:Label ID="DBSize" runat="server"></asp:Label>
            </div>
        </div>
        <div class="box-footer">
            <YAF:LocalizedLabel ID="LocalizedLabel10" runat="server" LocalizedTag="STATS_DONTCOUNT"
                    LocalizedPage="ADMIN_ADMIN" />
        </div>
    </div>

    <div id="UpgradeNotice" runat="server" visible="false" class="alert alert-info alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>">
        <h4><i class="icon fa fa-info"></i>Alert!</h4>
        <YAF:LocalizedLabel ID="LocalizedLabel9" runat="server" LocalizedTag="ADMIN_UPGRADE"
            LocalizedPage="ADMIN_ADMIN" />
    </div>

    <div class="box box-success">
        <div class="box-header with-border">
            <strong><YAF:LocalizedLabel ID="LocalizedLabel21" runat="server" LocalizedTag="HEADER1" LocalizedPage="ADMIN_ADMIN" /></strong>
        </div>
        <div id="ActiveUsers" class="box-body">
            <asp:Repeater ID="ActiveList" runat="server">
                    <HeaderTemplate>
                        <div class="col-xs-3 no-padding">
                            <strong><YAF:LocalizedLabel ID="LocalizedLabel2" runat="server"
                                LocalizedTag="ADMIN_NAME" LocalizedPage="ADMIN_ADMIN" /></strong>
                        </div>
                        <div class="col-xs-3 no-padding">
                            <strong><YAF:LocalizedLabel ID="LocalizedLabel3" runat="server"
                                LocalizedTag="ADMIN_IPADRESS" LocalizedPage="ADMIN_ADMIN" /></strong>
                        </div>
                        <div class="col-xs-3 no-padding">
                            <strong><YAF:LocalizedLabel ID="LocalizedLabel4" runat="server"
                                LocalizedTag="LOCATION" /></strong>
                        </div>
                        <div class="col-xs-3 no-padding">
                            <strong><YAF:LocalizedLabel ID="LocalizedLabel5" runat="server"
                                LocalizedTag="BOARD_LOCATION" LocalizedPage="ADMIN_ADMIN" /></strong>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-xs-3 no-padding">
                            <YAF:UserLink ID="ActiveUserLink" UserID='<%# Eval("UserID") %>' CrawlerName='<%# this.Eval("IsCrawler").ToType<int>() > 0 ? Eval("Browser").ToString() : String.Empty %>'
                                Style='<%# Eval("Style") %>' runat="server" />
                        </div>
                        <div class="col-xs-3 no-padding">
                            <a id="A1" href='<%# this.Get<YafBoardSettings>().IPInfoPageURL.FormatWith(IPHelper.GetIp4Address(this.Eval("IP").ToString())) %>'
                                title='<%# this.GetText("COMMON","TT_IPDETAILS") %>' target="_blank" runat="server">
                            <%# IPHelper.GetIp4Address(Eval("IP").ToString())%></a>
                        </div>
                        <div class="col-xs-3 no-padding">
                            <%# this.SetLocation(Eval("UserName").ToString())%>
                        </div>
                        <div class="col-xs-3 no-padding">
                            <YAF:ActiveLocation ID="ActiveLocation2" UserID='<%# ((this.Eval("UserID") == DBNull.Value)? 0 : this.Eval("UserID")).ToType<int>() %>'
                                UserName='<%# Eval("UserName") %>' ForumPage='<%# Eval("ForumPage") %>' ForumID='<%# ((this.Eval("ForumID") == DBNull.Value)? 0 : this.Eval("ForumID")).ToType<int>() %>'
                                ForumName='<%# Eval("ForumName") %>' TopicID='<%# ((this.Eval("TopicID") == DBNull.Value)? 0 : this.Eval("TopicID")).ToType<int>() %>'
                                TopicName='<%# Eval("TopicName") %>' LastLinkOnly="false" runat="server">
                            </YAF:ActiveLocation>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                        <div id="ActiveUsersPager" class="box-footer with-border text-center">
                            <a href="#" class="first pagelink"><span>&lt;&lt;</span></a>
                            <a href="#" class="prev pagelink"><span>&lt;</span></a>
                            <input type="text" class="pagedisplay" />
                            <a href="#" class="next pagelink"><span>&gt;</span></a>
                            <a href="#" class="last pagelink"><span>&gt;&gt;</span></a>
                            <select class="pagesize">
                                <option selected="selected" value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                            </select>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
</YAF:AdminMenu>
<YAF:SmartScroller ID="SmartScroller1" runat="server" />

