<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="YafHeader.ascx.cs" Inherits="YAF.Controls.YafHeader" %>
<div id="yafheader" class="hidden">
    <asp:Panel ID="GuestUserMessage" CssClass="guestUser" runat="server" Visible="false">
        <asp:Label ID="GuestMessage" runat="server"></asp:Label>
    </asp:Panel>
    <div class="box box-success">
        <div class="box-body">
            <asp:Panel ID="LoggedInUserPanel" CssClass="loggedInUser" runat="server" Visible="false">
            </asp:Panel>
            <asp:Panel ID="UserContainer" CssClass="menuMyContainer" runat="server" Visible="false">
                <ul class="menuMyList">
                    <li class="menuMy myProfile">
                        <asp:HyperLink ID="MyProfile" runat="server" Target="_top"></asp:HyperLink>
                    </li>
                    <asp:PlaceHolder ID="MyInboxItem" runat="server" Visible="false"></asp:PlaceHolder>
                    <asp:PlaceHolder ID="MyBuddiesItem" runat="server"></asp:PlaceHolder>
                    <asp:PlaceHolder ID="MyAlbumsItem" runat="server" Visible="false"></asp:PlaceHolder>
                    <asp:PlaceHolder ID="MyTopicItem" runat="server" Visible="false"></asp:PlaceHolder>
                    <asp:PlaceHolder ID="LogutItem" runat="server" Visible="false">
                        <li class="menuAccount hidden">
                            <asp:LinkButton ID="LogOutButton" runat="server" OnClick="LogOutClick" OnClientClick="createCookie('ScrollPosition',document.all ? document.scrollTop : window.pageYOffset);"></asp:LinkButton>
                        </li>
                    </asp:PlaceHolder>
                </ul>
            </asp:Panel>
            <div class="menuContainer pull-left-md">
                <ul class="menuList">
                    <asp:PlaceHolder ID="menuListItems" runat="server"></asp:PlaceHolder>
                </ul>
                <script>$(".menuList li:nth-child(2)").addClass("hidden");</script>
                <asp:Panel ID="quickSearch" runat="server" CssClass="QuickSearch hidden" Visible="false">
                    <asp:TextBox ID="searchInput" runat="server"></asp:TextBox>&nbsp;
               <asp:LinkButton ID="doQuickSearch" onkeydown="" runat="server" CssClass="QuickSearchButton"
                   OnClick="QuickSearchClick">
               </asp:LinkButton>
                </asp:Panel>
                <asp:PlaceHolder ID="AdminModHolder" runat="server" Visible="false">
                    <ul class="menuAdminList">
                        <asp:PlaceHolder ID="menuAdminItems" runat="server"></asp:PlaceHolder>
                    </ul>
                </asp:PlaceHolder>
            </div>
        </div>
    </div>
    <div id="yafheaderEnd">
    </div>
</div>
