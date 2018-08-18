<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false"
    Inherits="YAF.Controls.ForumWelcome" CodeBehind="ForumWelcome.ascx.cs" %>

<div class="box box-success">
    <div class="box-body">
        <asp:Label ID="TimeNow" runat="server" />&nbsp;
            <asp:Label ID="TimeLastVisit" runat="server" />&nbsp;
            <asp:HyperLink runat="server" ID="UnreadMsgs" Visible="false" />
    </div>
</div>
