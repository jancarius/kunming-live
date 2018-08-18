<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserInfo.ascx.cs" Inherits="controls_UserInfo" %>

<div id="pnlUserInfo" class="box box-success box-shadow" style="display: none;">
    <div class="box-body">
        <div class="col-xs-4 no-padding">
            <img src="https://www.kunminglive.com/dist/img/male_placeholder.png" alt="User Info Avatar" class="img-responsive img-circle" />
        </div>
        <div class="col-xs-8 no-pad-right">
            <a class="btn btn-xs btn-success pull-right request-friend" data-toggle="tooltip" data-original-title="Request Friend"><i class="fa fa-user-plus"></i></a>
            <h5 class="panel-username"><strong></strong></h5>
            <h5 class="panel-location"><strong>Location:&nbsp;</strong><span></span></h5>
            <h5 class="panel-tagline"><strong></strong></h5>
            <h5 class="panel-joined"><strong>Joined:&nbsp;</strong><span></span></h5>
            <h5 class="panel-last-activity"><strong>Activity:&nbsp;</strong><span></span></h5>
        </div>
        <div class="overlay" style="display: none;">
            <i class="fa fa-refresh fa-spin"></i>
        </div>
    </div>
</div>

<script>
    $("body").on("mouseenter", "a[href*='https://www.kunminglive.com/view-profile/']", function (e) {
        if ($(this).closest("[data-show_info]").data("show_info") == false) { return false; }
        var $panel = $("#pnlUserInfo");
        $panel.appendTo(this);
        var userId = $(this).attr("href").replace("https://www.kunminglive.com/", "").split("/")[1];
        callBack("master.asmx/GetUser", { userId: userId }, function (msg) {
            $panel.find("img").attr("src", msg.d.Avatar);
            $panel.find(".panel-username strong").text(msg.d.FullName);
            $panel.find(".panel-location span").text(msg.d.Location);
            $panel.find(".panel-tagline strong").text(msg.d.Tagline);
            $panel.find(".panel-joined span").text(msg.d.TimeCreatedString);
            $panel.find(".panel-last-activity span").text(msg.d.LastLoginString);
            $panel.find(".request-friend").data("username", msg.d.Username);
            $panel.find(".overlay").hide();
        }, false);
        $panel.find(".overlay").show();
        $panel.show(function () {
            if ($panel.offset().top + 300 > windowDimensions().H) {
                $panel.css("bottom", "0");
            } else {
                $panel.css("bottom", "");
            }
        });
    });

    $("body").on("mouseleave", "a[href*='https://www.kunminglive.com/view-profile/']", function () {
        $("#pnlUserInfo").hide();
            $("#pnlUserInfo img").attr("src", "https://www.kunminglive.com/dist/img/male_placeholder.png");
            $("#pnlUserInfo .panel-username strong").text("");
            $("#pnlUserInfo .panel-location span").text("");
            $("#pnlUserInfo .panel-tagline strong").text("");
            $("#pnlUserInfo .panel-joined span").text("");
            $("#pnlUserInfo .panel-last-activity span").text("");
    });

    $("#pnlUserInfo .request-friend").on("click", function () {
        var username = $(this).data("username");
        var data = {
            username: username
        };
        callBack("master.asmx/RequestFriend", data, function (msg) {
            if (msg.d == true) {
                showSuccess("Friend Request Sent");
            } else if (msg.d == null) {
                showWarning("Cannot Friend Yourself");
            } else {
                submitError("Failed to Send Friend Request (Tech Support Notified)", JSON.stringify({ data: data, msg: msg }));
            }
        });
        return false;
    });
</script>
