<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="messageboard.aspx.cs" Inherits="messageboard" %>

<%@ Register TagPrefix="YAF" Assembly="YAF" Namespace="YAF" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Forum
                    <small>Discussions</small>
                </div>
            </div>
        </h1>
    </section>

    <section class="content yaf-class">
        <div class="row">
            <YAF:Forum runat="server" ID="forum" BoardID="1" />
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script>
    $(".yafPageLink").children(":first").replaceWith("<a href='controltower.aspx'>Control Tower</a><span class='linkSeperator divider'>&nbsp;»&nbsp;</span><a href='messageboard.aspx?g=forum'>Forum / Q & A</a>");
    var menu = $(".adminMenuAccordian");
    if ($(menu).length > 0) {
        $(menu).wrap("<div class='box box-success' />");
        $(menu).wrap("<div class='box-body' />")
        $(menu).css("margin", "0 auto");
        $(".adminMenu").addClass("col-xs-3 col-xxs-12 d-block-xxs");
        $(".adminMenu").css("padding-top", "0");
        $(".adminContent").addClass("col-xs-9 col-xxs-12 d-block-xxs");
    }
</script>
</asp:Content>