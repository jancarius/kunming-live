<%@ Control Language="C#" AutoEventWireup="True" EnableViewState="false" CodeBehind="PollList.ascx.cs"
    Inherits="YAF.Controls.PollList" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Register TagPrefix="YAF" TagName="PollChoiceList" Src="PollChoiceList.ascx" %>
<asp:PlaceHolder ID="PollListHolder" runat="server" Visible="true">
    <asp:Repeater ID="PollGroup" OnItemCommand="PollGroup_ItemCommand" OnItemDataBound="PollGroup_OnItemDataBound"
        runat="server" Visible="true">
        <HeaderTemplate>
        </HeaderTemplate>
        <ItemTemplate>
            <div class="box box-success">
                <div class="box-header with-border">
                    <div class="col-xs-1 no-padding">
                        <a id="QuestionAnchor" runat="server" title='<%# GetPollQuestion(DataBinder.Eval(Container.DataItem, "PollID"))%>' class="hidden">
                            <img id="QuestionImage" src="" alt="" runat="server" />
                        </a>
                        <i class="fa fa-bar-chart" style="font-size:16px;"></i>
                    </div>
                    <div class="col-xs-11 no-padding">
                        <h4 class="no-margin no-padding">
                            <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="question" />
                            &nbsp;<asp:Label ID="QuestionLabel" Text='<%# GetPollQuestion(DataBinder.Eval(Container.DataItem, "PollID"))%>' runat="server"></asp:Label>
                        </h4>
                    </div>
                </div>
                <div class="box-body">
                    <div class="col-xs-1 no-padding">
                        <br />
                    </div>
                    <div class="col-xs-5 no-padding">
                        <strong>
                            <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="choice" />
                        </strong>
                    </div>
                    <div class="col-xs-2 no-padding">
                        <strong>
                            <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="votes" />
                        </strong>
                    </div>
                    <div class="col-xs-4 no-padding">
                        <strong>
                            <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="statistics" />
                        </strong>
                    </div>
                    <YAF:PollChoiceList ID="PollChoiceList1" runat="server" />
                </div>
                <div class="box-footer">
                    <div class="col-xs-1 no-padding">
                        <img id="PollClosedImage" title="" src="" alt="" visible="false" runat="server" />&nbsp; 
                              <YAF:ThemeButton ID="RefuseVoteButton" runat="server" Visible="false"
                                  CommandName="refuse" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PollID") %>' CssClass="yaflittlebutton rightItem" ImageThemePage="vote" ImageThemeTag="VOTE_REFUSE" TitleLocalizedTag="POLL_ALLOWSKIPVOTE_INFO" />
                    </div>
                    <div class="col-xs-5 no-padding">
                        <strong><%= this.GetText("total") %></strong>
                    </div>
                    <div class="col-xs-2 no-padding">
                        <strong><%# DataBinder.Eval(Container.DataItem, "Total") %></strong>
                    </div>
                    <div class="col-xs-4 no-padding">
                        <strong>100%</strong>
                    </div>
                    <table width="100%">
                        <tr id="PollInfoTr" runat="server" visible="false">
                            <td>
                                <asp:Label ID="PollNotification" Visible="false" runat="server" />
                            </td>
                        </tr>
                        <tr id="PollCommandRow" runat="server">
                            <td class="text-center">
                                <YAF:ThemeButton ID="RemovePollAll" runat="server" Visible="false" CommandName="removeall"
                                    CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PollID") %>' CssClass="btn btn-success btn-sm"
                                    TextLocalizedTag="REMOVEPOLL_ALL" />
                                <YAF:ThemeButton ID="RemovePoll" runat="server" Visible="false" CommandName="remove"
                                    CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PollID") %>' CssClass="btn btn-success btn-sm"
                                    TextLocalizedTag="REMOVEPOLL" />
                                <YAF:ThemeButton ID="EditPoll" runat="server" Visible='<%# CanEditPoll(DataBinder.Eval(Container.DataItem, "PollID")) %>'
                                    CommandName="edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PollID") %>'
                                    CssClass="btn btn-success btn-sm" TextLocalizedTag="EDITPOLL" />
                                <YAF:ThemeButton ID="CreatePoll" runat="server" Visible='<%# CanCreatePoll() %>'
                                    CommandName="new" CssClass="btn btn-success btn-sm" TextLocalizedTag="CREATEPOLL" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            <table width="100%">
                <tr id="PollGroupInfoTr" runat="server" visible="false">
                    <td class="text-center">
                        <asp:Label ID="PollGroupNotification" Visible="false" runat="server" />
                    </td>
                </tr>
                <tr id="PollGroupCommandRow" runat="server">
                    <td class="text-center">
                        <YAF:ThemeButton ID="RemoveGroupAll" runat="server" Visible='<%# CanRemoveGroupCompletely() %>'
                            CommandName="removegroupall" CssClass="btn btn-success btn-sm" TextLocalizedTag="REMOVEPOLLGROUP_ALL" />
                        <YAF:ThemeButton ID="RemoveGroupEverywhere" runat="server" Visible='<%# CanRemoveGroupEverywhere() %>'
                            CommandName="removegroupevery" CssClass="btn btn-success btn-sm" TextLocalizedTag="DETACHGROUP_EVERYWHERE" />
                        <YAF:ThemeButton ID="RemoveGroup" runat="server" Visible='<%# CanRemoveGroup() %>'
                            CommandName="removegroup" CssClass="btn btn-success btn-sm" TextLocalizedTag="DETACHPOLLGROUP" />
                    </td>
                </tr>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <table width="100%">
        <tr id="NewPollRow" runat="server" visible="false">
            <td>
                <YAF:ThemeButton ID="CreatePoll1" runat="server" CssClass="btn btn-success"
                    TextLocalizedTag="CREATEPOLL" />
            </td>
        </tr>
    </table>
</asp:PlaceHolder>
