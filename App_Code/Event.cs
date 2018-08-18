using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Data Structure for Events
/// </summary>
public class Event
{
    DateTime? endDate;
    public Event(int eventId, string username, TodoItem.TodoTypes type, string business, string title, string location, string details, decimal cost,
                DateTime? startDate, DateTime? endDate, TimeSpan startTime, TimeSpan endTime, string daysOfWeek, bool approved, bool denied, bool expired, bool inactive)
    {
        EventID = eventId;
        Username = username;
        Type = type;
        Business = business;
        Title = title;
        Location = location;
        Details = details;
        Cost = cost;
        StartDate = startDate;
        this.endDate = endDate;
        StartTime = startTime;
        EndTime = endTime;
        Approved = approved;
        Denied = denied;
        Expired = expired;
        Inactive = inactive;
        
        Days = string.IsNullOrEmpty(daysOfWeek) ? new DayOfWeek[] { } : (DayOfWeek[])(object)daysOfWeek.ToCharArray().Select(x => int.Parse(x.ToString())).ToArray();

        string sql = "SELECT * FROM event_images WHERE event_id = " + eventId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<EventImage> eventImages = new List<EventImage>();
        foreach (Result result in resultSet)
        {
            eventImages.Add(new EventImage(
                (int)result["event_image_id"],
                (int)result["event_id"],
                (string)result["image_path"],
                (int)result["sort_order"]
            ));
        }

        sql = "SELECT * FROM event_attendees WHERE event_id = " + eventId;
        resultSet = commons.ExecuteQuery(sql);
        List<EventAttendee> eventAttendees = new List<EventAttendee>();
        foreach (Result result in resultSet)
        {
            if ((string)result["user_name"] == HttpContext.Current.User.Identity.Name)
            {
                Going = true;
            }
            eventAttendees.Add(new EventAttendee(
                (int)result["event_attendee_id"],
                (int)result["event_id"],
                (string)result["user_name"]
            ));
        }

        EventImages = eventImages.ToArray();
        EventAttendees = eventAttendees.ToArray();
    }

    public int EventID { get; private set; }
    public string Username { get; private set; }

    public TodoItem.TodoTypes Type { get; private set; }
    public string TypeString
    {
        get
        {
            return Type.ToString();
        }
    }
    public string TypeLabel
    {
        get
        {
            return TodoItem.CssClasses.Label(Type);
        }
    }
    public string TypeBox
    {
        get
        {
            return TodoItem.CssClasses.Box(Type);
        }
    }

    public string Business { get; private set; }
    public string Title { get; private set; }
    public string Location { get; private set; }
    public string Details { get; private set; }

    public decimal Cost { get; private set; }
    public string CostString
    {
        get
        {
            return Cost.ToString("C", System.Globalization.CultureInfo.GetCultureInfo("zh-CN"));
        }
    }

    public bool Private { get; private set; }
    public bool Approved { get; private set; }
    public bool Denied { get; private set; }
    public bool Expired { get; private set; }
    public bool Inactive { get; private set; }

    public DateTime? StartDate { get; private set; }
    public DateTime? EndDate {
        get
        {
            if (!endDate.HasValue) { return null; }
            if (AllDay) { return endDate.Value.AddDays(1); }
            else { return endDate.Value; }
        }
    }
    public TimeSpan StartTime { get; private set; }
    public string StartTimeString
    {
        get
        {
            return StartTime.ToString("c");
        }
    }
    public TimeSpan EndTime { get; private set; }
    public string EndTimeString
    {
        get
        {
            return EndTime.ToString("c");
        }
    }
    public DayOfWeek[] Days { get; private set; }
    public string[] DaysText
    {
        get
        {
            return Array.ConvertAll(Days, x => x.ToString());
        }
    }
    public bool AllDay
    {
        get
        {
            return (StartTime.Ticks == 0 && EndTime.Ticks == 0);
        }
    }

    public bool Going { get; private set; }

    public string Link { get { return "https://www.kunminglive.com/events-calendar/" + EventID.ToString() + "/" + Title.RemoveSpecialCharacters().Replace(" ", "-"); } }
    public string EditLink { get { return "https://www.kunminglive.com/events-calendar/edit" + EventID.ToString(); } }

    public EventImage[] EventImages { get; private set; }
    public EventAttendee[] EventAttendees { get; private set; }

    public static Event[] GetEvents(string username)
    {
        return GetEvents(null, null, username);
    }
    public static Event[] GetEvents(DateTime? latestDate = null, DateTime ? earliestDate = null, string username = null)
    {
        if (latestDate == null) { latestDate = DateTime.Now.AddMonths(3); }
        if (earliestDate == null) { earliestDate = DateTime.Now.AddMonths(-3); }

        string sql = "SELECT * FROM events WHERE ";
        if (username != null)
        {
            sql += "user_name = @user_name";
        }
        else
        {
            sql += "(approved = 1 OR user_name = @user_name OR " + Convert.ToInt32(User.VerifyAdmin()).ToString() + " = 1) AND expired = 0 AND inactive = 0 AND " +
                "((start_date > @start_date AND end_date < @end_date) OR days IS NOT NULL) ";
        }
        sql += " ORDER BY start_date ASC,end_date ASC";

        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", (username == null ? HttpContext.Current.User.Identity.Name : username) },
            { "@start_date", earliestDate },
            { "@end_date", latestDate }
        });
        List<Event> events = new List<Event>();
        foreach (Result result in resultSet)
        {
            events.Add(new Event(
                (int)result["event_id"],
                (string)result["user_name"],
                (TodoItem.TodoTypes)result["todo_type"],
                (string)result["business_name"],
                (string)result["title"],
                (string)result["location"],
                (string)result["details"],
                (decimal)result["cost"],
                result["start_date"] as DateTime?,
                result["end_date"] as DateTime?,
                (TimeSpan)result["start_time"],
                (TimeSpan)result["end_time"],
                result["days"] as string,
                Convert.ToBoolean(result["approved"]),
                Convert.ToBoolean(result["denied"]),
                Convert.ToBoolean(result["expired"]),
                Convert.ToBoolean(result["inactive"])
            ));
        }
        return events.ToArray();
    }
    
    public static Event GetEvent(int eventId)
    {
        string sql = "SELECT * FROM events WHERE event_id = @event_id";
        Result result = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@event_id", eventId }
        })[0];

        return new Event(
            (int)result["event_id"],
            (string)result["user_name"],
            (TodoItem.TodoTypes)result["todo_type"],
            (string)result["business_name"],
            (string)result["title"],
            (string)result["location"],
            (string)result["details"],
            (decimal)result["cost"],
            result["start_date"] as DateTime?,
            result["end_date"] as DateTime?,
            (TimeSpan)result["start_time"],
            (TimeSpan)result["end_time"],
            result["days"] as string,
            Convert.ToBoolean(result["approved"]),
            Convert.ToBoolean(result["denied"]),
            Convert.ToBoolean(result["expired"]),
            Convert.ToBoolean(result["inactive"])
        );
    }

    public static int? CreateEvent(string business, string title, string location, string content, TodoItem.TodoTypes type, DateTime start, DateTime end, decimal cost, string[] images, DayOfWeek[] days, int? editEventId = null)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }

        title = commons.CensorWords(title);
        content = commons.CensorWords(content);

        string sql;
        if (editEventId.HasValue)
        {
            sql = "UPDATE events SET user_name=@user_name,todo_type=@todo_type,business_name=@business_name,title=@title,location=@location,details=@details,cost=@cost," +
                "start_date=@start_date,end_date=@end_date,start_time=@start_time,end_time=@end_time,days=@days,approved=@approved,denied=0 WHERE event_id = " + editEventId.Value;
        }
        else
        {
            sql = "INSERT INTO events (user_name,todo_type,business_name,title,location,details,cost,start_date,end_date,start_time,end_time,days,approved,denied,expired,inactive) " +
                "OUTPUT INSERTED.event_id VALUES (@user_name,@todo_type,@business_name,@title,@location,@details,@cost,@start_date,@end_date,@start_time,@end_time,@days,@approved,0,0,0);";
        }
        Dictionary<string, object> eventParams = new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@todo_type", type },
            { "@business_name", business },
            { "@title", title },
            { "@location", location },
            { "@details", content },
            { "@cost", cost },
            { "@start_date", (start.Year == 1970 ? (object)DBNull.Value : start.Date) },
            { "@end_date", (end.Year == 1970 ? (object)DBNull.Value : end.Date) },
            { "@start_time", start.TimeOfDay },
            { "@end_time", end.TimeOfDay },
            { "@days", (days.Length > 0 ? string.Join("", Array.ConvertAll(days, x => Convert.ToInt32(x).ToString())) : (object)DBNull.Value) },
            { "@approved", HttpContext.Current.User.IsInRole("Administrators") }
        };
        ResultSet resultSet = commons.ExecuteQuery(sql, eventParams);
        int eventId;

        if (editEventId.HasValue)
        {
            eventId = editEventId.Value;
            sql = "DELETE FROM event_images WHERE event_id = " + eventId;
            commons.ExecuteQuery(sql);
        } else { eventId = (int)resultSet[0]["event_id"]; }

        sql = "INSERT event_images (event_id,image_path,sort_order) VALUES (@event_id,@image_path,@sort_order)";
        for (int i = 0; i < images.Length; i++)
        {
            string imagePath = commons.SaveBase64Image(images[i], "/dist/img/events");
            resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@event_id", eventId },
                { "@image_path", imagePath },
                { "@sort_order", i }
            });

        }

        if (!HttpContext.Current.User.IsInRole("Administrators"))
        {
            string approvalBody = title + "<br/><br/>" + content;
            commons.CreateNotification("Event Pending Approval", "Your Event has been submitted for approval. You will be notified of approval or denial within a 8 hours.", Notification.Types.Event, HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/eventscalendar.aspx?view=" + eventId);
            commons.SendEmail(new User(HttpContext.Current.User.Identity.Name), "KL! New Event Approval", approvalBody);
            commons.SendEmail(new User("Jancarius"), "New Event Submitted", new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(eventParams));
        }

        return eventId;
    }

    public static bool? ApproveEvent(int eventId, bool approved, string deniedReason = "")
    {
        if (HttpContext.Current.Request.IsAuthenticated)
        {
            if (!User.VerifyAdmin()) { return null; }
        } else { return null; }

        string sql = "SELECT user_name FROM events WHERE event_id = " + eventId;
        string username = (string)commons.ExecuteQuery(sql)[0]["user_name"];

        string uriLeftPart = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);
        if (approved)
        {
            sql = "UPDATE events SET approved = 1 WHERE event_id = " + eventId;
            string body = "Thank you for submitting your event. It has been approved and can now be viewed by the public at <a href='https://kunminglive.com/eventscalendar.aspx?view=" + eventId + "'>Kunming LIVE!</a>.";
            commons.SendEmail(new User(username), "Kunming LIVE! Event Approved", body);
            commons.CreateNotification("Event Approved", "Your event has been approved and is now available to the public. Thank you for sharing!", Notification.Types.Event, uriLeftPart + "/eventscalendar.aspx?view=" + eventId, false, username);
        } else
        {
            sql = "UPDATE events SET denied = 1 WHERE event_id = " + eventId;
            string body = "Thank you for submitting your event. Unfortunately your event has been denied for the following reason(s). Please correct the issue and resubmit the event.<br/><br/>" + deniedReason;
            commons.SendEmail(new User(username), "Kunming LIVE! Event Denied", body);
            commons.CreateNotification("Event Denied", "Unfortunately your event has been denied for: " + deniedReason + ". Please edit your event to correct the reason for denial. Click \"Eye\" Icon.", Notification.Types.Event, uriLeftPart + "/eventscalendar.aspx?edit=" + eventId, true, username);
        }
        
        commons.ExecuteQuery(sql);
        return true;
    }

    public static bool? AttendEvent(int eventId)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }

        string sql = "SELECT * FROM event_attendees WHERE user_name = '" + HttpContext.Current.User.Identity.Name + "' AND event_id = " + eventId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length == 1) {
            sql = "DELETE FROM event_attendees WHERE user_name = '" + HttpContext.Current.User.Identity.Name + "' AND event_id = " + eventId;
            commons.ExecuteQuery(sql);
            return false;
        }

        sql = "INSERT INTO event_attendees (user_name,event_id) VALUES (@user_name,@event_id)";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@event_id", eventId }
        });

        Event thisEvent = Event.GetEvent(eventId);
        string body = "You're scheduled to attend an event<br/><strong>" + thisEvent.Title + "</strong><br />" + thisEvent.Business + "<br/>" + thisEvent.Location + "<br/>";
        if (thisEvent.StartDate.HasValue && thisEvent.EndDate.HasValue)
        {
            body += "Event Dates: " + thisEvent.EndDate.Value.AddDays(-1).ToString("ddd MMM d") + " to " + thisEvent.StartDate.Value.ToString("ddd MMM d") + "<br/>";
        }
        else
        {
            body += "Event Days: " + string.Join(",", thisEvent.Days.Select(x => x.ToString()).ToArray()) + "<br/>";
        }
        body += "Event Times: ";
        if (thisEvent.AllDay)
        {
            body += "All Day";
        }
        else
        {
            body += thisEvent.StartTime.ToString("HH:mm") + " to " + thisEvent.EndTime.ToString("HH:mm");
        }
        body += "<br/>We will send you a reminder email ahead of events that are not recurring. Thank you!";

        commons.SendEmail(new User(HttpContext.Current.User.Identity.Name), "Kunming LIVE! You're Going!", body);
        commons.CreateNotification("Attending Event", "You're attending the event, \"" + thisEvent.Title + "\".", Notification.Types.Event, "eventscalendar.aspx?view=" + eventId);

        return true;
    }

    public static void SuspendEvent(int eventId, bool suspended)
    {
        string sql = "UPDATE events SET inactive = @inactive WHERE event_id = " + eventId;
        commons.ExecuteQuery(sql, suspended);
    }

    public static void DeleteEvent(int eventId)
    {
        string sql = "DELETE FROM event_attendees WHERE event_id = @event_id;" +
                    "DELETE FROM event_images WHERE event_id = @event_id;" +
                    "DELETE FROM events WHERE event_id = @event_id;";
        commons.ExecuteQuery(sql, eventId);
    }

    public static DateTime GetNextWeekday(DateTime start, DayOfWeek day)
    {
        int daysToAdd = ((int)day - (int)start.DayOfWeek + 7) % 7;
        return start.AddDays(daysToAdd);
    }

    public class EventImage
    {
        public EventImage(int eventImageId, int eventId, string path, int sortOrder)
        {
            EventImageID = eventImageId;
            EventID = eventId;
            Path = path;
            SortOrder = sortOrder;
        }

        public int EventImageID { get; private set; }

        public int EventID { get; private set; }

        public string Path { get; private set; }

        public int SortOrder { get; set; }
    }

    public class EventAttendee
    {
        public EventAttendee(int eventAttendeeId, int eventId, string username)
        {
            EventAttendeeID = eventAttendeeId;
            EventID = eventId;
            User = new User(username);
        }

        public int EventAttendeeID { get; set; }
        public int EventID { get; set; }
        public User User { get; set; }
    }

    public class EventJsObj
    {
        public EventJsObj(int _id, string _title, string _start, string _end, bool _allDay, string _className)
        {
            id = _id;
            title = _title;
            start = _start;
            end = _end;
            allDay = _allDay;
            className = _className;
        }
        public int id;
        public string title;
        public string start;
        public string end;
        public bool allDay;
        public string className;
        public bool editable = false;
        public bool overlap = true;
    }
}