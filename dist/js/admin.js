$(window).on("load", function () {
    // Sortables //
    window.touchPunchDelay = 300;
    $(".connectedSortable").sortable({
        tolerance: "touch",
        scrollSensitivity: 50,
        stop: function () {
            var sortables = [];
            $(".connectedSortable").each(function () {
                sortables = sortables.concat($(this).sortable("toArray"));
            });

            var data = { sortableData: [], pageLink: Page.Link };
            for (var i = 0; i < sortables.length; i++) {
                data.sortableData[i] = {
                    sortOrder: i,
                    elementId: sortables[i],
                    containerId: $("#" + sortables[i]).closest(".connectedSortable").attr("id")
                };
            }
            callBack("master.asmx/SaveSortables", data, null, false);
        },
        connectWith: ".connectedSortable"
    });

    // Box States //
    $('[data-widget="collapse"]').click(function () {
        if ($(this).data("ignore") == true) { return; }
        var dynamic = $(this).closest(".box").attr("data-dynamic");
        if (typeof (dynamic) === "undefined" || dynamic == false) {
            dynamic = false;
        }
        var tableName = $(this).parent().data("table_name");
        var primaryId = $(this).parent().data("primary_identifier");
        var data = {
            elementId: $(this).closest(".box").attr("id"),
            elementTitle: $(this).parent().siblings(".box-title").text(),
            boxState: 0,
            dynamic: dynamic,
            tableName: typeof (tableName) === "undefined" ? null : tableName,
            primaryId: typeof (primaryId) === "undefined" ? null : primaryId,
            hidden: false
        };
        $(this).tooltip("hide");
        callBack("master.asmx/SaveBoxState", data, null, false);
    });

    $('[data-widget="remove"]').click(function () {
        if ($(this).data("ignore") == true) { return; }
        var dynamic = $(this).closest(".box").attr("data-dynamic");
        if (typeof (dynamic) === "undefined" || dynamic == false) {
            dynamic = false;
        }
        var tableName = $(this).parent().data("table_name");
        var primaryId = $(this).parent().data("primary_identifier");
        var data = {
            elementId: $(this).closest(".box").attr("id"),
            elementTitle: $(this).parent().siblings(".box-title").text(),
            boxState: 1,
            dynamic: dynamic,
            tableName: typeof (tableName) === "undefined" ? null : tableName,
            primaryId: typeof (primaryId) === "undefined" ? null : primaryId
        };
        $(this).tooltip("hide");
        callBack("master.asmx/SaveBoxState", data, null, false);
    });

    $('[data-dismiss="alert"]').click(function () {
        var data = {
            elementId: $(this).closest(".alert").attr("id"),
            elementTitle: $(this).siblings("h4").text(),
            boxState: 1,
            dynamic: false,
            tableName: null,
            primaryId: null,
            hidden: true
        }
        $(this).tooltip("hide");
        callBack("master.asmx/SaveBoxState", data, null, false);
    });

    $("#btnSidebarToggle").click(function () {
        var state = getCookie("sidebar-collapse");
        if (state == "true") {
            eraseCookie("sidebar-collapse");
        } else {
            setCookie("sidebar-collapse", "true", 365);
        }
    });

    // Sign In/Out/Register //
    $("#btnRegister").click(function () {
        if ($("#btnRegister").hasClass("btn-default")) {
            $("#btnSignin").removeClass("btn-success");
            $("#btnSignin").addClass("btn-default");
            $("#btnRegister").removeClass("btn-default");
            $("#btnRegister").addClass("btn-success");
            $("#frmSignin").slideUp("slow");
            $("#frmForgotSignin").slideUp("slow");
            $("#frmRegister").slideDown("slow", function () {
                $("#txtUsername").focus();
            });
        } else if ($("#btnRegister").hasClass("btn-success")) {
            if (checkUsername(false) && checkEmail(false) && checkPassword() && checkConfirmPassword() && checkAgreeTerms()) {
                var data = {
                    username: $("#txtUsername").val().trim(),
                    password: $("#txtPassword").val().trim(),
                    email: $("#txtEmail").val()
                };
                callBack("master.asmx/Register", data, function (msg) {
                    if (msg.d === "Valid") {
                        window.location.href = "controltower.aspx";
                    } else if (msg.d === "Confirm") {
                        window.location.href = "introduction.aspx";
                    } else {
                        $("#lblRegisterErrorText").text(msg.d);
                        if (msg.d.includes("Username")) {
                            $("#txtUsername").addClass("has-warning");
                        } else {
                            $("#txtUsername").removeClass("has-warning");
                        }
                        if (msg.d.includes("Email")) {
                            $("#txtEmail").addClass("has-warning");
                        } else {
                            $("#txtEmail").removeClass("has-warning");
                        }
                        $("#lblRegisterError").slideDown();
                        $(".loading-overlay").hide();
                    }
                }, true, true);
            }
        }
    });

    $("#btnSignin").click(function () {
        if ($("#btnSignin").hasClass("btn-default")) {
            $("#btnSignin").removeClass("btn-default").addClass("btn-success");
            $("#btnRegister").removeClass("btn-success").addClass("btn-default");
            $("#frmRegister").slideUp("slow");
            $("#frmForgotSignin").slideUp("slow");
            $("#frmSignin").slideDown("slow", function () {
                $("#txtUsernameLogin").focus();
            });
        } else if ($("#btnSignin").hasClass("btn-success")) {
            $("#txtUsernameLogin").parent().removeClass("has-error");
            $("#txtPasswordLogin").parent().removeClass("has-error");
            $("#lblLoginError").slideUp();
            var data = {
                username: $("#txtUsernameLogin").val(),
                password: $("#txtPasswordLogin").val(),
                rememberMe: $("#chkRememberMe").is(':checked')
            };
            callBack("master.asmx/Signin", data, function (msg) {
                if (msg.d === true) {
                    location.reload();
                } else if (msg.d === null) {
                    $("#lblLoginErrorText").text("User Inactive");
                    $("#lblLoginError").slideDown();
                    $(".loading-overlay").hide();
                } else if (msg.d === false) {
                    $("#lblLoginErrorText").text("Invalid Username/Password");
                    $("#txtUsernameLogin").parent().addClass("has-error");
                    $("#txtPasswordLogin").parent().addClass("has-error");
                    $("#lblLoginError").slideDown();
                    $(".loading-overlay").hide();
                }
            }, true, true);
        }
    });

    $("#btnForgotSignin").click(function () {
        $("#btnSignin").removeClass("btn-success").addClass("btn-default");
        $("#frmSignin").slideUp("slow");
        $("#frmForgotSignin").slideDown("slow", function () {
            $("#txtUsernameForgot").focus();
        });
    });
    $("#btnForgotSigninSubmit").click(function () {
        var username = $("#txtUsernameForgot").val();
        var email = $("#txtEmailForgot").val();
        if (username.length == 0 && email.length == 0) {
            showWarning("Must Provide Email or Username");
            return;
        }
        var data = {
            username: username,
            email: email
        }
        callBack("master.asmx/ForgotSignin", data, null, false);
        showWarning("Reset Instructions Sent to Your Email. Follow Instructions to Reset Your Password", 8);
        $("#btnSignin").removeClass("btn-default").addClass("btn-success");
        $("#frmForgotSignin").slideUp("slow");
        $("#frmSignin").slideDown("slow", function () {
            $("#txtUsernameLogin").focus();
        });
    });

    $("#btnSignOut").click(function () {
        callBack("master.asmx/Signout", null, function () { window.location.reload(); }, true, true);
    });

    $("#txtUsername").change({ ajaxCheck: true }, checkUsername);
    $("#txtEmail").change({ ajaxCheck: true }, checkEmail);
    $("#txtPassword").change(checkPassword);
    $("#txtConfirmPassword").change(checkConfirmPassword);
    $("#chkAgreeTerms").change(checkAgreeTerms);

    function checkUsername(event) {
        var regex = /^[a-zA-Z0-9_-]{3,15}$/;
        if (!regex.test($("#txtUsername").val())) {
            $("#txtUsername").parent().addClass("has-error");
            $("#lblRegisterErrorText").text("Invalid Username Format");
            $("#lblRegisterError").slideDown();
            return false;
        } else {
            $("#txtUsername").parent().removeClass("has-error");
            $("#lblRegisterError").slideUp();
            if (!event.data) { return true; }
            if (event.data.ajaxCheck) {
                callBack("master.asmx/CheckUsername", { username: $("#txtUsername").val() }, function (msg) {
                    if (msg.d === true) {
                        $("#lblRegisterError").slideUp();
                    } else if (msg.d === false) {
                        $("#lblRegisterErrorText").text("Username Already Exists");
                        $("#lblRegisterError").slideDown();
                    }
                }, false);
            } else {
                return true;
            }
        }
    }

    function checkEmail(event) {
        var regex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/;
        if (!regex.test($("#txtEmail").val())) {
            $("#txtEmail").parent().addClass("has-error");
            $("#lblRegisterErrorText").text("Invalid Email Format");
            $("#lblRegisterError").slideDown();
            return false;
        } else {
            if ($("#txtEmail").val().includes("@qq.com")) {
                $("#lblRegisterErrorText").text("Invalid Email Format");
                $("#lblRegisterError").slideDown();
                showWarning("@qq.com Emails Not Allowed Due to Restrictive Delivery Standards", 10)
                return false;
            } else {
                $("#txtEmail").parent().removeClass("has-error");
                $("#lblRegisterError").slideUp();
                if (!event.data) { return true; }
                if (event.data.ajaxCheck) {
                    var data = { email: $("#txtEmail").val() };
                    callBack("master.asmx/CheckEmail", data, function (msg) {
                        if (msg.d === true) {
                            $("#lblRegisterError").slideUp();
                        } else if (msg.d === false) {
                            $("#lblRegisterErrorText").text("Email Already Exists");
                            $("#lblRegisterError").slideDown();
                        }
                    }, false);
                } else {
                    return true;
                }
            }
        }
    }

    function checkPassword() {
        if ($("#txtPassword").val().length < 8) {
            $("#txtPassword").parent().addClass("has-error");
            $("#lblRegisterErrorText").text("Minimum 8 Characters");
            $("#lblRegisterError").slideDown();
            return false;
        } else if ($("#txtPassword").val().includes(" ")) {
            $("#txtPassword").parent().addClass("has-error");
            $("#lblRegisterErrorText").text("No Spaces Allowed");
            $("#lblRegisterError").slideDown();
            return false;
        } else {
            $("#txtPassword").parent().removeClass("has-error");
            $("#lblRegisterError").slideUp();
            return true;
        }
    }

    function checkConfirmPassword() {
        if ($("#txtConfirmPassword").val() !== $("#txtPassword").val()) {
            $("#txtConfirmPassword").parent().addClass("has-error");
            $("#lblRegisterErrorText").text("Passwords Do Not Match");
            $("#lblRegisterError").slideDown();
            return false;
        } else {
            $("#txtConfirmPassword").parent().removeClass("has-error");
            $("#lblRegisterError").slideUp();
            return true;
        }
    }

    function checkAgreeTerms() {
        if (!$("#chkAgreeTerms").is(':checked')) {
            $("#lblRegisterErrorText").text("Must Accept Terms of Service");
            $("#lblRegisterError").slideDown();
            return false;
        } else {
            $("#lblRegisterError").slideUp();
            return true;
        }
    }

    $("#txtUsernameLogin,#txtPasswordLogin,#chkRememberMe").on("keypress", function (e) {
        if (e.keyCode === 13) {
            $("#btnSignin").click();
            e.stopPropagation();
            return false;
        }
    });
    $("#txtUsername,#txtEmail,#txtPassword,#txtConfirmPassword,#chkAgreeTerms").on("keypress", function (e) {
        if (e.keyCode === 13) {
            $("#btnRegister").click();
            e.stopPropagation();
            return false;
        }
    });

    // Facebook Signin //
    if (typeof FB !== 'undefined') {
        FB.getLoginStatus(function (response) {
            window.facebookLoginResponse = response;
            console.log(response);
        }, { scope: 'email,public_profile' }, true);
    }

    $("#btnSigninFacebook").click(function () {
        $("#lblLoginError").slideUp();
        if (!FB) {
            $("#lblLoginErrorText").text("Facebook Not Available");
            $("#lblLoginError").slideDown();
        }
        if (window.facebookLoginResponse.status === 'connected') {
            var data = {
                username: window.facebookLoginResponse.authResponse.userID,
                rememberMe: $("#chkRememberMe").is(":checked")
            };
            callBack("master.asmx/Signin", data, function (msg) {
                if (msg.d === true) {
                    location.reload();
                } else if (msg.d === null) {
                    $(".loading-overlay").hide();
                    $("#lblLoginErrorText").text("User Inactive");
                    $("#lblLoginError").slideDown();
                } else if (msg.d === false) {
                    $(".loading-overlay").hide();
                    $("#lblLoginErrorText").text("Invalid Auth Token");
                    $("#lblLoginError").slideDown();
                }
            }, true, true);
        } else {
            FB.login(function (response) {
                if (response.status !== 'connected') {
                    $("#lblLoginErrorText").text("Failed to Connect to Facebook");
                    $("#lblLoginError").slideDown();
                }
                FB.api("/me",
                    { fields: "id,about,picture.width(128),birthday,email,location,middle_name,name,timezone" },
                    function (response) {
                        window.facebookUserInfo = response;
                        var data = {
                            username: response.id,
                            rememberMe: $("#chkRememberMe").is(":checked")
                        };
                        callBack("master.asmx/Signin", data, function (msg) {
                            if (msg.d === true) {
                                location.reload();
                            } else if (msg.d === null) {
                                $(".loading-overlay").hide();
                                $("#lblLoginErrorText").text("User Inactive");
                                $("#lblLoginError").slideDown();
                            } else if (msg.d === false) {
                                var data = {
                                    name: window.facebookUserInfo.name,
                                    authToken: window.facebookUserInfo.id,
                                    picture: window.facebookUserInfo.picture.data.url,
                                    email: window.facebookUserInfo.email
                                };
                                callBack("master.asmx/RegisterSocial", data, function (msg) {
                                    if (msg.d === "Valid") {
                                        window.location.reload();
                                    } else {
                                        $(".loading-overlay").hide();
                                        $("#lblLoginErrorText").text("Failed Facebook Login");
                                        $("#lblLoginError").slideDown();
                                    }
                                }, true, true);
                            }
                        }, true, true);
                    }
                );
            }, { scope: 'email,public_profile' });
        }
    });

    // Todo Items //
    $(".save-todo").click(function () {
        checkLogin(function (button) {
            var title = $(button).data("todo-title");
            var tableName = $(button).parent().data("table_name");
            var primaryIdentifier = $(button).parent().data("primary_identifier");
            var linkBack = $(button).data("link_back");
            var todoType = $(button).data("todo-type");
            var remove = $(button).find("i").hasClass("text-yellow");
            var data = {
                tableName: tableName,
                primaryIdentifier: primaryIdentifier,
                linkBack: linkBack,
                todoType: todoType,
                title: title,
                remove: remove
            };
            $(button).find("i").toggleClass("text-yellow");
            callBack("master.asmx/SaveTodoItem", data, function (msg) {
                if (msg.d === null) {
                    $("#" + tableName + "-" + primaryIdentifier + " i").removeClass("text-yellow");
                    showWarning("Must Be Logged In");
                } else if (msg.d === false) {
                    $("#" + tableName + "-" + primaryIdentifier + " i").removeClass("text-yellow");
                    submitError("Failed to Create Todo Item (Support Has Been Notified)", JSON.stringify({ errorMessage: msg, data: data }));
                }
            }, false);
        }, this, false);
    });

    // Scroll to Top //
    $(document).scroll(function () {
        var y = $(this).scrollTop();
        if (y > 100) {
            $('.scroll-to-top').fadeIn();
        } else {
            $('.scroll-to-top').fadeOut();
        }
    });

    $(".scroll-to-top").click(function () {
        $("html, body").animate({ scrollTop: 0 }, "slow");
    });

    // Update Conversations //
    setTimeout(UpdateConversations, 3000)
});

$(".top-bar-warning .clickable").click(function () {
    $(".top-bar-warning").slideUp();
});

// Setup States Before Page Load //
function setupTodoItems() {
    var todoItems = $("#hiddenTodoItems").val();
    if (todoItems.length > 0) {
        todoItems = todoItems.split("|")
        for (var i = 0; i < todoItems.length; i++) {
            var thisElement = $("#" + todoItems[i] + " i");
            if (thisElement.length > 0) {
                thisElement.addClass("text-yellow");
            }
        }
    }
}
setupTodoItems();

function setupBoxStates() {
    var hiddenBoxStates = $("#hiddenBoxStates").val();
    if (hiddenBoxStates.length > 0) {
        var data = hiddenBoxStates.split(",");
        for (var i = 0; i < data.length; i++) {
            var collapseBox = $("#" + data[i]);
            if (!collapseBox.hasClass("collapsed-box")) {
                collapseBox.addClass("collapsed-box");
            }
            collapseBox.find(".box-body").css("display", "none");
            collapseBox.find(".box-footer").css("display", "none");
            var collapseButton = collapseBox.find("[data-widget='collapse'] .fa");
            $(collapseButton).removeClass("fa-minus");
            $(collapseButton).addClass("fa-plus");
        }
    }
}
setupBoxStates();

$("body").tooltip({
    container: "body",
    selector: "[data-toggle=tooltip]"
});

// iChecks //
$('.icheck').iCheck({
    checkboxClass: 'icheckbox_square-green',
    radioClass: 'iradio_square-green',
    increaseArea: '20%'
});

// Dropdown Menu Bar Lists //
$("#btnUserMenu").click(function () {
    $(this).parent().siblings().removeClass("open");
    $("#btnUserMenu").parent().toggleClass("open");
    $("#txtUsernameLogin").focus();
    return false;
});
$("#btnWeatherMenu,#btnNotificationMenu,#btnMessagesMenu,#btnTasksMenu").click(function () {
    $(this).closest(".dropdown").siblings(".dropdown").removeClass("open");
    $(this).closest(".dropdown").toggleClass("open");
    $(this).tooltip("hide");
    $(this).blur();
    return false;
});
$(".navbar-custom-menu [data-toggle=control-sidebar]").click(function () {
    $(this).closest("li").siblings(".dropdown").removeClass("open");

});
$(".navbar.navbar-static-top").click(function (e) {
    if (e.target == $("nav.navbar.navbar-static-top")[0]) {
        $(this).find(".dropdown").removeClass("open");
        $("#btnOnlineStatusMenu").closest(".dropdown").removeClass("open");
    }
});
$("#contentWrapper,.main-sidebar").click(function (e) {
    if ($(this)[0] == $(".main-sidebar")[0] && $(e.currentTarget)[0] == $(".main-sidebar")[0]) { return true; }
    $(".navbar-custom-menu li").removeClass("open");
    $("#btnOnlineStatusMenu").closest(".dropdown").removeClass("open");
    $(".control-sidebar").removeClass("control-sidebar-open");
});
$("#btnOnlineStatusMenu").click(function () {
    $(this).closest(".dropdown").toggleClass("open");
    return false;
});
$(".content-wrapper").swipe({
    swipe: function (event, direction) {
        if (direction == "left") {
            if (!$("body").hasClass("sidebar-collapse")) {
                $("body").addClass("sidebar-collapse");
            }
        }
        if (direction == "right") {
            if ($(".control-sidebar").hasClass("control-sidebar-open")) {
                $(".control-sidebar").removeClass("control-sidebar-open");
            }
        }
    }
});

// Search Bar //
$("#txtSearch").on("keyup", function (e) {
    if (e.keyCode == 13) {
        $("#btnSearch").click();
        return false;
    }
});
$("#btnSearch").click(function (e) {
    var data = {
        searchText: $("#txtSearch").val()
    }
    callBack("master.asmx/Search", data, function (msg) {
        var body = $("#modalSearchResults .modal-body");
        var blogData = msg.d["Blog/Articles"];
        for (var i = 0; i < blogData.length; i++) {
            if (i == 0) {
                body.append(
                    "<table id='tblBlogSearchResults' class='table table-striped'>" +
                        "<tbody>" +
                            "<tr>" +
                                "<th class='col-sm-4'>Title</th>" +
                                "<th class='col-sm-8'>Content</th>" +
                            "</tr>" +
                        "</tbody>" +
                    "</table>");
            }
            body.find("#tblBlogSearchResults").append(
                "<tr>" +
                    "<td><a href='" + blogData[i].Link + "' target='_blank'>" + blogData[i].Title + "</a></td>" +
                    "<td>" + blogData[i].Content + "</td>" +
                "</tr>");
        }
        
        var eventData = msg.d["Events Calendar"];
        for (var i = 0; i < eventData.length; i++) {
            if (i == 0) {
                body.append(
                    "<table id='tblEventsSearchResults' class='table table-striped'>" +
                        "<tbody>" +
                            "<tr>" +
                                "<th class='col-sm-3'>Business</th>" +
                                "<th class='col-sm-3'>Title</th>" +
                                "<th class='col-sm-6'>Details</th>" +
                            "</tr>" +
                        "</tbody>" +
                    "</table>");
            }
            body.find("#tblEventsSearchResults").append(
                "<tr>" +
                    "<td><a href='" + eventData[i].Link + "' target='_blank'>" + eventData[i].Business + "</a></td>" +
                    "<td>" + eventData[i].Title + "</td>" +
                    "<td>" + eventData[i].Details + "</td>" +
                "</tr>");
        }

        var businessData = msg.d["Local Businesses"];
        for (var i = 0; i < businessData.length; i++) {
            if (i == 0) {
                body.append(
                    "<table id='tblBusinessSearchResults' class='table table-striped'>" +
                        "<tbody>" +
                            "<tr>" +
                                "<th class='col-sm-4'>Name</th>" +
                                "<th class='col-sm-8'>Description</th>" +
                            "</tr>" +
                        "</tbody>" +
                    "</table>");
            }
            body.find("#tblBusinessSearchResults").append(
                "<tr>" +
                    "<td><a href='" + businessData[i].Link + "' target='_blank'>" + businessData[i].Name + "</a></td>" +
                    "<td>" + businessData[i].Description + "</td>" +
                "</tr>");
        }

        var tipsData = msg.d["Tips & Tricks"];
        for (var i = 0; i < tipsData.length; i++) {
            if (i == 0) {
                body.append(
                    "<table id='tblTipsSearchResults' class='table table-striped'>" +
                        "<tbody>" +
                            "<tr>" +
                                "<th class='col-sm-4'>Title</th>" +
                                "<th class='col-sm-8'>Description</th>" +
                            "</tr>" +
                        "</tbody>" +
                    "</table>");
            }
            body.find("#tblTipsSearchResults").append(
                "<tr>" +
                    "<td><a href='" + tipsData[i].Link + "' target='_blank'>" + tipsData[i].Title + "</a></td>" +
                    "<td>" + tipsData[i].Description + "</td>" +
                "</tr>");
        }

        var classifiedData = msg.d["Classified Posts"];
        for (var i = 0; i < classifiedData.length; i++) {
            if (i == 0) {
                body.append(
                    "<table id='tblClassifiedSearchResults' class='table table-striped'>" +
                        "<tbody>" +
                            "<tr>" +
                                "<th class='col-sm-4'>Title</th>" +
                                "<th class='col-sm-8'>Description</th>" +
                            "</tr>" +
                        "</tbody>" +
                    "</table>");
            }
            body.find("#tblClassifiedSearchResults").append(
                "<tr>" +
                    "<td><a href='" + classifiedData[i].Link + "' target='_blank'>" + classifiedData[i].Title + "</a></td>" +
                    "<td>" + classifiedData[i].Description + "</td>" +
                "</tr>");
        }

        $("#modalSearchResults").modal("show");
    });
    e.stopPropagation();
});

// Notifications //
function showNotificationBar(notificationId, url) {
    var forward = (typeof (url) !== "undefined");
    callBack("master.asmx/ViewNotification", { notificationId: notificationId }, function (msg) {
        if (forward) {
            window.location.href = url;
        } else {
            var li = $("[data-notification_id=" + notificationId + "]")
            li.removeClass("bg-success");
            li.find("i[class=fa-check-circle]").remove();
        }
    }, forward, forward);
}
function dismissNotificationBar(notificationId) {
    callBack("master.asmx/DismissNotification", { notificationId: notificationId }, null, false);
    var li = $("[data-notification_id=" + notificationId + "]");
    var lblCount = $("#lblYouHaveNotificationCount");
    lblCount.text(parseInt(lblCount.text()) - 1);
    li.find("[data-toggle=tooltip]").tooltip("hide");
    li.remove();
}

// Messages //
$("#pnlMessagesList").on("click", "[data-conversation_id]", function () {
    var conversationId = $(this).data("conversation_id");
    var checkExists = $("#conversationsContainer [data-conversation_id=" + conversationId + "]");
    if (checkExists.length > 0) {
        if (checkExists.hasClass("collapsed-box")) {
            checkExists.find("[data-widget=collapse]").click();
        }
        checkExists.find(".conversation-message").focus();
        return;
    }
    var readingCount = parseInt($(this).find(".badge").text());
    $(this).find(".badge").removeClass("bg-green").addClass("bg-gray").text("0");
    var lblMessagesMenuCount = $(this).closest(".dropdown-menu").find("#lblMessagesMenuCount");
    var currentUnreadCount = parseInt(lblMessagesMenuCount.text());
    lblMessagesMenuCount.text(currentUnreadCount - readingCount)
    var lblMessagesCount = $(this).closest(".dropdown").find("#lblMessagesCount");
    if (currentUnreadCount - readingCount == 0) {
        lblMessagesCount.addClass("hidden");
    }
    lblMessagesCount.text(currentUnreadCount - readingCount);
    var data = {
        conversationId: conversationId
    }
    callBack("master.asmx/GetChatBox", data, function (msg) {
        if (msg.d == null) {
            showWarning("Must be Logged In");
        } else {
            var $container = $("#conversationsContainer")
            $container.append(msg.d);
            $container.find(".direct-chat-messages")[0].scrollTop = $container.find(".direct-chat-messages")[0].scrollHeight;
            $container.find("[data-conversation_id=" + conversationId + "] .conversation-message").focus();
            setChatCookies();
        }
    });
    $(this).closest(".dropdown").removeClass("open");
});

$("#btnShowCreateConversation").click(function () {
    callBack("master.asmx/GetFriendNames", null, function (msg) {
        var modal = $("#modalCreateConversation");
        modal.find("#txtCreateConversationParticipants").tagify({
            duplicates: false,
            suggestionsMinChars: 2,
            enforceWhitelist: true,
            whitelist: msg.d,
            maxTags: 12
        });
        modal.on("modal.bs.shown", function () {
            modal.find("tags .input.placeholder").focus();
        });
        modal.modal("show");
    });
    $(this).closest(".dropdown").removeClass("open");
});

$("#pnlFriendsList").on("click", ".fa-comments", function () {
    var boxConvo = $("#pnlFriendsListConversation");
    boxConvo.appendTo($(this).closest("li"));
    boxConvo.slideDown("slow", function () {
        boxConvo.find("#txtFriendsConversationTitle").focus();
    });
});
$("#pnlFriendsList").on("click", ".fa-commenting", function () {
    var boxNote = $("#pnlFriendsListNote");
    boxNote.appendTo($(this).closest("li"));
    if ($(this).attr("data-original-title") != "Attach Comment") {
        boxNote.find("#txtFriendsNote").val($(this).attr("data-original-title").replace(/<br>/g, "\r\n"));
    }
    boxNote.slideDown("slow", function () {
        boxNote.find("#txtFriendsNote").focus();
    });
});
$("#pnlFriendsList").on("click", ".fa-star", function () {
    $(this).toggleClass("text-yellow");
    var data = {
        favorite: $(this).hasClass("text-yellow"),
        username: $(this).closest("li").data("username")
    };
    callBack("master.asmx/FavoriteFriend", data, null, false);
    var thisLi = $(this).closest("li");
    thisLi.attr("data-favorite", "null");
    if (data.favorite) {
        thisLi.insertAfter(thisLi.siblings("[data-favorite=true]:last"));
    } else {
        thisLi.insertBefore(thisLi.siblings("[data-favorite=false]:first"));
    }
    thisLi.attr("data-favorite", data.favorite);
});

$("#btnFriendsConversationSubmit").on("click", function () {
    var box = $(this).closest(".box");

    var title = box.find("#txtFriendsConversationTitle");
    var message = box.find("#txtFriendsConversationMessage");
    var usernames = [box.closest("li").data("username")];

    createConversation(title.val(), usernames, message.val());

    box.slideUp("slow", function () {
        title.val("");
        message.val("");
    });
});
$("#btnFriendsConversationCancel").on("click", function () {
    $(this).closest(".box").slideUp("slow", function () {
        var box = $(this).closest(".box");
        box.find("#txtFriendsConversationTitle").val("");
        box.find("#txtFriendsConversationMessage").val("");
    });
});
$("#btnFriendsNoteSubmit").on("click", function () {
    var box = $(this).closest(".box");

    var note = box.find("#txtFriendsNote");
    var username = box.closest("li").data("username");

    var noteVal = note.val().replace(/\r?\n/g, '<br>');

    var data = {
        note: noteVal,
        username: username
    };

    callBack("master.asmx/AddFriendNote", data, null, false);

    box.siblings("span").find(".fa-commenting").attr("data-original-title", data.note).addClass("text-green");

    box.slideUp("slow", function () {
        note.val("");
    });
});
$("#btnFriendsNoteCancel").on("click", function () {
    $(this).closest(".box").slideUp("slow", function () {
        $(this).find("#txtFriendsListNote").val("");
    });
});

$("#conversationsContainer").on("click", ".submit-chat", function () {
    var convoId = $(this).closest(".box").data("conversation_id");
    var message = $(this).parent().siblings(".conversation-message");
    var group = $(this).closest(".input-group");

    if (message.val().length == 0 || message.val().length > 500) {
        group.addClass("has-error");
        showWarning("Message must be more than 0 and less than 500 characters.");
        return;
    } else {
        group.removeClass("has-error");
    }

    var data = {
        conversationId: convoId,
        message: message.val()
    };
    
    message.attr("disabled", "disabled");
    message.val("Sending...");
    callBack("master.asmx/SendMessage", data, function (msg) {
        if (msg.d == null) {
            showWarning("Failed Sending Message! Please Try Refreshing the Page.");
            message.val(data.message);
            return;
        }
        var response = parseInt(msg.d);
        if (response > 0) {
            $chatMessages = $(".direct-chat[data-conversation_id=" + convoId + "] .direct-chat-messages")
            $chatMessages.append(
                "<div class='direct-chat-msg right' data-conversation_message_id='" + msg.d + "'>" +
                    "<div class='direct-chat-info clearfix'>" +
                        "<span class='direct-chat-name pull-right'>" + User.FullName + "</span>" +
                        "<span class='direct-chat-timestamp pull-left'>" + moment().format("MMM d @ HH:mm:ss") + "</span>" +
                    "</div>" +
                    "<img class='direct-chat-img' src='" + User.Avatar + "' alt='Sender Avatar'>" +
                    "<div class='direct-chat-text'>" + data.message + "</div>" +
                "</div>");
            $chatMessages[0].scrollTop = $chatMessages[0].scrollHeight;
            message.val("");
        } else {
            submitError("Failed to Send Message", JSON.stringify({ data: data, msg: msg }));
        }
        message.removeAttr("disabled");
    }, false);
});
$("#conversationsContainer").on("keyup", ".conversation-message", function (e) {
    if (e.keyCode == 13) {
        $(this).siblings(".input-group-btn").find(".submit-chat").click();
        return;
    }
    if ($(this).val().length > 0) {
        $(this).closest(".input-group").removeClass("has-error");
    }
});

$("#btnCreateConversation").click(function () {
    var title = $("#txtCreateConversationTitle").val();
    var usernames = $("#txtCreateConversationParticipants").val().split(",");
    var message = $("#txtCreateConversationMessage").val();

    if (title.length == 0) {
        $("#lblCreateConversationErrorText").text("Must Create a Title");
        $("#lblCreateConversationError").slideDown();
        return;
    } else { $("#lblCreateConversationError").slideUp(); }
    if (usernames[0].length == 0) {
        $("#lblCreateConversationErrorText").text("Must Have at Least One Recipient");
        $("#lblCreateConversationError").slideDown();
        return;
    } else { $("#lblCreateConversationError").slideUp(); }
    if (message.length == 0) {
        $("#lblCreateConversationErrorText").text("Must Enter a Message");
        $("#lblCreateConversationError").slideDown();
        return;
    } else { $("#lblCreateConversationError").slideUp(); }

    createConversation(title, usernames, message);
});

function createConversation(title, usernames, message) {
    var data = {
        title: title,
        usernames: usernames,
        message: message
    }
    callBack("master.asmx/CreateConversation", data, function (msg) {
        if (msg.d == null) {
            showWarning("Must be Logged In");
            $(".loading-overlay").hide();
        } else {
            var $container = $("#conversationsContainer");
            var convoId = $(msg.d).find(".direct-chat").data("conversation_id");
            var $convoChatBox = $container.find("[data-conversation_id=" + convoId + "]");
            if ($convoChatBox.length == 0) {
                $container.append(msg.d);
            } else {
                if ($convoChatBox.hasClass("collapsed-chat")) {
                    $convoChatBox.find("[data-widget=collapse]").click();
                }
                $convoChatBox.find(".conversation-message").focus();
            }
            setChatCookies();
            $container.find(".direct-chat-messages")[0].scrollTop = $container.find(".direct-chat-messages")[0].scrollHeight;
        }
    });
}

function UpdateConversations() {
    var openChats = [];
    var lastConversationId = 0;
    $("#conversationsContainer .direct-chat").each(function () {
        if (parseInt($(this).data("conversation_id")) > lastConversationId) {
            lastConversationId = $(this).data("conversation_id");
        }
        var openConvoId = $(this).data("conversation_id");
        var openLastMessage = $(this).find(".direct-chat-msg:last").data("conversation_message_id");
        openChats.push({
            conversationId: openConvoId,
            lastMessageId: openLastMessage
        });
    });

    $("#pnlMessagesList [data-conversation_id]").each(function () {
        if (parseInt($(this).data("conversation_id")) > lastConversationId) {
            lastConversationId = $(this).data("conversation_id");
        }
    });

    var data = {
        openChats: openChats,
        lastConversationId: lastConversationId
    };
    callBack("master.asmx/UpdateChats", data, function (msg) {
        if (msg.d == null) { return; }
        var openChats = msg.d.OpenChats;
        var newChats = msg.d.NewChats;

        for (var i = 0; i < openChats.length; i++) {
            var $chatBox = $(".direct-chat[data-conversation_id=" + openChats[i].ConversationID + "]");
            $chatBox.find(".direct-chat-messages").append(openChats[i].NewMessages);
            var avatarHtml = "";
            var avatarUserIds = [];
            var fullNames = [];
            for (var ii = 0; ii < openChats[i].Participants.length; ii++) {
                var participant = openChats[i].Participants[ii];
                avatarUserIds.push(participant.UserID);
                fullNames.push(participant.FullName);
                if ($chatBox.find(".chat-avatars [data-avatar_user_id=" + participant.UserID + "]").length == 0) {
                    $chatBox.find(".chat-avatars").append(
                        "<div class='col-xs-2' style='padding:0 5px' data-avatar_user_id='" + participant.UserID + "'>" +
                            "<a href='https://www.kunminglive.com/view-profile/" + participant.UserID + "'><img src='" + participant.Avatar + "' class='img-responsive img-circle' /></a>" +
                        "</div>");
                }
            }
            $chatBox.data("conversation_participants", fullNames.join(";"));
            $chatBox.find(".chat-avatars [data-avatar_user_id]").each(function () {
                if (!avatarUserIds.includes($(this).data("avatar_user_id"))) {
                    $(this).remove();
                }
            });
        }

        var $container = $("#conversationsContainer");
        var $lblMessagesCount = $("#lblMessagesCount");
        var $lblMessagesMenuCount = $("#lblMessagesMenuCount");
        for (var i = 0; i < newChats.length; i++) {
            if ($container.find("[data-conversation_id=" + newChats[i].ConversationID + "]").length > 0) { continue; }
            $container.append(newChats[i].ChatBox);
            var unread = $(newChats[i].ChatBox).find(".direct-chat-msg").length;
            var title = $(newChats[i].ChatBox).find(".box-title").text();
            $lblMessagesCount.removeClass("hidden");
            var totalUnread = parseInt($lblMessagesMenuCount.text()) + unread;
            $lblMessagesCount.text(totalUnread);
            $lblMessagesMenuCount.text(totalUnread);
            $("#pnlMessagesList li").filter(function () {
                return this.attributes.length == 0;
            }).remove();
            $("#pnlMessagesList").append(
                "<li data-conversation_id='" + newChats[i].ConversationID + "'" + (unread > 0 ? " class='unread-conversation'" : "") + ">" +
                    "<a href='#'>" +
                        "<span data-toggle='tooltip' class='badge " + (unread > 0 ? "bg-green" : "bg-gray") + " pull-right chat-new-messages' data-original-title='" + unread + " Unread Messages'>" + unread + "</span>" +
                        "<h4>" +
                            title +
                        "</h4>" +
                    "</a>" +
                "</li>");
            setChatCookies();
        }
        var $msgContainer = $container.find(".direct-chat-messages");
        if ($msgContainer.length > 0) {
            $msgContainer[0].scrollTop = $msgContainer[0].scrollHeight;
        }
        setTimeout(UpdateConversations, 3000)
    }, false);
}

$(".direct-chat .direct-chat-messages").each(function () {
    $(this)[0].scrollTop = $(this)[0].scrollHeight;
});

$("#conversationsContainer").on("click", ".direct-chat [data-widget=collapse]", function () {
    var $box = $(this).closest(".box")
    $box.toggleClass("collapsed-chat");
    setChatCookies()
});
$("#conversationsContainer").on("click", ".direct-chat [data-widget=remove]", function () {
    $(this).tooltip("hide");
    removeChatCookies($(this).closest(".box").data("conversation_id"));
});
$("#conversationsContainer").on("click", ".chat-options-button", function () {
    $(this).closest(".dropdown").toggleClass("open");
});
$("#conversationsContainer").on("click", ".leave-conversation", function () {
    var confirmText;
    if ($(this).siblings(".invite-conversation").length > 0) {
        confirmText = "You are the creator of this chat. If you leave, participants will still have access but you cannot be invited back.";
    } else {
        confirmText = "You will not be able to rejoin this conversation unless invited!";
    }
    var convoId = $(this).closest(".direct-chat").data("conversation_id");
    confirmWarning(confirmText, function leaveConversation() {
        callBack("master.asmx/LeaveChat", { conversationId: convoId }, null, false);
        $(".direct-chat [data-conversation_id=" + convoId + "]").parent().remove();
        $("pnlMessagesList [data-conversation_id=" + convoId + "]").remove();
        
    });
});
$("#conversationsContainer").on("click", ".invite-conversation", function () {
    var currentParticipants = $(this).closest(".box").data("conversation_participants").split(";");
    var inviteButton = $(this);
    callBack("master.asmx/GetFriendNamesExclude", { excludeUsernames: currentParticipants }, function (msg) {
        var inputBox = inviteButton.siblings(".dropdown-menu").find(".invite-conversation-users");
        inputBox[0].tagify = inputBox.tagify({
            duplicates: false,
            suggestionsMinChars: 2,
            enforceWhitelist: true,
            whitelist: msg.d,
            maxTags: 12 - currentParticipants.length
        });
        inviteButton.closest(".dropdown").toggleClass("open");
    });
});
$("#conversationsContainer").on("click", ".do-invite-conversation-users", function () {
    var usersBox = $(this).closest(".box").find("input.invite-conversation-users");
    var inviteUsers = usersBox.val().split(",");

    if (inviteUsers[0].length == 0) {
        showWarning("Must Enter a User!");
        return;
    }

    var data = {
        conversationId: $(this).closest(".direct-chat").data("conversation_id"),
        fullNames: inviteUsers
    }

    callBack("master.asmx/InviteUser", data, null, false);

    $(this).closest(".dropdown").removeClass("open").closest(".dropdown").removeClass("open");
});

function setChatCookies() {
    var openConversations = [];
    $(".direct-chat").each(function () {
        openConversations.push($(this).data("conversation_id") + "|" + $(this).hasClass("collapsed-chat"));
    });
    setCookie("open-conversations", openConversations.join(","), 365);
}
function removeChatCookies(conversationId) {
    var openConversations = getCookie("open-conversations").split(",");
    var $chat = $(".direct-chat [data-conversation_id=" + conversationId + "]");
    openConversations.splice(openConversations.indexOf(conversationId + "|" + $chat.hasClass("collapsed-chat")), 1);
    setCookie("open-conversations", openConversations.join(","), 365);
}

// Todo-Items Menu //
function todoMenuDone(todoItemId) {
    var data = {
        todoItemIds: [todoItemId],
        done: true
    };
    var li = $("[data-todo_item_id=" + todoItemId + "]");
    var label = li.closest(".dropdown-menu").find("#lblTasksInnerCount");
    var count = parseInt(label.text())
    label.text(count - 1);
    if (count == 0) {
        label.addClass("hidden");
        $("#pnlTasksList").html(
            "<li><a href='#' style='cursor:default;'>" +
                "<i class='fa fa-check text-black'></i>&nbsp;You Haven't Saved Any Items" +
            "</a></li>");
    }
    $("#lblTasksCount").text(label.text());
    li.remove();
    callBack("master.asmx/TodoItemDone", data, null, false);
}

function todoMenuDelete(todoItemId) {
    var data = {
        deleteItems: [todoItemId]
    };
    var li = $("[data-todo_item_id=" + todoItemId + "]");
    var label = li.closest(".dropdown-menu").find("#lblTasksInnerCount");
    var count = parseInt(label.text())
    label.text(count - 1);
    if (count == 0) {
        label.addClass("hidden");
        $("#pnlTasksList").html(
            "<li><a href='#' style='cursor:default;'>" +
                "<i class='fa fa-check text-black'></i>&nbsp;You Haven't Saved Any Items" +
            "</a></li>");
    }
    $("#lblTasksCount").text(label.text());
    li.remove();
    callBack("master.asmx/DeleteTodoItem", data, null, false);
};

// Online Status Type //
$(".online-status-menu .dropdown-menu a").click(function () {
    var onlineStatusType = $(this).data("online-status-type");
    $("#btnOnlineStatusMenu").html($(this).html());
    callBack("master.asmx/UpdateOnlineStatus", { onlineStatus: onlineStatusType }, null, false);
    $("#btnOnlineStatusMenu").closest(".dropdown").removeClass("open");
});

// Slideshow //
$(".close-slideshow").click(function () {
    $("#showImagesCarousel").attr("data-interval", "false");
    $("#showImagesCarousel").carousel("pause").removeData();
    $("#showImagesCarousel .carousel-indicators").html("");
    $("#showImagesCarousel .carousel-inner").html("");
    $(".slideshow-overlay").hide();
});

function showImageSlideshow(image) {
    var images = [$(image).attr("src")];
    $(image).closest(".carousel-images-panel").find("img").each(function () {
        if (this == image) { return; }
        images.push($(this).attr("src"))
    });
    for (var i = 0; i < images.length; i++) {
        $("#showImagesCarousel .carousel-inner").append(
            "<div class='item" + (i == 0 ? " active" : "") + "' style='border:0;'>" +
                "<img src='" + images[i].replace("_thumb", "") + "' alt='Slide #" + i + "' style='margin:auto;' />" +
            "</div>");
        $("#showImagesCarousel .carousel-indicators").append("<li data-target='#showImagesCarousel' data-slide-to='" + i + "' " + (i == 0 ? "class='active'" : "") + "></li>");
    }

    $(".slideshow-overlay").show();
    $(".slideshow-overlay").css("display", "flex");

    $("#showImagesCarousel").attr("data-interval", 8000);
    $("#showImagesCarousel").carousel("pause").removeData();
    $("#showImagesCarousel").carousel({
        interval: 8000
    }).carousel("cycle");
}

var $contentWrapper = $("#contentWrapper");
$contentWrapper.attr("style", $contentWrapper.attr("style") + $contentWrapper.data("style"))

// Helper Functions //
var User = $("#hiddenUserInfo").val();
if (User.length > 0) {
    User = JSON.parse(User);
}

var Page = $("#hiddenPageInfo").val();
if (Page.length > 0) {
    Page = JSON.parse(Page);
}

function showWarning(msg, timeout) {
    if (!timeout) { timeout = 5000; }
    else { timeout = timeout * 1000; }
    $(".top-bar-warning h4").text(msg);
    $(".top-bar-warning").slideDown();
    setTimeout(function () {
        $(".top-bar-warning").slideUp();
    }, timeout);
}
function showSuccess(msg, timeout) {
    if (!timeout) { timeout = 5000; }
    else { timeout = timeout * 1000; }
    $(".top-bar-success h4").text(msg);
    $(".top-bar-success").slideDown();
    setTimeout(function () {
        $(".top-bar-success").slideUp();
    }, timeout);
}

function submitError(msg, stringifyParams) {
    $(".loading-overlay").hide();
    showWarning(msg, 8);
    var data = {
        message: msg,
        stringifyParams: stringifyParams
    }
    callBack("master.asmx/JavascriptError", data, null, false);
}

function confirmWarning(msg, callback) {
    $("#confirmWarning .modal-body p").html(msg);
    $("#btnConfirmWarning").click(callback);
    $("#confirmWarning").modal("show");
}

function checkLogin(callback, callbackParam, showOverlay, persistOverlay) {
    if (typeof (showOverlay) == "undefined") {
        showOverlay = true;
    }
    if (typeof (persistOverlay) == "undefined") {
        persistOverlay = true;
    }
    callBack("master.asmx/CheckLogin", null, function (msg) {
        if (!msg.d == true) {
            if ($("#lvLoggedIn").length > 0) {
                showWarning("Login Timed Out (If you still have work to save then open another tab and sign in there, otherwise refresh the page)", 60000);
            } else {
                showWarning("Must Be Logged In");
                $("#btnUserMenu").click();
            }
            $(".loading-overlay").hide();
            return;
        }
        callback(callbackParam);
    }, showOverlay, persistOverlay);
}
function getPageName(url) {
    var index = url.lastIndexOf("/") + 1;
    var filenameWithExtension = url.substr(index);
    var filename = filenameWithExtension.split(".")[0];
    return filename;
}

function getParam(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function readFile(input, callback, persistOverlay, imageContainerIndex, moveDirectory, getBase64) {
    if (typeof (persistOverlay) === "undefined") {
        persistOverlay = false;
    }
    if (typeof (moveDirectory) === "undefined") {
        moveDirectory = null;
    } else if (moveDirectory == "") { moveDirectory = null; }
    if (input) {
        $(".loading-overlay").show();
        var reader = new FileReader();
        reader.onload = function (e) {
            var base64Image = e.target.result;
            var imgExt = base64Image.substring(base64Image.indexOf("/") + 1, base64Image.indexOf(";"));
            if (!["jpeg", "jpg", "gif", "png"].includes(imgExt)) {
                showWarning("Only JPEG, PNG, or GIF Allowed!");
                return;
            }
            if (getBase64) {
                callback(e.target.result);
                return;
            }
            callBack("master.asmx/ResizeImage", { base64Image: e.target.result, moveDirectory: moveDirectory }, function (msg) {
                callback(msg.d, imageContainerIndex);
            }, true, persistOverlay);
        }
        reader.readAsDataURL(input);
    } else { $(".loading-overlay").hide(); }
}

function callBack(url, data, success, showOverlay, persistOverlay, async) {
    if (typeof (showOverlay) === "undefined") {
        showOverlay = true;
    }
    if (typeof (persistOverlay) === "undefined") {
        persistOverlay = false;
    }
    if (typeof (async) === "undefined") {
        async = true;
    }
    if (!url.includes("http")) {
        url = "https://www.kunminglive.com/" + url;
    }
    var options = {
        type: "POST",
        url: url,
        contentType: "application/json; charset=utf-8",
        async: async,
        data: JSON.stringify(data),
        dataType: "json",
        error: function (msg) {
            if (msg.status !== 0) {
                submitError("Request Failed (Technical Support Notified)", JSON.stringify({ url: url, data: data, error: msg }));
            }
            $(".loading-overlay").hide();
        },
        complete: function (msg) {
            if (!persistOverlay && showOverlay) {
                $(".loading-overlay").hide();
            }
            console.log(msg);
        }
    }
    if (!data) {
        options.data = "{null:null}";
    }
    if (success) {
        options.success = success;
    }
    if (showOverlay) {
        $(".loading-overlay").show();
    }
    $.ajax(options);
}

function stripTags(content) {
    return $(document.createElement("div")).html(content).text().replace("//previewContent\\", "").replace("//shortContent\\", "");
}

function setCookie(name,value,days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days*24*60*60*1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}
function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}
function eraseCookie(name) {   
    document.cookie = name+'=; Max-Age=-99999999;';  
}

jQuery(document).arrive('div.box [data-widget]', (element) => {
    $(element).parents('.box').boxWidget();
});

function getCursorXY(e) {
    return {
        X: (window.Event) ? e.pageX : event.clientX + (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft),
        Y: (window.Event) ? e.pageY : event.clientY + (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop)
    };
}

function windowDimensions() {
    return {
        W: Math.max(document.documentElement.clientWidth, window.innerWidth || 0),
        H: Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    };
}