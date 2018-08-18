<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="polledit.ascx.cs" Inherits="YAF.Pages.polledit" %>
<YAF:PageLinks ID="PageLinks" runat="server" />
<div class="box box-success">
    <div class="box-header with-border">
        <strong>
            <YAF:LocalizedLabel ID="PollNameLabel" runat="server" LocalizedPage="POLLEDIT" LocalizedTag="POLLHEADER" />
        </strong>
    </div>
    <div class="box-body">
        <table width="100%" class="form-horizontal">
            <tr id="PollRow1" runat="server" visible="true">
                <td>
                    <div class="form-group">
                        <label for="<%= Question.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="pollquestion" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:TextBox ID="Question" runat="server" CssClass="form-control" MaxLength="255" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="PollObjectRow1" runat="server" class="hidden" visible="<%# (PageContext.IsAdmin || PageContext.BoardSettings.AllowUsersImagedPoll) && PageContext.ForumPollAccess %>">
                <td>
                    <div class="form-group">
                        <label for="<%= QuestionObjectPath.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="PollQuestionObjectLabel" runat="server" LocalizedTag="POLLIMAGE_TEXT" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:TextBox ID="QuestionObjectPath" runat="server" CssClass="form-control" MaxLength="255" />
                        </div>
                    </div>
                </td>
            </tr>
            <asp:Repeater ID="ChoiceRepeater" runat="server" Visible="false">
                <HeaderTemplate>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class="poll-question-break">
                        <td>
                            <div class="with-border"><br /></div>
                        </td>
                    </tr>
                    <tr class="poll-question">
                        <td>
                            <div class="form-group">
                                <label class="col-xs-3 col-xxs-12 control-label">
                                    <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="choice" Param0='<%# DataBinder.Eval(Container.DataItem, "ChoiceOrderID") %>' />
                                </label>
                                <div class="col-xs-9 col-xxs-12">
                                    <asp:HiddenField ID="PollChoiceID" Value='<%# DataBinder.Eval(Container.DataItem, "ChoiceID") %>' runat="server" />
                                    <asp:TextBox ID="PollChoice" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Choice") %>' CssClass="form-control" MaxLength="50" />
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr id="ChoiceRow1" class="poll-question-image hidden" visible="<%# (PageContext.IsAdmin || PageContext.BoardSettings.AllowUsersImagedPoll) && PageContext.ForumPollAccess %>" runat="server">
                        <td>
                            <div class="form-group">
                                <label class="col-xs-3 col-xxs-12 control-label">
                                    <YAF:LocalizedLabel ID="PollChoiceObjectLabel" runat="server" LocalizedTag="POLLIMAGE_TEXT" />
                                </label>
                                <div class="col-xs-9 col-xxs-12">
                                    <asp:TextBox ID="ObjectPath" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ObjectPath") %>' CssClass="form-control" MaxLength="255" />
                                </div>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
            </asp:Repeater>
            <tr>
                <td>
                    <div class="with-border text-right">
                        <button id="pollQuestionAdd" class="btn btn-success btn-sm" type="button">Add</button>
                        <button id="pollQuestionRemove" class="btn btn-success btn-sm hidden" type="button">Remove</button>
                        <br />
                    </div>
                </td>
            </tr>
            <tr id="tr_AllowMultipleChoices" runat="server" visible="<%# PageContext.BoardSettings.AllowMultipleChoices %>">
                <td>
                    <div class="form-group">
                        <label for="<%= AllowMultipleChoicesCheckBox.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="AllowMultipleChoicesLabel" runat="server" LocalizedTag="POLL_MULTIPLECHOICES" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:CheckBox ID="AllowMultipleChoicesCheckBox" runat="server" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="tr_AllowSkipVote" runat="server" visible="<%# PageContext.BoardSettings.AllowMultipleChoices %>">
                <td>
                    <div class="form-group">
                        <label for="<%= AllowSkipVoteCheckBox.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="AllowSkipVoteLocalizedLabel" runat="server" LocalizedTag="POLL_MULTIPLECHOICES" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:CheckBox ID="AllowSkipVoteCheckBox" runat="server" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="tr_ShowVoters" runat="server" visible="true">
                <td>
                    <div class="form-group">
                        <label for="<%= ShowVotersCheckBox.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="ShowVotersLocalizedLabel" runat="server" LocalizedTag="POLL_SHOWVOTERS" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:CheckBox ID="ShowVotersCheckBox" runat="server" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="PollRowExpire" runat="server" visible="false">
                <td>
                    <div class="form-group">
                        <label for="<%= PollExpire.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="poll_expire" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:TextBox ID="PollExpire" runat="server" CssClass="form-control" MaxLength="10" />
                            <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="poll_expire_explain" Visible="false" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="IsBound" runat="server" visible="false">
                <td>
                    <div class="form-group">
                        <label for="<%= IsBoundCheckBox.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="IsBoundLabel" runat="server" LocalizedTag="POLLGROUP_BOUNDWARN" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:CheckBox ID="IsBoundCheckBox" runat="server" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="IsClosedBound" runat="server" visible="false">
                <td>
                    <div class="form-group">
                        <label for="<%= IsClosedBoundCheckBox.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="IsClosedBoundLabel" runat="server" LocalizedTag="pollgroup_closedbound" />
                            &nbsp;:&nbsp;
                            <YAF:LocalizedLabel ID="IsClosedBoundExplainLabel" runat="server" LocalizedTag="POLLGROUP_CLOSEDBOUND_WARN" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:CheckBox ID="IsClosedBoundCheckBox" runat="server" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr id="PollGroupList" runat="server" visible="false">
                <td>
                    <div class="form-group">
                        <label for="<%= PollGroupListDropDown.ClientID %>" class="col-xs-3 col-xxs-12 control-label">
                            <YAF:LocalizedLabel ID="PollGroupListLabel" runat="server" LocalizedTag="pollgroup_list" />
                        </label>
                        <div class="col-xs-9 col-xxs-12">
                            <asp:DropDownList ID="PollGroupListDropDown" runat="server" CssClass="form-control" MaxLength="10" />
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="box-footer with-border text-center">
        <YAF:ThemeButton ID="SavePoll" runat="server" CssClass="btn btn-success"
            OnClick="SavePoll_Click" TextLocalizedTag="POLLSAVE" />
        <YAF:ThemeButton ID="Cancel" runat="server" CssClass="btn btn-success"
            OnClick="Cancel_Click" TextLocalizedTag="CANCEL" />
    </div>
</div>
<script>
    var nextIndex = 2;
    var questions = $(".poll-question");
    var questionImages = $(".poll-question-image");
    var questionBreak = $(".poll-question-break");
    for (var i = 2; i < questions.length; i++) {
        $(questions[i]).addClass("hidden");
        $(questionBreak[i]).addClass("hidden");
    }
    $("#pollQuestionAdd").click(function () {
        $(questions[nextIndex]).removeClass("hidden");
        $(questionBreak[nextIndex]).removeClass("hidden");
        $(questions[nextIndex]).find("input").focus();
        nextIndex++;
        if (nextIndex == 3) {
            $("#pollQuestionRemove").removeClass("hidden");
        }
        if (nextIndex == 10) {
            $(this).addClass("hidden");
        }
    });
    $("#pollQuestionRemove").click(function () {
        nextIndex--;
        $(questions[nextIndex]).addClass("hidden");
        $(questionBreak[nextIndex]).addClass("hidden");
        if (nextIndex == 2) {
            $("#pollQuestionRemove").addClass("hidden");
        }
        if (nextIndex < 10) {
            $("#pollQuestionAdd").removeClass("hidden");
        }
    });
</script>