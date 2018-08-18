<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="corner.aspx.cs" Inherits="corner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    English / Chinese Corner
                    <small>Language Exchange</small>
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="/"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">English / Chinese Corner</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-lg-4 col-xs-12 pull-right">
                <div id="pnlAvailableChats" class="box box-success box-state" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">Available Chats
                        </h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                        </div>
                    </div>
                    <div class="box-body table-responsive no-padding">
                        <table class="table table-hover">
                            <tbody id="showChatRooms" runat="server">
                                <tr>
                                    <th></th>
                                    <th>User</th>
                                    <th>Room</th>
                                    <th>Description</th>
                                </tr>
                            </tbody>
                        </table>

                        <div id="createChatBox" class="col-xs-12 popup-box" style="bottom: -20px;">
                            <div class="box box-success box-shadow">
                                <div class="box-header with-border">
                                    <h3 class="box-title">Create Chat Room</h3>
                                    <div class="box-tools pull-right">
                                        <button type="button" class="btn btn-box-tool close-popup-box"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                                <div class="box-body form-horizontal">
                                    <div class="form-group">
                                        <label for="txtChatTitle" class="col-xs-4 control-label">
                                            Chat Title
                                        </label>
                                        <div class="col-xs-8">
                                            <input id="txtChatTitle" type="text" class="form-control" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="txtChatDescription" class="col-xs-4 control-label">
                                            Description
                                        </label>
                                        <div class="col-xs-8">
                                            <input id="txtChatDescription" type="text" class="form-control" />
                                        </div>
                                    </div>
                                </div>
                                <div class="box-footer text-right">
                                    <div class="pull-left">
                                        <label for="chkChatPrivate" class="control-label">
                                            <input id="chkChatPrivate" type="checkbox" />
                                            Private
                                        </label>
                                    </div>
                                    <button id="btnCreateChat" type="button" class="btn btn-success">Create</button>
                                    <button id="btnCreateChatCancel" type="button" class="btn btn-warning">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-footer with-border">
                        <button id="btnCreateChatShow" type="button" class="btn btn-success btn-sm pull-right">Create Chat</button>
                    </div>
                </div>
            </div>

            <div class="col-xl-7 col-lg-8 col-xs-12">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Video Call</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12 relative">
                            <div class="video-placeholder">
                                <video id="remoteVideo" width="100%" autoplay></video>
                            </div>
                            <div class="video-placeholder">
                                <video id="localVideo" class="video-preview box-shadow box-shadow" autoplay muted></video>
                            </div>

                        </div>
                        <div id="videoChatBox" class="col-xs-6 col-xxs-8 popup-box">
                            <div class="box box-success direct-chat direct-chat-success box-shadow">
                                <div class="box-header with-border">
                                    <h3 class="box-title">Chat Box</h3>
                                    <div class="box-tools pull-right">
                                        <span data-toggle="tooltip" title="" class="badge bg-green" data-original-title="3 New Messages">3</span>
                                        <button type="button" class="btn btn-box-tool close-popup-box"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                                <div class="box-body">
                                    <div class="direct-chat-messages">
                                    </div>
                                </div>
                                <div class="box-footer">
                                    <div class="input-group">
                                        <input id="txtChatMessage" type="text" name="message" placeholder="Type Message ..." class="form-control" />
                                        <span class="input-group-btn">
                                            <button id="btnSendChatMessage" type="button" class="btn btn-success btn-flat">Send</button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-footer with-border">
                        <div class="col-xs-9">
                            <button id="btnHangup" class="btn btn-danger" type="button">Hang Up</button>
                        </div>
                        <div class="col-xs-3 pull-right text-right">
                            <button id="btnShowChat" class="btn btn-success" type="button">Show Chat</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="clearfix"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script src="dist/js/scaledrone.min.js"></script>
    <script src="dist/js/webrtc_adapter.js"></script>
    <script src="dist/js/webrtc.js"></script>
    <script>
        $("#btnShowChat").click(function () {
            $("#videoChatBox").toggle(500, function () {
                $("#txtChatMessage").focus();
            });
        });
        $(".close-popup-box").click(function () {
            $(this).parents(".popup-box").toggle(500);
        });
        $("#localVideo").click(function () {
            var chatBox = $("#videoChatBox");
            if ($(chatBox).is(":visible")) {
                $(chatBox).hide(500);
            }
        });

        $("#btnCreateChatShow").click(function () {
            $("#createChatBox").toggle(500, function () {
                $("#txtChatTitle").focus();
            })
        });
        $("#btnCreateChatCancel").click(function () {
            $("#createChatBox").toggle(500);
        });
        $("#btnHangup").click(function () {

        });
        $("#btnCreateChat").click(function () {
            var chatRoomName = establishChatRoom();
            var data = {
                roomTitle: $("#txtChatTitle").val(),
                roomDescription: $("#txtChatDescription").val(),
                roomName: chatRoomName,
                isPrivate: $("#chkChatPrivate").prop("checked")
            };
            callBack("corner.aspx/CreateChat", data, function (msg) {
                if (msg.d == null) {
                    showWarning("Must Be Logged In");
                } else if (msg.d == true) {
                    $("#showChatRooms").append(
                        "<tr class='chat-room-row' data-room_id='" + data.roomName + "' data-is_creator='true'>" +
                            "<td><img src='" + User.Avatar + "' class='img-circle profile-img' /></td>" +
                            "<td>" + User.FullName + "</td>" +
                            "<td>" + data.roomTitle + "</td>" +
                            "<td>" + data.roomDescription + "</td>" +
                        "</tr>");
                    $("#txtChatTitle").val("");
                    $("#txtChatDescription").val("");
                    $("#chkChatPrivate").prop("checked", false);
                    $("#createChatBox").toggle(500);
                }
            }, true, false);
        });

        setTimeout(updateAvailableChats, 10000);
        function updateAvailableChats() {
            callBack("corner.aspx/GetChats", null, function (msg) {
                $(".no-chats-available").remove();
                $(".chat-room-row").remove();
                if (msg.d.length > 0) {
                    var chatData = msg.d;
                    for (var i = 0; i < chatData.length; i++) {
                        $("#showChatRooms").append(
                            "<tr class='chat-room-row' data-room_id='" + chatData[i].Name + "' data-is_creator='" + chatData[i].IsCreator + "'>" +
                                "<td><img src='" + chatData[i].Creator.Avatar + "' class='img-circle profile-img' /></td>" +
                                "<td>" + chatData[i].Creator.FullName + "</td>" +
                                "<td>" + chatData[i].Title + "</td>" +
                                "<td>" + chatData[i].Description + "</td>" +
                            "</tr>");
                    }

                    $(".chat-room-row").click(function () {
                        if ($(this).data("is_creator") == true) { return; }
                        establishChatRoom($(this).data("room_id"));
                    });
                } else {
                    $("#showChatRooms").append("<tr class='no-chats-available'><td class='text-center' colspan='4'><em>None Available</em></td></tr>");
                }
                setTimeout(updateAvailableChats, 10000);
            }, false);
        }

        $(window).bind('beforeunload', function () {
            if (typeof (drone) !== "undefined") {
                var myRoom = $(".chat-room-row[data-room_id=" + drone.room.name + "]").data("is_creator");
                var userJoined = drone.room.members.length > 1;

                drone.localStream.getTracks().forEach(function (track) {
                    track.stop();
                });
                drone.room.unsubscribe();
                drone.close();

                if (myRoom && !userJoined) {
                    var data = {
                        username: User.Username
                    };
                    callBack("corner.aspx/CloseRoom", data, null, false, false, false);
                }
            }
        });
    </script>
</asp:Content>
