<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.cp_profile" Codebehind="cp_profile.ascx.cs" %>
<%@ Register TagPrefix="YAF" TagName="ProfileYourAccount" Src="../controls/ProfileYourAccount.ascx" %>
<YAF:PageLinks runat="server" ID="PageLinks" />
<table width="100%" cellspacing="1" cellpadding="0" class="content box box-success">
    <tr>
        <td colspan="2" style="font-size: 10.5pt;font-weight: bold;">
            <YAF:LocalizedLabel ID="ControlPanel" runat="server" LocalizedTag="CONTROL_PANEL" />
        </td>
    </tr>
    <tr>
        <td class="post">
            <div id="yafprofilecontainer">
                <div class="col-md-3">
                    <YAF:ProfileMenu ID="ProfileMenu1" runat="server" />
                </div>
                <div class="col-md-9">
                    <YAF:ProfileYourAccount ID="YourAccount" runat="server" />
                </div>
            </div>
        </td>
    </tr>
</table>
<div id="DivSmartScroller">
    <YAF:SmartScroller ID="SmartScroller1" runat="server" />
</div>
