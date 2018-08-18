$(".show-full-article").on("click", function () {
    var tipInfo = JSON.parse($(this).siblings("input[type=hidden]").val());

    var $modal = $("#modalShowTip");

    $modal.find(".modal-title").text(tipInfo.Title);
    $modal.find("#showTipTitle").text(tipInfo.Title);
    $modal.find("#showTipDescription").html(tipInfo.Description);

    $modal.modal("show");
});

$("#modalShowTip").on("hidden.bs.modal", function () {
    var $modal = $("#modalShowTip");
    $modal.find(".modal-title").text("");
    $modal.find("#showTipTitle").text("");
    $modal.find("#showTipDescription").html("");
});