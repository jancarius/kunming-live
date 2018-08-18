<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.Admin.editforum"
    CodeBehind="editforum.ascx.cs" %>
<%@ Register TagPrefix="YAF" Namespace="YAF.Controls" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<YAF:AdminMenu runat="server" ID="Adminmenu1">
    <div class="box box-success">
        <div class="box-header with-border">
            <strong>
                <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="HEADER1" LocalizedPage="ADMIN_EDITFORUM" />
                <asp:Label ID="ForumNameTitle" runat="server"></asp:Label>
            </strong>
        </div>
        <div class="box-body">
            <div class="col-xs-6 col-xxs-12 pad hidden">
                <YAF:HelpLabel ID="HelpLabel1" runat="server" LocalizedTag="CATEGORY" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs-12 pad hidden">
                <asp:DropDownList Width="250" ID="CategoryList" runat="server" OnSelectedIndexChanged="Category_Change" DataValueField="CategoryID" DataTextField="Name" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs-12 pad">
                <YAF:HelpLabel ID="HelpLabel2" runat="server" LocalizedTag="PARENT_FORUM" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs-12 pad">
                <asp:DropDownList Width="250" ID="ParentList" runat="server" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs-12 pad">
                <YAF:HelpLabel ID="HelpLabel3" runat="server" LocalizedTag="NAME" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs-12 pad">
                <asp:TextBox Width="250" ID="Name" runat="server" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs-12 pad">
                <YAF:HelpLabel ID="HelpLabel4" runat="server" LocalizedTag="DESCRIPTION" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:TextBox Width="250" ID="Description" runat="server" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <YAF:HelpLabel ID="HelpLabel14" runat="server" LocalizedTag="REMOTE_URL" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <asp:TextBox Width="250" ID="remoteurl" runat="server" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <YAF:HelpLabel ID="HelpLabel13" runat="server" LocalizedTag="THEME" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <asp:DropDownList Width="250" ID="ThemeList" runat="server" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad">
                <YAF:HelpLabel ID="HelpLabel12" runat="server" LocalizedTag="SORT_ORDER" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:TextBox ID="SortOrder" Width="250" MaxLength="5" runat="server" Text="10" CssClass="form-control" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad">
                <YAF:HelpLabel ID="HelpLabel11" runat="server" LocalizedTag="HIDE_NOACESS" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:CheckBox ID="HideNoAccess" runat="server"></asp:CheckBox>
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad">
                <YAF:HelpLabel ID="HelpLabel10" runat="server" LocalizedTag="LOCKED" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:CheckBox ID="Locked" runat="server"></asp:CheckBox>
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad">
                <YAF:HelpLabel ID="HelpLabel9" runat="server" LocalizedTag="NO_POSTSCOUNT" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:CheckBox ID="IsTest" runat="server"></asp:CheckBox>
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad">
                <YAF:HelpLabel ID="HelpLabel8" runat="server" LocalizedTag="PRE_MODERATED" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad">
                <asp:CheckBox ID="Moderated" runat="server" AutoPostBack="true" OnCheckedChanged="ModeratedCheckedChanged"></asp:CheckBox>
            </div>
            <div class="clearfix"></div>
            <table>
                <tr runat="server" id="ModerateNewTopicOnlyRow" visible="false">
                    <td>
                        <div class="col-xs-6 col-xxs12 pad">
                            <YAF:HelpLabel ID="HelpLabel16" runat="server" LocalizedTag="MODERATED_NEWTOPIC_ONLY" LocalizedPage="ADMIN_EDITFORUM" />
                        </div>
                        <div class="col-xs-6 col-xxs12 pad">
                            <asp:CheckBox ID="ModerateNewTopicOnly" runat="server" AutoPostBack="true"></asp:CheckBox>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="clearfix"></div>
            <table>
                <tr runat="server" id="ModeratedPostCountRow" visible="false">
                    <td>
                        <div class="col-xs-6 col-xxs12 pad">
                            <YAF:HelpLabel ID="HelpLabel15" runat="server" LocalizedTag="MODERATED_COUNT" LocalizedPage="ADMIN_EDITFORUM" />
                        </div>
                        <div class="col-xs-6 col-xxs12 pad">
                            <asp:CheckBox ID="ModerateAllPosts" runat="server" AutoPostBack="true" OnCheckedChanged="ModerateAllPostsCheckedChanged" Checked="true" />
                            <asp:TextBox Width="250" ID="ModeratedPostCount" runat="server" Visible="false" MaxLength="5" Text="5" CssClass="form-control" />
                        </div>
                    </td>
                </tr>
            </table>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <YAF:HelpLabel ID="HelpLabel7" runat="server" LocalizedTag="FORUM_IMAGE" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <asp:DropDownList Width="250" ID="ForumImages" runat="server" CssClass="form-control" />
                <img align="middle" runat="server" id="Preview" alt="" />
            </div>
            <div class="clearfix"></div>
            <div class="col-xs-6 col-xxs12 pad hidden" runat="server" visible="false">
                <YAF:HelpLabel ID="HelpLabel6" runat="server" LocalizedTag="STYLES" LocalizedPage="ADMIN_EDITFORUM" />
            </div>
            <div class="col-xs-6 col-xxs12 pad hidden">
                <asp:TextBox Width="250" ID="Styles" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="clearfix"></div>
            <table width="100%">
                <tr id="NewGroupRow" runat="server">
                    <td>
                        <div class="col-xs-6 col-xxs12 pad">
                            <YAF:HelpLabel ID="HelpLabel5" runat="server" LocalizedTag="INITAL_MASK" LocalizedPage="ADMIN_EDITFORUM" />
                        </div>
                        <div class="col-xs-6 col-xxs12 pad">
                            <asp:DropDownList Width="250" ID="AccessMaskID" OnDataBinding="BindData_AccessMaskID" CssClass="form-control" runat="server" />
                        </div>
                    </td>
                </tr>
            </table>
            <asp:Repeater ID="AccessList" runat="server">
                <HeaderTemplate>
                    <div class="col-xs-12 pad">
                        <strong>
                            <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="HEADER2" LocalizedPage="ADMIN_EDITFORUM" />
                        </strong>
                    </div>
                    <div class="col-xs-6 col-xxs12 pad">
                        <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="Group" LocalizedPage="ADMIN_EDITFORUM" />
                    </div>
                    <div class="col-xs-6 col-xxs12 pad">
                        <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="ACCESS_MASK" LocalizedPage="ADMIN_EDITFORUM" />
                    </div>
                    <div class="clearfix"></div>
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="col-xs-6 col-xxs12 pad">
                        <asp:Label ID="GroupID" Visible="false" runat="server" Text='<%# Eval( "GroupID") %>' />
                        <%# Eval( "GroupName") %>
                    </div>
                    <div class="col-xs-6 col-xxs12 pad">
                        <asp:DropDownList Width="250" runat="server" ID="AccessMaskID" OnDataBinding="BindData_AccessMaskID" CssClass="form-control"
                            OnPreRender="SetDropDownIndex" value='<%# Eval("AccessMaskID") %>' />
                        ...
                    </div>
                    <div class="clearfix"></div>
                </ItemTemplate>
            </asp:Repeater>
            <div class="col-xs-12 text-center">
                <asp:Button ID="Save" runat="server" CssClass="pbutton"></asp:Button>&nbsp;
                <asp:Button ID="Cancel" runat="server" CssClass="pbutton"></asp:Button>
            </div>
        </div>
    </div>
</YAF:AdminMenu>
<YAF:SmartScroller ID="SmartScroller1" runat="server" />
