using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Data Structure for Notifications
/// </summary>
public class Notification
{
    public Notification(int notificationId, string username, string title, string description, Types type, string url, bool urgent, bool viewed, bool dismissed, DateTime timeCreated)
    {
        NotificationID = notificationId;
        Username = username;
        Title = title;
        Description = description;
        Type = type;
        Url = url;
        Urgent = urgent;
        Viewed = viewed;
        Dismissed = dismissed;
        TimeCreated = timeCreated;
    }

    public int NotificationID { get; private set; }
    public string Username { get; private set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public Types Type { get; set; }
    public string Url { get; set; }
    public bool Urgent { get; set; }
    public bool Viewed { get; set; }
    public bool Dismissed { get; set; }
    public DateTime TimeCreated { get; set; }
    public string ElapsedTime { get { return commons.GetTimeSince(TimeCreated); } }
    public string IconClass
    {
        get
        {
            switch (Type)
            {
                case Types.Article:
                    return "fa-file-text text-primary";
                case Types.Business:
                    return "fa-building text-danger";
                case Types.Classified:
                    return "fa-newspaper text-purple";
                case Types.Event:
                    return "fa-calendar text-success";
                case Types.Forum:
                    return "fa-comments text-aqua";
                case Types.Request:
                    return "fa-question text-yellow";
                default:
                    return "fa-comment text-black";
            }
        }
    }

    public static Notification[] GetNotifications(string username = null)
    {
        string sql = "SELECT * FROM notifications WHERE dismissed = 0 AND user_name = @user_name ORDER BY time_created DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", (username == null ? HttpContext.Current.User.Identity.Name : username) }
        });
        List<Notification> notifications = new List<Notification>();
        foreach (Result result in resultSet)
        {
            notifications.Add(new Notification(
                (int)result["notification_id"],
                (string)result["user_name"],
                (string)result["title"],
                (string)result["description"],
                (Types)result["type"],
                (string)result["url"],
                Convert.ToBoolean(result["urgent"]),
                Convert.ToBoolean(result["viewed"]),
                Convert.ToBoolean(result["dismissed"]),
                (DateTime)result["time_created"]
            ));
        }
        return notifications.ToArray();
    }

    public enum Types
    {
        Article,
        Classified,
        Event,
        Forum,
        Request,
        Business
    }
}