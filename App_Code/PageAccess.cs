using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Structure Class for Page Access
/// </summary>
public class PageAccess
{
    public PageAccess(int pageId)
    {
        string sql = "SELECT * FROM pages WHERE page_id = " + pageId;
        SetupPage(sql);
    }

    public PageAccess(string pageLink)
    {
        string sql = "SELECT * FROM pages WHERE page_link = '" + pageLink + "'";
        SetupPage(sql);
    }

    private void SetupPage(string sql)
    {
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length == 1)
        {
            PageID = (int)resultSet[0]["page_id"];
            Link = (string)resultSet[0]["page_link"];
            Description = (string)resultSet[0]["description"];
            AdminAccess = Convert.ToBoolean(resultSet[0]["administrator_access"]);
            UserAccess = Convert.ToBoolean(resultSet[0]["user_access"]);
            TimeCreated = (DateTime)resultSet[0]["time_created"];
            Inactive = Convert.ToBoolean(resultSet[0]["inactive"]);

            if (HttpContext.Current.Request.IsAuthenticated)
            {
                sql = "INSERT INTO page_access_log (page_id,page_rewrite,user_name,time_created) VALUES (@page_id,@page_rewrite,@user_name,@time_created)";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@page_id", PageID },
                    { "@page_rewrite", HttpContext.Current.Request.RawUrl },
                    { "@user_name", HttpContext.Current.User.Identity.Name },
                    { "@time_created", DateTime.Now }
                });
            }
        } else { commons.SendEmail(new User("Jancarius"), "Page Doesn't Exist", sql); }
    }

    public int PageID { get; private set; }
    public string Link { get; set; }
    public string Description { get; set; }
    public bool AdminAccess { get; set; }
    public bool UserAccess { get; set; }
    public DateTime TimeCreated { get; private set; }
    public bool Inactive { get; set; }

    public static bool CreatePage(string pageLink, string description, bool adminAccess, bool allUserAccess)
    {
        string sql = "INSERT INTO pages (page_link,description,administrator_access,user_access,time_created,inactive) VALUES (@page_link,@description,@administrator_access,@user_access,@time_created,@inactive)";
        commons.ExecuteQuery(sql, new Dictionary<string, object> {
            { "@page_link", pageLink },
            { "@description", description },
            { "@administrator_access", adminAccess },
            { "@user_access", allUserAccess },
            { "@time_created", DateTime.Now },
            { "@inactive", false }
        });
        return true;
    }
}

public class PageAccessLog
{
    public PageAccessLog(int pageAccessLogId, string pageLink, string pageDescription, string pageRewrite, string username, DateTime timeCreated)
    {
        PageAccessLogID = pageAccessLogId;
        PageLink = pageLink;
        PageDescription = pageDescription;
        PageRewrite = pageRewrite;
        User = new User(username);
        TimeCreated = timeCreated;
    }

    public int PageAccessLogID { get; private set; }
    public string PageLink { get; private set; }
    public string PageDescription { get; private set; }
    public string PageRewrite { get; private set; }
    public User User { get; private set; }
    public DateTime TimeCreated { get; private set; }
    public string StatusColor {
        get
        {
            switch (User.OnlineStatus)
            {
                case User.OnlineStatusType.Online:
                    return "text-success";
                case User.OnlineStatusType.Busy:
                    return "text-yellow";
                case User.OnlineStatusType.Offline:
                    return "text-danger";
                default: return "";
            }
        }
    }

    public static PageAccessLog[] GetRecentPageAccess()
    {
        string sql = "SELECT l.*,p.description,p.page_link FROM page_access_log l JOIN pages p ON l.page_id = p.page_id WHERE l.page_access_log_id IN (SELECT MAX(page_access_log_id) FROM page_access_log GROUP BY user_name) AND l.time_created > @fifteen_minutes_ago ORDER BY l.time_created DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql, DateTime.Now.AddMinutes(-15));
        List<PageAccessLog> pageAccessLog = new List<PageAccessLog>();
        foreach (Result result in resultSet)
        {
            pageAccessLog.Add(new PageAccessLog(
                (int)result["page_access_log_id"],
                (string)result["page_link"],
                (string)result["description"],
                (string)result["page_rewrite"],
                (string)result["user_name"],
                (DateTime)result["time_created"]
            ));
        }
        return pageAccessLog.ToArray();
    }
}