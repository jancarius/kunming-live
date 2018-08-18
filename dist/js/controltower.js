$(window).on("load", function () {
    $(".todo-list").sortable({
        tolerance: "touch",
        stop: function () {
            var sortables = [];
            $(".todo-list").each(function () {
                sortables = sortables.concat($(this).sortable("toArray"));
            });

            var data = { sortableData: [] };
            for (var i = 0; i < sortables.length; i++) {
                data.sortableData[i] = {
                    sortOrder: i,
                    elementId: sortables[i],
                };
            }
            callBack("controltower.aspx/SaveTodoList", data, null, false);
        }
    });
});

$("#calendar").datepicker({
    numberOfMonths: 12
});

// Todo List //
function showTodoListButtons() {
    var thisCheckbox = $(".todo-list-item [type='checkbox']:checked");
    if (thisCheckbox.length > 0) {
        if (thisCheckbox.closest("#lstTodoItems").length > 0) {
            $("#pnlTodoItemButtons").slideDown();
        } else {
            $("#pnlTodoItemButtonsDone").slideDown();
        }
    } else {
        $("#pnlTodoItemButtons,#pnlTodoItemButtonsDone").slideUp();
    }
}

$("#btnTodoItemsDone").click(todoDoneUndone);
$("#btnTodoItemsUndone").click(todoDoneUndone);
function todoDoneUndone() {
    $(".loading-overlay").show();
    var todoItems = $(".todo-list-item [type='checkbox']:checked");
    var done = false;
    if (todoItems.length > 0) {
        var todoItemIds = [];
        todoItems.each(function () {
            todoItemIds.push($(this).closest(".todo-list-item").attr("id").split("-")[1]);
        });
        if ($(todoItems[0]).closest(".todo-list").attr("id") === "lstTodoItems") {
            done = true;
        }
    }
    var data = {
        todoItemIds: todoItemIds,
        done: done
    };
    callBack("master.asmx/TodoItemDone", data, function (msg) {
        if (msg.d === true) {
            $(".todo-list-item [type=checkbox]:checked").each(function () {
                if (done) {
                    $(this).closest(".todo-list-item").appendTo("#lstTodoItemsDone");
                    $("#pnlTodoItemButtons").slideUp();
                    if ($("#lstTodoItems li").length === 0) {
                        $("#lstTodoItems h3").removeClass("hidden");
                    }
                    if (!$("#lstTodoItemsDone h3").hasClass("hidden")) {
                        $("#lstTodoItemsDone h3").addClass("hidden");
                    }
                } else {
                    $(this).closest(".todo-list-item").appendTo("#lstTodoItems");
                    $("#pnlTodoItemButtonsDone").slideUp();
                    if ($("#lstTodoItemsDone li").length === 0) {
                        $("#lstTodoItemsDone h3").removeClass("hidden");
                    }
                    if (!$("#lstTodoItems h3").hasClass("hidden")) {
                        $("#lstTodoItems h3").addClass("hidden");
                    }
                }
                $(this).prop("checked", false);
            });
        } else {
            submitError("Failed to Mark Todo Item 'Done' (Tech Support Notified)", JSON.stringify({ msg: msg, data: data }));
        }
    });
};

$("#btnViewCompletedTodo").click(function () {
    $(".todo-list-item [type='checkbox']:checked").each(function () {
        $(this).prop("checked", false);
    });
    if ($("#lstTodoItems").css("display") === "none") {
        $("#lstTodoItems").slideDown("slow");
        $("#lstTodoItemsDone").slideUp("slow");
        $("#pnlTodoItemButtonsDone").slideUp();
        $(this).text("View Completed");
    } else {
        $("#lstTodoItems").slideUp("slow");
        $("#pnlTodoItemButtons").slideUp();
        $("#lstTodoItemsDone").slideDown("slow");
        $(this).text("View Bucket List");
    }
});

$("#btnTodoItemsDelete").click(function () {
    var data = {
        deleteItems: []
    };
    $(".todo-list-item [type=checkbox]:checked").each(function () {
        data.deleteItems = data.deleteItems.concat($(this).closest(".todo-list-item").data("todo_item_id"));
        $(this).closest(".todo-list-item").remove();
    });
    callBack("master.asmx/DeleteTodoItem", data);
});

var allEventData = JSON.parse($("#hiddenEventData").val());
var eventsCalendar = $("#controlTowerCalendar").fullCalendar({
    header: { left: "prev,month,basicWeek", center: "title", right: "today,next" },
    buttonText: { month: "Month", week: "Week", today: "Today" },
    titleFormat: "D MMM",
    themeSystem: "bootstrap3",
    contentHeight: 310,
    visibleRange: function (currentDate) {
        return {
            start: currentDate.clone().subtract(1, 'months'),
            end: currentDate.clone().add(1, 'months')
        };
    },
    viewRender: function (view) {
        $("#controlTowerCalendar").fullCalendar("removeEvents");
        $("#controlTowerCalendar").fullCalendar("addEventSource", allEventData);
    },
    views: {
        month: {
            eventLimit: 1
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
        window.location.href = "eventscalendar.aspx?view=" + calEvent.id;
    },
    eventMouseover: function (calEvent, jsEvent, view) {
    }
});