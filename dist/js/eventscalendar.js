$(window).on("load", function () {
    var actionParam = $("#hiddenActionParam").val();
    if (actionParam.length > 0) {
        switch (actionParam) {
            case "add":
                $("#btnShowAddEvent").click();
                break;
        }
        window.history.replaceState(null, $("title").text(), '/events-calendar');
    }

    var viewParam = parseInt($("#hiddenViewParam").val());
    if (viewParam > 0) {
        $("[data-event_id=" + viewParam + "] .box-body").click();
    }

    var editParam = parseInt($("#hiddenEditParam").val());
    if (editParam > 0) {
        window.history.replaceState(null, $("title").text(), '/events-calendar');
        checkLogin(function () {
            callBack("eventscalendar.aspx/GetEventData", { eventId: editParam }, function (msg) {
                if (msg.d == null) {
                    showWarning("Could Not Find Event (Tech Support Notified)");
                    $(".loading-overlay").hide();
                } else {
                    $("#modalCreateEvent").data("edit_event_id", editParam);
                    $("#txtEventBusiness").val(msg.d.Business);
                    $("#txtEventTitle").val(msg.d.Title);
                    $("#txtEventLocation").val(msg.d.Location);
                    if (msg.d.Days.length > 0) {
                        $("#chkEventDateTimeWeekly").iCheck("check");
                        for (var i = 0; i < msg.d.Days.length; i++) {
                            $("#pnlEventDateTimeRecurring input[type=checkbox][value=" + msg.d.Days[i] + "]").iCheck("check");
                        }
                        $("#txtEventDateTimeRecurringTimeStart").timepicker("setTime", msg.d.StartTimeString);
                        $("#txtEventDateTimeRecurringTimeEnd").timepicker("setTime", msg.d.EndTimeString);
                    } else if (msg.d.StartDate != null && msg.d.EndDate != null) {
                        $("#chkEventDateTimeSpecific").iCheck("check");
                        var drp = $("#txtEventDateTimeSpecific").data("daterangepicker");
                        var start = new Date(parseInt(msg.d.StartDate.substr(6))).toDateString();
                        var end = new Date(parseInt(msg.d.EndDate.substr(6))).toDateString();
                        var dateFormat = "ddd MMM DD YYYY";
                        $('#txtEventDateTimeSpecific').daterangepicker({
                            "timePicker": true,
                            "timePicker24Hour": true,
                            "timePickerIncrement": 15,
                            "dateLimit": {
                                "days": 30
                            },
                            "startDate": moment(start, dateFormat).format("MM/DD/YYYY"),
                            "endDate": moment(end, dateFormat).format("MM/DD/YYYY"),
                            "minDate": moment(start, dateFormat).format("MM/DD/YYYY")
                        }, function (start, end) {
                            eventDate.start = start.format("YYYY-MM-DD HH:mm:ss");
                            eventDate.end = end.format("YYYY-MM-DD HH:mm:ss");
                        });
                    }
                    $("#ddlTodoType option[value=" + msg.d.Type + "]").prop("selected", true);
                    $("#txtEventCost").val(msg.d.Cost);
                    $("#eventsTextarea").data("wysihtml5").eventsTextarea.setValue(msg.d.Details);
                    var imagesPreview = $("#eventImageUploads .images-preview");
                    var imageUploadsIndex = imagesPreview.data("index");
                    for (var i = 0; i < msg.d.EventImages.length; i++) {
                        imagesPreview.append(
                            "<div class='text-center image-preview pull-left' style='width:135px;margin:0px auto 5px auto;'>" +
                                "<img src='" + msg.d.EventImages[i].Path + "' class='img-responsive image-upload' style='margin:0 auto;max-height:75px;' />" +
                                "<div class='input-group input-group-sm' style='margin:0 auto;width:114px;'>" +
                                    "<span class='input-group-addon bg-primary clickable' onclick='makeMainImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Main Image'><i class='fa fa-home'></i></span>" +
                                    "<input class='text-center form-control image-sort' type='text' value='" + (i + 1) + "' disabled />" +
                                    "<span class='input-group-addon bg-red clickable' onclick='removePreviewImage(this," + imageUploadsIndex + ")' data-toggle='tooltip' data-original-title='Delete Image'><i class='fa fa-times'></i></span>" +
                                "</div>" +
                            "</div>"
                        );
                    }

                    $("#modalCreateEvent").modal({
                        show: true,
                        backdrop: "static",
                        keyboard: false
                    });

                    $('#modalCreateEvent').on('shown.bs.modal', function () {
                        $('#txtEventBusiness').focus();
                    });
                }
            });
        });
    }
});

var eventDate = {
    start: null,
    end: null
}

var eventCalendarData = JSON.parse($("#hiddenEventCalendarData").val());
var allEventData = JSON.parse($("#hiddenEventData").val());

var eventsCalendar = $("#eventsCalendar").fullCalendar({
    header: { left: "prev,month,basicWeek", center: "title", right: "today,next" },
    buttonText: { month: "Month", week: "Week", today: "Today" },
    titleFormat: "D MMM",
    visibleRange: function (currentDate) {
        return {
            start: currentDate.clone().subtract(3, 'months'),
            end: currentDate.clone().add(3, 'months')
        };
    },
    viewRender: function (view) {
        $("#eventsCalendar").fullCalendar("removeEvents");
        $("#eventsCalendar").fullCalendar("addEventSource", eventCalendarData);
    },
    views: {
        month: {
            eventLimit: 3
        },
        basicWeek: {

        },
        listDay: {

        }
    },
    dayClick: function (date, jsEvent, view) {
        eventsCalendar.fullCalendar("changeView", "listDay");
        eventsCalendar.fullCalendar("gotoDate", date);
    },
    events: [],
    eventClick: function (calEvent, jsEvent, view) {
        showEventModal(allEventData[calEvent.id]);
    },
    eventMouseover: function (calEvent, jsEvent, view) {
        showEventPreview(allEventData[calEvent.id]);
    }
});

$(".event-preview").hover(function () {
    showEventPreview(allEventData[$(this).data("event_id")]);
});
$(".event-preview").click(function () {
    showEventModal(allEventData[$(this).data("event_id")]);
});

$("#btnShowAddEvent").click(function () {
    checkLogin(function () {
        $("#modalCreateEvent").on("shown.bs.modal", function () {
            $("#txtEventBusiness").focus();
        });
        $("#modalCreateEvent").modal({
            show: true,
            backdrop: "static",
            keyboard: false
        });

        var today = new Date().toDateString();
        var todayFormat = "ddd MMM DD YYYY";
        $('#txtEventDateTimeSpecific').daterangepicker({
            "timePicker": true,
            "timePicker24Hour": true,
            "timePickerIncrement": 15,
            "dateLimit": {
                "days": 30
            },
            "startDate": moment(today, todayFormat).format("MM/DD/YYYY"),
            "endDate": moment(today, todayFormat).add(1, "days").format("MM/DD/YYYY"),
            "minDate": moment(today, todayFormat).format("MM/DD/YYYY")
        }, function (start, end) {
            eventDate.start = start.format("YYYY-MM-DD HH:mm:ss");
            eventDate.end = end.format("YYYY-MM-DD HH:mm:ss");
        });
        $(".daterangepicker").appendTo("#modalCreateEvent");

        $("#txtEventDateTimeRecurringTimeStart,#txtEventDateTimeRecurringTimeEnd").timepicker({
            defaultTime: false,
            showMeridian: false,
            disableFocus: true,
            icons: {
                up: "fa fa-angle-up",
                down: "fa fa-angle-down"
            }
        })
    }, false, false);
});

$('#modalCreateEvent').on('hidden.bs.modal', function () {
    $("#modalCreateEvent").data("edit_event_id", null);
    $("#txtEventBusiness").val("");
    $("#txtEventTitle").val("");
    $("#txtEventLocation").val("");
    $("#eventsTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html("");
    $("#txtEventDateTimeSpecific").val("");
    eventDate.start = null;
    eventDate.end = null;
    $("#ddlTodoType option[value=null]").prop("selected", true);
    $("#txtEventCost").val(0);
    $("#eventImageUploads .images-preview").html("");
    if (typeof (window.uploadsCompleted) !== "undefined") {
        window.uploadsCompleted[$("#eventImageUploads .images-preview").data("index")] = 0;
    }
})

$('[name=chkEventDateTimeType],#pnlEventDateTimeRecurring input[type=checkbox]').iCheck({
    checkboxClass: 'icheckbox_square-green',
    radioClass: 'iradio_square-green',
    increaseArea: '20%'
});

$("[name=chkEventDateTimeType]").change(function () {
    $("#pnlEventDateTimeSelectType").slideUp();
    switch ($(this).val()) {
        case "Recurring":
            $("#pnlEventDateTimeRecurring").slideDown();
            break;
        case "Specific":
            $("#pnlEventDateTimeSpecific").slideDown();
            break;
    }
});
$('[name=chkEventDateTimeType]').on('ifChanged', function (event) { $(event.target).trigger('change'); });

$("#btnEventDateTimeChangeTypeRecurring,#btnEventDateTimeChangeTypeSpecific").click(function () {
    $("#pnlEventDateTimeRecurring,#pnlEventDateTimeSpecific").slideUp();
    $("#pnlEventDateTimeSelectType").slideDown();
    $("[name=chkEventDateTimeType]").prop("checked", false);
    $("#txtEventDateTimeRecurringTimeStart,#txtEventDateTimeRecurringTimeEnd").val("");
    eventDate.start = null;
    eventDate.end = null;
    $("#txtEventDateTimeSpecific").val("");
})

$("#btnSubmitNewEvent").click(function () {
    var business = $("#txtEventBusiness").val();
    var title = $("#txtEventTitle").val();
    var location = $("#txtEventLocation").val();
    var content = $("#eventsTextarea").siblings(".wysihtml5-sandbox").contents().find("body").html();
    var type = $("#ddlTodoType option:selected").val();
    var cost = parseFloat($("#txtEventCost").val());
    var images = [];
    $("#eventImageUploads .image-upload").each(function () {
        images.push($(this).attr("src"));
    });
    var days = [];
    var recurringTimeStart = false;
    var recurringTimeEnd = false;
    if ($("#pnlEventDateTimeRecurring").is(":visible")) {
        $("#pnlEventDateTimeRecurring input[type=checkbox]:checked").each(function () {
            days.push($(this).val());
        });
        eventDate.start = new Date("1970-01-01 " + $("#txtEventDateTimeRecurringTimeStart").val()).toLocaleString().replace(",", "");
        eventDate.end = new Date("1970-01-01 " + $("#txtEventDateTimeRecurringTimeEnd").val()).toLocaleString().replace(",", "");
        
        if (days.length == 0) {
            eventError("Must Select Day(s)");
            return;
        } else { $("#lblEventError").slideUp(); }
    } else if ($("#pnlEventDateTimeSpecific").is(":visible")) {
        if (eventDate.start == null || eventDate.end == null) {
            eventError("Must Select Date/Time");
            return;
        } else { $("#lblEventError").slideUp(); }
    } else { eventError("Must Select Dates/Times"); return; }

    function eventError(msg) {
        $("#modalCreateEvent").animate({ scrollTop: 0 }, "slow");
        $("#lblEventErrorText").text(msg);
        $("#lblEventError").slideDown();
    }
    var edit = $("#modalCreateEvent").data("edit_event_id");

    if (business.length == 0) {
        eventError("Enter a Business Name")
        return;
    } else { $("#lblEventError").slideUp(); }
    if (title.length < 10) {
        eventError("Title Minimum 10 Characters");
        return;
    } else { $("#lblEventError").slideUp(); }
    if (location.length == 0) {
        eventError("Enter the Event Location");
        return;
    } else { $("#lblEventError").slideUp(); }
    if (stripTags(content).length < 200) {
        eventError("Details Minimum 200 Characters");
        return;
    } else { $("#lblEventError").slideUp(); }
    if (type == "null") {
        eventError("Must Select Event Type");
        return;
    } else { $("#lblEventError").slideUp(); }
    if (!(cost >= 0 && cost <= 5000)) {
        eventError("Invalid Cost (Must be Between 0 and 5,000 元)");
        return;
    } else { $("#lblEventError").slideUp(); }

    if (images.length == 0) {
        eventError("Must Provide At Least 1 Image");
        return;
    } else { $("#lblEventError").slideUp(); }

    var data = {
        business: business,
        title: title,
        location: location,
        content: content,
        type: type,
        start: eventDate.start,
        end: eventDate.end,
        cost: cost,
        images: images,
        days: days,
        editEventId: edit
    }

    callBack("eventscalendar.aspx/SaveEvent", data, function (msg) {
        if (msg.d > 0) {
            window.location.href = 'https://www.kunminglive.com/events-calendar/' + msg.d;
        } else {
            submitError("Failed to Save Event (Technical Support Notified)", JSON.stringify({ data: data, msg: msg }));
            $(".loading-overlay").hide();
        }
    }, true, true);
});

$(".show-event-details").click(function () {
    if ($(this).hasClass("inactive")) { return; }
    var eventData = allEventData[$(this).closest(".box").data("event_id")];
    showEventModal(eventData);
});

function showEventModal(eventData) {
    var eventModal = $("#modalShowEventDetails");
    eventModal.data("event_id", eventData.EventID);

    eventModal.find(".modal-title").text(eventData.Title);
    for (var i = 0; i < eventData.EventImages.length; i++) {
        $("#showEventCarousel .carousel-inner").append(
            "<div class='item" + (i == 0 ? " active" : "") + "' style='border:0;'>" +
                "<img src='" + eventData.EventImages[i].Path + "' alt='Slide #" + i + "' class='clickable' onclick='showImageSlideshow(this)' style='max-height:200px;margin:0 auto;' />" +
            "</div>");
        $("#showEventCarousel .carousel-indicators").append("<li data-target='#showEventCarousel' data-slide-to='" + i + "' " + (i == 0 ? "class='active'" : "") + "></li>");
    }
    $("#showEventType").addClass("event-type " + eventData.TypeLabel);
    $("#showEventType").text(eventData.TypeString);
    $("#showEventBusiness").text(eventData.Business);
    $("#showEventLocation").text(eventData.Location);

    var dateFormat = "ddd MMM DD YYYY";
    var outputDate = "";
    if (eventData.StartDate != null) {
        eventData.StartDate = (typeof(eventData.StartDate) == "string" ? parseInt(eventData.StartDate.replace(/[^0-9 +]/g, '')) : eventData.StartDate);
        eventData.EndDate = (typeof(eventData.EndDate) == "string" ? parseInt(eventData.EndDate.replace(/[^0-9 +]/g, '')) : eventData.EndDate);
        var startDate = moment(new Date(eventData.StartDate).toDateString(), dateFormat).format("MMM d");
        var endDate = moment(new Date(eventData.EndDate).toDateString(), dateFormat).format("MMM d");
        outputDate = startDate + " to " + endDate;
    } else if (eventData.Days.length > 0) {
        for (var i = 0; i < eventData.Days.length; i++) {
            outputDate += eventData.DaysText[i].substr(0, 1);
        }
    }
    $("#showEventDates").text(outputDate);

    var startTime = moment(new Date(eventData.StartDate).toISOString().substring(0, 10) + "T" + eventData.StartTimeString).format("h:mm");
    var endTime = moment(new Date(eventData.StartDate).toISOString().substring(0, 10) + "T" + eventData.EndTimeString).format("h:mm");
    var timeOutput = (eventData.AllDay ? "All Day" : startTime + "-" + endTime);
    $("#showEventTimes").text(timeOutput);
    $("#showEventCost").text(eventData.Cost == 0 ? "Free" : eventData.CostString);
    $("#showEventAttendeesCount").text(eventData.EventAttendees.length)

    for (var i = 0; i < eventData.EventAttendees.length; i++) {
        appendAttendee(eventData.EventAttendees[i].User.UserID, eventData.EventAttendees[i].User.Avatar, eventData.EventAttendees[i].User.FullName);
    }
    userInfoEvents();

    if (eventData.Going) {
        var btnEventGoing = $("#showEventGoing");
        btnEventGoing.removeClass("btn-success").addClass("btn-danger");
        btnEventGoing.attr("data-original-title", "Click To Cancel Attendance");
        btnEventGoing.text("Cancel Attendance");
    }

    $("#showEventDetails").html(eventData.Details);

    $("#showEventCarousel").attr("data-interval", 3000);
    $("#showEventCarousel").carousel("pause").removeData();
    $("#showEventCarousel").carousel({
        interval: 3000
    }).carousel("cycle");

    eventModal.modal("show");
}

$("#modalShowEventDetails").on("hidden.bs.modal", function () {
    $("#modalShowEventDetails").find(".modal-title").text("");
    $("#showEventCarousel").attr("data-interval", "false");
    $("#showEventCarousel").carousel("pause").removeData();
    $("#showEventCarousel .carousel-indicators").html("");
    $("#showEventCarousel .carousel-inner").html("");
    $("#showEventType").attr("class", "");
    $("#showEventType").text("");
    $("#showEventBusiness").text("");
    $("#showEventLocation").text("");
    $("#showEventDates").text("");
    $("#showEventTimes").text("");
    $("#showEventCost").text("");
    $("#showEventAttendeesCount").text("");
    $("#showEventAttendeesBox").slideUp();
    $("#showEventAttendeesBox tbody").html("");
    $("#showEventGoing").removeClass("btn-danger").addClass("btn-success");
    $("#showEventGoing").attr("data-original-title", "Click To Attend Event");
    $("#showEventGoing").text("I'm Going!");
    $("#showEventDetails").html("");
    window.history.replaceState(null, $("title").text(), '/events-calendar');
});

function showEventPreview(eventData) {
    var dateFormat = "ddd MMM DD YYYY";
    var outputDate = "";
    if (eventData.StartDate != null) {
        eventData.StartDate = (typeof (eventData.StartDate) == "string" ? parseInt(eventData.StartDate.replace(/[^0-9 +]/g, '')) : eventData.StartDate)
        eventData.EndDate = (typeof (eventData.EndDate) == "string" ? parseInt(eventData.EndDate.replace(/[^0-9 +]/g, '')) : eventData.EndDate);
        var startDate = moment(new Date(eventData.StartDate).toDateString(), dateFormat).format("MMM d");
        var endDate = moment(new Date(eventData.EndDate).toDateString(), dateFormat).format("MMM d");
        outputDate = startDate + " to " + endDate;
    } else if (eventData.Days.length > 0) {
        for (var i = 0; i < eventData.Days.length; i++) {
            outputDate += eventData.DaysText[i].substr(0, 1);
        }
    }

    var startTime = moment(new Date(eventData.StartDate).toISOString().substring(0, 10) + "T" + eventData.StartTimeString).format("h:mm");
    var endTime = moment(new Date(eventData.StartDate).toISOString().substring(0, 10) + "T" + eventData.EndTimeString).format("h:mm");
    var timeOutput = (eventData.AllDay ? "All Day" : startTime + "-" + endTime);
    $("#showEventTimes").text(timeOutput);

    var showPreview = $("#showEventPreview");
    showPreview.data("event_id", eventData.EventID);
    showPreview.attr("class", "box " + eventData.TypeBox);
    showPreview.find(".save-todo").attr("id", "events-" + eventData.EventID)
        .removeClass("hidden")
        .attr("data-todo-title", eventData.Title)
        .attr("data-todo-type", eventData.Type)
        .attr("data-link_back", eventData.Link);
    showPreview.find(".box-title").text(eventData.Title);
    showPreview.find(".box-body").removeClass("inactive");
    showPreview.find(".show-event-main-image").attr("src", eventData.EventImages[0].Path);
    showPreview.find(".event-type").attr("class", "event-type " + eventData.TypeLabel);
    showPreview.find(".event-type").text(eventData.TypeString);
    showPreview.find(".event-preview-business").text(eventData.Business);
    showPreview.find(".event-preview-location").text(eventData.Location);
    showPreview.find(".event-preview-dates").text(outputDate);
    showPreview.find(".event-preview-times").text(timeOutput);
    showPreview.find(".event-preview-cost").text(eventData.Cost == 0 ? "Free" : eventData.CostString);
    showPreview.find(".event-preview-data").val(JSON.stringify(eventData));
}

$("#btnShowEventAttendeesBoxClose").click(function () {
    $("#showEventAttendeesBox").slideUp();
});

$("#showEventAttendees").click(function () {
    $("#showEventAttendeesBox").slideToggle();
});

$("#showEventGoing").click(function () {
    checkLogin(function () {
        var data = {
            eventId: $("#modalShowEventDetails").data("event_id")
        };
        callBack("eventscalendar.aspx/AttendEvent", data, function (msg) {
            var attendeeCount = $("#showEventAttendeesCount");
            var btnEventGoing = $("#showEventGoing");
            if (msg.d == null) {
                showWarning("Must Be Logged In");
                return;
            } else if (msg.d == false) {
                btnEventGoing.removeClass("btn-danger").addClass("btn-success");
                btnEventGoing.attr("data-original-title", "Click To Attend Event");
                btnEventGoing.text("I'm Going!");
                $("#showEventAttendeesBox tbody #user-" + User.ID).remove();
                attendeeCount.text(parseInt(attendeeCount.text()) - 1);
            } else if (msg.d == true) {
                var btnSave = $("#events-" + data.eventId);
                if (!btnSave.find(".fa-star").hasClass("text-yellow")) {
                    btnSave.click();
                }
                btnEventGoing.removeClass("btn-success").addClass("btn-danger");
                btnEventGoing.attr("data-original-title", "Click To Cancel Attendance");
                btnEventGoing.text("Cancel Attendance");
                appendAttendee(User.ID, User.Avatar, User.FullName)
                attendeeCount.text(parseInt(attendeeCount.text()) + 1);
            }
        });
    });
});

function appendAttendee(id, avatar, name) {
    $("#showEventAttendeesBox tbody").append(
        "<tr id='user-" + id + "'>" +
            "<td class='col-xs-2'>" +
                "<a href='https://www.kunminglive.com/view-profile/" + id + "' target='_blank'><img src='" + avatar + "' alt='Event Attendee' class='img-responsive img-circle' /></a>" +
            "</td>" +
            "<td class='col-xs-10' style='vertical-align:middle;'>" +
                "<a href='https://www.kunminglive.com/view-profile/" + id + "' target='_blank'>" + name + "</a>" +
            "</td>" +
        "</tr>");
}