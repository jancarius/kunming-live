<%@ Control Language="C#" ClassName="UserComments" %>
<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>
<%@ Register TagPrefix="hwa" TagName="WYSIHTML5" Src="~/controls/WYSIHTML5.ascx" %>

<script runat="server">
    private string tableName;
    private bool allowRating;
    private bool allowMultiple;

    protected void Page_Load(object sender, EventArgs e)
    {
        int controlCount = 0;
        foreach (Control ctrl in Page.Controls)
        {
            if (typeof(UserComments) == ctrl.GetType())
            {
                controlCount++;
            }
            if (controlCount > 1)
            {
                throw new Exception("Only One User Comments Control Allowed Per Page");
            }
        }
    }

    public string TableName { get { return tableName; } set { tableName = value; } }
    public bool Rating { get { return allowRating; } set { allowRating = value; } }
    public bool Multiple { get { return allowMultiple; } set { allowMultiple = value; } }
</script>

<div class="col-xs-12 no-padding">
    <button id="btnAddReview" type="button" class="btn btn-sm btn-primary margin-bottom pull-right">Add Review</button>
</div>
<div id="frmAddReview" class="form-horizontal" style="display: none; margin-bottom: 10px;background:#fff;border:solid 1px #111;padding:10px;z-index:1000;">
    <div class="form-group no-margin">
        <div class="row container-fluid">
            <div class="col-sm-6 no-padding">
                <input id="txtReviewTitle" type="text" class="form-control" placeholder="Title..." tabindex="301" />
            </div>
            <%
                if (Rating)
                { %>
            <div class="col-sm-3 col-xs-7" style="padding-right: 0;">
                <label for="txtReviewRating" class="control-label">Rating</label>
                <div id="lblBusinessReview" class='rating' data-primary-id='' style="position: relative; top: 8px;">
                    <input type='radio' class='rating-input' value='5' id='rating-input-1-5' name='rating-input-1'>
                    <label for='rating-input-1-5' class='rating-star'></label>
                    <input type='radio' class='rating-input' value='4' id='rating-input-1-4' name='rating-input-1'>
                    <label for='rating-input-1-4' class='rating-star'></label>
                    <input type='radio' class='rating-input' value='3' id='rating-input-1-3' name='rating-input-1'>
                    <label for='rating-input-1-3' class='rating-star'></label>
                    <input type='radio' class='rating-input' value='2' id='rating-input-1-2' name='rating-input-1'>
                    <label for='rating-input-1-2' class='rating-star'></label>
                    <input type='radio' class='rating-input' value='1' id='rating-input-1-1' name='rating-input-1'>
                    <label for='rating-input-1-1' class='rating-star'></label>
                </div>
            </div>
            <%
                } %>
        </div>
    </div>
    <hwa:WYSIHTML5 ID="wysihtml5Reviews" runat="server" TextareaID="txtReviewComments" ToolbarID="toolbarReview" />
    <button id="btnSubmitReview" type="button" class="btn btn-success pull-right" tabindex="304">Post</button>
    <button id="btnCancelReview" type="button" class="btn btn-default pull-right" tabindex="303">Cancel</button>
    <div id="pnlAddReviewImages" class="col-xs-12 margin-bottom">
        <hwa:ImageUploads ID="addReviewImageUploads" runat="server" />
    </div>
    <div class="clearfix"></div>
</div>
<div id="pnlViewReviews" class="col-xs-12 no-padding">
</div>

<script>
    var reviewTableName = null;
    function getReviews(tableName, primaryId, rating, callback) {
        reviewTableName = tableName;
        var data = {
            tableName: tableName,
            primaryId: primaryId
        };
        callBack("master.asmx/GetReviews", data, function (msg) {
            var pnlViewReviews = $("#pnlViewReviews");
            pnlViewReviews.data("primary-id", primaryId);
            pnlViewReviews.data("table-name", tableName);
            if (msg.d.length == 0) {
                pnlViewReviews.html("<h2 class='text-center'><i>No Reviews</i></h2>");
            } else {
                pnlViewReviews.html("");
                for (var i = 0; i < msg.d.length; i++) {
                    var review = msg.d[i];
                    <% if (!Multiple) { %>
                    if (review.Author.IsMe) {
                        pnlViewReviews.data("user-reviewed", true);
                    }
                    <% } %>
                    appendReview(review, !review.Author.IsMe);
                }
                $("#pnlViewReviews [data-toggle=tooltip]").tooltip({ container: 'body' });
            }
            $("#modalShowReviews").modal("show");
            if (rating) {
                <% if (!Multiple) { %>
                if (pnlViewReviews.data("user-reviewed")) {
                    showWarning("You've Already Submitted a Review (You may edit your review)");
                    return;
                }
                <% }
                if (Rating) { %>
                $("#modalShowReviews").find(".rating").find("[value='" + rating + "']").prop("checked", true);
                <% } %>
                $("#frmAddReview").show();
                $("#btnAddReview").hide();
                $('#modalShowReviews').on('shown.bs.modal', function () {
                    $('#txtReviewTitle').focus();
                });
            }
            if (typeof (callback) !== "undefined") {
                callback();
            }
        });
    }

    function clearReviews() {
        var pnlViewReviews = $("#pnlViewReviews");
        pnlViewReviews.data("primary-id", null);
        pnlViewReviews.data("table-name", null);
        pnlViewReviews.html("");
        <% if (!Multiple) { %>
        pnlViewReviews.data("user-reviewed", null);
        <% } %>
        $("#frmAddReview").hide();
        $("#btnAddReview").show();
    }

    $("#btnSubmitReview").click(function () {
        var pnlViewReviews = $("#pnlViewReviews");
        var tableName = pnlViewReviews.data("table-name");
        var primaryId = pnlViewReviews.data("primary-id");
        var title = $("#txtReviewTitle").val();
        var comment = $("#txtReviewComments").siblings(".wysihtml5-sandbox").contents().find("body").html();
        if (title.length == 0) {
            showWarning("Please Enter a Title");
            return;
        }
        if (comment.length < 10) {
            showWarning("Please Enter a Short Comment (Minimum 10 Characters)", 8);
            return;
        }
        var reviewImages = [];
        $("#pnlAddReviewImages img").each(function () {
            reviewImages.push($(this).attr("src"));
        });
        var data = {
            tableName: reviewTableName,
            primaryId: primaryId,
            title: title,
            rating: null,
            comment: comment,
            reviewImages: reviewImages
        };

        <% if (Rating) { %>
        var rating = $("input[name='rating-input-1']:checked").val();
        if (typeof (rating) === "undefined") {
            showWarning("Please Select a Star Rating");
            return;
        }
        data.rating = rating;
        <% } %>

        callBack("master.asmx/SaveReview", data, function (msg) {
            if (msg.d == null) {
                showWarning("Must Be Logged in to Submit Review");
            } else if (msg.d == false) {
                showWarning("You've Already Reviewed This Business");
            } else {
                if (!clearReview(true)) { return; }
                pnlViewReviews.data("primary-id", null);
                if (pnlViewReviews.children().length == 1) {
                    pnlViewReviews.html("");
                }
                appendReview(msg.d, false);
                $("#pnlViewReviews [data-toggle=tooltip]").tooltip({ container: 'body' });
            }
        });
    });

    $("#btnAddReview").click(function () {
        <% if (!Multiple) { %>
        if ($("#pnlViewReviews").data("user-reviewed") == true) {
            showWarning("You've Already Reviewed This Business");
            return;
        }
        <% } %>
        $("#frmAddReview").show();
        $("#btnAddReview").hide();
        $('#txtReviewTitle').focus();
    });

    $("#btnCancelReview").click(function () {
        if (!clearReview()) { return; }
    });

    window.appendedReviews = 0;
    function appendReview(review, append, container) {
        var reviewImages = "";
        for (var i = 0; i < review.Images.length; i++) {
            reviewImages += "<img src='" + review.Images[i].Path + "' alt='' class='clickable margin' style='max-height:50px;' onclick='showImageSlideshow(this)' />";
        }
        var starHtml = "";
        <% if (Rating) { %>
        starHtml =
            "<div class='rating-static'>" +
                "<input type='radio' class='rating-input-static' value='5' name='rating-input-3_" + window.appendedReviews + "' disabled " + (review.Rating == 5 ? "checked" : "") + ">" +
                "<label for='rating-input-1-5' class='rating-star'></label>" +
                "<input type='radio' class='rating-input-static' value='4' name='rating-input-3_" + window.appendedReviews + "' disabled " + (review.Rating == 4 ? "checked" : "") + ">" +
                "<label for='rating-input-1-4' class='rating-star'></label>" +
                "<input type='radio' class='rating-input-static' value='3' name='rating-input-3_" + window.appendedReviews + "' disabled " + (review.Rating == 3 ? "checked" : "") + ">" +
                "<label for='rating-input-1-3' class='rating-star'></label>" +
                "<input type='radio' class='rating-input-static' value='2' name='rating-input-3_" + window.appendedReviews + "' disabled " + (review.Rating == 2 ? "checked" : "") + ">" +
                "<label for='rating-input-1-2' class='rating-star'></label>" +
                "<input type='radio' class='rating-input-static' value='1' name='rating-input-3_" + window.appendedReviews + "' disabled " + (review.Rating == 1 ? "checked" : "") + ">" +
                "<label for='rating-input-1-1' class='rating-star'></label>" +
            "</div>";
        <% } %>
        
        var reviewContent =
            "<div class='col-xs-12 no-padding review-container' data-review-id='" + review.ReviewID + "' style='margin-bottom:10px;'>" +
                "<div class='col-xs-12 no-padding'>" +
                    "<a href='viewprofile.aspx?id=" + review.Author.UserID + "' target='_blank' class='pull-left margin-r-5 no-padding col-sm-1 col-xs-2' style='padding-top:5px!important'>" +
                        "<img src='" + review.Author.Avatar + "' alt='" + review.Author.FullName + "' class='img-circle img-responsive' />" +
                    "</a>" +
                    "<div class='btn-group-vertical pull-right' style='margin-left:3px;'>" +
                        "<button type='button' class='btn btn-xs btn-success helpful-vote' data-vote-type='0' onclick='helpfulVoteClick(" + review.ReviewID + ",this)' data-toggle='tooltip' data-original-title='Helpful'>" +
                            "<span class='vote-count'>" + review.UpVotes + "</span> <i class='fa fa-thumbs-up'></i>" +
                        "</button>" +
                        "<button type='button' class='btn btn-xs btn-danger helpful-vote' data-vote-type='1' onclick='helpfulVoteClick(" + review.ReviewID + ",this)' data-toggle='tooltip' data-original-title='Not Helpful'>" +
                            "<span class='vote-count'>" + review.DownVotes + "</span> <i class='fa fa-thumbs-down'></i>" +
                        "</button>" +
                    "</div>" +
                    (starHtml.length > 0 ? starHtml + "<br />" : "") +
                    "<strong style='margin-bottom:3px;'>" + review.Title + "</strong><br />" +
                    "<div>" + review.Comment + "</div>" +
                "</div>" +
                "<div class='col-xs-12 valign no-padding carousel-images-panel' style='overflow-x:auto;'>" + reviewImages + "</div>" +
            "</div>";
        if (append) {
            $("#pnlViewReviews").append(reviewContent);
        } else {
            $("#pnlViewReviews").prepend(reviewContent);
        }
        window.appendedReviews++;
    }

    function clearReview(skipValidation) {
        if (!skipValidation) {
            if ($("#txtReviewTitle").val().length > 0 ||
                $("input[name='rating-input-1']:checked").length > 0 ||
                stripTags($("#txtReviewComments").siblings(".wysihtml5-sandbox").contents().find("body").html()).length > 0 ||
                $("#pnlAddReviewImages img").length > 0) {
                if (!confirm("Are you sure you want cancel your review? Content will be lost!")) {
                    return false;
                }
            }
        }
        $("#txtReviewTitle").val("");
        $("input[name='rating-input-1']:checked").prop("checked", false);
        $("#txtReviewComments").siblings(".wysihtml5-sandbox").contents().find("body").html("");
        $("#pnlAddReviewImages .images-preview").html("");
        if (typeof (window.uploadsCompleted) !== "undefined") {
            window.uploadsCompleted[$("#pnlAddReviewImages .images-preview").data("index")] = 0;
        }
        $("#frmAddReview").hide();
        $("#btnAddReview").show();
        return true;
    }

    function helpfulVoteClick(reviewId, button) {
        var voteType = $(button).attr("data-vote-type");
        var voteCount = $(button).find(".vote-count");
        var data = {
            reviewId: reviewId,
            voteType: voteType
        };
        callBack("master.asmx/AddVote", data, function (msg) {
            if (msg.d == true) {
                voteCount.text(parseInt(voteCount.text()) + 1);
            } else if (msg.d == false) {
                showWarning("Already Voted");
            } else if (msg.d == null) {
                showWarning("Must be Logged in to Vote");
            } else {
                showWarning("Failed to Add Vote (Tech Support Notified)");
            }
        });
    }

    $('#modalShowReviews').on('hide.bs.modal', function () {
        if (!clearReview()) {
            $("#modalShowReviews").data("bs.modal").isShown = false;
            setTimeout(function () { $("#modalShowReviews").data("bs.modal").isShown = true; }, 100);
        }
    });

</script>
