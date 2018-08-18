<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" Inherits="YAF.Controls.ProfileYourAccount"
    CodeBehind="ProfileYourAccount.ascx.cs" %>
<h2>
    <YAF:LocalizedLabel ID="YourAccountLocalized" runat="server" LocalizedTag="YOUR_ACCOUNT" />
</h2>
<div class="col-sm-10">
    <dl class="dl-horizontal">
        <dt>
            <YAF:LocalizedLabel ID="YourUsernameLocalized" runat="server" LocalizedTag="YOUR_USERNAME" />
        </dt>
        <dd>
            <asp:Label ID="Name" runat="server" />
        </dd>
        <asp:PlaceHolder ID="DisplayNameHolder" runat="server">
            <dt>
                <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="YOUR_USERDISPLAYNAME" />
            </dt>
            <dd>
                <asp:Label ID="DisplayName" runat="server" />
            </dd>
        </asp:PlaceHolder>
        <dt>
            <YAF:LocalizedLabel ID="YourEmailLocalized" runat="server" LocalizedTag="YOUR_EMAIL" />
        </dt>
        <dd>
            <asp:Label ID="AccountEmail" runat="server" />
        </dd>
        <dt>
            <YAF:LocalizedLabel ID="NumPostsLocalized" runat="server" LocalizedTag="NUMPOSTS" />
        </dt>
        <dd>
            <asp:Label ID="NumPosts" runat="server" />
        </dd>
        <dt>
            <YAF:LocalizedLabel ID="GroupsLocalized" runat="server" LocalizedTag="GROUPS" />
        </dt>
        <dd>
            <asp:Repeater ID="Groups" runat="server">
                <ItemTemplate>
                    <span runat="server" style='<%# DataBinder.Eval(Container.DataItem,"Style") %>'>
                        <%# DataBinder.Eval(Container.DataItem,"Name") %></span>
                </ItemTemplate>
                <SeparatorTemplate>
                    ,
                </SeparatorTemplate>
            </asp:Repeater>
        </dd>
        <dt>
            <YAF:LocalizedLabel ID="JoinedLocalized" runat="server" LocalizedTag="JOINED" />
        </dt>
        <dd>
            <asp:Label ID="Joined" runat="server" />
        </dd>
    </dl>
</div>
<div class="col-sm-2">
    <asp:Image runat="server" ID="AvatarImage" CssClass="avatarimage img-rounded" AlternateText="avatar" />
</div>
