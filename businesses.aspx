<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="businesses.aspx.cs" Inherits="businesses" %>
<%@ Register TagPrefix="hwa" TagName="WYSIHTML5" Src="~/controls/WYSIHTML5.ascx" %>
<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>
<%@ Register TagPrefix="kl" TagName="UserReviews" Src="~/controls/UserComments.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div id="pnlPageTitle" class="box-body" runat="server"></div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="controltower.aspx"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li id="pnlPageBreadcrumbSource" runat="server"><a href="businesses.aspx?view=all">Businesses</a></li>
            <li id="pnlPageBreadcrumb" class="active" runat="server"></li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-xs-12 margin-bottom">
                <button type="button" id="btnNewBusiness" class="btn btn-success btn-sm">Submit a Business</button>
            </div>
            <div class="col-lg-4 col-xs-12 pull-right">
                <div id="businessFilters" class="box box-success" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <span class="head">Filter</span> <small>Businesses</small>
                        </h3>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                            <button type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                                <i class="fa fa-times"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="form-group">
                            <div class="col-lg-12 col-md-8 col-sm-12" style="margin-top: 5px;">
                                <label class="col-xs-12 control-label">Sort By</label>
                                <div class="col-lg-12 col-sm-6">
                                    <select id="ddlBusinessPrimarySort" class="form-control">
                                        <option value="null" selected>Primary Sort...</option>
                                        <option value="costUp">Cost (Low > High)</option>
                                        <option value="costDown">Cost (High > Low)</option>
                                        <option value="rating">Rating</option>
                                        <option value="value">Value</option>
                                        <option value="service">Service</option>
                                        <option value="atmosphere">Atmosphere</option>
                                        <option value="rating">Rating</option>
                                        <option value="distance">Distance</option>
                                    </select>
                                </div>
                                <div class="col-lg-12 col-sm-6">
                                    <select id="ddlBusinessSecondarySort" class="form-control">
                                        <option value="null" selected>Secondary Sort...</option>
                                        <option value="costUp">Cost (Low > High)</option>
                                        <option value="costDown">Cost (High > Low)</option>
                                        <option value="rating">Rating</option>
                                        <option value="value">Value</option>
                                        <option value="service">Service</option>
                                        <option value="atmosphere">Atmosphere</option>
                                        <option value="rating">Rating</option>
                                        <option value="distance">Distance</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6 col-sm-4 col-xs-6" style="margin-top: 5px;">
                                <label for="rating-input-3-1" class="col-xs-12 no-pad-right control-label">Min. Rating</label>
                                <div id='lblFilterBusinessReviews' class='col-xs-12 no-pad-right rating' style="margin: 7px auto; width: auto;">
                                    <input type='radio' class='rating-input' value='5' id='rating-input-3-5' name='rating-input-3'>
                                    <label for='rating-input-3-5' class='rating-star'></label>
                                    <input type='radio' class='rating-input' value='4' id='rating-input-3-4' name='rating-input-3'>
                                    <label for='rating-input-3-4' class='rating-star'></label>
                                    <input type='radio' class='rating-input' value='3' id='rating-input-3-3' name='rating-input-3'>
                                    <label for='rating-input-3-3' class='rating-star'></label>
                                    <input type='radio' class='rating-input' value='2' id='rating-input-3-2' name='rating-input-3'>
                                    <label for='rating-input-3-2' class='rating-star'></label>
                                    <input type='radio' class='rating-input' value='1' id='rating-input-3-1' name='rating-input-3'>
                                    <label for='rating-input-3-1' class='rating-star'></label>
                                </div>
                            </div>
                            <div class="col-lg-6 col-sm-4 col-xs-6" style="margin-top: 5px;">
                                <label for="txtMaximumDistance" class="col-xs-12 no-pad-right control-label">Max Distance</label>
                                <div class="col-xs-12">
                                    <input id="txtMaximumDistance" type="number" class="form-control" min="0" max="100" value="0" />
                                </div>
                            </div>
                            <div class="col-lg-12 col-sm-4 col-xs-12 text-center" style="margin-top: 5px;">
                                <label for="txtNumOfBusinesses" class="col-xs-12 control-label"># of Businesses</label>
                                <input id="txtNumOfBusinesses" type="number" class="form-control" min="1" max="30" value="10" style="width: 55px; margin: 0 auto;" />
                            </div>
                            <div class="col-lg-12">
                                <label class="col-xs-12 text-center control-label" style="margin-top: 5px;">Tags:</label>
                                <div class="col-xs-12 text-center">
                                    <asp:PlaceHolder ID="phTags" runat="server"></asp:PlaceHolder>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="form-group">
                            </div>
                        </div>
                    </div>
                    <div class="box-footer with-border text-right">
                        <button id="btnFilterBusinesses" type="button" class="btn btn-success btn-sm">Filter</button>
                        <button id="btnFilterBusinessesClear" type="button" class="btn btn-warning btn-sm">Clear</button>
                    </div>
                </div>
            </div>
            <div id="pnlBusinesses" class='col-lg-8 col-xs-12' runat="server">
            </div>
        </div>
    </section>
    <!-- Create Business Modal -->
    <div class="modal fade in" id="modalCreateBusiness" data-edit_business_id="null">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">Add a Business</h4>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <div class="col-sm-12 no-padding">
                                <div id="lblBusinessError" class="control-label text-red text-bold collapse" style="text-align: left!important;">&nbsp;<i class="fa fa-times-circle-o"></i><span id="lblBusinessErrorText"></span></div>
                                <div class="col-sm-6">
                                    <select id="ddlBusinessType" class="form-control" tabindex="100" runat="server">
                                        <option value="-1" selected disabled>Business Type</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <h3>English</h3>
                                <label for="txtBusinessNameEnglish" class="col-sm-3 control-label">Name</label>
                                <div id="txtBusinessNameEnglishAutosuggestContainer" class="col-sm-9">
                                    <input id="txtBusinessNameEnglish" type="text" class="form-control" tabindex="102" />
                                </div>
                                <label for="txtBusinessAddressEnglish" class="col-sm-3 control-label">Address</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessAddressEnglish" type="text" class="form-control" tabindex="103" />
                                </div>
                                <label for="txtBusinessCityEnglish" class="col-sm-3 control-label">City</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessCityEnglish" type="text" class="form-control" value="Kunming" />
                                </div>
                                <label for="txtBusinessProvincecEnglish" class="col-sm-3 control-label">Province</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessProvinceEnglish" type="text" class="form-control" value="Yunnan" />
                                </div>
                                <label for="txtBusinessCountryEnglish" class="col-sm-3 control-label">Country</label>
                                <div class="col-sm-6">
                                    <input id="txtBusinessCountryEnglish" type="text" class="form-control" value="CN" />
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <h3>Chinese</h3>
                                <label for="txtBusinessNameChinese" class="col-sm-3 control-label">Name</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessNameChinese" type="text" class="form-control" tabindex="104" />
                                </div>
                                <label for="txtBusinessAddressChinese" class="col-sm-3 control-label">Address</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessAddressChinese" type="text" class="form-control" tabindex="105" />
                                </div>
                                <label for="txtBusinessCityChinese" class="col-sm-3 control-label">City</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessCityChinese" type="text" class="form-control" value="昆明市" />
                                </div>
                                <label for="txtBusinessProvinceChinese" class="col-sm-3 control-label">Province</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessProvinceChinese" type="text" class="form-control" value="云南省" />
                                </div>
                                <label for="txtBusinessCountryChinese" class="col-sm-3 control-label">Country</label>
                                <div class="col-sm-6">
                                    <input id="txtBusinessCountryChinese" type="text" class="form-control" value="中国" />
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="txtBusinessPostalCode" class="col-sm-3 control-label" style="margin-bottom: 15px;">Postal</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessPostalCode" type="text" class="form-control" tabindex="106" />
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="txtBusinessPhoneNumber" class="col-sm-3 control-label" style="margin-bottom: 15px;">Phone</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessPhoneNumber" type="text" class="form-control" tabindex="107" />
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="txtBusinessWebsite" class="col-sm-3 control-label" style="margin-bottom: 15px;">Website</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessWebsite" type="text" class="form-control" tabindex="108" />
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="ddlBusinessTodoType" class="col-sm-3 control-label" style="margin-bottom: 15px;">Type</label>
                                <div class="col-sm-9">
                                    <select id="ddlBusinessTodoType" class="form-control" tabindex="109" runat="server">
                                        <option value="-1" selected disabled>Todo Type</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <label for="txtBusinessCost" class="col-sm-3 control-label">Cost</label>
                                <div class="col-sm-3">
                                    <input id="txtBusinessCost" type="text" value="0" max="5" class="form-control text-center" tabindex="110" />
                                </div>
                                <label for="txtBusinessValue" class="col-sm-3 control-label">Value</label>
                                <div class="col-sm-3">
                                    <input id="txtBusinessValue" type="text" value="0" max="5" class="form-control text-center" tabindex="111" />
                                </div>
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <label for="txtBusinessService" class="col-sm-3 control-label">Service</label>
                                <div class="col-sm-3">
                                    <input id="txtBusinessService" type="text" value="0" max="5" class="form-control text-center" tabindex="112" />
                                </div>
                                <label for="txtBusinessAtmosphere" class="col-sm-3 control-label" style="padding-left: 0;">Atmosphere</label>
                                <div class="col-sm-3">
                                    <input id="txtBusinessAtmosphere" type="text" value="0" max="5" class="form-control text-center" tabindex="113" />
                                </div>
                            </div>
                            <div class="col-sm-12" style="margin-bottom: 10px;">
                                <label for="txtBusinessTags" class="col-xs-12 control-label" style="text-align: left!important;">Tags</label>
                                <div class="col-xs-12">
                                    <input id="txtBusinessTags" type="text" tabindex="116" />
                                </div>
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <label for="txtBusinessCoordinates" class="col-sm-3 control-label">Coords</label>
                                <div class="col-sm-9">
                                    <input id="txtBusinessCoordinates" type="text" class="form-control" tabindex="114" />
                                </div>
                            </div>
                            <div class="col-xs-12">
                                <hwa:WYSIHTML5 id="wysihtml5AdminBusiness" toolbarid="adminBusinessToolbar" textareaid="adminBusinessTextarea" togglehtml="true" runat="server" />
                            </div>
                            <div id="pnlBusinessSubImagesPreview" class="col-sm-12">
                                <hwa:ImageUploads id="adminBusinessImageUploads" LimitImages="false" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelBusiness" type="button" class="btn btn-default pull-left" data-dismiss="modal" tabindex="118">Cancel</button>
                    <button id="btnSubmitBusiness" type="button" class="btn btn-primary" tabindex="119">Post</button>
                </div>
            </div>
            <div class="overlay hidden">
                <i class="fa fa-refresh fa-spin"></i>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- Show Reviews Modal -->
    <div class="modal fade in" id="modalShowReviews">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">User Reviews</h4>
                </div>
                <div class="modal-body">
                    <kl:UserReviews ID="businessReviews" runat="server" TableName="businesses" Rating="true" Multiple="false" />
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnDismissReviews" type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <asp:HiddenField ID="hiddenBusinessCoordinates" runat="server" />
    <asp:HiddenField ID="hiddenBusinessType" runat="server" />
    <asp:HiddenField ID="hiddenViewParam" runat="server" />
    <asp:HiddenField ID="hiddenIDParam" runat="server" />
    <asp:HiddenField ID="hiddenEditParam" runat="server" />
    <asp:HiddenField ID="hiddenActionParam" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <!--<script async defer src="https://maps.google.cn/maps/api/js?key=AIzaSyDFhRGAt2Ubos4raAoylqlE_dtKVcJI8po"></script>-->
    <script src="https://www.kunminglive.com/dist/js/businesses.js"></script>
    <script src="https://cn.bing.com/api/maps/mapcontrol?key=As6ALo25XEgbL0EeIlPFvq4nLO0LA5eqjCWsMQylJcP-t4T11VcuxPCEhzmlzNgQ" async defer></script>
    <script src="https://api.map.baidu.com/api?v=2.0&ak=m7OK1L2RzghywRt1cQT1WtS67ph0YwlB"></script>
</asp:Content>