<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="resetpassword.aspx.cs" Inherits="resetpassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content">
        <div class="row">
            <div class="col-xxl-2 col-xxl-push-5 col-lg-4 col-lg-push-4 col-md-6 col-md-push-3 col-sm-8 col-sm-push-2 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">Enter a New Password</h3>
                    </div>
                    <div class="box-body">
                        <div id="lblResetPasswordError" class="control-label text-yellow text-bold collapse" style="margin-top: -20px;"><i class="fa fa-times-circle-o"></i>&nbsp;<span id="lblResetPasswordErrorText"></span></div>
                        <div class="form-group">
                            <label for="txtResetPassword" class="control-label">New Password</label>
                            <input id="txtResetPassword" type="password" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="txtResetPasswordConfirm" class="control-label">Confirm New Password</label>
                            <input id="txtResetPasswordConfirm" type="password" class="form-control" />
                        </div>
                    </div>
                    <div class="box-footer">
                        <button id="btnSubmitNewPassword" type="button" class="btn btn-success pull-right">Submit</button>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <asp:HiddenField ID="hiddenGUIDParam" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script>
        $(window).on("load", function () {
            $("#txtResetPassword").focus();
            $("#btnSubmitNewPassword").click(function () {
                var $resetPassword = $("#txtResetPassword");
                if ($("#txtResetPassword").val().length < 8) {
                    $resetPassword.parent().addClass("has-error");
                    $("#lblResetPasswordErrorText").text("Minimum 8 Characters");
                    $("#lblResetPasswordError").slideDown();
                    return false;
                } else if ($("#txtResetPassword").val().includes(" ")) {
                    $resetPassword.parent().addClass("has-error");
                    $("#lblResetPasswordErrorText").text("No Spaces Allowed");
                    $("#lblResetPasswordError").slideDown();
                    return false;
                } else {
                    $resetPassword.parent().removeClass("has-error");
                    $("#lblResetPasswordError").slideUp();
                }

                var $resetPasswordConfirm = $("#txtResetPasswordConfirm");
                if ($resetPasswordConfirm.val() !== $resetPassword.val()) {
                    $resetPasswordConfirm.parent().addClass("has-error");
                    $("#lblResetPasswordErrorText").text("Passwords Do Not Match");
                    $("#lblResetPasswordError").slideDown();
                    return false;
                } else {
                    $resetPasswordConfirm.parent().removeClass("has-error");
                    $("#lblResetPasswordError").slideUp();
                }

                var newPassword = $resetPassword.val();
                var guid = $("#hiddenGUIDParam").val();

                var data = {
                    newPassword: newPassword,
                    guid: guid
                }
                callBack("master.asmx/ResetPassword", data, function (msg) {
                    if (msg.d == false) {
                        $("#lblRegisterErrorText").text("Invalid Password Reset Code. Reconfirm Link Received in Email.");
                        $("#lblRegisterError").slideDown();
                        $(".loading-overlay").hide();
                    } else if (msg.d == true) {
                        window.location.href = '/';
                    }
                }, true, true);
            });
        });
    </script>
</asp:Content>

