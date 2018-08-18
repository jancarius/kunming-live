<%@ Control Language="C#" ClassName="UploadImages" %>

<script runat="server">
    private bool multipleImages = true;
    private string autoSavePath = null;
    private bool limitImages = true;

    protected void Page_Load(object sender, EventArgs e)
    {
        hiddenProvidePath.Value = AutoSavePath;
        hiddenLimitImages.Value = LimitImages.ToString();
    }

    public bool MultipleImages { get { return multipleImages; } set { multipleImages = value; } }
    public string AutoSavePath { get { return autoSavePath; } set { autoSavePath = value; } }
    public bool LimitImages { get { return limitImages; } set { limitImages = value; } }
</script>

<label class="col-xs-12 no-padding">Add Photos</label>
<div class="pull-left">
    <label class="file-upload add-photo" style="margin: 0 15px 0 0;">
        <i class="fa fa-image"></i>
        <input id="fileImages" type="file" accept="image/*" class="form-control hidden file-images" <%: (MultipleImages ? "multiple" : "") %> />
    </label>
</div>
<div id="imagesPreview" class="images-preview"></div>
<asp:HiddenField ID="hiddenProvidePath" runat="server" />
<asp:HiddenField ID="hiddenLimitImages" runat="server" />
<script>
    if (typeof (window.activeUploads) == "undefined") {
        window.activeUploads = 0;
    } else {
        window.activeUploads++;
    }
    $("#hiddenProvidePath").data("index", window.activeUploads);
    $("#hiddenLimitImages").data("index", window.activeUploads);
    $("#hiddenProvidePath").attr("id", "hiddenProvidePath_" + window.activeUploads);
    $("#hiddenLimitImages").attr("id", "hiddenLimitImages_" + window.activeUploads);
    $("#fileImages").data("index", window.activeUploads);
    $("#fileImages").attr("id", "fileImages_" + window.activeUploads);
    $("#imagesPreview").data("index", window.activeUploads);
    $("#imagesPreview").attr("id", "imagesPreview_" + window.activeUploads);

    $("#fileImages_" + window.activeUploads).on("change", function (e) {
        var thisIndex = $(this).data("index");
        if (typeof (window.uploadsCompleted) == "undefined") {
            window.uploadsCompleted = [];
        }
        if (typeof (window.uploadsCompleted[thisIndex]) == "undefined") {
            window.uploadsCompleted[thisIndex] = 0;
        }
        if (window.uploadsCompleted[thisIndex] > 0) {
            if (!$(this)[0].hasAttribute("multiple")) {
                showWarning("Can Only Insert One Image at a Time")
                return;
            }
        }
        if (typeof (window.imageUploads) == "undefined") {
            window.imageUploads = [];
        }
        window.imageUploads[thisIndex] = 0;
        if (typeof (window.uploadsCount) == "undefined") {
            window.uploadsCount = [];
        }

        var providePath = $("#hiddenProvidePath_" + thisIndex).val();

        window.uploadsCount[thisIndex] = this.files.length + $("#imagesPreview_" + thisIndex).children().length;
        readFile(this.files[window.imageUploads[thisIndex]], processImageUpload, true, thisIndex, providePath);
    });

    $(window).on("load", function () {
        if (typeof (window.processImageUpload) == "undefined") {
            window.processImageUpload = function (imgFile, containerIndex) {
                var providePath = $("#hiddenProvidePath_" + containerIndex).val();
                var limitImages = $("#hiddenLimitImages_" + containerIndex).val() == "True";
                if (window.uploadsCompleted[containerIndex] == 9 && limitImages && providePath != null) {
                    $(".loading-overlay").hide();
                    showWarning("Maximum of 9 Images Allowed");
                    window.uploadsCount[containerIndex] = $("#imagesPreview_" + containerIndex).children().length;
                    return;
                }
                var inputValue;
                if (providePath == "") {
                    inputValue = (window.uploadsCompleted[containerIndex] == 0 ? "Main" : window.uploadsCompleted[containerIndex])
                } else {
                    inputValue = imgFile.replace("_thumb", "");
                }
                $("#imagesPreview_" + containerIndex).append(
                    "<div class='text-center image-preview pull-left' style='width:135px;margin:0px auto 5px auto;'>" +
                        "<img src='" + imgFile + "' class='draggable img-responsive image-upload' style='margin:0 auto;max-height:75px;' />" +
                        "<div class='input-group input-group-sm' style='margin:0 auto;width:114px;'>" +
                            "<span class='input-group-addon bg-primary clickable" + (providePath ? " hidden" : "") + "' onclick='makeMainImage(this," + containerIndex + ")' data-toggle='tooltip' data-original-title='Main Image'><i class='fa fa-home'></i></span>" +
                            "<input class='text-center form-control image-sort' type='text' value='" + inputValue + "' disabled />" +
                            "<span class='input-group-addon bg-red clickable" + (providePath ? " hidden" : "") + "' onclick='removePreviewImage(this," + containerIndex + ")' data-toggle='tooltip' data-original-title='Delete Image'><i class='fa fa-times'></i></span>" +
                        "</div>" +
                    "</div>"
                );
                window.uploadsCompleted[containerIndex]++;
                window.imageUploads[containerIndex]++;
                if (window.uploadsCompleted[containerIndex] !== window.uploadsCount[containerIndex]) {
                    var fileData = $("#fileImages_" + containerIndex)[0].files[window.imageUploads[containerIndex]];
                    readFile(fileData, processImageUpload, true, containerIndex, providePath);
                } else {
                    $(".loading-overlay").hide();
                }
            }
        }

        $(".images-preview").sortable({
            tolerance: "touch",
            stop: function () {
                var sortCount = 1;
                $(this).find(".image-sort").each(function (index) {
                    if (index == 0) {
                        $(this).val("Main");
                    } else {
                        $(this).val(sortCount);
                        sortCount++;
                    }
                });
            }
        });
    });

    function removePreviewImage(button, uploadsIndex) {
        var thisIndex = $(button);
        $(button).closest(".image-preview").remove();
        window.uploadsCompleted[uploadsIndex]--;
        window.uploadsCount[uploadsIndex]--;
        var sortCount = 1;
        $("#imagesPreview_" + uploadsIndex + " .image-sort").each(function (index) {
            if (index == 0) {
                $(this).val("Main");
            } else {
                $(this).val(sortCount);
                sortCount++;
            }
        });
    }

    function makeMainImage(button, uploadsIndex) {
        $(button).siblings(".image-sort").val("Main");
        $(button).closest(".image-preview").prependTo($(button).closest(".images-preview"))
        var sortCount = 1;
        $("#imagesPreview_" + uploadsIndex + " .image-sort").each(function (index) {
            if (index > 0) {
                $(this).val(sortCount);
                sortCount++;
            }
        });
    }


</script>
