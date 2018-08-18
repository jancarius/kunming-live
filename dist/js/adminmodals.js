$(window).on("load", function () {
    // Blog Post //
    $("#btnNewBlogPost").click(function () {
        callBack("master.asmx/GetBlogTags", null, function (msg) {
            $("#txtBlogPostTags").tagify({
                duplicates: false,
                suggestionsMinChars: 1,
                enforceWhitelist: false,
                whitelist: msg.d
            }).on("duplicate", function () {
                newBlogPostErrorMessage("Duplicate Tag", 5000);
            });
            $("#modalCreateBlogPost").modal("show");
            $('#modalCreateBlogPost').on('shown.bs.modal', function () {
                $('#txtBlogPostTitle').focus();
            });
        });
    });

    $("#btnSubmitBlogPost").click(function () {
        var type = $("#ddlBlogPostType option:selected").val();
        var title = $("#txtBlogPostTitle").val();
        var description = $("#txtBlogPostDescription").val();
        var tags = $("#txtBlogPostTags").val().split(",");
        var content = $("#adminBlogPostTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
        if (!content.includes("//previewContent\\") || !content.includes("//shortContent\\")) {
            showWarning("Missing preview and/or short content markers!");
            return;
        }
        var data = {
            type: type,
            title: title,
            description: description,
            tags: tags,
            content: content
        };
        callBack("master.asmx/SaveBlogPost", data, function (msg) {
            if (msg.d === true) {
                $("#modalCreateBlogPost").modal("hide");
                $("#txtBlogPostTitle").val("");
                $("#txtBlogPostDescription").val("");
                $("#txtBlogPostTags").val("");
                $("#ddlBlogPostType").val($("#ddlBlogPostType option:first").val());
            } else {
                submitError("Failed to Create Blog Post (Technical Support Notified)", JSON.stringify({ data: data, successMessage: msg }));
            }
        });
    });

    // New Tips & Tricks //
    $("#btnNewTip").click(function () {
        $("#modalCreateTip").modal("show");
    });

    $("#btnSubmitNewTip").click(function () {
        var title = $("#txtTipTitle").val();
        var mainImage = $("#tipsImageUploadMain").find("img").attr("src");
        var description = $("#tipsTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();

        if (title.length < 10) {
            newTipErrorMessage("Title Minimum 10 Characters");
            return;
        }
        if (typeof (mainImage) === "undefined") {
            newTipErrorMessage("Must Provide Main Image");
            return;
        }
        if (!description.includes("//previewContent\\") || !description.includes("//shortContent\\")) {
            newTipErrorMessage("Missing Preview and/or Short Content Tag");
            return;
        }

        var data = {
            title: title,
            mainImage: mainImage,
            description: description
        }
        callBack("master.asmx/SaveTip", data, function (msg) {
            if (msg.d == false) {
                showWarning("Must Be an Admin!");
                $(".loading-overlay").hide();
            } else if (msg.d == null) {
                showWarning("Must Be Logged In!");
                $(".loading-overlay").hide();
            } else if (msg.d != true) {
                submitError("Failed to Add Tip", JSON.stringify({ data: data, msg: msg }));
                $(".loading-overlay").hide();
            } else {
                window.location.reload();
            }
        }, true, true);
    });

    $("#modalCreateTip").on("hidden.bs.modal", function () {

    });

    // New Page //
    $("#btnNewPage").click(function () {
        $("#modalCreatePage").modal("show");
    });

    $("#btnSubmitNewPage").click(function () {
        var data = {
            link: $("#txtPageLink").val(),
            description: $("#txtPageDescription").val(),
            admin: $("#chkAdministratorAccess").prop("checked"),
            users: $("#chkUserAccess").prop("checked")
        };
        callBack("master.asmx/AddPage", data, function (msg) {
            if (msg.d === true) {
                $("#txtPageDescription").val("");
                $("#txtPageLink").val("");
                $("#chkAdministratorAccess").prop("checked", false);
                $("#chkUserAccess").prop("checked", false);
                $("#pnlExistingPages").append(
                    "<tr>" +
                        "<td>" + data.description + "</td>" +
                        "<td>" + data.link + "</td>" +
                        "<td class='text-center'><i class='fa fa-" + (data.users ? "check text-success" : "times text-danger") + "'></i></td>" +
                        "<td class='text-center'><i class='fa fa-" + (data.admin ? "check text-success" : "times text-danger") + "'></i></td>" +
                    "</tr>");
            } else {
                submitError("Failed to Add New Page (Technical Support Notified)", JSON.stringify({ data: data, successMessage: msg }));
            }
        });
    });

    // Add Admin //
    callBack("master.asmx/GetNonAdmins", null, function (msg) {
        $("#txtAddAdmin").tagify({
            duplicates: false,
            suggestionsMinChars: 1,
            enforceWhitelist: true,
            whitelist: msg.d
        }).on("add", function (e, tagName) {
            var data = { fullName: tagName.value };
            callBack("master.asmx/AddAdmin", data, function (msg) {
                $("#txtAddAdmin").data("tagify").removeAllTags();
                if (msg.d == false || msg.d == null) {
                    submitError("Failed to Add Admin (Technical Support Notified)", JSON.stringify({ data: data, msg: msg }));
                }
            });
        });
    }, false);

    // Event Approvals //
    $("#btnApproveEvents").click(function () {
        $("#modalApproveEvent").modal("show");
    });

    $(".approve-event,.deny-event").click(function () {
        var deniedReason = "";
        if ($(this).hasClass("deny-event")) {
            deniedReason = prompt("Enter a Denial Reason");
        }
        var data = {
            eventId: $(this).closest("tr").data("event_id"),
            approved: $(this).hasClass("approve-event"),
            deniedReason: deniedReason
        };
        callBack("master.asmx/ApproveEvent", data, function (msg) {
            if (msg.d == null) {
                showWarning("You Must Have Admin Access");
            } else if (msg.d == true) {
                $("#modalApproveEvent tr[data-event_id=" + data.eventId + "]").remove();
            }
        });
    });

    $(".approve-business,.deny-business").click(function () {
        var deniedReason = "";
        if ($(this).hasClass("deny-business")) {
            deniedReason = prompt("Enter a Denial Reason");
        }
        var data = {
            businessId: $(this).closest("tr").data("business_id"),
            approved: $(this).hasClass("approve-business"),
            deniedReason: deniedReason
        };
        callBack("master.asmx/ApproveBusiness", data, function (msg) {
            if (msg.d == null) {
                showWarning("You Must Have Admin Access");
            } else if (msg.d == true) {
                $("#modalApproveEvent tr[data-business_id=" + data.businessId + "]").remove();
            }
        });
    });
});

function newBlogPostErrorMessage(msg, timeout) {
    $("#modalCreateBlogPost").animate({ scrollTop: 0 }, "slow");
    $("#lblBlogPostErrorText").text(msg);
    $("#lblBlogPostError").slideDown();
    if (typeof (timeout) !== "undefined") {
        setTimeout(function () { $("#lblBlogPostError").slideUp(); }, timeout);
    }
}

function newTipErrorMessage(msg, timeout) {
    $("#modalCreateTip").animate({ scrollTop: 0 }, "slow");
    $("#lblNewTipErrorText").text(msg);
    $("#lblNewTipError").slideDown();
    if (typeof (timeout) !== "undefined") {
        setTimeout(function () { $("#lblNewTipError").slideUp(); }, timeout);
    }
}