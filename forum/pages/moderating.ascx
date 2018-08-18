<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.moderating" CodeBehind="moderating.ascx.cs" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<%@ Register TagPrefix="YAF" TagName="TopicLine" Src="../controls/TopicLine.ascx" %>

<div class="col-xs-12">
    <asp:PlaceHolder runat="server" ID="ModerateUsersHolder">
        <div class="box box-success content">
            <div class="box-header">
                <h3 class="box-title">
                    <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="MEMBERS" LocalizedPage="MODERATE" />
                </h3>
            </div>
            <div class="box-body">
                <div class="col-xs-12 header2">
                    <div class="col-xs-3">
                        <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="USER" LocalizedPage="MODERATE" />
                    </div>
                    <div class="col-xs-3 text-center">
                        <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="ACCEPTED" LocalizedPage="MODERATE" />
                    </div>
                    <div class="col-xs-3">
                        <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="ACCESSMASK" LocalizedPage="MODERATE" />
                    </div>
                </div>
                <asp:Repeater runat="server" ID="UserList" OnItemCommand="UserList_ItemCommand">
                    <ItemTemplate>
                        <div class="col-xs-12 post">
                            <div class="col-xs-3">
                                <%# this.Get<YafBoardSettings>().EnableDisplayName ? Eval("DisplayName") : Eval("DisplayName") %>
                            </div>
                            <div class="col-xs-3">
                                <%# Eval("Accepted") %>
                            </div>
                            <div class="col-xs-3">
                                <%# Eval("Access") %>
                            </div>
                            <div class="col-xs-3">
                                <YAF:ThemeButton ID="ThemeButtonEdit" CssClass="btn btn-small btn-success" CommandName='edit' CommandArgument='<%# Eval("UserID") %>' TitleLocalizedTag="EDIT" ImageThemePage="ICONS" ImageThemeTag="EDIT_SMALL_ICON" runat="server"></YAF:ThemeButton>
                                <YAF:ThemeButton ID="ThemeButtonRemove" CssClass="btn btn-small btn-success" OnLoad="DeleteUser_Load" CommandName='remove' CommandArgument='<%#Eval("UserID") %>' TitleLocalizedTag="REMOVE" ImageThemePage="ICONS" ImageThemeTag="DELETE_SMALL_ICON" runat="server"></YAF:ThemeButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="box-footer">
                <asp:Button runat="server" ID="AddUser" Text="Invite User" OnClick="AddUser_Click" CssClass="btn btn-small btn-success" />
            </div>
        </div>
    </asp:PlaceHolder>
    <YAF:ThemeButton ID="DeleteTopic" runat="server" CssClass="btn btn-small btn-success pull-right" TextLocalizedTag="BUTTON_DELETETOPIC" TitleLocalizedTag="BUTTON_DELETETOPIC_TT" OnLoad="Delete_Load" OnClick="DeleteTopics_Click" />
    <YAF:Pager ID="PagerTop" runat="server" OnPageChange="PagerTop_PageChange" UsePostBack="True" />

    <div class="box box-success content">
        <div class="box-header">
            <h3 class="box-title">
                <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" LocalizedTag="title" LocalizedPage="MODERATE" />
            </h3>
        </div>
        <div class="box-body">
            <div class="col-xs-12 header2">
                <div class="col-xs-1"></div>
                <div class="col-xs-1"></div>
                <div class="col-xs-3">
                    <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedTag="topics" LocalizedPage="MODERATE" />
                </div>
                <div class="col-xs-2 text-center">
                    <YAF:LocalizedLabel ID="LocalizedLabel8" runat="server" LocalizedTag="replies" LocalizedPage="MODERATE" />
                </div>
                <div class="col-xs-2 text-center">
                    <YAF:LocalizedLabel ID="LocalizedLabel9" runat="server" LocalizedTag="views" LocalizedPage="MODERATE" />
                </div>
                <div class="col-xs-3 text-center">
                    <YAF:LocalizedLabel ID="LocalizedLabel10" runat="server" LocalizedTag="lastpost" LocalizedPage="MODERATE" />
                </div>
            </div>
            <asp:Repeater ID="topiclist" runat="server" OnItemCommand="topiclist_ItemCommand">
                <ItemTemplate>
                    <YAF:TopicLine runat="server" DataRow="<%# Container.DataItem %>" AllowSelection="true" />
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <YAF:ThemeButton ID="DeleteTopics2" runat="server" CssClass="btn btn-small btn-success pull-right" TextLocalizedTag="BUTTON_DELETETOPIC" TitleLocalizedTag="BUTTON_DELETETOPIC_TT" OnLoad="Delete_Load" OnClick="DeleteTopics_Click" />
    <YAF:Pager ID="PagerBottom" runat="server" LinkedPager="PagerTop" UsePostBack="True" />
    <div id="DivSmartScroller">
        <YAF:SmartScroller ID="SmartScroller1" runat="server" />
    </div>
</div>
