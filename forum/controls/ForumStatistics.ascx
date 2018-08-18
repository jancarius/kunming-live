<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false"
    Inherits="YAF.Controls.ForumStatistics" CodeBehind="ForumStatistics.ascx.cs" %>
<asp:UpdatePanel ID="UpdateStatsPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        
    </ContentTemplate>
</asp:UpdatePanel>
        <div class="box box-success">
            <div class="box-header with-border ui-sortable-handle draggable">
                <h3 class="box-title">
                    <YAF:LocalizedLabel ID="InformationHeader" runat="server" LocalizedTag="INFORMATION" />
                </h3>
                <div class="pull-right box-tools">
                    <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                    <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                        <i class="fa fa-times"></i>
                    </button>
                </div>
            </div>
            <div class="box-body">
                <asp:PlaceHolder runat="server" ID="InformationPlaceHolder">
                    <div class="col-xs-12">
                        <strong>
                            <YAF:LocalizedLabel ID="ActiveUsersLabel" runat="server" LocalizedTag="ACTIVE_USERS" />
                        </strong>
                        <br />
                        <i class="fa fa-users fa-2x pull-left margin" style="margin-bottom: 0;"></i>
                        <asp:Label runat="server" ID="ActiveUserCount" />
                        <br />
                        <asp:Label runat="server" ID="MostUsersCount" />
                        <br />
                        <YAF:ActiveUsers ID="ActiveUsers1" runat="server">
                        </YAF:ActiveUsers>
                    </div>
                    <asp:PlaceHolder runat="server" ID="RecentUsersPlaceHolder" Visible="False">
                        <div class="col-xs-12">
                            <strong>
                                <YAF:LocalizedLabel ID="RecentUsersLabel" runat="server" LocalizedTag="RECENT_USERS" />
                            </strong>
                            <br />
                            <i class="fa fa-user-times fa-2x pull-left margin" style="margin-bottom: 0;"></i>
                            <asp:Label runat="server" ID="RecentUsersCount" />
                            <br />
                            <YAF:ActiveUsers ID="RecentUsers" runat="server" InstantId="RecentUsersOneDay" Visible="False"></YAF:ActiveUsers>
                        </div>
                    </asp:PlaceHolder>
                    <div class="col-xs-12">
                        <strong>
                            <YAF:LocalizedLabel ID="StatsHeader" runat="server" LocalizedTag="STATS" />
                        </strong>
                        <br />
                        <i class="fa fa-bar-chart fa-2x pull-left margin" style="margin-bottom: 0;"></i>
                        <asp:Label ID="StatsPostsTopicCount" runat="server" /><br />
                        <asp:PlaceHolder runat="server" ID="StatsLastPostHolder" Visible="False">
                            <asp:Label ID="StatsLastPost" runat="server" />&nbsp;<YAF:UserLink ID="LastPostUserLink" runat="server" />
                            <br />
                        </asp:PlaceHolder>
                        <asp:Label ID="StatsMembersCount" runat="server" /><br />
                        <asp:Label ID="StatsNewestMember" runat="server" />&nbsp;<YAF:UserLink ID="NewestMemberUserLink" runat="server" />
                        <br />
                        <asp:PlaceHolder ID="BirthdayUsers" runat="server" Visible="false">
                            <asp:Label ID="StatsTodaysBirthdays" runat="server" />
                        </asp:PlaceHolder>
                    </div>
                </asp:PlaceHolder>
            </div>
            <div class="box-footer with-border text-right">
                <a href="statistics.aspx" class="btn btn-success btn-flat">View All Stats</a>
            </div>
        </div>
        <YAF:ThemeImage ID="ForumStatsImage" runat="server" ThemeTag="FORUM_STATS" CssClass="hidden" />
        <YAF:ThemeImage ID="ForumUsersImage" runat="server" ThemeTag="FORUM_USERS" CssClass="hidden" />
        <YAF:CollapsibleImage ID="CollapsibleImage" runat="server" BorderWidth="0" Style="vertical-align: middle; display: none;"
                    PanelID='InformationPanel' AttachedControlID="InformationPlaceHolder" Visible="false" />