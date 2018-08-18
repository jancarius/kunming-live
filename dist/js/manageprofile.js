$("#fileProfileImage").file_upload();
$('#modalProfileImage').modal({
    show: false,
    backdrop: "static",
    keyboard: false
});

$.fn.cropper.setDefaults({
    viewMode: 1,
    minContainerWidth: 200,
    minContainerHeight: 200,
    minCanvasWidth: 200,
    minCanvasHeight: 200,
    minCropBoxWidth: 128,
    minCropBoxHeight: 128
});

var fields = {
    FullName: {
        input: "txtFullName",
        label: "lblFullName",
        changed: false
    },
    Email: {
        input: "txtEmail",
        label: "lblEmail",
        changed: false
    },
    Location: {
        input: "txtLocation",
        label: "lblLocation",
        changed: false
    },
    Description: {
        input: "txtDescription",
        label: "lblDescription",
        changed: false
    },
    ProfileImage: {
        input: "fileProfileImage",
        value: "",
        changed: false
    },
    Measurement: {
        input: "ddlMeasurement",
        label: "lblMeasurement",
        changed: false
    }
}

$("#btnEditProfile").click(function () {
    $("#btnEditProfile").addClass("hidden");
    $("#btnSaveProfile").removeClass("hidden");
    $("#btnCancelProfile").removeClass("hidden");

    for (var property in fields) {
        if (User.FullNameChanged) {
            if (property == "FullName") {
                continue;
            }
        }
        if (property != "Measurement") {
            $("#" + fields[property].input).val($("#" + fields[property].label).html());
        }
        $("#" + fields[property].label).addClass("hidden");
        $("#" + fields[property].input).removeClass("hidden");
    }

    $("#uploadImage").removeClass("hidden");
});

$("#btnCancelProfile").click(function () {
    $("#btnEditProfile").removeClass("hidden");
    $("#btnSaveProfile").addClass("hidden");
    $("#btnCancelProfile").addClass("hidden");
    $("#uploadImage").removeClass("btn-success");
    $("#uploadImage").removeClass("btn-primary");
    $("#uploadImage").addClass("btn-primary");

    fields.ProfileImage.value = "";

    for (var property in fields) {
        if (User.FullNameChanged) {
            if (property == "FullName") {
                continue;
            }
        }
        $("#" + fields[property].input).addClass("hidden");
        $("#" + fields[property].label).removeClass("hidden");
    }

    $("#uploadImage").addClass("hidden");
    $("#fileProfileImage").val("");
});

$("#btnSaveProfile").click(function () {
    $(".loading-overlay").show();
    for (var property in fields) {
        if (property == "ProfileImage") { continue; }
        fields[property].value = $("#" + fields[property].input).val();
    }
    if ($("#lblManageProfileError").is(":visible")) { return; }
    var data = {
        fullName: fields.FullName.value,
        email: fields.Email.value,
        location: fields.Location.value,
        description: fields.Description.value,
        profileImage: fields.ProfileImage.value,
        measurement: fields.Measurement.value
    };
    callBack("manageprofile.aspx/UpdateProfile", data, function (msg) {
        $("#btnSaveProfile").addClass("hidden");
        $("#btnCancelProfile").addClass("hidden");
        $("#btnEditProfile").removeClass("hidden");

        $("#lblFullName").text(msg.d.FullName);
        $("#lblEmail").text(msg.d.Email);
        $("#lblLocation").text(msg.d.Location);
        $("#lblDescription").text(msg.d.Description);
        $("#lblMeasurement").text(msg.d.MeasurementString)
        $("#lblUsernameSidebar").html(msg.d.FullName);
        $("#lblUsernameTopbar").html(msg.d.FullName);
        $("#imgProfile").attr("src", msg.d.Avatar);
        $("#imgCollapsedProfileImage").attr("src", msg.d.Avatar);
        $("#imgNavbarProfileImage").attr("src", msg.d.Avatar);
        $("#imgSidebarProfileImage").attr("src", msg.d.Avatar);
        $("#imgProfileUpdate").attr("src", msg.d.Avatar);
        $("#uploadImage").addClass("btn-primary");
        $("#uploadImage").removeClass("btn-success");
        $("#uploadImage").addClass("hidden");
        $("#fileProfileImage").val("");

        for (var property in fields) {
            if (User.FullNameChanged) {
                if (property == "FullName") {
                    continue;
                }
            }
            $("#" + fields[property].input).addClass("hidden");
            $("#" + fields[property].label).removeClass("hidden");
        }
    });
});

$("#fileProfileImage").on("change", function () {
    $(".loading-overlay").show();
    $("#modalProfileImage").modal({
        show: true,
        backdrop: "static",
        keyboard: false
    });
    readFile(this.files[0], function (imgFile) {
        $("#imgCropper").attr("src", imgFile);
        $(".loading-overlay").hide();
    }, false, null, null, true);
});

$("#modalProfileImage").on("shown.bs.modal", function () {
    $("#imgCropper").cropper({
        aspectRatio: 1 / 1,
        ready: function () {
            $(this).cropper("crop");
        }
    });
}).on("hidden.bs.modal", function () {
    $("#imgCropper").cropper("destroy");
    $("#fileProfileImage").val("");
});

$("#btnSaveCrop").click(function () {
    $(".loading-overlay").show();
    var croppedImage = $("#imgCropper").cropper("getCroppedCanvas", {
        width: 128,
        height: 128,
    });

    var base64 = $("#imgCropper").attr("src");
    var imgExt = base64.substring(base64.indexOf("/") + 1, base64.indexOf(";"));
    if (!["jpeg", "jpg", "gif", "png"].includes(imgExt)) {
        $(".loading-overlay").hide();
        showWarning("Only JPEG, PNG, or GIF Allowed!");
        return;
    }
    base64 = croppedImage.toDataURL("image/" + imgExt, 0.5);

    fields.ProfileImage.value = base64;

    $("#imgProfileUpdate").attr("src", base64);

    $("#uploadImage").removeClass("btn-primary");
    $("#uploadImage").removeClass("btn-success");
    $("#uploadImage").addClass("btn-success");
    $("#modalProfileImage").modal("hide");
    $(".loading-overlay").hide();
});

$(".undo-box-state").click(function () {
    $(".loading-overlay").show();
    $.ajax({
        type: "POST",
        url: "manageprofile.aspx/UndoCustomBoxState",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            customBoxStateId: $(this).attr("data-box-state-id")
        }),
        success: function (msg) {
            var customBoxStateId = $("[data-box-state-id='" + msg.d + "']");
            if (customBoxStateId.length > 0) {
                customBoxStateId.closest("tr").remove();
                if ($("#tblEditBoxStates tr").length == 1) {
                    $("#boxEditBoxStates").remove();
                }
            } else {
                alert("Failed to Find Custom Box State ID (Check Console)");
                console.log(msg);
            }
            $(".loading-overlay").hide();
        },
        error: function (msg) {
            alert("Failed to Find Custom Box State ID (Check Console)");
            console.log(msg);
            $(".loading-overlay").hide();
        }
    })
});

$("#txtFullName").change(function () {
    var data = { displayName: $("#txtFullName").val() };
    if (data.displayName == User.FullName) {
        $("#lblManageProfileError").slideUp();
        return;
    }
    callBack("master.asmx/CheckDisplayName", data, function (msg) {
        if (msg.d == false) {
            $("#lblManageProfileErrorText").text("Display Name Already in Use");
            $("#lblManageProfileError").slideDown();
        } else if (msg.d == true) {
            $("#lblManageProfileError").slideUp();
        }
    }, false);
});

$("#tblEditClassifiedPosts .fa-refresh").click(function () {
    var postRow = $(this).closest("tr");
    var postId = postRow.data("post_id");
    callBack("classifieds.aspx/RenewClassified", { postId: postId }, function (msg) {
        postRow.find(":nth-child(2)").removeClass("bg-danger").addClass("bg-success").text(msg.d)
    });
});

$(".fa-pause,.fa-play").click(function () {
    var tableName = $(this).closest("tbody").attr("id");
    var target;
    switch (tableName) {
        case "tblEditClassifiedPosts":
            target = "classifieds.aspx/SuspendClassified";
            break;
        case "tblEditEvents":
            target = "eventscalendar.aspx/SuspendEvent";
            break;
        case "tblEditBusinesses":
            target = "businesses.aspx/SuspendBusiness"
    }
    var postRow = $(this).closest("tr");
    var postId = postRow.data("post_id");
    callBack(target, { postId: postId, suspended: $(this).hasClass("fa-pause") }, null, false);
    if ($(this).hasClass("fa-pause")) {
        $(this).removeClass("fa-pause").addClass("fa-play").attr("data-original-title", "Resume");
        postRow.addClass("bg-gray");
    } else if ($(this).hasClass("fa-play")) {
        $(this).removeClass("fa-play bg-gray").addClass("fa-pause").attr("data-original-title", "Suspend");
        postRow.removeClass("bg-gray");
    }
    $(this).tooltip("hide");
});

$(".fa-trash").click(function () {
    var tableName = $(this).closest("tbody").attr("id");
    var target;
    switch (tableName) {
        case "tblEditClassifiedPost":
            target = "classifieds.aspx/DeleteClassified";
            break;
        case "tblEditEvents":
            target = "eventscalendar.aspx/DeleteEvent";
            break;
        case "tblEditBusinesses":
            target = "businesses.aspx/DeleteBusiness"
    }
    var postRow = $(this).closest("tr");
    var postId = postRow.data("post_id");
    confirmWarning("Are you sure you want to delete your Classified Ad? <strong>This action cannot be undone!</strong>", function () {
        postRow.remove();
        callBack(target, { postId: postId }, null, false);
    });
})