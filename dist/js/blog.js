$(window).on("load", function () {
    var idParam = parseInt($("#hiddenIDParam").val());
    if (idParam > 0) {
        $("[data-blog_post_id=" + idParam + "] .read-more-blog").click();
    }
});

$("#btnCloseBlogDetails").click(function () {
    setTimeout(function () { $("#timeline").parent().removeClass("col-xl-9 col-md-8"); }, 500);
});
if ($("#blogDetails").length == 0) { $("#timeline").parent().removeClass("col-lg-8"); }
$("#txtDateRangeFilter").daterangepicker({
    locale: {
        format: 'DD-MM-YYYY'
    },
    startDate: moment("2018-01-01"),
    endDate: moment()
},
function (start, end, label) {
    filters.dateRange = start.format("YYYY-MM-DD") + "," + end.format("YYYY-MM-DD");
});

var filters = {
    postCount: 10,
    typeFilters: "",
    tagFilters: "",
    dateRange: moment("2018-01-01").format("YYYY-MM-DD") + "," + moment().format("YYYY-MM-DD")
};

$(".type-filters").click(function () {
    $(this).toggleClass("selected-border");
});
$(".tag-filters").click(function () {
    $(this).toggleClass("selected-border");
});
$("#btnFilterPosts").click(function () {
    // Post Type Filter
    filters.typeFilters = ""
    $(".type-filters.selected-border").each(function () {
        filters.typeFilters += $(this).data("blog_type") + ",";
    });
    filters.typeFilters = filters.typeFilters.slice(0, -1);

    // Post Tags Filter
    filters.tagFilters = "";
    $(".tag-filters.selected-border").each(function () {
        filters.tagFilters += $(this).attr("title") + ",";
    });
    filters.tagFilters = filters.tagFilters.slice(0, -1);

    // Post Count Filter
    filters.postCount = $("#txtNumPosts").val();

    var data = { postFilterData: filters };
    callBack("blog.aspx/FilterPosts", data, function (msg) {
        $("#timeline").html(msg.d);
        checkLoadMore();
    });
});
$("#btnFilterPostsClear").click(function () {
    clearFilterForm();
    var data = {
        postFilterData: filters
    };
    callBack("blog.aspx/FilterPosts", data, function (msg) {
        $("#timeline").html(msg.d);
        checkLoadMore();
    });
});

function clearFilterForm() {
    $(".tag-filters.selected-border").each(function () {
        $(this).toggleClass("selected-border");
        filters.tagFilters = "";
    });
    $(".type-filters.selected-border").each(function () {
        $(this).toggleClass("selected-border");
        filters.typeFilters = "";
    });
    $("#txtDateRangeFilter").daterangepicker({
        locale: {
            format: 'MM-DD-YYYY'
        },
        startDate: moment("2018-01-01"),
        endDate: moment()
    },
    function (start, end, label) {
        filters.dateRange = start.format("YYYY-MM-DD") + "," + end.format("YYYY-MM-DD");
    });
    filters.dateRange = moment("2018-01-01").format("YYYY-MM-DD") + "," + moment().format("YYYY-MM-DD");
    $("#txtNumPosts").val("10");
    filters.postCount = "10";
}

function filterPostTag() {
    $("#modalShowBlogDetails").modal("hide");
    clearFilterForm();
    filters.tagFilters = $(this).text().trim();
    data = {
        postFilterData: filters
    };
    callBack("blog.aspx/FilterPosts", data, function (msg) {
        $("#timeline").html(msg.d);
        checkLoadMore();
    });
};

$("#btnLoadMorePosts").click(function () {
    filters.postCount += 10;
    var data = { postFilterData: filters };
    callBack("blog.aspx/FilterPosts", data, function (msg) {
        $("#timeline").html(msg.d);
        checkLoadMore();
    });
});

function checkLoadMore() {
    userInfoEvents($("#timeline")[0]);
    $(".btn-tag").click(filterPostTag);
    $(".read-more-blog").click(showReadMore);
    if ($(".timeline-item").length < filters.postCount) {
        if (!$("#btnLoadMorePosts").hasClass("hidden")) {
            $("#btnLoadMorePosts").addClass("hidden")
        }
    } else if ($(".timeline-item").length == filters.postCount) {
        $("#btnLoadMorePosts").removeClass("hidden");
    }
}

function showReadMore() {
    var blogData = JSON.parse($(this).closest(".timeline-body").find("input[type=hidden]").val());
    var blogModal = $("#modalShowBlogDetails");

    blogModal.find(".modal-title").text(blogData.Title);
    blogModal.find("#showBlogContent").html(blogData.FullContent);
    blogModal.find(".user-block img").attr("src", blogData.Author.Avatar).attr("alt", blogData.Author.FullName);
    blogModal.find(".user-block .username a").attr("href", "viewprofile.aspx?id=" + blogData.Author.UserID).text(blogData.Author.FullName);
    blogModal.find(".user-block .description").text(blogData.Author.Tagline);
    var tagHtml = "";
    for (var i = 0; i < blogData.Tags.length; i++)
    {
        tagHtml += "<span class='btn btn-small btn-flat btn-primary btn-tag' style='margin-left:5px;font-size: " + blogData.Tags[i].Size + "px'><i class='fa fa-tag'></i> " + blogData.Tags[i].Tag + "</span>";
    }
    blogModal.find(".blog-tags").append(tagHtml);
    $("#showUserReviewCount").text(blogData.CommentCount);
    blogModal.find(".btn-tag").click(filterPostTag);

    blogModal.find("#showUserComments").click(function () {
        getReviews("blog_posts", blogData.BlogPostID, null, function () {
            $("#pnlShowUserComments").slideDown();
            $("#showUserComments").slideUp();
        });
    });

    userInfoEvents(blogModal[0]);

    blogModal.modal("show");
}

$("#modalShowBlogDetails").on("hidden.bs.modal", function () {
    var blogModal = $("#modalShowBlogDetails");
    blogModal.find(".modal-title").text("");
    blogModal.find("#showBlogContent").html("");
    blogModal.find(".user-block img").attr("src", "/dist/img/profile/male_placeholder.png").attr("alt", "Blog Post Author");
    blogModal.find(".user-block .username a").attr("href", "#").text("");
    blogModal.find(".user-block .description").text("");
    blogModal.find(".blog-tags .btn-tag").remove();
    blogModal.find("#showUserReviewCount").text("0");
    blogModal.find("#showUserComments").unbind("click");
    blogModal.find("#pnlShowUserComments").slideUp();
    blogModal.find("#showUserComments").slideDown();
});

checkLoadMore();