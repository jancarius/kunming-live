<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.postmessage" CodeBehind="postmessage.ascx.cs" %>
<%@ Import Namespace="YAF.Core" %>
<%@ Register TagPrefix="YAF" TagName="smileys" Src="../controls/smileys.ascx" %>
<%@ Register TagPrefix="YAF" TagName="LastPosts" Src="../controls/LastPosts.ascx" %>
<%@ Register TagPrefix="YAF" TagName="PostOptions" Src="../controls/PostOptions.ascx" %>
<%@ Register TagPrefix="YAF" TagName="PostAttachments" Src="../controls/PostAttachments.ascx" %>
<%@ Register TagPrefix="YAF" TagName="PollList" Src="../controls/PollList.ascx" %>
<%@ Register TagPrefix="YAF" TagName="AttachmentsUploadDialog" Src="../controls/AttachmentsUploadDialog.ascx" %>
<YAF:PageLinks ID="PageLinks" runat="server" />
<YAF:PollList ID="PollList" ShowButtons="true" PollGroupId='<%# GetPollGroupID() %>' runat="server" />
<div class="col-xs-12">
    <div class="box box-success">
        <div class="box-header with-border text-center">
            <strong>
                <asp:Label ID="Title" runat="server" /></strong>
        </div>
        <div class="box-body form-horizontal">
            <table width="100%">
                <tr id="PreviewRow" runat="server" visible="false">
                    <td id="PreviewCell" runat="server" colspan="2">
                        <div class="form-group">
                            <label for="<%= PreviewMessagePost.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="previewtitle" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <YAF:MessagePost ID="PreviewMessagePost" runat="server" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="SubjectRow" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= TopicSubjectLabel.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel ID="TopicSubjectLabel" runat="server" LocalizedTag="subject" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:TextBox ID="TopicSubjectTextBox" runat="server" CssClass="form-control" MaxLength="100" autocomplete="off" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="DescriptionRow" visible="false" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= TopicDescriptionTextBox.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel ID="TopicDescriptionLabel" runat="server" LocalizedTag="description" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:TextBox ID="TopicDescriptionTextBox" runat="server" CssClass="form-control" MaxLength="100" autocomplete="off" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="BlogRow" runat="server" visible="false">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= BlogPostID.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                Post to blog?
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:CheckBox ID="PostToBlog" runat="server" />
                                Blog Password:
                            <asp:TextBox ID="BlogPassword" runat="server" TextMode="Password" CssClass="form-control" />
                                <asp:HiddenField ID="BlogPostID" runat="server" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="FromRow" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= From.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="from" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:TextBox ID="From" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="StatusRow" visible="false" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= TopicStatus.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="Status" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:DropDownList ID="TopicStatus" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="PriorityRow" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= Priority.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="priority" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:DropDownList ID="Priority" runat="server" CssClass="form-control" Style="width: auto;" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="StyleRow" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= TopicStylesTextBox.ClientID %>" class="col-xs-2 col-xxs-12 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="STYLES" />
                            </label>
                            <div class="col-xs-10 col-xxs-12">
                                <asp:TextBox ID="TopicStylesTextBox" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr class="form-group">
                    <td class="col-xs-2 col-xxs-12 text-right text-left-xxs" style="display: inline-block; padding: 0 25px 0 0;">
                        <label for="<%= EditorLine.ClientID %>" class="control-label">
                            <YAF:LocalizedLabel runat="server" LocalizedTag="message" />
                        </label>
                        <YAF:smileys runat="server" OnClick="insertsmiley" />
                        <br />
                        <span class="hidden">
                            <YAF:LocalizedLabel ID="LocalizedLblMaxNumberOfPost" runat="server" LocalizedTag="MAXNUMBEROF" Visible="false" />
                        </span>
                    </td>
                    <td id="EditorLine" runat="server" class="col-xs-10 col-xxs-12" style="display: inline-block; padding: 0">
                        <!-- editor goes here -->
                    </td>
                </tr>

                <YAF:PostOptions ID="PostOptions1" runat="server"></YAF:PostOptions>
                <YAF:PostAttachments ID="PostAttachments1" runat="server" Visible="False"></YAF:PostAttachments>

                <tr id="tr_captcha1" runat="server" visible="false">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= imgCaptcha.ClientID %>" class="col-xs-2 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="Captcha_Image" />
                            </label>
                            <div class="col-xs-10">
                                <asp:Image ID="imgCaptcha" runat="server" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="tr_captcha2" runat="server" visible="false">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= tbCaptcha.ClientID %>" class="col-xs-2 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="Captcha_Enter" />
                            </label>
                            <div class="col-xs-10">
                                <asp:TextBox ID="tbCaptcha" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr id="EditReasonRow" runat="server">
                    <td colspan="2">
                        <div class="form-group">
                            <label for="<%= ReasonEditor.ClientID %>" class="col-xs-2 control-label">
                                <YAF:LocalizedLabel runat="server" LocalizedTag="EditReason" />
                            </label>
                            <div class="col-xs-10">
                                <asp:TextBox ID="ReasonEditor" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="box-footer with-border">
                <div class="col-xs-12 text-center">
                    <YAF:ThemeButton ID="Preview" runat="server" CssClass="btn btn-success"
                        OnClick="Preview_Click" TitleLocalizedTag="PREVIEW_TITLE" TextLocalizedTag="PREVIEW" />
                    <YAF:ThemeButton ID="PostReply" TitleLocalizedTag="SAVE_TITLE" runat="server" CssClass="btn btn-success"
                        OnClick="PostReply_Click" TextLocalizedTag="SAVE" />
                    <YAF:ThemeButton ID="Cancel" TitleLocalizedTag="CANCEL_TITLE" runat="server" CssClass="btn btn-success" OnClick="Cancel_Click"
                        TextLocalizedTag="CANCEL" />
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_beginRequest(beginRequest);
    function beginRequest() {
        prm._scrollPosition = null;
    }
</script>
<YAF:LastPosts ID="LastPosts1" runat="server" Visible="false" />
<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
<YAF:AttachmentsUploadDialog ID="UploadDialog" runat="server" Visible="False"></YAF:AttachmentsUploadDialog>
