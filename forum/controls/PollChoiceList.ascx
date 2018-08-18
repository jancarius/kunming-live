<%@ Control Language="C#" AutoEventWireup="True" EnableViewState="false" CodeBehind="PollChoiceList.ascx.cs"
    Inherits="YAF.Controls.PollChoiceList" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<asp:Repeater ID="Poll" runat="server" OnItemDataBound="Poll_OnItemDataBound" OnItemCommand="Poll_ItemCommand"
    Visible="true" DataSource="<%# this.DataSource %>">
    <HeaderTemplate>
    </HeaderTemplate>
    <ItemTemplate>
        <table width="100%">
            <tr id="VoteTr" runat="server">
                <td class="valign">
                    <div class="col-xs-1 no-padding">
                        <a id="ChoiceAnchor" runat="server" title='<%# this.HtmlEncode(this.Get<IBadWordReplace>().Replace(Convert.ToString(DataBinder.Eval(Container.DataItem, "Choice")))) %>' class="hidden">
                            <img id="ChoiceImage" src="" alt='<%# this.HtmlEncode(this.Get<IBadWordReplace>().Replace(Convert.ToString(DataBinder.Eval(Container.DataItem, "Choice")))) %>' runat="server" />
                        </a>
                        <i class="fa fa-arrow-circle-right fa-2x"></i>
                    </div>
                    <div class="col-xs-5 no-padding">
                        <img id="YourChoice" visible="false" runat="server" alt='<%# this.GetText("POLLEDIT", "POLL_VOTED") %>'
                            title='<%# this.GetText("POLLEDIT", "POLL_VOTED") %>'
                            width="16" height="16" src='<%# GetThemeContents("VOTE","POLL_VOTED") %>' />&nbsp; 
                        <YAF:MyLinkButton ID="MyLinkButton1" Enabled="false" runat="server" CommandName="vote"
                            CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ChoiceID") %>' Text='<%# this.HtmlEncode(this.Get<IBadWordReplace>().Replace(Convert.ToString(DataBinder.Eval(Container.DataItem, "Choice")))) %>' />
                    </div>
                    <div class="col-xs-2 no-padding">
                        <asp:Panel ID="VoteSpan" Visible="false" runat="server">
                            <%# DataBinder.Eval(Container.DataItem, "Votes") %>
                        </asp:Panel>
                        <asp:Panel ID="MaskSpan" Visible="false" runat="server">
                            <img alt='<%# this.GetText("POLLEDIT", "POLLRESULTSHIDDEN_SHORT") %>'
                                title='<%# this.GetText("POLLEDIT", "POLLRESULTSHIDDEN_SHORT") %>'
                                src='<%# GetThemeContents("VOTE","POLL_MASK") %>' />
                        </asp:Panel>
                    </div>
                    <div class="col-xs-4 no-padding ">
                        <asp:Panel ID="resultsSpan" Visible="false" runat="server">
                            <img alt="" src="<%# GetThemeContents("VOTE","LCAP") %>" /><img id="Img1" alt="" src='<%# GetThemeContents("VOTE","BAR") %>'
						        height="12" width='<%# VoteWidth(Container.DataItem) %>' runat="server" /><img alt="" src='<%# GetThemeContents("VOTE","RCAP") %>' />
                        <%# DataBinder.Eval(Container.DataItem,"Stats") %>
                                        %
                        </asp:Panel>
                    </div>
                </td>
            </tr>
        </table>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
    </FooterTemplate>
</asp:Repeater>