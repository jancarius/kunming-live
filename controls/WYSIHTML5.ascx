<%@ Control Language="C#" ClassName="WYSIHTML5" %>
<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>

<script runat="server">
    private string toolbarId = string.Empty;
    private string textareaId = string.Empty;
    private bool toggleHtml = false;
    private int tabIndex = -1;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar.ID = ToolbarID;
        textarea.ID = TextareaID;
        if (!ToggleHTML)
        {
            wysihtml5ChangeView.Visible = false;
            wysihtml5InsertPreview.Visible = false;
            wysihtml5InsertShort.Visible = false;
            modalInsertImage.Visible = false;
        }
        else
        {
            wysihtml5ChangeView.ID = "changeView_" + TextareaID;
            wysihtml5InsertPreview.ID = "previewContent_" + TextareaID;
            wysihtml5InsertShort.ID = "shortContent_" + TextareaID;
            modalInsertImage.ID = "insertImage_" + TextareaID;
        }
    }

    public string ToolbarID { get { return toolbarId; } set { toolbarId = value; } }
    public string TextareaID { get { return textareaId; } set { textareaId = value; } }
    public bool ToggleHTML { get { return toggleHtml; } set { toggleHtml = value; } }
    public int TabIndex { get { return tabIndex; } set { tabIndex = value; } }
</script>

<div id="toolbar" style="display: none;padding-bottom:3px;" runat="server">
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="bold"><i class="fa fa-bold"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="italic"><i class="fa fa-italic"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="underline"><i class="fa fa-underline"></i></button>

    <div class="dropdown toolbar-menu">
        <button type="button" class="btn btn-sm btn-default dropdown-toggle wysihtml5-dropdown" data-toggle="dropdown"><i class="fa fa-font"></i></button>
        <ul class="dropdown-menu">
            <li><a data-wysihtml5-command="fontSize" data-wysihtml5-command-value="x-small"><span class="wysiwyg-font-size-x-small">X-Small</span></a></li>
            <li><a data-wysihtml5-command="fontSize" data-wysihtml5-command-value="small"><span class="wysiwyg-font-size-small">Small</span></a></li>
            <li><a data-wysihtml5-command="fontSize" data-wysihtml5-command-value="medium"><span class="wysiwyg-font-size-medium">Medium</span></a></li>
            <li><a data-wysihtml5-command="fontSize" data-wysihtml5-command-value="large"><span class="wysiwyg-font-size-large">Large</span></a></li>
            <li><a data-wysihtml5-command="fontSize" data-wysihtml5-command-value="x-large"><span class="wysiwyg-font-size-x-large">X-Large</span></a></li>
        </ul>
    </div>

    <div class="dropdown toolbar-menu">
        <button type="button" class="btn btn-sm btn-default dropdown-toggle wysihtml5-dropdown" data-toggle="dropdown"><i class="fa fa-square wysiwyg-color-black"></i></button>
        <ul class="dropdown-menu toolbar-font-color">
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="blue"><i class="fa fa-square wysiwyg-color-blue"></i>Blue</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="aqua"><i class="fa fa-square wysiwyg-color-aqua"></i>Aqua</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="teal"><i class="fa fa-square wysiwyg-color-teal"></i>Teal</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="green"><i class="fa fa-square wysiwyg-color-green"></i>Green</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="yellow"><i class="fa fa-square wysiwyg-color-yellow"></i>Yellow</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="red"><i class="fa fa-square wysiwyg-color-red"></i>Red</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="gray"><i class="fa fa-square wysiwyg-color-gray"></i>Gray</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="navy"><i class="fa fa-square wysiwyg-color-navy"></i>Navy</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="purple"><i class="fa fa-square wysiwyg-color-purple"></i>Purple</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="orange"><i class="fa fa-square wysiwyg-color-orange"></i>Orange</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="maroon"><i class="fa fa-square wysiwyg-color-maroon"></i>Maroon</a></li>
            <li><a data-wysihtml5-command="foreColor" data-wysihtml5-command-value="black"><i class="fa fa-square wysiwyg-color-black"></i>Black</a></li>
        </ul>
    </div>

    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="insertOrderedList"><i class="fa fa-list-ol"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="insertUnorderedList"><i class="fa fa-list-ul"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="justifyLeft"><i class="fa fa-align-left"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="justifyCenter"><i class="fa fa-align-center"></i></button>
    <button type="button" class="btn btn-sm btn-default" data-wysihtml5-command="justifyRight"><i class="fa fa-align-right"></i></button>
    <button id="wysihtml5ChangeView" type="button" class="btn btn-sm btn-default" data-wysihtml5-action="change_view" runat="server"><i class="fa fa-code"></i></button>
    <button type="button" class="btn btn-sm btn-default wysihtml-insert-image"><i class="fa fa-image"></i></button>
    <div id="modalInsertImage" runat="server" class="box box-success box-shadow insert-image-content" style="display:none;position:absolute;z-index:500;">
        <div class="box-header">
            <h4 class="box-title">Insert Image</h4>
        </div>
        <div class="box-body no-padding">
            <div class="form-group col-xs-12">
                <label>Image URL</label>
                <input type="text" class="form-control insert-image-url" />
            </div>
            <div class="form-group col-sm-3 col-xs-6">
                <label>Alt Text</label>
                <input type="text" class="form-control insert-image-alt" />
            </div>
            <div class="form-group col-sm-3 col-xs-6">
                <label>Alignment</label>
                <select class="form-control insert-image-align">
                    <option value="" selected>Default</option>
                    <option value="wysiwyg-float-left">Left</option>
                    <option value="wysiwyg-float-right">Right</option>
                </select>
            </div>
            <div class="form-group col-sm-3 col-xs-6">
                <label>Width</label>
                <input type="text" class="form-control insert-image-width" />
            </div>
            <div class="form-group col-sm-3 col-xs-6">
                <label>Height</label>
                <input type="text" class="form-control insert-image-height" />
            </div>
            <div class="clearfix"></div>
        </div>
        <div class="box-footer">
            <button type="button" class="btn btn-default btn-insert-image-cancel">Cancel</button>
            <button type="button" class="btn btn-success pull-right btn-insert-image">Submit</button>
        </div>
    </div>
    <button id="wysihtml5InsertPreview" type="button" class="btn btn-sm btn-default" data-wysihtml5-command="insertHTML" data-wysihtml5-command-value="//previewContent\\" runat="server"><i class="fa fa-quote-left"></i></button>
    <button id="wysihtml5InsertShort" type="button" class="btn btn-sm btn-default" data-wysihtml5-command="insertHTML" data-wysihtml5-command-value="//shortContent\\" runat="server"><i class="fa fa-quote-right"></i></button>
</div>
<textarea id="textarea" rows="10" cols="20" class="form-control" runat="server" tabindex="<%:TabIndex%>"></textarea>
Character Count: <span class="character-count">0</span>
<script>
    $(window).on("load", function () {
        if (typeof(editor) == "undefined") {
            editor = [];
        }
        window.editor["<%:TextareaID%>"] = new wysihtml5.Editor("<%:TextareaID%>", {
            toolbar: "<%:ToolbarID%>",
            parserRules: wysihtml5ParserRules,
            useLineBreaks: false
        });

        $("#<%:TextareaID%>").data("wysihtml5", editor);

        editor["<%:TextareaID%>"].on("load", function () {
            var doc = $("#<%:TextareaID%>").siblings(".wysihtml5-sandbox").contents()[0];
            $(doc).find('body').on("keyup", function () {
                var charCount = $(this).text().replace("//shortContent\\", "").replace("//previewContent\\").length;
                $("#<%:TextareaID%>").siblings(".character-count").text(charCount);
                $("#<%:TextareaID%>").data("character_count", charCount)
            });
            if (!editor["<%:TextareaID%>"].isCompatible()) {
                return;
            }
            var link = doc.createElement("link");
            link.href = "https://www.kunminglive.com/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.css";
            link.rel = "stylesheet";
            doc.querySelector("head").appendChild(link);
        });

        $(".wysihtml5-dropdown").off("click").on("click", function (e) {
            $(this).closest(".dropdown").siblings().removeClass("open");
            $(this).closest(".dropdown").toggleClass("open");
            e.stopPropagation()
        });
        $(".toolbar-menu").off("mouseleave").on("mouseleave", function (e) {
            $(this).closest(".dropdown").removeClass("open");
            e.stopPropagation()
        });
        $(".toolbar-menu .toolbar-font-color li").off("click").on("click", function () {
            $(this).closest(".dropdown").find(".wysihtml5-dropdown i").attr("class", $(this).find("i").attr("class"));
            e.stopPropagation()
        });
        $(".wysihtml-insert-image").off("click").on("click", function () {
            $("#insertImage_<%:TextareaID%>").slideDown("slow", function () {
                $(this).find(".insert-image-url").focus();
            });
        });
        $(".btn-insert-image-cancel").off("click").on("click", function () {
            $(this).closest(".insert-image-content").slideUp("slow", clearInsertImageForm);
        });

        $("#wysihtml5ImagePanel<%:TextareaID%>").bind("DOMSubtreeModified",function(){
            $("#txtInsertImage<%:TextareaID%>").val($(this).find("img").attr("src"));
        });
        $(".btn-insert-image").off("click").on("click", function () {
            var $modal = $(this).closest(".insert-image-content");
            var url = $modal.find(".insert-image-url").val();
            var alt = $modal.find(".insert-image-alt").val();
            var align = $modal.find(".insert-image-align").val();
            var w = parseInt($modal.find(".insert-image-width").val());
            var h = parseInt($modal.find(".insert-image-height").val());
            
            if (url.Length == 0) {
                return false;
            }
            $("#<%:TextareaID%>").siblings(".wysihtml5-sandbox").contents().find("body").append(
                '<img src="' + url + '" alt="' + alt + '" class="wysiwyg-responsive ' + align + '" ' + (w > 0 ? 'width="' + w + '"' : '') + ' ' + (h > 0 ? 'height="' + h + '"' : '') + ' />'
            );

            $modal.slideUp("slow", clearInsertImageForm);
        });
        function clearInsertImageForm() {
            var $modal = $(this).closest(".modal");
            $modal.find(".insert-image-url").val("");
            $modal.find(".insert-image-alt option[value='']").prop("selected", true);
            $modal.find(".insert-image-align").val("");
            $modal.find(".insert-image-width").val("");
            $modal.find(".insert-image-height").val("");
        };

        $("#btnInsertImageSubmit<%:TextareaID%>").click(function () {
            var txtInsertImage = $("#txtInsertImage<%:TextareaID%>");
            var data = {
                tempImagePath: txtInsertImage.val(),
                directory: "dist/img/events"
            }
            txtInsertImage.val(txtInsertImage.val().replace("dist/img/tmp", "dist/img/events"));

            callBack("master.asmx/MoveTempImage", data);

            setTimeout(function () {
                $("#wysihtml5ImagePanel<%:TextareaID%> .images-preview").html("");
                txtInsertImage.val("http://");
                $("#ddlInsertImageAlign<%:TextareaID%> [value='']").prop("selected", true);
                $("#txtInsertImageWidth<%:TextareaID%>").val("auto");
                $("#txtInsertImageHeight<%:TextareaID%>").val("auto");
            }, 100);
        });
        $("#btnInsertImageCancel<%:TextareaID%>").click(function () {
            setTimeout(function () {
                $("#wysihtml5ImagePanel<%:TextareaID%> .images-preview").html("");
                $("#txtInsertImage<%:TextareaID%>").val("http://");
                $("#ddlInsertImageAlign<%:TextareaID%> [value='']").prop("selected", true);
                $("#txtInsertImageWidth<%:TextareaID%>").val("auto");
                $("#txtInsertImageHeight<%:TextareaID%>").val("auto");
            }, 100);
        });
    });
</script>
