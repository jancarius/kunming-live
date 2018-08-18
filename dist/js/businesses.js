// Business Distances //
$(window).on("load", function () {
    setupLocations();
    setupMaps();

    window.viewParam = $("#hiddenViewParam").val();

    var actionParam = $("#hiddenActionParam").val();
    if (actionParam.length > 0) {
        switch (actionParam) {
            case "add":
                $("#btnNewBusiness").click();
                window.history.replaceState(null, $("title").text(), '/things-to-do/' + viewParam);
                break;
        }
    }

    var idParam = parseInt($("#hiddenIDParam").val());
    if (idParam > 0) {
        var post = $("[data-business_id=" + idParam + "]");
        post.css("-webkit-box-shadow", "0px 0px 20px 10px rgba(0, 166, 90, 0.95)");
        post.css("box-shadow", "0px 0px 20px 10px rgba(0, 166, 90, 0.95)");
    }

    var editParam = parseInt($("#hiddenEditParam").val());
    if (editParam > 0) {
        window.history.replaceState(null, $("title").text(), '/things-to-do/' + viewParam);
        checkLogin(function () {
            callBack("businesses.aspx/GetBusiness", { businessId: editParam }, function (msg) {
                if (msg.d == null) {
                    showWarning("Could Not Find Business (Tech Support Notified)");
                    $(".loading-overlay").hide();
                } else {
                    callBack("master.asmx/GetBusinessTags", null, function (msg2) {
                        $("#txtBusinessTags").tagify({
                            duplicates: false,
                            suggestionsMinChars: 1,
                            enforceWhitelist: false,
                            whitelist: msg2.d
                        }).on("duplicate", function () {
                            newBusinessErrorMessage("Duplicate Tag", 5000);
                        });

                        $("#modalCreateBusiness").data("edit_business_id", editParam);

                        $("#ddlBusinessType option[value=" + msg.d.Type + "]").prop("selected", true);
                        $("#txtBusinessNameEnglish").val(msg.d.Name.English);
                        $("#txtBusinessNameChinese").val(msg.d.Name.Chinese);
                        $("#txtBusinessAddressEnglish").val(msg.d.Address.English);
                        $("#txtBusinessAddressChinese").val(msg.d.Address.Chinese);
                        $("#txtBusinessCityEnglish").val(msg.d.City.English);
                        $("#txtBusinessCityChinese").val(msg.d.City.Chinese);
                        $("#txtBusinessProvinceEnglish").val(msg.d.Province.English);
                        $("#txtBusinessProvinceChinese").val(msg.d.Province.Chinese);
                        $("#txtBusinessCountryEnglish").val(msg.d.Country.English);
                        $("#txtBusinessCountryChinese").val(msg.d.Country.Chinese);
                        $("#txtBusinessPostalCode").val(msg.d.PostalCode);
                        $("#txtBusinessPhoneNumber").val(msg.d.PhoneNumber);
                        $("#txtBusinessWebsite").val(msg.d.Website);
                        $("#ddlBusinessTodoType option[value=" + msg.d.TodoType + "]").prop("selected", true);
                        $("#txtBusinessCost").val(msg.d.Cost);
                        $("#txtBusinessValue").val(msg.d.Value);
                        $("#txtBusinessAtmosphere").val(msg.d.Atmosphere);
                        $("#txtBusinessService").val(msg.d.Service);
                        $("#txtBusinessCoordinates").val(msg.d.Coordinates);
                        $("#adminBusinessTextarea").data("wysihtml5").adminBusinessTextarea.setValue(msg.d.Description);
                        for (var i = 0; i < msg.d.Tags.length; i++) {
                            $("#txtBusinessTags").data("tagify").addTags(msg.d.Tags[i].Tag);
                        }
                        var imagesPreview = $("#pnlBusinessSubImagesPreview .images-preview");
                        var imageUploadsIndex = imagesPreview.data("index");
                        imagesPreview.append(
                            "<div class='text-center image-preview pull-left' style='width:135px;margin:0px auto 5px auto;'>" +
                                "<img src='" + msg.d.MainImagePath + "' class='img-responsive image-upload' style='margin:0 auto;max-height:75px;' />" +
                                "<div class='input-group input-group-sm' style='margin:0 auto;width:114px;'>" +
                                    "<span class='input-group-addon bg-primary clickable' onclick='makeMainImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Main Image'><i class='fa fa-home'></i></span>" +
                                    "<input class='text-center form-control image-sort' type='text' value='Main' disabled />" +
                                    "<span class='input-group-addon bg-red clickable' onclick='removePreviewImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Delete Image'><i class='fa fa-times'></i></span>" +
                                "</div>" +
                            "</div>"
                        );
                        for (var i = 0; i < msg.d.SubImages.length; i++) {
                            imagesPreview.append(
                                "<div class='text-center image-preview pull-left' style='width:135px;margin:0px auto 5px auto;'>" +
                                    "<img src='" + msg.d.SubImages[i].ImagePath + "' class='img-responsive image-upload' style='margin:0 auto;max-height:75px;' />" +
                                    "<div class='input-group input-group-sm' style='margin:0 auto;width:114px;'>" +
                                        "<span class='input-group-addon bg-primary clickable' onclick='makeMainImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Main Image'><i class='fa fa-home'></i></span>" +
                                        "<input class='text-center form-control image-sort' type='text' value='" + (i + 1) + "' disabled />" +
                                        "<span class='input-group-addon bg-red clickable' onclick='removePreviewImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Delete Image'><i class='fa fa-times'></i></span>" +
                                    "</div>" +
                                "</div>"
                            );
                        }

                        $("#modalCreateBusiness").modal({
                            show: true,
                            backdrop: "static",
                            keyboard: false
                        });

                        $('#modalCreateBusiness').on('shown.bs.modal', function () {
                            $('#ddlBusinessType').focus();
                        });
                    });
                }
            }, true, true);
        });
    }
});

function setupMaps() {
    if (Microsoft) {
        $(".pnlBusinessMap").each(function () {
            var coords = $(this).attr("data-business-coords").split(",");
            var center = new Microsoft.Maps.Location(coords[0], coords[1]);
            var businessMap = new Microsoft.Maps.Map(this, {
                center: center,
                zoom: 15
            });
            var pin = new Microsoft.Maps.Pushpin(center, { title: $(this).data("business_name") });
            businessMap.entities.push(pin);
        });
    }
}

function setupLocations() {
    if (navigator.geolocation) {
        //navigator.geolocation.getCurrentPosition(function(){},function(){},{});
        //navigator.geolocation.getCurrentPosition(function (position) {
        //    window.userCoords = [{
        //        latitude: position.coords.latitude,
        //        longitude: position.coords.longitude
        //    }];
        //    loadBusinessDistances();
        //},
        //function () {

        //},
        //{ maximumAge: 10000, timeout: 5000 });
    } else {

    }
}

function loadBusinessDistances() {
    if (Microsoft) {
        var businessCoords = [];
        var hiddenCoords = $("#hiddenBusinessCoordinates").val();
        if (hiddenCoords.length > 0) {
            businessCoords = hiddenCoords.split(";");
        }
        for (var i = 0; i < businessCoords.length; i++) {
            var thisCoords = businessCoords[i].split(",");
            businessCoords[i] = {
                latitude: thisCoords[0],
                longitude: thisCoords[1]
            };
        }
        if (businessCoords.length > 0) {
            function showDistances(msg) {
                if (msg && msg.resourceSets && msg.resourceSets[0] && msg.resourceSets[0].resources && msg.resourceSets[0].resources[0] && msg.resourceSets[0].resources[0].results) {
                    var results = msg.resourceSets[0].resources[0].results;
                    var businessDistances = $(".lblBusinessDistance");
                    if (results.length != businessDistances.length) {
                        submitError("Invalid Distance Results (Tech Support Notified)", JSON.stringify({ results: results, labels: businessDistances }));
                        return;
                    }
                    for (var i = 0; i < businessDistances.length; i++) {
                        businessDistances[i].innerHTML += "<i class='fa fa-location-arrow'></i>&nbsp;" + results[i].travelDistance + "&nbsp;<i class='fa fa-clock-o'></i>&nbsp;" + results[i].travelDuration;
                    }
                }
            }
            var $labels = $(".lblBusinessDistances");
            $labels.html("");
            $labels.each(function () {
                var reqUrl = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?key=As6ALo25XEgbL0EeIlPFvq4nLO0LA5eqjCWsMQylJcP-t4T11VcuxPCEhzmlzNgQ";

                var driveData = {
                    origins: window.userCoords,
                    destinations: businessCoords,
                    travelMode: "driving"
                };
                callBack(reqUrl, driveData, showDistances, false);

                var walkData = {
                    origins: window.userCoords,
                    destinations: businessCoords,
                    travelMode: "walking"
                };
                callBack(reqUrl, walkData, showDistances, false);

                var transitData = {
                    origins: window.userCoords,
                    destinations: businessCoords,
                    travelMode: "transit"
                };
                callBack(reqUrl, transitData, showDistances, false);
            });
        }
    } else {
        setTimeout(loadBusinessDistances, 300);
    }
}

// Submit a Business //
$("#btnNewBusiness").click(function () {
    checkLogin(function () {
        callBack("master.asmx/GetBusinessTags", null, function (msg) {
            $("#txtBusinessTags").tagify({
                duplicates: false,
                suggestionsMinChars: 1,
                enforceWhitelist: false,
                whitelist: msg.d
            }).on("duplicate", function () {
                newBusinessErrorMessage("Duplicate Tag", 5000);
            });

            $("#modalCreateBusiness").modal({
                show: true,
                backdrop: "static",
                keyboard: false
            });
            $('#modalCreateBusiness').on('shown.bs.modal', function () {
                $('#ddlBusinessType').focus();
            });
        });
    }, null, true, true);
});

$("#btnSubmitBusiness").click(function () {
    var type = $("#ddlBusinessType").val();
    var mainImage;
    var subImages = []
    $("#pnlBusinessSubImagesPreview img").each(function (index) {
        if (index == 0) {
            mainImage = $(this).attr("src");
        } else {
            subImages.push($(this).attr("src"));
        }
    });
    var name = {
        English: $("#txtBusinessNameEnglish").val(),
        Chinese: $("#txtBusinessNameChinese").val()
    };
    var address = {
        English: $("#txtBusinessAddressEnglish").val(),
        Chinese: $("#txtBusinessAddressChinese").val()
    };
    var city = {
        English: $("#txtBusinessCityEnglish").val(),
        Chinese: $("#txtBusinessCityChinese").val()
    };
    var province = {
        English: $("#txtBusinessProvinceEnglish").val(),
        Chinese: $("#txtBusinessProvinceChinese").val()
    };
    var country = {
        English: $("#txtBusinessCountryEnglish").val(),
        Chinese: $("#txtBusinessCountryChinese").val()
    };
    var postalCode = $("#txtBusinessPostalCode").val();
    var phoneNumber = $("#txtBusinessPhoneNumber").val();
    var website = $("#txtBusinessWebsite").val();
    var cost = $("#txtBusinessCost").val();
    var value = $("#txtBusinessValue").val();
    var service = $("#txtBusinessService").val();
    var atmosphere = $("#txtBusinessAtmosphere").val();
    var coordinates = $("#txtBusinessCoordinates").val();
    var todoType = $("#ddlBusinessTodoType").val();
    var tags = $("#txtBusinessTags").val().split(",");
    var description = $("#adminBusinessTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
    var edit = $("#modalCreateBusiness").data("edit_business_id");

    if (type == null) {
        newBusinessErrorMessage("Please Select a Business Type"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (typeof (mainImage) === "undefined") {
        newBusinessErrorMessage("Please Provide At Least 1 Image"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (name.English == "" || name.Chinese == "") {
        newBusinessErrorMessage("Please Provide an English AND Chinese Language NAME"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (address.English == "" || address.Chinese == "") {
        newBusinessErrorMessage("Please Provide an English AND Chinese Language ADDRESS"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (city.English == "" | city.Chinese == "") {
        newBusinessErrorMessage("Please Provide an English AND Chinese Language CITY"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (province.English == "" || province.Chinese == "") {
        newBusinessErrorMessage("Please Provide an English AND Chinese Language PROVINCE"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (country.English == "" || country.Chinese == "") {
        newBusinessErrorMessage("Please Provide an English AND Chinese Language COUNTRY"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (todoType == null) {
        newBusinessErrorMessage("Please Select a \"Todo Type\""); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (!(parseInt(cost) >= 0) && !(parseInt(cost) <= 5)) {
        newBusinessErrorMessage("\"Cost\" Should be a NUMBER Between 0 and 5"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (!(parseInt(value) >= 0) && !(parseInt(value) <= 5)) {
        newBusinessErrorMessage("\"Value\" Should be a NUMBER Between 0 and 5"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (!(parseInt(service) >= 0) && !(parseInt(service) <= 5)) {
        newBusinessErrorMessage("\"Service\" Should be a NUMBER Between 0 and 5"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (!(parseInt(atmosphere) >= 0) && !(parseInt(atmosphere) <= 5)) {
        newBusinessErrorMessage("\"Atmosphere\" Should be a NUMBER Between 0 and 5"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (tags.length == 0) {
        newBusinessErrorMessage("Must Provide Tags to Describe Business"); return;
    } else { $("#lblBusinessError").slideUp(); }
    if (stripTags(description.length) < 200) {
        newBusinessErrorMessage("Description Minimum 200 Characters"); return;
    } else { $("#lblBusinessError").slideUp(); }

    var data = {
        type: type,
        mainImage: mainImage,
        subImages: subImages,
        name: name,
        address: address,
        city: city,
        province: province,
        country: country,
        postalCode: postalCode,
        phoneNumber: phoneNumber,
        website: website,
        cost: cost,
        value: value,
        service: service,
        atmosphere: atmosphere,
        coordinates: coordinates,
        todoType: todoType,
        tags: tags,
        description: description,
        editBusinessId: edit
    };
    callBack("businesses.aspx/SaveBusiness", data, function (msg) {
        if (msg.d > 0) {
            window.location.href = 'https://www.kunminglive.com/things-to-do/' + msg.d;
        } else {
            $(".loading-overlay").hide();
            submitError("Failed to Create Business (Technical Support Notified)", JSON.stringify({ data: data, successMessage: msg }));
        }
    }, true, true);
});

$("#modalCreateBusiness").on("hidden.bs.modal", function () {
    $("#modalCreateBusiness").data("edit_business_id", null);
    $("#ddlBusinessType option[value='']").prop("selected", true);
    $("#txtBusinessNameEnglish").val("");
    $("#txtBusinessNameChinese").val("");
    $("#txtBusinessAddressEnglish").val("");
    $("#txtBusinessAddressChinese").val("");
    $("#txtBusinessPostalCode").val("");
    $("#txtBusinessPhoneNumber").val("");
    $("#txtBusinessWebsite").val("");
    $("#ddlBusinessTodoType option[value='']").prop("selected", true);
    $("#txtBusinessCost").val("0");
    $("#txtBusinessValue").val("0");
    $("#txtBusinessService").val("0");
    $("#txtBusinessAtmosphere").val("0");
    $("#txtBusinessTags").data("tagify").removeAllTags();
    $("#txtBusinessCoordinates").val("");
    $("#adminBusinessTextarea").data("wysihtml5").adminBusinessTextarea.setValue("");
    $("#pnlBusinessSubImagesPreview .images-preview").html("");
    if (typeof (window.uploadsCompleted) !== "undefined") {
        window.uploadsCompleted[$("#pnlBusinessSubImagesPreview .images-preview").data("index")] = 0;
    }
});

function newBusinessErrorMessage(msg, timeout) {
    $("#modalCreateBusiness").animate({ scrollTop: 0 }, "slow");
    $("#lblBusinessErrorText").text(msg);
    $("#lblBusinessError").slideDown();
    if (typeof (timeout) !== "undefined") {
        setTimeout(function () { $("#lblBusinessError").slideUp(); }, timeout);
    }
}

function loadReviews(element) {
    var businessId = parseInt($(element).closest(".nav-tabs-custom").data("business_id"));
    var rating = parseInt($(element.control).val());
    getReviews('businesses', businessId, rating);
}

// User Ratings //
$(".content-wrapper").on("click", ".rating-input-main", function () {
    var originalRating = parseInt($(this).parent().data("original_rating"));
    $(this).siblings(".rating-input[value=" + originalRating + "]").prop("checked", true);
    checkLogin(loadReviews, this);
});

// Business Filters //
var businessFilters = {
    count: 10,
    primarySort: null,
    secondarySort: null,
    minimumRating: null,
    tags: null,
    type: $("#hiddenBusinessType").val()
}
$("#businessFilters button[data-widget=remove]").click(function () {
    setTimeout(function () { $("#pnlBusinesses").removeClass("col-lg-8"); }, 500);
});
if ($("#businessFilters").length == 0) { $("#pnlBusinesses").removeClass("col-lg-8"); }

$("#ddlBusinessPrimarySort").change(function () {
    $("#ddlBusinessSecondarySort option").each(function () {
        $(this).removeClass("hidden");
    });
    var sortValue = $("#ddlBusinessPrimarySort option:selected").val();
    if (sortValue === "costUp" || sortValue === "costDown") {
        $("#ddlBusinessSecondarySort option[value=costUp]").addClass("hidden");
        $("#ddlBusinessSecondarySort option[value=costDown]").addClass("hidden");
    } else if (sortValue === "null") {
        sortValue = null;
    } else {
        $("#ddlBusinessSecondarySort option[value=" + sortValue + "]").addClass("hidden");
    }
    businessFilters.primarySort = sortValue;
});
$("#ddlBusinessSecondarySort").change(function () {
    $("#ddlBusinessPrimarySort option").each(function () {
        $(this).removeClass("hidden");
    });
    var sortValue = $("#ddlBusinessSecondarySort option:selected").val();
    if (sortValue === "costUp" || sortValue === "costDown") {
        $("#ddlBusinessPrimarySort option[value=costUp]").addClass("hidden");
        $("#ddlBusinessPrimarySort option[value=costDown]").addClass("hidden");
    } else if (sortValue === "null") {
        sortValue = null;
    } else {
        $("#ddlBusinessPrimarySort option[value=" + sortValue + "]").addClass("hidden");
    }
    businessFilters.secondarySort = sortValue;
});

$("#lblFilterBusinessReviews input[name=rating-input-3]").change(function () {
    businessFilters.minimumRating = $(this).val();
});

$("#txtMaximumDistance").change(function () {
    var sortDistance = $(this).val();
    if (sortDistance === 0) {
        sortDistance = null;
    } else if (sortDistance > 100) {
        sortDistance = 100;
        $(this).val(100);
    }
    businessFilters.maximumDistance = sortDistance;
});

$("#txtNumOfBusinesses").change(function () {
    var numOfBusinesses = $(this).val();
    if (numOfBusinesses > 30) {
        numOfBusinesses = 30;
        $(this).val(30);
    }
    businessFilters.count = numOfBusinesses;
})

$(".tag-filters").click(function () {
    $(this).toggleClass("selected-border");
    businessFilters.tags = [];
    $(".tag-filters.selected-border").each(function () {
        businessFilters.tags.push($(this).attr("title"));
    });
    if (businessFilters.tags.length === 0) {
        businessFilters.tags = null;
    }
});

$("#btnFilterBusinesses").click(function () {
    callBack("businesses.aspx/FilterBusinesses", businessFilters, function (msg) {
        $("#pnlBusinesses").html(msg.d.content);
        $("#hiddenBusinessCoordinates").val(msg.d.coordinates);
        setupTodoItems();
        setupMaps();
        setupLocations();
        window.history.replaceState(null, $("title").text(), '/things-to-do/' + window.viewParam);
    });
});

$("#btnFilterBusinessesClear").click(function () {
    businessFilters = {
        count: 10,
        primarySort: null,
        secondarySort: null,
        minimumRating: null,
        tags: null,
        type: $("#hiddenBusinessType").val()
    }
    $("#ddlBusinessPrimarySort option[value=null]").prop("selected", true);
    $("#ddlBusinessSecondarySort option[value=null]").prop("selected", true);
    $("#lblFilterBusinessReviews input:checked").prop("checked", false);
    $("#txtMaximumDistance").val("");
    $(".tag-filters.selected-border").each(function () {
        $(this).toggleClass(".selected-border");
    });
});

$(".content-wrapper").on("click", ".lblBusinessTags .btn", function () {
    var tag = $(this).text();
    var data = {
        tag: tag,
        type: businessFilters.type,
        count: businessFilters.count,
        primarySort: businessFilters.primarySort,
        secondarySort: businessFilters.secondarySort,
        minimumRating: businessFilters.minimumRating
    };
    callBack("businesses.aspx/FilterByTag", data, function (msg) {
        $("#pnlBusinesses").html(msg.d.content);
        $("#hiddenBusinessCoordinates").val(msg.d.coordinates);
        setupTodoItems();
        setupMaps();
        setupLocations();
        window.history.replaceState(null, $("title").text(), '/things-to-do/' + window.viewParam + "/tag/" + data.tag.replace(" ", "+"));
    });
});

$(".pnlBusinessSubImages .lazy-load").each(function () {
    $(this).attr("src", $(this).data("src"))
});