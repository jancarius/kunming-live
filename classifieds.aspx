<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="classifieds.aspx.cs" Inherits="classifieds" %>
<%@ MasterType VirtualPath="~/admin.master" %>
<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>
<%@ Register TagPrefix="hwa" TagName="WYSIHTML5" Src="~/controls/WYSIHTML5.ascx" %>

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
            <li id="pnlPageBreadcrumbSource" runat="server"><a href="classifieds.aspx?view=all">Classifieds</a></li>
            <li id="pnlPageBreadcrumb" class="active" runat="server"></li>
        </ol>
    </section>

    <section class="content">
        <div id="pnlClassifieds" class="row" runat="server">
            <div class="col-xs-12">
                <button id="btnPostClassified" type="button" class="btn btn-success margin" style="margin-top: 0;">Post a Classified Ad</button>
            </div>
            <div class="col-xs-12">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <span class="head">Filter</span>
                            <small>Classifieds</small>
                        </h3>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                            <button id="btnCloseBusinessDetails" type="button" class="btn btn-default btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                                <i class="fa fa-times"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                    </div>
                    <div class="box-footer with-border text-right">
                        <button id="btnFilterBusinesses" type="button" class="btn btn-success btn-sm">Filter</button>
                        <button id="btnFilterBusinessesClear" type="button" class="btn btn-warning btn-sm">Clear</button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Create Classified Ad Modal -->
    <div class="modal fade in" id="modalCreateClassifiedAd" data-edit_classified_id="null">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">Submit a Classified Ad</h4>
                </div>
                <div class="modal-body">
                    <div class="col-xs-12 no-padding">
                        <div id="pnlAddClassifiedAlert" class="alert alert-info alert-dismissable" runat="server">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true"><i class="fa fa-times"></i></button>
                            <h4><i class="icon fa fa-info"></i>Editing / Approval</h4>
                            Submitted Classified Ads are subject to approval. Content will NOT be edited, but content that is deemed inappropriate may result in your event being denied.
                            You will be notified of approval/denial within a few hours. Examples of content that may result in denial include, but are not limited to:
                            inappropriate language, inappropriate imagery, and/or sensitive content.
                        </div>
                    </div>
                    <div class="col-xs-12 no-padding">
                        <div id="lblClassifiedError" class="control-label text-red text-bold collapse"><i class="fa fa-times-circle-o"></i><span id="lblClassifiedErrorText"></span></div>
                    </div>
                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="ddlClassifiedType" class="col-xs-12 no-padding control-label">Ad Type</label>
                        <div class="col-xs-12 no-pad-left">
                            <select id="ddlClassifiedType" class="form-control" runat="server" tabindex="500">
                                <option value="" selected disabled>Ad Type...</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="ddlClassifiedSubType" class="col-xs-12 no-padding control-label">Sub Type</label>
                        <div class="col-xs-12 no-pad-left">
                            <select id="ddlClassifiedSubType" class="select-classified-sub-type form-control">
                                <option value="" selected disabled>Select Ad Type...</option>
                            </select>
                            <select id="ddlClassifiedEmployment" class="select-classified-sub-type form-control hidden" runat="server" tabindex="501">
                                <option value="" selected disabled>Sub Type...</option>
                            </select>
                            <select id="ddlClassifiedMarketplace" class="select-classified-sub-type form-control hidden" runat="server" tabindex="501">
                                <option value="" selected disabled>Sub Type...</option>
                            </select>
                            <select id="ddlClassifiedHousing" class="select-classified-sub-type form-control hidden" runat="server" tabindex="501">
                                <option value="" selected disabled>Sub Type...</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="txtClassifiedLocation" class="col-xs-12 no-padding control-label">Postal Code</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtClassifiedLocation" type="text" class="form-control" placeholder="Postal Code..." tabindex="502" />
                        </div>
                    </div>
                    <div id="classifiedEmploymentInput" class="select-classified-input hidden">
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedCompensation" class="col-xs-12 no-padding control-label">Compensation (元)</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedCompensation" class="form-control" type="text" placeholder="Compensation..." tabindex="503" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="ddlClassifiedTerm" class="col-xs-12 no-padding control-label">Term</label>
                            <div class="col-xs-12 no-pad-left">
                                <select id="ddlClassifiedTerm" class="form-control" tabindex="504">
                                    <option value="" selected disabled>Term...</option>
                                    <option value="Full Time">Full Time</option>
                                    <option value="Part Time">Part Time</option>
                                    <option value="Short Term">Short Term</option>
                                    <option value="Optional">Optional</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding icheck" style="padding-top: 28px !important;">
                            <label for="chkClassifiedInternship" class="col-xs-12 no-padding">
                                <input id="chkClassifiedInternship" type="checkbox" tabindex="505" />&nbsp;Internship
                            </label>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding icheck" style="padding-top: 28px !important;">
                            <label for="chkClassifiedTelecommuting" class="col-xs-12 no-padding">
                                <input id="chkClassifiedTelecommuting" type="checkbox" tabindex="506" />&nbsp;Telecommuting
                            </label>
                        </div>
                    </div>
                    <div id="classifiedMarketplaceInput" class="select-classified-input hidden">
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedPrice" class="col-xs-12 no-padding control-label">Price (元)</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedPrice" class="form-control" type="number" min="0" max="10000" value="0" tabindex="503" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="ddlClassifiedCondition" class="col-xs-12 no-padding control-label">Condition</label>
                            <div class="col-xs-12 no-pad-left">
                                <select id="ddlClassifiedCondition" class="form-control" tabindex="504">
                                    <option value="" selected disabled>Condition...</option>
                                    <option value="New">New</option>
                                    <option value="Like New">Like New</option>
                                    <option value="Excellent">Excellent</option>
                                    <option value="Good">Good</option>
                                    <option value="Fair">Fair</option>
                                    <option value="Salvage">Salvage</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedMake" class="col-xs-12 no-padding control-label">Manufacturer</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedMake" class="form-control" type="text" placeholder="Manufacturer..." tabindex="505" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedModel" class="col-xs-12 no-padding control-label">Model</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedModel" class="form-control" type="text" placeholder="Model..." tabindex="506" />
                            </div>
                        </div>
                    </div>
                    <div id="classifiedHousingInput" class="select-classified-input hidden">
                        <div class="col-sm-3 col-xs-4 no-padding">
                            <label for="txtClassifiedMeters" class="col-xs-12 no-padding control-label">Meters<sup>2</sup></label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedMeters" class="form-control" type="number" min="1" max="5000" value="0" tabindex="503" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-8 no-padding">
                            <label for="txtClassifiedRent" class="col-xs-12 no-padding control-label">Rent (元)</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedRent" class="form-control" type="number" min="1" max="50000" value="0" tabindex="504" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedBedrooms" class="col-xs-12 no-padding control-label">Bedrooms</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedBedrooms" class="form-control" type="number" min="0" max="10" step="0.5" value="0" tabindex="505" />
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtClassifiedBathrooms" class="col-xs-12 no-padding control-label">Bathrooms</label>
                            <div class="col-xs-12 no-pad-left">
                                <input id="txtClassifiedBathrooms" class="form-control" type="number" min="0" max="10" step="0.5" value="0" tabindex="506" />
                            </div>
                        </div>
                        <div class="col-sm-4 col-xs-12 no-pad-left">
                            <label for="txtClassifiedAvailable" class="col-xs-12 no-padding control-label">Date Available</label>
                            <div class="input-group">
                                <input id="txtClassifiedAvailable" type="text" class="form-control datepicker" tabindex="507" />
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                            </div>
                        </div>
                        <div class="col-sm-8 col-xs-12 no-padding">
                            <div class="col-sm-4 col-xs-4 no-padding icheck" style="padding-top: 28px !important;">
                                <label for="chkClassifiedPets" class="col-xs-12 no-padding">
                                    <input id="chkClassifiedPets" type="checkbox" tabindex="508" />&nbsp;Pets
                                </label>
                            </div>
                            <div class="col-sm-4 col-xs-4 no-padding icheck" style="padding-top: 28px !important;">
                                <label for="chkClassifiedLaundry" class="col-xs-12 no-padding">
                                    <input id="chkClassifiedLaundry" type="checkbox" tabindex="509" />&nbsp;Laundry
                                </label>
                            </div>
                            <div class="col-sm-4 col-xs-4 no-padding icheck" style="padding-top: 28px !important;">
                                <label for="chkClassifiedFurnished" class="col-xs-12 no-padding">
                                    <input id="chkClassifiedFurnished" type="checkbox" tabindex="510" />&nbsp;Furnished
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 no-padding">
                        <label for="txtClassifiedTitle" class="col-xs-12 no-padding control-label">Title</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtClassifiedTitle" type="text" class="form-control" placeholder="Ad Title..." tabindex="511" />
                        </div>
                    </div>
                    <div class="col-xs-12 no-padding" style="margin-top: 5px;">
                        <label for="txtClassifiedDetails" class="col-xs-12 no-padding control-label">Details</label>
                        <div class="col-xs-12 no-padding">
                            <hwa:WYSIHTML5 ID="wysihtml5Events" ToolbarID="classifiedToolbar" TextareaID="classifiedTextarea" TabIndex="512" runat="server" />
                        </div>
                    </div>
                    <div id="classifiedImageUploads" class="col-xs-12 no-padding" style="margin-top: 5px;">
                        <hwa:ImageUploads ID="imageUploads1" runat="server" />
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelNewClassifiedAd" type="button" class="btn btn-default pull-left" tabindex="513" data-dismiss="modal">Cancel</button>
                    <button id="btnSubmitNewClassifiedAd" type="button" class="btn btn-primary" tabindex="514">Create</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- Create Classified Ad Modal -->
    <div class="modal fade in" id="modalShowClassifiedAd">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body no-padding">
                    <div class="col-xs-12 no-padding" style="background: #ddd;">
                        <div id="showClassifiedCarousel" class="carousel slide" data-ride="carousel" data-interval="false" style="display: contents;">
                            <ol class="carousel-indicators"></ol>
                            <div class="carousel-inner carousel-images-panel"></div>
                            <a class="left carousel-control" href="#showClassifiedCarousel" role="button" data-slide="prev">
                                <span class="fa fa-angle-left" aria-hidden="true"></span>
                            </a>
                            <a class="right carousel-control" href="#showClassifiedCarousel" role="button" data-slide="next">
                                <span class="fa fa-angle-right" aria-hidden="true"></span>
                            </a>
                        </div>
                        <span id="showClassifiedType"></span>
                    </div>

                    <div class="col-xs-12">
                    </div>

                    <div class="col-xs-12 no-padding" style="margin-top:10px;">
                        <div class="col-sm-6 col-xs-12">
                            <span class="show-classified-category">
                                <span id="showClassifiedCategory"></span>
                                &nbsp;<i class="fa fa-angle-right"></i>&nbsp;
                                <span id="showClassifiedSubCategory"></span>
                            </span>
                        </div>

                        <div class="col-sm-6 col-xs-12 valign text-right">
                            <span id="showClassifiedUsername" class="col-xs-8"></span>
                            <span id="showClassifiedAvatar" class="col-xs-4"></span>
                        </div>
                    </div>

                    <div id="showClassifiedEmployment" class="col-xs-12 no-padding hidden">
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Compensation:</strong>&nbsp;<span id="showClassifiedCompensation"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Term:</strong>&nbsp;<span id="showClassifiedTerm"></span></h4>
                        </div>
                        <div id="showClassifiedInternship" class="col-sm-6 col-xs-6 hidden">
                            <h4><strong>This Position is an Internship</strong></h4>
                        </div>
                        <div id="showClassifiedTelecommuting" class="col-sm-6 col-xs-6 hidden">
                            <h4><strong>This is a Telecommuting Position</strong></h4>
                        </div>
                    </div>
                    <div id="showClassifiedMarketplace" class="col-xs-12 no-padding hidden">
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Price:</strong>&nbsp;<span id="showClassifiedPrice"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Condition:</strong>&nbsp;<span id="showClassifiedCondition"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Make:</strong>&nbsp;<span id="showClassifiedMake"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Model:</strong>&nbsp;<span id="showClassifiedModel"></span></h4>
                        </div>
                    </div>
                    <div id="showClassifiedHousing" class="col-xs-12 no-padding hidden">
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Size:</strong>&nbsp;<span id="showClassifiedMeters"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Rent:</strong>&nbsp;<span id="showClassifiedRent"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Bedrooms:</strong>&nbsp;<span id="showClassifiedBedrooms"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Bathrooms:</strong>&nbsp;<span id="showClassifiedBathrooms"></span></h4>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <h4><strong>Date Available:</strong>&nbsp;<span id="showClassifiedAvailable"></span></h4>
                        </div>
                        <div id="showClassifiedPets" class="col-sm-6 col-xs-12 hidden">
                            <h4><strong>Pets Are Allowed</strong></h4>
                        </div>
                        <div id="showClassifiedLaundry" class="col-sm-6 col-xs-12 hidden">
                            <h4><strong>Laundry Facilities Available</strong></h4>
                        </div>
                        <div id="showClassifiedFurniture" class="col-sm-6 col-xs-12 hidden">
                            <h4><strong>Furnished Rental</strong></h4>
                        </div>
                    </div>

                    <div id="showClassifiedDescription" class="col-xs-12"></div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelShowClassifiedAd" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <asp:HiddenField ID="hiddenViewParam" runat="server" />
    <asp:HiddenField ID="hiddenIDParam" runat="server" />
    <asp:HiddenField ID="hiddenEditParam" runat="server" />
    <asp:HiddenField ID="hiddenActionParam" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <script src="https://www.kunminglive.com/dist/js/classifieds.js"></script>
</asp:Content>
