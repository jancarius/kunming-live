<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="tips.aspx.cs" Inherits="tips" %>
<%@ MasterType VirtualPath="~/admin.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" Runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Tips & Tricks
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="controltower.aspx"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">Tips & Tricks</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            Contents
                            <small>Index</small>
                        </h3>
                    </div>
                    <div class="box-body">
                        <ul id="lstContentsIndex" runat="server">

                        </ul>
                    </div>
                </div>
            </div>

            <div id="pnlTipsContent" class="col-xs-12 no-padding" runat="server">

            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" Runat="Server">
    <!-- Show Tip/Trick Modal -->
    <div class="modal fade in" id="modalShowTip">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <h2 id="showTipTitle" class="text-center text-bold" style="margin-top:0;"></h2>
                    <div id="showTipDescription"></div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <script src="dist/js/tips.js"></script>
</asp:Content>