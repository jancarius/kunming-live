$(window).on("load", function () {
    var viewParam = getParam("view");

    var actionParam = $("#hiddenActionParam").val();
    if (actionParam.length > 0) {
        switch (actionParam) {
            case "add":
                $("#btnPostClassified").click();
                break;
        }
        window.history.replaceState(null, $("title").text(), '/classifieds/' + viewParam);
    }

    var idParam = parseInt($("#hiddenIDParam").val());
    if (idParam > 0) {
        $("#classified-" + idParam + " .box-body").click();
    }

    var editParam = parseInt($("#hiddenEditParam").val());
    if (editParam > 0) {
        window.history.replaceState(null, $("title").text(), '/classifieds/' + viewParam);
        checkLogin(function () {
            callBack("classifieds.aspx/GetClassified", { classifiedId: editParam }, function (msg) {
                if (msg.d == null) {
                    showWarning("Could Not Get Classified Ad (Tech Support Notified)");
                    $(".loading-overlay").hide();
                } else {
                    $("#modalCreateClassifiedAd").data("edit_classified_id", editParam);

                }

                $("#ddlClassifiedType option[value='" + msg.d.Category + "']").prop("selected", true);
                $("#txtClassifiedLocation").val(msg.d.PostalCode);

                switch (msg.d.Category) {
                    case 0:
                        $("#ddlClassifiedEmployment option[value='" + msg.d.SubCategory + "']").prop("selected", true);
                        $("#txtClassifiedCompensation").val(msg.d.Compensation);
                        $("#ddlClassifiedTerm option[value='" + msg.d.Term + "']").prop("selected", true);
                        if (msg.d.Internship == true) { $("#chkClassifiedInternship").iCheck("check"); }
                        if (msg.d.Telecommuting == true) { $("#chkClassifiedTelecommuting").iCheck("check"); }
                        break;
                    case 1:
                        $("#ddlClassifiedMarketplace option[value='" + msg.d.SubCategory + "']").prop("selected", true);
                        $("#txtClassifiedPrice").val(msg.d.Price);
                        $("#ddlClassifiedCondition option[value='" + msg.d.Condition + "']").prop("selected", true);
                        $("#txtClassifiedMake").val(msg.d.Make);
                        $("#txtClassifiedModel").val(msg.d.Model);
                        break;
                    case 2:
                        $("#ddlClassifiedHousing option[value='" + msg.d.SubCategory + "']").prop("selected", true);
                        $("#txtClassifiedMeters").val(msg.d.Meters);
                        $("#txtClassifiedRent").val(msg.d.Rent);
                        $("#txtClassifiedBedrooms").val(msg.d.Bedrooms);
                        $("#txtClassifiedBathrooms").val(msg.d.Bathrooms);
                        $("#txtClassifiedAvailable").datepicker("setStartDate", new Date(parseInt(msg.d.Available.substr(6))));
                        $("#txtClassifiedAvailable").datepicker("update", new Date(parseInt(msg.d.Available.substr(6))));
                        if (msg.d.Pets) { $("#chkClassifiedPets").iCheck("check"); }
                        if (msg.d.Laundry) { $("#chkClassifiedLaundry").iCheck("check"); }
                        if (msg.d.Furniture) { $("#chkClassifiedFurnished").iCheck("check"); }
                        break;
                }

                $("#ddlClassifiedType").change();

                $("#txtClassifiedTitle").val(msg.d.Title);
                $("#classifiedTextarea").data("wysihtml5").classifiedTextarea.setValue(msg.d.Description);

                var imagesPreview = $("#classifiedImageUploads .images-preview");
                var imageUploadsIndex = imagesPreview.data("index");
                for (var i = 0; i < msg.d.Images.length; i++) {
                    imagesPreview.append(
                        "<div class='text-center image-preview pull-left' style='width:135px;margin:0px auto 5px auto;'>" +
                            "<img src='" + msg.d.Images[i].Path + "' class='img-responsive image-upload' style='margin:0 auto;max-height:75px;' />" +
                            "<div class='input-group input-group-sm' style='margin:0 auto;width:114px;'>" +
                                "<span class='input-group-addon bg-primary clickable' onclick='makeMainImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Main Image'><i class='fa fa-home'></i></span>" +
                                "<input class='text-center form-control image-sort' type='text' value='" + (i + 1) + "' disabled />" +
                                "<span class='input-group-addon bg-red clickable' onclick='removePreviewImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Delete Image'><i class='fa fa-times'></i></span>" +
                            "</div>" +
                        "</div>"
                    );
                }

                $("#modalCreateClassifiedAd").modal({
                    show: true,
                    backdrop: "static",
                    keyboard: false
                });

                $('#modalCreateClassifiedAd').on('shown.bs.modal', function () {
                    $('#ddlClassifiedType').focus();
                });
            });
        });
    }
});

$("#btnPostClassified").click(function () {
    checkLogin(function () {
        var today = new Date().toDateString();
        var todayFormat = "ddd MMM DD YYYY";

        $("#txtClassifiedAvailable").datepicker({
            format: "mm/dd/yyyy",
            startDate: "0d"
        });

        $("#txtClassifiedOpenHouse").datepicker({
            format: "mm/dd/yyyy"
        });

        $("#modalCreateClassifiedAd").modal({
            show: true,
            backdrop: "static",
            keyboard: false
        });

        $('#modalCreateClassifiedAd').on('shown.bs.modal', function () {
            $('#ddlClassifiedType').focus();
        });
    }, true, false);
});

$("#ddlClassifiedType").change(function () {
    $(".select-classified-sub-type").addClass("hidden");
    $(".select-classified-input").addClass("hidden");
    var selectedText = $(this).find(":selected").text()
    $("#ddlClassified" + selectedText).removeClass("hidden");
    $("#classified" + selectedText + "Input").removeClass("hidden");
});

$("#btnSubmitNewClassifiedAd").click(function () {
    function classifiedError(msg) {
        $("#modalCreateClassifiedAd").animate({ scrollTop: 0 }, "slow");
        $("#lblClassifiedErrorText").text(msg);
        $("#lblClassifiedError").slideDown();
    }

    var postalCode = $("#txtClassifiedLocation").val();
    var title = $("#txtClassifiedTitle").val();
    var details = $("#classifiedTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
    
    var sponsored = false;

    var images = [];
    $("#classifiedImageUploads .image-upload").each(function () {
        images.push($(this).attr("src"));
    });

    if (postalCode.length < 6) {
        classifiedError("Invalid Postal Code");
        return;
    } else { $("#lblClassifiedError").slideUp(); }
    if (title.length < 8) {
        classifiedError("Title Minimum 8 Characters");
        return;
    } else { $("#lblClassifiedError").slideUp(); }
    if (stripTags(details).length < 50) {
        classifiedError("Details Minimum 50 Characters");
        return;
    } else { $("#lblClassifiedError").slideUp(); }
    
    var data = {
        category: $("#ddlClassifiedType option:selected").val(),
        postalCode: postalCode,
        title: title,
        details: details,
        images: images,
        sponsored: sponsored
    };
    $(".select-classified-sub-type").each(function () {
        if (!$(this).hasClass("hidden")) {
            data.subCategory = $(this).find("option:selected").val();
        }
    });
    if (typeof data.subCategory == "undefined") {
        classifiedError("Sub Type Required");
        return;
    } else if (data.subCategory.length == 0) {
        classifiedError("Sub Type Required");
        return;
    } else { $("#lblClassifiedError").slideUp(); }
    switch (data.category) {
        case "0":
            data.compensation = $("#txtClassifiedCompensation").val();
            data.term = $("#ddlClassifiedTerm option:selected").val();
            data.internship = $("#chkClassifiedInternship").prop("checked");
            data.telecommuting = $("#chkClassifiedTelecommuting").prop("checked");
            checkLogin(function (data) {
                callBack("classifieds.aspx/CreateClassifiedEmployment", data, function (msg) {
                    if (msg.d == null) {
                        showWarning("You May Only Post an Ad Every 5 Minutes");
                    } else if (msg.d > 0) {
                        window.location.href = 'https://www.kunminglive.com/classifieds/' + msg.d;
                    } else {
                        submitError("Failed to Create Classified Ad (Tech Support Notified)", JSON.stringify({ msg: msg, data: data }))
                    }
                });
            }, data);
            break;
        case "1":
            data.price = $("#txtClassifiedPrice").val();
            data.condition = $("#ddlClassifiedCondition option:selected").val();
            data.make = $("#txtClassifiedMake").val();
            data.model = $("#txtClassifiedModel").val();
            checkLogin(function (data) {
                callBack("classifieds.aspx/CreateClassifiedMarketplace", data, function (msg) {
                    if (msg.d == null) {
                        showWarning("You May Only Post an Ad Every 5 Minutes");
                    } else if (msg.d > 0) {
                        window.location.href = 'https://www.kunminglive.com/classifieds/' + msg.d;
                    } else {
                        submitError("Failed to Create Classified Ad (Tech Support Notified)", JSON.stringify({ msg: msg, data: data }))
                    }
                });
            }, data);
            break;
        case "2":
            data.meters = $("#txtClassifiedMeters").val();
            data.rent = $("#txtClassifiedRent").val();
            data.bedrooms = $("#txtClassifiedBedrooms").val();
            data.bathrooms = $("#txtClassifiedBathrooms").val();
            data.available = $("#txtClassifiedAvailable").val();
            data.pets = $("#chkClassifiedPets").prop("checked");
            data.laundry = $("#chkClassifiedLaundry").prop("checked");
            data.furniture = $("#chkClassifiedFurnished").prop("checked");
            checkLogin(function (data) {
                callBack("classifieds.aspx/CreateClassifiedHousing", data, function (msg) {
                    if (msg.d == null) {
                        showWarning("You May Only Post an Ad Every 5 Minutes");
                    } else if (msg.d > 0) {
                        window.location.href = 'https://www.kunminglive.com/classifieds/' + msg.d;
                    } else {
                        submitError("Failed to Create Classified Ad (Tech Support Notified)", JSON.stringify({ msg: msg, data: data }))
                    }
                });
            }, data);
            break;
    }
});

$("#modalCreateClassifiedAd").on("hidden.bs.modal", function () {
    $("#ddlClassifiedType option[value='']").prop("selected", true);
    $("#ddlClassifiedEmployment option[value='']").prop("selected", true);
    $("#ddlClassifiedMarketplace option[value='']").prop("selected", true);
    $("#ddlClassifiedHousing option[value='']").prop("selected", true);
    $(".select-classified-sub-type").addClass("hidden")
    $("#ddlClassifiedSubType").removeClass("hidden");
    $(".select-classified-input").addClass("hidden");
    $("#txtClassifiedLocation").val("");
    $("#txtClassifiedCompensation").val("");
    $("#ddlClassifiedTerm option[value='']").prop("selected", true);
    $("#chkClassifiedInternship").prop("checked", false);
    $("#chkClassifiedTelecommuting").prop("checked", false);
    $("#txtClassifiedPrice").val(0);
    $("#ddlClassifiedCondition option[value='']").prop("selected", true);
    $("#txtClassifiedMake").val("");
    $("#txtClassifiedModel").val("");
    $("#txtClassifiedMeters").val(0);
    $("#txtClassifiedRent").val(0);
    $("#txtClassifiedBedrooms").val(0);
    $("#txtClassifiedBathrooms").val(0);
    $("#txtClassifiedAvailable").val("");
    $("#chkClassifiedPets").prop("checked", false);
    $("#chkClassifiedLaundry").prop("checked", false);
    $("#chkClassifiedFurnished").prop("checked", false);
    $("#txtClassifiedTitle").val("");
    $("#classifiedTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html("");
    $("#classifiedImageUploads .images-preview").html("");
    if (typeof (window.uploadsCompleted) !== "undefined") {
        window.uploadsCompleted[$("#classifiedImageUploads .images-preview").data("index")] = 0;
    }
});

$('#chkClassifiedInternship,#chkClassifiedTelecommuting,#chkClassifiedLaundry,#chkClassifiedPets,#chkClassifiedFurnished').iCheck({
    checkboxClass: 'icheckbox_square-green',
    radioClass: 'iradio_square-green',
    increaseArea: '20%'
});

$(".classified-post-preview").click(function () {
    showClassifiedModal(JSON.parse($(this).find("input[type=hidden]").val()));
})

$("#modalShowClassifiedAd").on("hidden.bs.modal", function () {
    $("#showClassifiedCategory").text("");
    $("#showClassifiedCategory").attr("class", "");
    $("#showClassifiedSubCategory").text("");
    $("#showClassifiedUsername").text("");
    $("#showClassifiedAvatar").html("");
    $("#showClassifiedEmployment").addClass("hidden");
    $("#showClassifiedMarketplace").addClass("hidden");
    $("#showClassifiedHousing").addClass("hidden");
    $("#showClassifiedCompensation").text("");
    $("#showClassifiedTerm").text("");
    $("#showClassifiedInternship").addClass("hidden");
    $("#showClassifiedTelecommuting").addClass("hidden");
    $("#showClassifiedPrice").text("");
    $("#showClassifiedCondition").text("");
    $("#showClassifiedMake").text("");
    $("#showClassifiedModel").text("");
    $("#showClassifiedMeters").html("");
    $("#showClassifiedRent").text("");
    $("#showClassifiedBedrooms").text("");
    $("#showClassifiedBathrooms").text("");
    $("#showClassifiedAvailable").text("");
    $("#showClassifiedPets").addClass("hidden");
    $("#showClassifiedLaundry").addClass("hidden");
    $("#showClassifiedFurniture").addClass("hidden");
    $("#showClassifiedDescription").html("");
    $("#showClassifiedCarousel .carousel-inner").html("");
    $("#showClassifiedCarousel .carousel-indicators").html("");
    $("#showClassifiedCarousel").attr("data-interval", "false");
    $("#showClassifiedCarousel").carousel("pause").removeData();
    window.history.replaceState(null, $("title").text(), '/classifieds/' + viewParam);
});

function showClassifiedModal(classifiedData) {
    var classifiedModal = $("#modalShowClassifiedAd");
    classifiedModal.data("classified_id", classifiedData.PostID);

    $("#showClassifiedCategory").text(classifiedData.CategoryString);
    $("#showClassifiedCategory").addClass(classifiedData.LabelClass);
    $("#showClassifiedSubCategory").text(classifiedData.SubCategoryString);

    $("#showClassifiedUsername").text(classifiedData.Poster.FullName);
    $("#showClassifiedAvatar").html("<img src='" + classifiedData.Poster.Avatar + "' alt='Poster Avatar' class='img-responsive img-circle' />");

    switch (classifiedData.CategoryString) {
        case "Employment":
            $("#showClassifiedEmployment").removeClass("hidden");
            $("#showClassifiedCompensation").text(classifiedData.Compensation);
            $("#showClassifiedTerm").text(classifiedData.Term);
            if (classifiedData.Internship) { $("#showClassifiedInternship").removeClass("hidden"); }
            if (classifiedData.Telecommuting) { $("#showClassifiedTelecommuting").removeClass("hidden"); }
            break;
        case "Marketplace":
            $("#showClassifiedMarketplace").removeClass("hidden");
            $("#showClassifiedPrice").text(classifiedData.Price);
            $("#showClassifiedCondition").text(classifiedData.Condition);
            $("#showClassifiedMake").text(classifiedData.Make);
            $("#showClassifiedModel").text(classifiedData.Model);
            break;
        case "Housing":
            $("#showClassifiedHousing").removeClass("hidden");
            $("#showClassifiedMeters").html(classifiedData.Meters + " m<sup>2</sup>");
            $("#showClassifiedRent").text(classifiedData.Rent);
            $("#showClassifiedBedrooms").text(classifiedData.Bedrooms);
            $("#showClassifiedBathrooms").text(classifiedData.Bathrooms);
            $("#showClassifiedAvailable").text(classifiedData.AvailableString);
            if (classifiedData.Pets) { $("#showClassifiedPets").removeClass("hidden"); }
            if (classifiedData.Laundry) { $("#showClassifiedLaundry").removeClass("hidden"); }
            if (classifiedData.Furniture) { $("#showClassifiedFurniture").removeClass("hidden"); }
            break;
    }

    $("#showClassifiedDescription").html(classifiedData.Description);

    classifiedModal.find(".modal-title").text(classifiedData.Title);
    for (var i = 0; i < classifiedData.Images.length; i++) {
        $("#showClassifiedCarousel .carousel-inner").append(
            "<div class='item" + (i == 0 ? " active" : "") + "' style='border:0;'>" +
                "<img src='" + classifiedData.Images[i].Path + "' alt='Slide #" + i + "' class='clickable' style='max-height:350px;margin:0 auto;' onclick='showImageSlideshow(this)' />" +
            "</div>");
        $("#showClassifiedCarousel .carousel-indicators").append("<li data-target='#showClassifiedCarousel' data-slide-to='" + i + "' " + (i == 0 ? "class='active'" : "") + "></li>");
    }

    $("#showClassifiedCarousel").attr("data-interval", 5000);
    $("#showClassifiedCarousel").carousel("pause").removeData();
    $("#showClassifiedCarousel").carousel({
        interval: 5000
    }).carousel("cycle");

    classifiedModal.modal("show");
}