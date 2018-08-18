<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Controls.DisplayPost" EnableViewState="false" CodeBehind="DisplayPost.ascx.cs" %>
<%@ Register TagPrefix="YAF" TagName="DisplayPostFooter" Src="DisplayPostFooter.ascx" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Core.Services" %>
<%@ Import Namespace="YAF.Types.Constants" %>
<%@ Import Namespace="YAF.Utils" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Types.Extensions" %>
<div class="box-header with-border" style="padding-bottom: 0;">
    <table width="100%">
        <tr>
            <td id="NameCell" class="postUser" runat="server">
                <div class="col-xs-6 col-xxs-12 no-padding">
                    <strong>
                        <YAF:OnlineStatusImage ID="OnlineStatusImage" runat="server" Visible='<%# this.Get<YafBoardSettings>().ShowUserOnlineStatus && !UserMembershipHelper.IsGuestUser( DataRow["UserID"] )%>' Style="vertical-align: bottom" UserID='<%# DataRow["UserID"] %>' />
                        <YAF:ThemeImage ID="ThemeImgSuspended" ThemePage="ICONS" ThemeTag="USER_SUSPENDED" UseTitleForEmptyAlt="True" Enabled='<%# DataRow["Suspended"] != DBNull.Value && DataRow["Suspended"].ToType<DateTime>() > DateTime.UtcNow %>' runat="server"></YAF:ThemeImage>
                        <YAF:UserLink ID="UserProfileLink" runat="server" UserID='<%# DataRow["UserID"]%>' ReplaceName='<%# this.Get<YafBoardSettings>().EnableDisplayName && (!DataRow["IsGuest"].ToType<bool>() || (DataRow["IsGuest"].ToType<bool>() && DataRow["DisplayName"].ToString() == DataRow["UserName"].ToString())) ? DataRow["DisplayName"] : DataRow["UserName"]%>' PostfixText='<%# DataRow["IP"].ToString() == "NNTP" ? this.GetText("EXTERNALUSER") : String.Empty %>' Style='<%#DataRow["Style"]%>' CssClass="UserPopMenuLink" EnableHoverCard="False" />
                    </strong>
                    &nbsp;<YAF:ThemeButton ID="AddReputation" CssClass='<%# "AddReputation_" + DataRow["UserID"]%>' runat="server" ImageThemeTag="VOTE_UP" Visible="false" TitleLocalizedTag="VOTE_UP_TITLE" OnClick="AddUserReputation"></YAF:ThemeButton>
                    <YAF:ThemeButton ID="RemoveReputation" CssClass='<%# "RemoveReputation_" + DataRow["UserID"]%>' runat="server" ImageThemeTag="VOTE_DOWN" Visible="false" TitleLocalizedTag="VOTE_DOWN_TITLE" OnClick="RemoveUserReputation"></YAF:ThemeButton>
                    <span class="hidden-xxs">
                        <br />
                        <br />
                    </span>
                    <strong><a id="post<%# DataRow["MessageID"] %>" name="post<%# DataRow["MessageID"] %>" href='<%# YafBuildLink.GetLink(ForumPages.posts,"m={0}#post{0}",DataRow["MessageID"]) %>'>#<%# (CurrentPage * this.Get<YafBoardSettings>().PostsPerPage) + PostCount + 1%></a>
                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="POSTED" />
                        :</strong>
                    <YAF:DisplayDateTime ID="DisplayDateTime" runat="server" DateTime='<%# DataRow["Posted"] %>'></YAF:DisplayDateTime>
                    <YAF:PopMenu runat="server" ID="PopMenu1" Control="UserName" />
                    <script>
                        $("#<%= PopMenu1.ClientID %>").find("li.popupitem")[2].remove();
                    </script>
                </div>
                <div class="col-xs-6 col-xxs-12 text-right no-padding">
                    <span class="hidden">
                        <YAF:ThemeButton ID="Retweet" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_RETWEET"
                            TitleLocalizedTag="BUTTON_RETWEET_TT" OnClick="Retweet_Click" />
                    </span>
                    <span id="<%# "dvThankBox" + DataRow["MessageID"] %>">
                        <YAF:ThemeButton ID="Thank" runat="server" CssClass="btn btn-success btn-sm" Visible="false" TextLocalizedTag="BUTTON_THANKS"
                            TitleLocalizedTag="BUTTON_THANKS_TT" />
                    </span>
                    <YAF:ThemeButton ID="Edit" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_EDIT"
                        TitleLocalizedTag="BUTTON_EDIT_TT" />
                    <YAF:ThemeButton ID="MovePost" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_MOVE"
                        TitleLocalizedTag="BUTTON_MOVE_TT" />
                    <YAF:ThemeButton ID="Delete" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_DELETE"
                        TitleLocalizedTag="BUTTON_DELETE_TT" />
                    <YAF:ThemeButton ID="UnDelete" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_UNDELETE"
                        TitleLocalizedTag="BUTTON_UNDELETE_TT" />
                    <YAF:ThemeButton ID="Quote" runat="server" CssClass="btn btn-success btn-sm" TextLocalizedTag="BUTTON_QUOTE"
                        TitleLocalizedTag="BUTTON_QUOTE_TT" />
                    <br />
                    <asp:CheckBox runat="server" ID="MultiQuote" />
                </div>
            </td>
        </tr>
    </table>
</div>
<div class="box-body">
    <div class="col-xs-3 col-xxs-12">
        <YAF:UserBox ID="UserBox1" runat="server" Visible="<%# !PostData.IsSponserMessage %>" PageCache="<%# PageContext.CurrentForumPage.PageCache %>" DataRow='<%# DataRow %>'></YAF:UserBox>
    </div>
    <div class="col-xs-9 col-xxs-12">
        <asp:Panel ID="panMessage" runat="server">
            <YAF:MessagePostData runat="server" DataRow="<%# DataRow %>" IsAltMessage="<%# this.IsAlt %>" ColSpan="<%#GetIndentSpan()%>" ShowEditMessage="True"></YAF:MessagePostData>
        </asp:Panel>
    </div>
</div>
<div class="body-footer">
    <div class="col-xs-3 col-xxs-6">
        <div id="<%# "dvThanksInfo" + DataRow["MessageID"] %>" class="ThanksInfo">
            <asp:Literal runat="server" Visible="false" ID="ThanksDataLiteral"></asp:Literal>
        </div>
    </div>
    <div class="col-xs-3 col-xxs-6">
        <div id="<%# "dvThanks" + DataRow["MessageID"] %>" class="ThanksList">
            <asp:Literal runat="server" Visible="false" ID="thanksDataExtendedLiteral"></asp:Literal>
        </div>
    </div>
    <div class="col-xs-6 col-xxs-12" style="padding-bottom:5px;">
        <div class="valign pull-right">
            <span id="IPSpan1" runat="server" visible="false">
                <i class="fa fa-map-marker"></i><a id="IPLink1" target="_blank" runat="server" />
            </span>&nbsp; &nbsp; 
            <a onclick="ScrollToTop();" class="postTopLink" href="javascript: void(0)">
                <i class="fa fa-arrow-circle-up fa-2x"></i>
                <span class="hidden">
                    <YAF:ThemeImage LocalizedTitlePage="POSTS" LocalizedTitleTag="TOP" runat="server" ThemeTag="TOTOPPOST" />
                </span>
            </a>&nbsp; &nbsp; 
            <YAF:DisplayPostFooter ID="PostFooter" runat="server" DataRow="<%# DataRow %>"></YAF:DisplayPostFooter>
        </div>
    </div>
</div>
