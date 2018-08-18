<%@ Control Language="C#" AutoEventWireup="true"
    Inherits="YAF.Controls.EditUsersProfile" CodeBehind="EditUsersProfile.ascx.cs" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<div class="box box-success">
    <div class="box-header">
        <strong>
            <YAF:LocalizedLabel runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="TITLE" />
        </strong>
    </div>
    <div class="box-body form-horizontal">
        <div class="col-sm-9 no-padding" style="margin:0 auto;float:none;">
            <asp:PlaceHolder ID="ProfilePlaceHolder" runat="server">
                <div class="col-xs-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="aboutyou" />
                    </h3>
                </div>
                <asp:PlaceHolder ID="DisplayNamePlaceholder" runat="server" Visible="false">
                    <div class="form-group">
                        <label for="<%= DisplayName.ClientID %>" class="col-sm-3 control-label">
                            <YAF:LocalizedLabel ID="LocalizedLabel34" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="DISPLAYNAME" />
                        </label>
                        <div class="col-sm-9">
                            <asp:TextBox ID="DisplayName" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <div class="form-group">
                    <label for="<%= Realname.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="REALNAME2" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Realname" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <table width="100%" class="hidden">
                    <tr id="HideTr" visible="<%# this.Get<YafBoardSettings>().AllowUserHideHimself || this.PageContext.IsAdmin %>" runat="server">
                        <td>
                            <div class="form-group">
                                <label for="<%= HideMe.ClientID %>" class="col-sm-3 control-label">
                                    <YAF:LocalizedLabel ID="LocalizedLabel35" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="HIDEME" />
                                </label>
                                <div class="col-sm-9">
                                    <asp:CheckBox ID="HideMe" runat="server" Checked="false" />
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="form-group">
                    <label for="<%= BirthdayLabel.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="BirthdayLabel" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="BIRTHDAY" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Birthday" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Occupation.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="OCCUPATION" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Occupation" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Interests.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="INTERESTS" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Interests" runat="server" CssClass="form-control" TextMode="MultiLine" MaxLength="400" Rows="5" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Gender.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="GENDER" />
                    </label>
                    <div class="col-sm-9">
                        <asp:DropDownList ID="Gender" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-sm-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="LOCATION" />
                    </h3>
                </div>
                <div class="form-group">
                    <label for="<%= Country.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel40" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="COUNTRY" />
                    </label>
                    <div class="col-sm-9">
                        <YAF:ImageListBox ID="Country" AutoPostBack="true" OnTextChanged="LookForNewRegions" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <table width="100%">
                    <tr id="RegionTr" visible="false" runat="server">
                        <td>
                            <div class="form-group">
                                <label for="<%= Region.ClientID %>" class="col-sm-3 control-label">
                                    <YAF:LocalizedLabel ID="LocalizedLabel41" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="REGION" />
                                </label>
                                <div class="col-sm-9">
                                    <asp:DropDownList ID="Region" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="form-group">
                    <label for="<%= City.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel42" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="CITY" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="City" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group hidden">
                    <label for="<%= Location.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="where" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Location" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="col-sm-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel8" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="homepage" />
                    </h3>
                </div>
                <div class="form-group">
                    <label for="<%= HomePage.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel9" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="homepage2" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="HomePage" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Weblog.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel10" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="weblog2" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Weblog" CssClass="form-control" />
                    </div>
                </div>
            </asp:PlaceHolder>
            <asp:PlaceHolder runat="server" ID="MetaWeblogAPI" Visible="true">
                <div class="col-sm-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel11" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="METAWEBLOG_TITLE" />
                    </h3>
                </div>
                <div class="form-group">
                    <label for="<%= WeblogUrl.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel12" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="METAWEBLOG_API_URL" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="WeblogUrl" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= WeblogID.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel13" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="METAWEBLOG_API_ID" />
                        <br />
                        <YAF:LocalizedLabel ID="LocalizedLabel14" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="METAWEBLOG_API_ID_INSTRUCTIONS" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="WeblogID" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= WeblogUsername.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel15" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="METAWEBLOG_API_USERNAME" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="WeblogUsername" CssClass="form-control" />
                    </div>
                </div>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="IMServicesPlaceHolder" runat="server">
                <div class="col-sm-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel16" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="messenger" />
                    </h3>
                </div>
                <div class="form-group">
                    <label for="<%= MSN.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel29" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="MSN" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="MSN" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= YIM.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel28" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="YIM" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="YIM" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group hidden">
                    <label for="<%= AIM.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel27" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="AIM" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="AIM" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group hidden">
                    <label for="<%= ICQ.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel26" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="ICQ" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="ICQ" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Facebook.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel31" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="Facebook" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Facebook" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Twitter.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel33" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="Twitter" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Twitter" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="<%= Google.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel36" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="Google" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Google" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group hidden">
                    <label for="<%= Xmpp.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel32" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="xmpp" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Xmpp" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group hidden">
                    <label for="<%= Skype.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel30" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="SKYPE" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox runat="server" ID="Skype" CssClass="form-control" />
                    </div>
                </div>
            </asp:PlaceHolder>
            <div class="col-sm-12 text-center">
                <h3>
                    <YAF:LocalizedLabel ID="LocalizedLabel25" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="TIMEZONE" />
                </h3>
            </div>
            <div class="form-group">
                <label for="<%= DSTUser.ClientID %>" class="col-sm-3 control-label">
                    <YAF:LocalizedLabel ID="DSTLocalizedLabel" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="DST" />
                </label>
                <div class="col-sm-9">
                    <asp:CheckBox runat="server" ID="DSTUser" />
                </div>
            </div>
            <div class="form-group">
                <label for="<%= TimeZones.ClientID %>" class="col-sm-3 control-label">
                    <YAF:LocalizedLabel ID="LocalizedLabel24" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="TIMEZONE2" />
                </label>
                <div class="col-sm-9">
                    <asp:DropDownList runat="server" ID="TimeZones" CssClass="form-control" DataTextField="Name" DataValueField="Value" />
                </div>
            </div>
            <table width="100%">
                <tr runat="server" id="ForumSettingsRows">
                    <td>
                        <div class="col-sm-12">
                            <strong>
                                <YAF:LocalizedLabel ID="LocalizedLabel23" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="FORUM_SETTINGS" />
                            </strong>
                        </div>
                    </td>
                </tr>
                <tr runat="server" id="UserThemeRow">
                    <td>
                        <div class="form-group">
                            <label for="<%= Theme.ClientID %>" class="col-sm-3 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel22" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="SELECT_THEME" />
                            </label>
                            <div class="col-sm-9">
                                <asp:DropDownList runat="server" ID="Theme" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr runat="server" id="TrTextEditors">
                    <td>
                        <div class="form-group">
                            <label for="<%= ForumEditor.ClientID %>" class="col-sm-3 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel19" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="SELECT_TEXTEDITOR" />
                            </label>
                            <div class="col-sm-9">
                                <asp:DropDownList ID="ForumEditor" CssClass="form-control" runat="server" DataValueField="Value" DataTextField="Name" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr runat="server" id="UseMobileThemeRow" visible="false">
                    <td>
                        <div class="form-group">
                            <label for="<%= UseMobileTheme.ClientID %>" class="col-sm-3 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel21" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="USE_MOBILE_THEME" />
                            </label>
                            <div class="col-sm-9">
                                <asp:CheckBox ID="UseMobileTheme" runat="server" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr runat="server" id="UserLanguageRow">
                    <td>
                        <div class="form-group">
                            <label for="<%= Culture.ClientID %>" class="col-sm-3 control-label">
                                <YAF:LocalizedLabel ID="LocalizedLabel20" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="SELECT_LANGUAGE" />
                            </label>
                            <div class="col-sm-9">
                                <asp:DropDownList runat="server" ID="Culture" CssClass="form-control" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <asp:PlaceHolder runat="server" ID="LoginInfo" Visible="false">
                <div class="col-sm-12 text-center">
                    <h3>
                        <YAF:LocalizedLabel ID="LocalizedLabel18" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="CHANGE_EMAIL" />
                    </h3>
                </div>
                <div class="form-group">
                    <label for="<%= Email.ClientID %>" class="col-sm-3 control-label">
                        <YAF:LocalizedLabel ID="LocalizedLabel17" runat="server" LocalizedPage="CP_EDITPROFILE" LocalizedTag="EMAIL" />
                    </label>
                    <div class="col-sm-9">
                        <asp:TextBox ID="Email" CssClass="form-control" runat="server" OnTextChanged="Email_TextChanged" />
                    </div>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

    <div class="box-footer text-center">
        <asp:Button ID="UpdateProfile" CssClass="btn btn-primary" runat="server" OnClick="UpdateProfile_Click" />
        |
        <asp:Button ID="Cancel" CssClass="btn btn-primary" runat="server" OnClick="Cancel_Click" />
    </div>
</div>
