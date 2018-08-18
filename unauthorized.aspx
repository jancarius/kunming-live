<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="unauthorized.aspx.cs" Inherits="unauthorized" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content">
        <div class="row">
            <div id="unauthorizedAlert" class="alert alert-warning">
                <h4><i class="icon fa fa-warning"></i>Unauthorized Access!</h4>
                You are not authorized to access this page. Please sign in or register! Registration provides many benefits and access to additional resources. You may visit our <a href="introduction.aspx">Introduction Page</a> for a full description of all features. Thank you!
            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script>
        $(window).on("load", function () {
            $("#btnUserMenu").click();
        });
    </script>
</asp:Content>

