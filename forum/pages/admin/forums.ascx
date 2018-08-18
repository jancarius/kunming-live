<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.Admin.forums" CodeBehind="forums.ascx.cs" %>
<%@ Register TagPrefix="YAF" Namespace="YAF.Controls" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<YAF:AdminMenu runat="server">
    <div class="box box-success with-border">
        <div class="box-header">
            <strong>
                <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="FORUMS" LocalizedPage="TEAM" />
            </strong>
        </div>
        <div class="box-body">
            <asp:Repeater ID="CategoryList" runat="server" OnItemCommand="CategoryList_ItemCommand">
                <ItemTemplate>
                    <span class="hidden">
                        <div class="col-xs-7">
                            <%# HtmlEncode(Eval( "Name"))%>
                        </div>
                        <div class="col-xs-2">
                            <%# Eval( "SortOrder") %>
                        </div>
                        <div class="col-xs-3">
                            <YAF:ThemeButton ID="ThemeButtonEdit" CssClass="btn btn-success btn-sm"
                                CommandName='edit' CommandArgument='<%# Eval( "CategoryID") %>'
                                TitleLocalizedTag="EDIT" ImageThemePage="ICONS" ImageThemeTag="EDIT_SMALL_ICON"
                                TextLocalizedTag="EDIT"
                                runat="server">
                            </YAF:ThemeButton>
                            <YAF:ThemeButton ID="ThemeButtonDelete" CssClass="btn btn-success btn-sm"
                                OnLoad="DeleteCategory_Load" CommandName='delete' CommandArgument='<%# Eval( "CategoryID") %>'
                                TitleLocalizedTag="DELETE" ImageThemePage="ICONS" ImageThemeTag="DELETE_SMALL_ICON"
                                TextLocalizedTag="DELETE"
                                runat="server">
                            </YAF:ThemeButton>
                        </div>
                    </span>
                    <asp:Repeater ID="ForumList" OnItemCommand="ForumList_ItemCommand" runat="server"
                        DataSource='<%# ((System.Data.DataRowView)Container.DataItem).Row.GetChildRows("FK_Forum_Category") %>'>
                        <ItemTemplate>
                            <div class="col-xs-7">
                                <strong>
                                    <%# HtmlEncode(DataBinder.Eval(Container.DataItem, "[\"Name\"]")) %>
                                </strong>
                                <br />
                                <%# HtmlEncode(DataBinder.Eval(Container.DataItem, "[\"Description\"]")) %>
                            </div>
                            <div class="col-xs-2">
                                <%# DataBinder.Eval(Container.DataItem, "[\"SortOrder\"]") %>
                            </div>
                            <div class="col-xs-3">
                                <YAF:ThemeButton ID="btnEdit" CssClass="btn btn-success btn-sm"
                                    CommandName='edit' CommandArgument='<%# Eval( "[\"ForumID\"]") %>'
                                    TextLocalizedTag="EDIT"
                                    TitleLocalizedTag="EDIT" ImageThemePage="ICONS" ImageThemeTag="EDIT_SMALL_ICON" runat="server">
                                </YAF:ThemeButton>
                                <YAF:ThemeButton ID="btnDuplicate" CssClass="btn btn-success btn-sm"
                                    CommandName='copy' CommandArgument='<%# Eval( "[\"ForumID\"]") %>'
                                    TextLocalizedTag="COPY"
                                    TitleLocalizedTag="COPY" ImageThemePage="ICONS" ImageThemeTag="COPY_SMALL_ICON" runat="server">
                                </YAF:ThemeButton>
                                <YAF:ThemeButton ID="btnDelete" CssClass="btn btn-success btn-sm"
                                    CommandName='delete' CommandArgument='<%# Eval( "[\"ForumID\"]") %>'
                                    TextLocalizedTag="DELETE"
                                    TitleLocalizedTag="DELETE" ImageThemePage="ICONS" ImageThemeTag="DELETE_SMALL_ICON" runat="server">
                                </YAF:ThemeButton>
                            </div>
                            <div class="col-xs-12"><br /></div>
                        </ItemTemplate>
                    </asp:Repeater>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="box-footer with-border text-center">
            <asp:Button ID="NewCategory" runat="server" OnClick="NewCategory_Click" CssClass="pbutton"></asp:Button>
            |
			<asp:Button ID="NewForum" runat="server" OnClick="NewForum_Click" CssClass="pbutton"></asp:Button>
        </div>
    </div>
</YAF:AdminMenu>

<YAF:SmartScroller ID="SmartScroller1" runat="server" />
