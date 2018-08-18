<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.forum" CodeBehind="forum.ascx.cs" %>
<%@ Register TagPrefix="YAF" TagName="ForumWelcome" Src="../controls/ForumWelcome.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumIconLegend" Src="../controls/ForumIconLegend.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumStatistics" Src="../controls/ForumStatistics.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumActiveDiscussion" Src="../controls/ForumActiveDiscussion.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ForumCategoryList" Src="../controls/ForumCategoryList.ascx" %>
<%@ Register TagPrefix="YAF" TagName="ShoutBox" Src="../controls/ShoutBox.ascx" %>
<%@ Register TagPrefix="YAF" TagName="PollList" Src="../controls/PollList.ascx" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<!-- Hidden -->
<asp:PlaceHolder ID="AdminModHolder2" runat="server">
    <ul class="menuAdminList hidden">
        <asp:PlaceHolder ID="menuAdminItems2" runat="server"></asp:PlaceHolder>
    </ul>
</asp:PlaceHolder>
<div class="col-xs-3 pull-right hidden">
    <YAF:ForumWelcome runat="server" ID="Welcome" />
</div>
<YAF:ShoutBox ID="ShoutBox1" runat="server" />
<YAF:PollList ID="PollList" runat="server" Visible="false" />
<!-- /Hidden -->
<div class="col-xs-12">
    <YAF:ForumCategoryList ID="ForumCategoryList" runat="server"></YAF:ForumCategoryList>
</div>
<div class="clearfix"></div>
<div class="col-md-8 col-xs-12">
    <YAF:ForumActiveDiscussion ID="ActiveDiscussions" runat="server" />
</div>
<div class="col-md-4 col-xs-12">
    <YAF:ForumStatistics ID="ForumStats" runat="Server" />
</div>
<YAF:ForumIconLegend ID="IconLegend" runat="server" Visible="false" />
<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
