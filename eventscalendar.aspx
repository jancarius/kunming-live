<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="eventscalendar.aspx.cs" Inherits="eventscalendar" %>

<%@ Register TagPrefix="hwa" TagName="ImageUploads" Src="~/controls/UploadImages.ascx" %>
<%@ Register TagPrefix="hwa" TagName="WYSIHTML5" Src="~/controls/WYSIHTML5.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!-- Date Range Picker -->
    <link rel="stylesheet" href="https://www.kunminglive.com/bower_components/bootstrap-daterangepicker/daterangepicker.css" />
    <!-- Time Picker -->
    <link rel="stylesheet" href="https://www.kunminglive.com/bower_components/bootstrap-timepicker/css/bootstrap-timepicker.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Events
                    <small>Calendar</small>
                </div>
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
            <div class="col-xs-12">
                <button id="btnShowAddEvent" type="button" class="btn btn-success" style="margin: -5px 0 10px 0;">Add Event</button>
            </div>

            <div class="col-xl-7 col-lg-6 col-md-12 col-xs-12 pull-right">
                <div class="box box-success">
                    <div id="eventsCalendar" class="box-body"></div>
                </div>
            </div>

            <div class='col-xl-5 col-lg-6 hidden-md hidden-sm hidden-xs'>
                <div id='showEventPreview' class='box' runat="server">
                    <div class='box-header with-border'>
                        <div class='pull-right' style='margin: -3px'>
                            <button id='events-preview' type='button' class='btn btn-default btn-sm save-todo hidden' data-toggle='tooltip' data-original-title='Save to Bucket list'>
                                <i class='fa fa-star clickable'></i>
                            </button>
                            <button type='button' class='btn btn-default btn-sm' data-widget='collapse' data-toggle='tooltip' title='Collapse' data-original-title='Collapse'>
                                <i class='fa fa-minus'></i>
                            </button>
                            <button type='button' class='btn btn-default btn-sm' data-widget='remove' data-toggle='tooltip' title='Remove' data-original-title='Remove'>
                                <i class='fa fa-times'></i>
                            </button>
                        </div>
                        <h3 class='pull-left box-title' style='display: contents;'>Hover Event to Preview</h3>
                    </div>
                    <div class='box-body no-padding clickable show-event-details inactive'>
                        <div class='col-sm-5 col-xs-12 no-padding'>
                            <img src='https://www.kunminglive.com/dist/img/company_placeholder.jpg' class='img-responsive show-event-main-image' alt='Event Image' style="max-height:135px;" />
                            <span class='event-type'></span>
                        </div>
                        <div class='col-sm-7 col-xs-12'>
                            <h4><i class='fa fa-building'></i>&nbsp;<span class="event-preview-business">Business Name</span></h4>
                            <h4><i class='fa fa-map-marker'></i>&nbsp;<span class="event-preview-location">Location</span></h4>
                        </div>
                        <div class='col-sm-7 col-xs-12'>
                            <h5 class='pull-left'>
                                <i class='fa fa-calendar'></i>&nbsp;&nbsp;<span class="event-preview-dates">Dates</span>&nbsp;&nbsp;
                                <i class='fa fa-clock-o'></i>&nbsp;&nbsp;<span class="event-preview-times">Times</span>
                            </h5>
                            <h5 class='pull-right' style='font-size: 18px; position: absolute; right: 10px; bottom: -1px;'><span class="event-preview-cost">Cost</span></h5>
                        </div>
                    </div>
                    <input class="event-preview-data" type='hidden' />
                </div>
            </div>

            <div class="col-xl-5 col-lg-6 col-xs-12">
                <div id="pnlMostPopularEvents" class="box box-success" runat="server">
                    <div class="box-header with-border">
                        <h3 class="box-title">Most Popular Events
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
                    <div class="box-body no-padding">
                        <table class="table">
                            <tbody id="pnlMostPopularEventsTable" runat="server">
                                <tr>
                                    <th class="col-sm-4 col-xs-7">Event</th>
                                    <th class="col-sm-4 hidden-xs"><i class='fa fa-globe'></i>&nbsp;Location</th>
                                    <th class="col-sm-2 col-xs-3 no-padding text-center"><i class='fa fa-calendar'></i>&nbsp;Dates</th>
                                    <th class="col-xs-1 no-padding text-center"><i class='fa fa-users'></i></th>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div id="pnlEventsList" runat="server" class="col-xs-12 no-padding">
            </div>
        </div>
    </section>

    <!-- Create Event Modal -->
    <div class="modal fade in" id="modalCreateEvent" data-edit_event_id="null">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">Submit a New Event</h4>
                </div>
                <div class="modal-body">
                    <div class="col-xs-12 no-padding">
                        <div id="pnlAddEventAlert" class="alert alert-info alert-dismissable" runat="server">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true"><i class="fa fa-times"></i></button>
                            <h4><i class="icon fa fa-info"></i>Editing / Approval</h4>
                            Submitted events are subject to approval. Content will NOT be edited, but content that is deemed inappropriate may result in your event being denied.
                            You will be notified of approval/denial within a few hours. Examples of content that may result in denial include, but are not limited to:
                            inappropriate language, inappropriate imagery, and/or sensitive content.
                        </div>
                    </div>
                    <div class="col-xs-12 no-padding">
                        <div id="lblEventError" class="control-label text-red text-bold collapse">&nbsp;<i class="fa fa-times-circle-o"></i><span id="lblEventErrorText"></span></div>
                    </div>
                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="txtEventBusiness" class="col-xs-12 no-padding control-label">Business</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtEventBusiness" type="text" class="form-control" placeholder="Business Name..." />
                        </div>
                    </div>
                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="txtEventTitle" class="col-xs-12 no-padding control-label">Title</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtEventTitle" type="text" class="form-control" placeholder="Event Title..." />
                        </div>
                    </div>

                    <div class="col-sm-4 col-xs-12 no-padding">
                        <label for="txtEventLocation" class="col-xs-12 no-padding control-label">Location</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtEventLocation" type="text" class="form-control" placeholder="Event Location..." />
                        </div>
                    </div>
                    <div id="pnlEventDateTimeSelectType" class="col-sm-6 col-xs-12 no-pad-left checkbox icheck">
                        <br />
                        <label for="chkEventDateTimeWeekly" class="col-xs-5 no-padding control-label">
                            <input id="chkEventDateTimeWeekly" type="radio" name="chkEventDateTimeType" value="Recurring" />&nbsp;Recurring
                        </label>
                        <label for="chkEventDateTimeSpecific" class="col-xs-7 no-padding control-label">
                            <input id="chkEventDateTimeSpecific" type="radio" name="chkEventDateTimeType" value="Specific" />&nbsp;Specific Date(s)
                        </label>
                    </div>
                    <div id="pnlEventDateTimeRecurring" class="col-xs-12 no-padding" style="display: none;">
                        <div class="col-sm-6 text-center pad">
                            <button id="btnEventDateTimeChangeTypeRecurring" type="button" class="btn btn-xs btn-default" style="position: absolute; left: 0; top: 25px;"><i class="fa fa-times"></i></button>
                            <label for="chkEventDateTimeRecurringSunday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringSunday" type="checkbox" value="0" />&nbsp;Sun
                            </label>
                            <label for="chkEventDateTimeRecurringMonday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringMonday" type="checkbox" value="1" />&nbsp;Mon
                            </label>
                            <label for="chkEventDateTimeRecurringTuesday" class=" no-padding control-label">
                                <input id="chkEventDateTimeRecurringTuesday" type="checkbox" value="2" />&nbsp;Tues
                            </label>
                            <label for="chkEventDateTimeRecurringWednesday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringWednesday" type="checkbox" value="3" />&nbsp;Wed
                            </label>
                            <label for="chkEventDateTimeRecurringThursday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringThursday" type="checkbox" value="4" />&nbsp;Thurs
                            </label>
                            <label for="chkEventDateTimeRecurringFriday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringFriday" type="checkbox" value="5" />&nbsp;Fri
                            </label>
                            <label for="chkEventDateTimeRecurringSaturday" class="no-padding control-label">
                                <input id="chkEventDateTimeRecurringSaturday" type="checkbox" value="6" />&nbsp;Sat
                            </label>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtEventDateTimeRecurringTimeStart" class="control-label">Start Time</label>
                            <div class="input-group pull-left" style="padding-right: 15px;">
                                <input id="txtEventDateTimeRecurringTimeStart" type="text" class="form-control timepicker" />
                                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                            </div>
                        </div>
                        <div class="col-sm-3 col-xs-6 no-padding">
                            <label for="txtEventDateTimeRecurringTimeEnd" class="control-label">End Time</label>
                            <div class="input-group" style="padding-right: 15px;">
                                <input id="txtEventDateTimeRecurringTimeEnd" type="text" class="form-control timepicker" />
                                <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                            </div>
                        </div>
                    </div>
                    <div id="pnlEventDateTimeSpecific" class="col-sm-6 col-xs-12 no-pad-left" style="display: none;">
                        <button id="btnEventDateTimeChangeTypeSpecific" type="button" class="btn btn-xs btn-default" style="position: absolute; left:115px; top:3px;"><i class="fa fa-times"></i></button>
                        <label for="txtEventDateTimeSpecific" class="col-xs-12 no-padding control-label">Event Dates/Time</label>
                        <div class="input-group">
                            <input id="txtEventDateTimeSpecific" type="text" class="form-control datepicker" />
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <div class="col-sm-4 col-xs-8 no-padding">
                        <label for="ddlTodoType" class="col-xs-12 no-padding control-label">Event Type</label>
                        <div class="col-xs-12 no-pad-left">
                            <select id="ddlTodoType" class="form-control" runat="server">
                                <option value="null" selected disabled>Event Type...</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-2 col-xs-4 no-padding">
                        <label for="txtEventCost" class="col-xs-12 no-padding control-label">Cost (元)</label>
                        <div class="col-xs-12 no-pad-left">
                            <input id="txtEventCost" class="form-control" type="number" min="0" max="5000" value="0" />
                        </div>
                    </div>
                    <div class="col-xs-12 no-padding" style="margin-top: 5px;">
                        <label for="txtEventDetails" class="col-xs-12 no-padding control-label">Details</label>
                        <div class="col-xs-12 no-padding">
                            <hwa:WYSIHTML5 ID="wysihtml5Events" ToolbarID="eventsToolbar" TextareaID="eventsTextarea" runat="server" />
                        </div>
                    </div>
                    <div id="eventImageUploads" class="col-xs-12 no-padding" style="margin-top: 5px;">
                        <hwa:ImageUploads ID="imageUploads1" runat="server" />
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelNewEvent" type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                    <button id="btnSubmitNewEvent" type="button" class="btn btn-primary">Create</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <!-- Show Event Modal -->
    <div class="modal fade in" id="modalShowEventDetails">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body no-padding">
                    <div class="col-sm-6 col-xs-12 no-padding">
                        <div id="showEventCarousel" class="carousel slide" data-ride="carousel" data-interval="false" style="display: contents;">
                            <ol class="carousel-indicators"></ol>
                            <div class="carousel-inner carousel-images-panel"></div>
                            <a class="left carousel-control" href="#showEventCarousel" role="button" data-slide="prev">
                                <span class="fa fa-angle-left" aria-hidden="true"></span>
                            </a>
                            <a class="right carousel-control" href="#showEventCarousel" role="button" data-slide="next">
                                <span class="fa fa-angle-right" aria-hidden="true"></span>
                            </a>
                        </div>
                        <span id="showEventType"></span>
                    </div>
                    <div class='col-sm-6 col-xs-12'>
                        <h4><i class='fa fa-building'></i>&nbsp;<span id="showEventBusiness"></span></h4>
                        <h4><i class='fa fa-map-marker'></i>&nbsp;<span id="showEventLocation"></span></h4>
                    </div>
                    <div class='col-sm-6 col-xs-12'>
                        <h5 class='pull-left'>
                            <i class='fa fa-calendar'></i>&nbsp;<span id="showEventDates"></span>&nbsp;&nbsp;&nbsp;
                            <i class='fa fa-clock-o'></i>&nbsp;<span id="showEventTimes"></span>
                        </h5>
                        <h5 id="showEventCost" class='pull-right' style='font-size: 18px; position: absolute; right: 10px; bottom: -1px;'></h5>
                    </div>
                    <div class="col-sm-6 col-xs-12" style="margin-top: 15px;">
                        <button id="showEventAttendees" type="button" class="btn btn-sm btn-primary">Who's Going? (<span id="showEventAttendeesCount"></span>)</button>
                        <button id="showEventGoing" type="button" class="btn btn-sm btn-success" data-toggle="tooltip" data-original-title="Click To Attend Event" runat="server">I'm Going!</button>
                        <div id="showEventAttendeesBox" class="box box-success box-shadow" style="position: absolute; z-index: 1000; display: none;">
                            <div class="box-header with-border">
                                <h3 class="box-title">Event Attendees</h3>
                            </div>
                            <div class="box-body no-padding">
                                <table class="table table-striped">
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer with-border">
                                <button id="btnShowEventAttendeesBoxClose" type="button" class="btn btn-sm btn-default pull-right">Close</button>
                            </div>
                        </div>
                    </div>
                    <div id="showEventDetails" class="col-xs-12" style="padding-top: 10px;">
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelShowEvent" type="button" class="btn btn-default pull-right" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <asp:HiddenField ID="hiddenEventCalendarData" runat="server" />
    <asp:HiddenField ID="hiddenEventData" runat="server" />
    <asp:HiddenField ID="hiddenActionParam" runat="server" />
    <asp:HiddenField ID="hiddenViewParam" runat="server" />
    <asp:HiddenField ID="hiddenEditParam" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="Server">
    <!-- Date Range Picker -->
    <script src="https://www.kunminglive.com/bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
    <!-- Time Picker -->
    <script src="https://www.kunminglive.com/bower_components/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>

    <script src="https://www.kunminglive.com/dist/js/eventscalendar.js"></script>
</asp:Content>
