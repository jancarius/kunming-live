$("#btnComposeMessage").click(function () {
    callBack("mailbox.aspx/GetUserEmails", null, function (msg) {
        var whitelist = []
        for (var i = 0; i < msg.d.length; i++) {
            whitelist.push(msg.d[i].FullName + " [" + msg.d[i].Email + "]");
        }
        $("#txtComposeTo").tagify({
            duplicates: false,
            suggestionsMinChars: 1,
            enforceWhitelist: true,
            whitelist: whitelist
        }).on("duplicate", function () {
            composeErrorMessage("Duplicate Email Address", 5000);
        }).on("notWhitelisted", function () {
            composeErrorMessage("Select a Valid Recipient", 5000);
        });
        
        $("#modalComposePM").modal({
            show: true,
            backdrop: "static",
            keyboard: false
        });
    }, true, false);
});

$("#btnSendComposePM").click(function () {
    var recipients = $("#txtComposeTo").val().split(",");
    var subject = $("#txtComposeSubject").val();
    var body = $("#composeTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
    if (subject.length == 0) {
        subject = "(No Subject)";
    }

    var data = {
        subject: subject,
        body: body,
        recipients: recipients
    };

    callBack("mailbox.aspx/SendMail", data, function (msg) {
        if (msg.d == null) {
            showWarning("Session Timed Out (Sign in on Separate Tab)");
        } else if (msg.d == false) {
            showWarning("Limited to 1 Email per Minute");
        } else if (msg.d == true) {

        }
    });
});

$("#btnSubmitReply").click(function () {
    var body = $("#replyTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
    var threadId = $("#pnlMailView .mail-message").data("thread_id");
    if (body.length == 0) {
        showWarning("Must Reply Text");
        return;
    }
    var data = {
        threadId: threadId,
        body: body
    };

    callBack("mailbox.aspx/SendReply", data, function (msg) {
        if (msg.d == null) {
            showWarning("Session Timed Out (Sign in on Separate Tab)");
        } else if (msg.d == false) {
            submitError("Failed to Reply (Tech Support Notified)", JSON.stringify({ data: data, msg: msg }));
        } else {
            $("#pnlMailView tbody").append(createViewMail(msg.d));
            $("#replyTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html("");
        }
    });
});

function viewMail(element) {
    $(element).find(".mailbox-read .fa").removeClass("fa-envelope").addClass("fa-envelope-open-o");
    $("#lblReturnToFolder").data("panel_id", $(element).closest(".mailbox-messages").attr("id"));
    $(".mail-message").remove();
    var data = {
        threadId: $(element).data("thread_id")
    };
    callBack("mailbox.aspx/GetThread", data, function (msg) {
        var mails = msg.d;
        for (var i = 0; i < mails.length; i++) {
            $("#pnlMailView tbody").append(createViewMail(mails[i]));
        }
        $(".mailbox-messages").slideUp();
        $("#pnlMailView").slideDown();
        $("#lblReturnToFolder").removeClass("hidden");
    });
}

function createViewMail(mailObj) {
    var showRecipients = "";
    for (var i = 0; i < mailObj.Recipients.length; i++) {
        showRecipients += "<a href='viewprofile.aspx?id=" + mailObj.Recipients[i].UserID + "' target='_blank' data-toggle='tooltip' data-original-title='" + mailObj.Recipients[i].Email + "'>" + mailObj.Recipients[i].FullName + "</a>, ";
    }
    showRecipients = showRecipients.substr(0, showRecipients.length - 2);
    return "<tr class='mail-message' data-thread_id='" + mailObj.ThreadID + "'>" +
                "<td>" +
                    "<div class='col-xs-12 no-padding margin-bottom valign mail-message'>" +
                        "<div class='col-xl-1 col-md-2 col-xs-3 no-pad-right'>" +
                            "<img src='" + mailObj.Sender.Avatar + "' alt='Sender Avatar' class='img-responsive img-circle' />" +
                        "</div>" +
                        "<div class='col-xl-11 col-md-10 col-xs-9'>" +
                            "<h4><a href='viewprofile.aspx?id=" + mailObj.Sender.UserID + "' target='_blank' data-toggle='tooltip' data-original-title='" + mailObj.Sender.Email + "'>" + mailObj.Sender.FullName + "</a></h4>" +
                            "<h5><strong>To:</strong>&nbsp;" + showRecipients + "</h5>" +
                            "<h5>" + mailObj.TimeSentString + "&nbsp;&nbsp;<i class='fa fa-clock-o'></i>&nbsp;" + mailObj.TimeSince + "</h5>" +
                        "</div>" +
                    "</div>" +
                    "<div class='col-xs-12'>" +
                        mailObj.Body +
                    "</div>" +
                "</td>" +
            "</tr>";
}

function getMessages() {
    var folder = $(".mailbox-messages:visible").data("folder_id")
    if (typeof (folder) === "undefined") { return; }
    var data = {
        folder: folder
    };
    callBack("mailbox.aspx/GetMails", data, function (msg) {
        var mails = msg.d;
        for (var i = 0; i < mails.length; i++) {
            if ($("[data-message_id=" + mails[i].MailID + "]").length == 0) {
                $("[data-folder=" + mails[i].Folder + "]").prepend(
                    "<tr data-message_id='" + mails[i].MailID + "' data-thread_id='" + mails[i].ThreadID + "' class='clickable' onclick='viewMail(this)'>" +
                        "<td>" +
                            "<input type='checkbox'></td>" +
                            "<td class='mailbox-star'><a href='#'><i class='fa " + (mails[i].Starred ? "fa-star" : "fa-star-o") + " text-yellow'></i></a></td>" +
                            "<td class='mailbox-read'><i class='fa " + (mails[i].Unread ? "fa-envelope" : "fa-envelope-open-o") + "'></i></td>" +
                            "<td class='mailbox-name'><a href='read-mail.html'>" + mails[i].Sender.FullName + "</a></td>" +
                            "<td class='mailbox-subject'><b>" + mails[i].Subject + "</b> - " + mails[i].BodyPreview +
                        "</td>" +
                        "<td class='mailbox-date'>NEW!</td>" +
                    "</tr>"
                );
            }
        }
        setTimeout(getMessages, 15000);
    }, false);
}
setTimeout(getMessages, 15000);

function composeErrorMessage(msg, timeout) {
    $("#lblComposeErrorText").text(msg);
    $("#lblComposeError").slideDown();
    if (typeof (timeout) !== "undefined") {
        setTimeout(function () { $("#lblComposeError").slideUp(); }, timeout);
    }
}

$("#lblReturnToFolder").click(function () {
    $(".mailbox-messages").slideUp();
    $("#" + $(this).data("panel_id")).slideDown();
    $("#lblReturnToFolder").addClass("hidden");
});

var viewParam = parseInt(getParam("view"));
if (viewParam > 0) {
    var msgRow = $("tr[data-message_id=" + viewParam + "]");
    if (msgRow.length > 0) {
        var newMsgCount = parseInt($("#showInboxNewMessages").text()) - 1
        $("#showInboxNewMessages").text(newMsgCount);
        $("#showNewMessages").text(newMsgCount + " New Messages");
        $("#lblMessagesMenuCount").text(newMsgCount);
        $("#pnlMessagesList li[data-message_id=" + viewParam + "]").remove();
        var lblMsgCount = $("#lblMessagesCount");
        if (newMsgCount == 0) {
            lblMsgCount.remove();
        } else {
            lblMsgCount.text(newMsgCount);
        }
        history.replaceState({}, $("title").text(), "mailbox.aspx");
        msgRow.click();
    } else {
        showWarning("Message Not Found (Possibly Too Old)");
    }
}