using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Globalization;

public partial class eventscalendar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        foreach (TodoItem.TodoTypes type in Enum.GetValues(typeof(TodoItem.TodoTypes)))
        {
            ddlTodoType.Items.Add(new ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }


        hiddenActionParam.Value = Request.QueryString["action"];
        hiddenViewParam.Value = Request.QueryString["view"];
        hiddenEditParam.Value = Request.QueryString["edit"];

        SetupEvents();
    }

    private void SetupEvents()
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();

        Event[] events = Event.GetEvents();
        List<Event.EventJsObj> eventJsObjects = new List<Event.EventJsObj>();
        CultureInfo culture = new CultureInfo("zh-CN");

        Dictionary<string, Event> eventData = new Dictionary<string, Event>();
        
        foreach (Event thisEvent in events)
        {
            if (thisEvent.Days.Length > 0)
            {
                for (int i = 0; i < 12; i++)
                {
                    foreach (DayOfWeek dow in thisEvent.Days)
                    {
                        DateTime date = Event.GetNextWeekday(DateTime.Now.Date.AddDays(i * 7), dow);
                        eventJsObjects.Add(new Event.EventJsObj(
                            thisEvent.EventID,
                            thisEvent.Title,
                            date.Add(thisEvent.StartTime).ToString("s", culture),
                            date.Add(thisEvent.EndTime).ToString("s", culture),
                            thisEvent.AllDay,
                            TodoItem.CssClasses.Label(thisEvent.Type)
                        ));
                    }
                }
            }
            else if (thisEvent.StartDate.HasValue && thisEvent.EndDate.HasValue)
            {
                if (thisEvent.AllDay)
                {
                    eventJsObjects.Add(new Event.EventJsObj(
                        thisEvent.EventID,
                        thisEvent.Title,
                        thisEvent.StartDate.Value.ToString("s", culture),
                        thisEvent.EndDate.Value.ToString("s", culture),
                        thisEvent.AllDay,
                        TodoItem.CssClasses.Label(thisEvent.Type)
                    ));
                }
                else
                {
                    int dayCount = (thisEvent.EndDate.Value - thisEvent.StartDate.Value).Days;
                    for (int i = 0; i <= dayCount; i++)
                    {
                        eventJsObjects.Add(new Event.EventJsObj(
                            thisEvent.EventID,
                            thisEvent.Title,
                            thisEvent.StartDate.Value.AddDays(i).ToString("YYYY/MM/DD", culture) + " " + thisEvent.StartTime.ToString(),
                            thisEvent.StartDate.Value.AddDays(i).ToString("YYYY/MM/DD", culture) + " " + thisEvent.EndTime.ToString(),
                            thisEvent.AllDay,
                            TodoItem.CssClasses.Label(thisEvent.Type)
                        ));
                    }
                }
            }

            string dates = "";
            if (thisEvent.StartDate.HasValue && thisEvent.EndDate.HasValue)
            {
                dates = thisEvent.StartDate.Value.ToString("MMM d") + " to " + thisEvent.EndDate.Value.ToString("MMM d");
            } else if (thisEvent.Days.Length > 0)
            {
                foreach (DayOfWeek dow in thisEvent.Days)
                {
                    dates += dow.ToString().Substring(0, 1);
                }
            }
            pnlEventsList.Controls.Add(new LiteralControl(
                "<div class='col-xxl-4 col-md-6 col-xs-12'>" +
                    "<div id='event-box-" + thisEvent.EventID + "' class='box " + TodoItem.CssClasses.Box(thisEvent.Type) + "' data-event_id='" + thisEvent.EventID + "' runat='server'>" +
                        "<div class='box-header with-border'>" +
                            "<div class='pull-right' style='margin:-3px' data-table_name='events' data-primary_identifier='" + thisEvent.EventID + "'>" +
                                "<button id='events-" + thisEvent.EventID + "' data-todo-title=\"" + thisEvent.Title + "\" data-todo-type=\"" + Convert.ToInt32(thisEvent.Type).ToString() + "\" data-link_back=\"" + thisEvent.Link + "\" type='button' class='btn btn-default btn-sm save-todo' data-toggle='tooltip' title='Save to Bucket list'>" +
                                    "<i class='fa fa-star clickable'></i>" +
                                "</button>" +
                                "<button type='button' class='btn btn-default btn-sm' data-widget='collapse' data-toggle='tooltip' title='Collapse' data-original-title='Collapse'>" +
                                    "<i class='fa fa-minus'></i>" +
                                "</button>" +
                                "<button type='button' class='btn btn-default btn-sm' data-widget='remove' data-toggle='tooltip' title='Remove' data-original-title='Remove'>" +
                                    "<i class='fa fa-times'></i>" +
                                "</button>" +
                            "</div>" +
                            "<h3 class='pull-left box-title' style='display:contents;'>" + thisEvent.Title + "</h3>" +
                        "</div>" +
                        "<div class='box-body no-padding clickable show-event-details'>" +
                            "<div class='col-sm-5 col-xs-12 no-padding' style='overflow:hidden;'>" +
                                "<div class='classified-image-background'" + (thisEvent.EventImages.Length > 0 ? " style=\"background:url('" + thisEvent.EventImages[0].Path + "') no-repeat center center fixed;\"" : "") + "></div>" +
                                "<img src='" + thisEvent.EventImages[0].Path + "' class='img-responsive' alt='Event Image' style='max-height:135px;margin:0 auto;position:relative;' />" +
                                "<span class='event-type " + TodoItem.CssClasses.Label(thisEvent.Type) + "'>" + thisEvent.Type.ToString() + "</span>" +
                            "</div>" +
                            "<div class='col-sm-7 col-xs-12'>" +
                                (thisEvent.Approved ? "" : "<h4 class='text-danger'>Pending Approval</h4>") +
                                "<h4><i class='fa fa-building'></i>&nbsp;" + thisEvent.Business + "</h4>" +
                                "<h4><i class='fa fa-map-marker'></i>&nbsp;" + thisEvent.Location + "</h4>" +
                            "</div>" +
                            "<div class='col-sm-7 col-xs-12'>" +
                                "<h5 class='pull-left'>" +
                                    "<i class='fa fa-calendar'></i>&nbsp;" + dates + " &nbsp; " +
                                    "<span class='hidden-md'><i class='fa fa-clock-o'></i>&nbsp;" + (thisEvent.AllDay ? "All Day" : thisEvent.StartTime.ToString("h':'mm") + "-" + thisEvent.EndTime.ToString("h':'mm")) + "</span>" +
                                "</h5>" +
                                "<h5 style='font-size:18px;text-align:right;margin-top:7px;'> " + (thisEvent.Cost == 0 ? "Free" : thisEvent.Cost.ToString("C", CultureInfo.GetCultureInfo("zh-CN"))) + "</h5>" +
                            "</div>" +
                        "</div>" +
                    "</div>" +
                "</div>"
            ));

            eventData.Add(thisEvent.EventID.ToString(), thisEvent);
        }

        Array.Sort(events, delegate (Event x, Event y) { return x.EventAttendees.Length.CompareTo(y.EventAttendees.Length); });
        Array.Reverse(events);

        int iLength = (events.Length > 4 ? 5 : events.Length);
        for (int i = 0; i < iLength; i++)
        {
            string dates = "";
            if (events[i].StartDate.HasValue && events[i].EndDate.HasValue)
            {
                dates = events[i].StartDate.Value.ToString("M/d") + " to " + events[i].EndDate.Value.ToString("M/d");
            }
            else if (events[i].Days.Length > 0)
            {
                foreach (DayOfWeek dow in events[i].Days)
                {
                    dates += dow.ToString().Substring(0, 1);
                }
            }

            pnlMostPopularEventsTable.Controls.Add(new LiteralControl(
                "<tr class='" + TodoItem.CssClasses.Background(events[i].Type) + " clickable event-preview' data-event_id='" + events[i].EventID + "'>" +
                    "<td class='no-pad-right ellipsis' data-toggle='tooltip' data-original-title='" + events[i].Title + "'>" + events[i].Title + "</td>" +
                    "<td class='no-pad-right hidden-xs ellipsis' data-toggle='tooltip' data-original-title='" + events[i].Location + "'> " + events[i].Location + "</td>" +
                    "<td class='no-padding text-center'>" + dates + "</td>" +
                    "<td class='no-padding text-center'>" + events[i].EventAttendees.Length + "</td>" +
                "</tr>"
            ));
        }

        hiddenEventCalendarData.Value = serializer.Serialize(eventJsObjects);
        hiddenEventData.Value = serializer.Serialize(eventData);
    }

    [WebMethod]
    public static int? SaveEvent(string business, string title, string location, string content, TodoItem.TodoTypes type, DateTime start, DateTime end, decimal cost, string[] images, DayOfWeek[] days, int? editEventId = null)
    {
        return Event.CreateEvent(business, title, location, content, type, start, end, cost, images, days, editEventId);
    }

    [WebMethod]
    public static bool? AttendEvent(int eventId)
    {
        return Event.AttendEvent(eventId);
    }

    [WebMethod]
    public static Event GetEventData(int eventId)
    {
        return Event.GetEvent(eventId);
    }

    [WebMethod]
    public static void SuspendEvent(int postId, bool suspended)
    {
        Event.SuspendEvent(postId, suspended);
    }

    [WebMethod]
    public static void DeleteEvent(int postId)
    {
        Event.DeleteEvent(postId);
    }
}