<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Kunming LIVE! | The Next Big Thing in China</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.7 -->
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css" />
    <!-- iCheck -->
    <link rel="stylesheet" href="plugins/iCheck/square/blue.css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- Google Font -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic" />
    <!-- Facebook Login -->
    <script src="https://sdk.accountkit.com/en_US/sdk.js"></script>
</head>
<body class="hold-transition login-page">
    <script>
        window.fbAsyncInit = function () {
            FB.init({
                appId: '421324431621180',
                cookie: true,
                xfbml: true,
                version: 'v2.12'
            });
            FB.AppEvents.logPageView();
        };
        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) { return; }
            js = d.createElement(s); js.id = id;
            js.src = "https://connect.facebook.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
    <form id="frmLogin" runat="server">
        <!-- login-box -->
        <div class="login-box">
            <div class="login-logo">
                <a href="../../index2.html">Kunming <b>LIVE!</b></a>
            </div>
            <!-- /.login-logo -->
            <div class="login-box-body">
                <p class="login-box-msg">Sign in to start your session</p>
                <div id="lblLoginError" class="control-label text-red text-bold collapse"><i class="fa fa-times-circle-o"></i>Invalid Username and/or Password</div>
                <div class="form-group has-feedback">
                    <input id="txtUsernameLogin" type="text" class="form-control" placeholder="Username" tabindex="1" data-toggle="tooltip" data-placement="right" trigger="manual" title="Invalid&nbsp;Username">
                    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="txtPasswordLogin" type="password" class="form-control" placeholder="Password" tabindex="2" data-toggle="tooltip" data-placement="right" trigger="manual" title="Invalid&nbsp;Username">
                    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                </div>
                <div class="row">
                    <div class="col-xs-8">
                        <div class="checkbox icheck">
                            <label>
                                <input id="chkRememberMe" type="checkbox" tabindex="3">
                                Remember Me
                            </label>
                        </div>
                    </div>
                    <!-- /.col -->
                    <div class="col-xs-4">
                        <button id="btnLogin" type="button" class="btn btn-primary btn-block btn-flat" tabindex="4">Sign In</button>
                    </div>
                    <!-- /.col -->
                </div>
                <div class="social-auth-links text-center">
                    <button id="btnSigninWeChat" type="button" class="btn btn-social-icon btn-weixin btn-flat" tabindex="5">
                        <i class="fa fa-weixin"></i>
                    </button>
                    <button id="btnSigninFacebook" type="button" class="btn btn-social-icon btn-facebook btn-flat" tabindex="6">
                        <i class="fa fa-facebook"></i>
                    </button>
                    <button id="btnSigninGoogle" type="button" class="btn btn-social-icon btn-google btn-flat" tabindex="7">
                        <i class="fa fa-google-plus"></i>
                    </button>
                </div>
                <!-- /.social-auth-links -->
                <a id="btnForgot" href="#" tabindex="8">I Forgot My Password</a><br>
                <a id="btnShowRegister" href="#" class="text-center" tabindex="9">Register a New Membership</a>
            </div>
            <!-- /.login-box-body -->
        </div>
        <!-- /login-box -->

        <!-- register-box -->
        <div class="register-box" style="display: none;">
            <div class="register-logo">
                <a href="index.html">Kunming <b>LIVE!</b></a>
            </div>
            <div class="register-box-body">
                <p class="login-box-msg">Register a New Membership</p>
                <div id="lblRegisterError" class="control-label text-red text-bold collapse"><i class="fa fa-times-circle-o"></i></div>
                <div class="form-group has-feedback">
                    <input id="txtUsername" name="username" type="text" class="form-control" placeholder="Username" tabindex="10">
                    <span class="glyphicon glyphicon-user form-control-feedback" id="txtUsernameTip" data-toggle="tooltip" data-placement="right" trigger="manual" title="Invalid&nbsp;Username"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="txtEmail" type="email" class="form-control" placeholder="Email" tabindex="11" autocomplete="off">
                    <span class="glyphicon glyphicon-envelope form-control-feedback" id="txtEmailTip" data-toggle="tooltip" data-placement="right" trigger="manual" title="Invalid&nbsp;Email&nbsp;Format"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="txtPassword" type="password" class="form-control" placeholder="Password" tabindex="12">
                    <span class="glyphicon glyphicon-lock form-control-feedback" id="txtPasswordTip" data-toggle="tooltip" data-placement="right" trigger="manual" title="Minimum&nbsp;8&nbsp;Characters&nbsp;Required"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="txtConfirmPassword" type="password" class="form-control" placeholder="Retype password" tabindex="13">
                    <span class="glyphicon glyphicon-log-in form-control-feedback" id="txtConfirmPasswordTip" data-toggle="tooltip" data-placement="right" trigger="manual" title="Passwords&nbsp;Do&nbsp;Not&nbsp;Match!"></span>
                </div>
                <div class="row">
                    <div class="col-xs-8">
                        <div class="checkbox icheck">
                            <label>
                                <input id="chkAgreeTerms" type="checkbox" tabindex="14">
                                I agree to the <a id="chkAgreeTermsTip" href="#" data-toggle="tooltip" data-placement="right" trigger="manual" title="Must&nbsp;Agree&nbsp;to&nbsp;Terms">terms</a>
                            </label>
                        </div>
                    </div>
                    <!-- /.col -->
                    <div class="col-xs-4">
                        <button id="btnRegister" type="button" class="btn btn-primary btn-block btn-flat" tabindex="15">Register</button>
                    </div>
                    <!-- /.col -->
                </div>
                <div class="social-auth-links text-center">
                    <p>- OR -</p>
                    <a id="btnRegisterWeChat" href="#" class="btn btn-social-icon btn-facebook btn-flat" style="background-color: #7bb32e;" tabindex="16">
                        <i class="fa fa-weixin"></i>
                    </a>
                    <a id="btnRegisterFacebook" href="#" class="btn btn-social-icon btn-facebook btn-flat" tabindex="17">
                        <i class="fa fa-facebook"></i>
                    </a>
                    <a id="btnRegisterGoogle" href="#" class="btn btn-social-icon btn-google btn-flat" tabindex="18">
                        <i class="fa fa-google-plus"></i>
                    </a>
                </div>
                <a id="btnHideRegister" href="#" class="text-center" tabindex="19">I Already Have A Membership</a>
            </div>
            <!-- /.form-box -->
        </div>
        <!-- /.register-box -->
        <!-- Forgot Password Modal -->
        <div class="modal fade in" id="modalForgotPassword">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span></button>
                        <h4 class="modal-title">I Forgot My Password</h4>
                    </div>
                    <div class="modal-body form-horizontal">
                        <div id="lblForgotError" class="control-label text-red text-bold collapse"><i class="fa fa-times-circle-o"></i>Username / Email Not Found</div>
                        <div class="form-group">
                            <label for="txtForgotPassword" class="col-sm-4 control-label margin-top">
                                Username OR Email
                            </label>
                            <div class="col-sm-8">
                                <input id="txtForgotPassword" class="form-control" />
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                    <div class="modal-footer">
                        <button id="btnCancelForgot" type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                        <button id="btnSubmitForgot" type="button" class="btn btn-primary">Recover</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
        <!-- jQuery 3 -->
        <script src="bower_components/jquery/dist/jquery.min.js"></script>
        <!-- Bootstrap 3.3.7 -->
        <script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
        <!-- iCheck -->
        <script src="plugins/iCheck/icheck.min.js"></script>
        <script>
            $('#modalProfileImage').modal({ show: false });

            $(function () {
                $("#txtUsernameLogin").focus();

                $('input').iCheck({
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                $.ajax({
                    type: "POST",
                    url: "login.aspx?action=getBackground",
                    success: function (msg) {
                        var url = msg.replace(/\\/g, "/");
                        $("body").css("background", "url(" + url + ") no-repeat center center fixed");
                        $("body").css("-webkit-background-size", "cover");
                        $("body").css("-moz-background-size", "cover");
                        $("body").css("-o-background-size", "cover");
                        $("body").css("background-size", "cover");
                    },
                    error: function (msg) {
                        alert("Fail (Check Console)");
                        console.log(JSON.stringify(msg))
                    }
                });

                $("#btnShowRegister").click(function () {
                    $(".login-box").toggle(1000);
                    $(".register-box").toggle(1000);
                    $("#txtUsername").focus();
                });
                $("#btnHideRegister").click(function () {
                    $(".register-box").toggle(1000);
                    $(".login-box").toggle(1000);
                    $("#txtUsernameLogin").focus();
                });

                var checkUsername = function () {
                    var regex = /^[a-zA-Z0-9_-]{3,15}$/;
                    if (!regex.test($("#txtUsername").val())) {
                        $("#txtUsername").css("border-color", "red");
                        $("#txtUsernameTip").tooltip('show');
                        return false;
                    } else {
                        $("#txtUsername").css("border-color", "");
                        $("#txtUsernameTip").tooltip('hide');
                        return true;
                    }
                }

                var checkEmail = function () {
                    var regex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/;
                    if (!regex.test($("#txtEmail").val())) {
                        $("#txtEmail").css("border-color", "red");
                        $("#txtEmailTip").tooltip('show');
                        return false;
                    } else {
                        $("#txtEmail").css("border-color", "");
                        $("#txtEmailTip").tooltip('hide');
                        return true;
                    }
                }

                var checkPassword = function () {
                    if ($("#txtPassword").val().length < 8) {
                        $("#txtPassword").css("border-color", "red");
                        $("#txtPasswordTip").tooltip('show');
                        return false;
                    } else {
                        $("#txtPassword").css("border-color", "");
                        $("#txtPasswordTip").tooltip('hide');
                        return true;
                    }
                }

                var checkConfirmPassword = function () {
                    if ($("#txtConfirmPassword").val() != $("#txtPassword").val()) {
                        $("#txtConfirmPassword").css("border-color", "red");
                        $("#txtConfirmPasswordTip").tooltip('show');
                        return false;
                    } else {
                        $("#txtConfirmPassword").css("border-color", "");
                        $("#txtConfirmPasswordTip").tooltip('hide');
                        return true;
                    }
                }

                var checkAgreeTerms = function () {
                    if (!$("#chkAgreeTerms").is(':checked')) {
                        $("#chkAgreeTerms").css("border-color", "red");
                        $("#chkAgreeTermsTip").tooltip('show');
                        return false;
                    } else {
                        $("#chkAgreeTerms").css("border-color", "");
                        $("#chkAgreeTermsTip").tooltip('hide');
                        return true;
                    }
                }

                $("#txtUsername").change(checkUsername);
                $("#txtEmail").change(checkEmail);
                $("#txtPassword").change(checkPassword);
                $("#txtConfirmPassword").change(checkConfirmPassword);
                $("#chkAgreeTerms").change(checkAgreeTerms);

                $("#btnRegister").click(function () {
                    if (checkUsername() && checkEmail() && checkPassword() && checkConfirmPassword() && checkAgreeTerms()) {
                        $.ajax({
                            type: "POST",
                            url: "login.aspx?action=register",
                            data: JSON.stringify({
                                username: $("#txtUsername").val(),
                                email: $("#txtEmail").val(),
                                password: $("#txtPassword").val()
                            }),
                            async: true,
                            cache: false,
                            success: function (msg) {
                                if (msg == "Valid") {
                                    window.location.href = "controltower.aspx";
                                } else if (msg == "Invalid") {

                                } else {
                                    $("#lblRegisterError").html(msg + " Already Exists");
                                    if (msg.includes("Username")) {
                                        $("#lblRegisterError").next().addClass("has-error");
                                    } else {
                                        $("#lbRegisterError").next().removeClass("has-error");
                                    }
                                    if (msg.includes("Email")) {
                                        $("#lblRegisterError").next().next().addClass("has-error");
                                    } else {
                                        $("#lbRegisterError").next().next().removeClass("has-error");
                                    }
                                    $("#lblRegisterError").show("slow");
                                }
                                console.log(msg);
                            },
                            error: function (msg) {
                                alert("Failed to Register (Check Console)");
                                console.log(msg);
                            }
                        });
                    }
                });

                $("#btnLogin").click(function () {
                    $.ajax({
                        type: "POST",
                        url: "login.aspx?action=login",
                        data: JSON.stringify({
                            username: $("#txtUsernameLogin").val(),
                            password: $("#txtPasswordLogin").val(),
                            rememberMe: $("#chkRememberMe").is(':checked')
                        }),
                        async: true,
                        cache: false,
                        success: function (msg) {
                            if (msg == "true") {
                                var params = new URLSearchParams(window.location.search);
                                var returnPage = "controltower.aspx";
                                if (params.has("return")) {
                                    returnPage = params.get("return");
                                }
                                window.location.href = returnPage;
                            } else {
                                $("#lblLoginError").next().addClass("has-error");
                                $("#lblLoginError").next().next().addClass("has-error");
                                $("#lblLoginError").show("slow");
                                console.log(msg);
                            }
                        },
                        error: function (msg) {
                            alert("Failed to Login (Check Console)");
                            console.log(msg);
                        }
                    });
                });

                $("#btnForgot").click(function () {
                    $("#modalForgotPassword").modal("show");
                });

                $("#modalForgotPassword").on('shown.bs.modal', function () {
                    $("#txtForgotPassword").focus();
                })

                $("#txtUsernameLogin").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnLogin").click();
                    }
                });
                $("#txtPasswordLogin").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnLogin").click();
                    }
                });
                $("#txtUsername").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnRegister").click();
                    }
                });
                $("#txtEmail").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnRegister").click();
                    }
                });
                $("#txtPassword").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnRegister").click();
                    }
                });
                $("#txtConfirmPassword").on("keyup", function (e) {
                    if (e.keyCode == 13) {
                        $("#btnRegister").click();
                    }
                });

                $("#btnSigninFacebook").click(function () {
                    FB.login(function (response) {
                        if (response.status === "connected") {
                            $.ajax({
                                type: "POST",
                                url: "login.aspx?action=login",
                                data: JSON.stringify({
                                    username: $("#txtUsernameLogin").val(),
                                    password: $("#txtPasswordLogin").val(),
                                    rememberMe: $("#chkRememberMe").is(':checked')
                                }),
                                async: true,
                                cache: false,
                                success: function (msg) {
                                    if (msg == "true") {
                                        var params = new URLSearchParams(window.location.search);
                                        var returnPage = "controltower.aspx";
                                        if (params.has("return")) {
                                            returnPage = params.get("return");
                                        }
                                        window.location.href = returnPage;
                                    } else {
                                        $("#lblLoginError").next().addClass("has-error");
                                        $("#lblLoginError").next().next().addClass("has-error");
                                        $("#lblLoginError").show("slow");
                                        console.log(msg);
                                    }
                                },
                                error: function (msg) {
                                    alert("Failed to Login (Check Console)");
                                    console.log(msg);
                                }
                            });
                        } else {
                            $("#lblLoginError").show("slow");
                            console.log(msg);
                        }
                    }, { scope: 'public_profile,email' });
                });
            });
        </script>
    </form>
</body>
</html>
