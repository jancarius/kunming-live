using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Web.Script.Serialization;
using System.Globalization;


public partial class controltower : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SetupBlogPost();
        SetupReviews();
        SetupEvents();
        SetupBusinesses();
        SetupClassifieds();
        SetupRecentUsers();

        if (Request.IsAuthenticated)
        {
            SetupTodoList();
            SetupStatsBox(ref lblYourPosts, Master.currentUser.PostCount);
        }
    }

    private void SetupEvents()
    {
        if (Request.IsAuthenticated)
        {
            string sql = "SELECT COUNT(event_attendee_id) FROM event_attendees WHERE user_name = '" + HttpContext.Current.User.Identity.Name + "'";
            ResultSet resultSet = commons.ExecuteQuery(sql);
            SetupStatsBox(ref lblYourEvents, (int)resultSet[0][""]);
        }

        CultureInfo culture = new CultureInfo("zh-CN");
        Event[] events = Event.GetEvents(DateTime.Now.AddMonths(1), DateTime.Now.AddMonths(-1));
        List<Event.EventJsObj> eventJsObjects = new List<Event.EventJsObj>();
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
                            TodoItem.CssClasses.Label(thisEvent.Type) + " clickable"
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
                        TodoItem.CssClasses.Label(thisEvent.Type) + " clickable"
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
                            TodoItem.CssClasses.Label(thisEvent.Type) + " clickable"
                        ));
                    }
                }
            }
        }
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        hiddenEventData.Value = serializer.Serialize(eventJsObjects);
    }

    private void SetupBlogPost()
    {
        BlogPost[] blogPosts = BlogPost.GetBlogPosts(3);
        foreach (BlogPost blogPost in blogPosts)
        {
            var previewContent = blogPost.PreviewContent;
            if (previewContent.Length > 200)
            {
                previewContent = previewContent.Substring(0, 200) + "...";
            }
            LiteralControl blogHtml = new LiteralControl(
                "<tr class='table-body'>" +
                    "<td class='col-xl-4 col-lg-5 col-xs-4'>" +
                        "<strong>" +
                            "<a href=\"" + blogPost.Link + "\"><h4 class='text-bold'>" + blogPost.Title + "</h4></a>" +
                            "<a href=\"" + blogPost.Author.ProfileLink + "\">" +
                                "<img src='" + blogPost.Author.Avatar + "' alt='" + blogPost.Author.Username + "' /> " +
                                blogPost.Author.FullName +
                            "</a><br />" +
                            "<span class='time'><i class='fa fa-clock-o'></i> " + blogPost.ElapsedTime + "</span>" +
                        "</strong>" +
                    "</td>" +
                    "<td class='col-xl-8 col-lg-7 col-xs-8 no-pad-left'>" + previewContent + "</td>" +
                "</tr>"
            );

            tblBlogPostsBody.Controls.Add(blogHtml);
        }
    }

    private void SetupReviews()
    {
        string sql = "SELECT TOP 5 * FROM reviews WHERE table_name = 'businesses' ORDER BY time_created DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            
        }

        if (Request.IsAuthenticated)
        {
            sql = "SELECT COUNT(review_id) FROM reviews WHERE user_id = " + Master.currentUser.UserID;
            resultSet = commons.ExecuteQuery(sql);
            if (resultSet.Length == 1)
            {
                SetupStatsBox(ref lblYourReviews, (int)resultSet[0][""]);
            }
        }
    }

    private void SetupBusinesses()
    {
        Business[] businesses = Business.GetBusinesses(Business.BusinessTypes.All, true, 5, "rating");
        int loopCount = (businesses.Length > 4 ? 5 : businesses.Length);
        for (int i = 0; i < loopCount; i++)
        {
            string tags = "";
            foreach (Business.BusinessTag tag in businesses[i].Tags)
            {
                tags += "<a href=\"" + tag.Link + "\"><span id='tag" + tag.Tag + "' title='" + tag.Tag + "' class='btn btn-xs btn-flat btn-primary tag-filters' style='margin: 0 0 5px 5px;'><i class='fa fa-tag'></i> " + tag.Tag + "</span></a>";
            }
            tblBusinessesBody.Controls.Add(new LiteralControl(
                "<div class='row table-body'>" +
                    "<div class='col-xl-2 col-md-3 col-sm-4 col-xs-5' style='vertical-align:middle;'>" +
                        "<a href=\"" + businesses[i].Link + "\"><img src='" + businesses[i].MainImagePath + "' alt='" + HttpUtility.HtmlEncode(businesses[i].Name.English) + "' class='img-responsive img-circle' /></a>" +
                    "</div>" +
                    "<div class='col-xl-10 col-md-9 col-sm-8 col-xs-7'>" +
                        "<a href=\"" + businesses[i].Link + "\">" +
                            "<h5 class='text-bold'>" +
                                businesses[i].Name.English + " " + businesses[i].Name.Chinese +
                            "</h5>" +
                        "</a>" +
                        "<div style='display:inline-block;'>" +
                            "<input type='radio' class='rating-input-static' value='5' name='rating-input-1_" + i + "' disabled " + (businesses[i].StarRating == 5 ? "checked" : "") + ">" +
                            "<label for='rating-input-1-5' class='rating-star'></label>" +
                            "<input type='radio' class='rating-input-static' value='4' name='rating-input-1_" + i + "' disabled " + (businesses[i].StarRating == 4 ? "checked" : "") + ">" +
                            "<label for='rating-input-1-4' class='rating-star'></label>" +
                            "<input type='radio' class='rating-input-static' value='3' name='rating-input-1_" + i + "' disabled " + (businesses[i].StarRating == 3 ? "checked" : "") + ">" +
                            "<label for='rating-input-1-3' class='rating-star'></label>" +
                            "<input type='radio' class='rating-input-static' value='2' name='rating-input-1_" + i + "' disabled " + (businesses[i].StarRating == 2 ? "checked" : "") + ">" +
                            "<label for='rating-input-1-2' class='rating-star'></label>" +
                            "<input type='radio' class='rating-input-static' value='1' name='rating-input-1_" + i + "' disabled " + (businesses[i].StarRating == 1 ? "checked" : "") + ">" +
                            "<label for='rating-input-1-1' class='rating-star'></label>" +
                        "</div>" +
                        "<div class='col-xs-12 no-padding'>" +
                            tags +
                        "</div>" +
                    "</div>" +
                "</div>"
            ));
        }
    }

    private void SetupClassifieds()
    {
        Classified[] posts = Classified.GetClassifieds(null, 5);
        foreach (Classified post in posts)
        {
            tblClassifiedsBody.Controls.Add(new LiteralControl(
                "<tr class='table-body clickable' onclick='window.location.href = \"" + post.Link + "\"'>" +
                    "<td class='col-xs-2 text-right'>" +
                        "<span id='showClassifiedCategory' class='" + post.LabelClass + "' style='font-size:12px !important;padding:0 3px 2px 5px !important;'>" + post.Category.ToString() + "</span>" +
                    "</td>" +
                    "<td class='col-xl-8 col-lg-7 col-sm-7 col-xs-10 ellipsis' data-toggle='tooltip' data-original-title='" + post.Title + "'>" +
                        "<h5 class='text-bold' style='display:inline'>" + post.Title + "</h5>" +
                    "</td>" +
                    "<td class='col-xl-2 col-lg-3 hidden-md col-sm-3 hidden-xs'>" +
                        "<span class='time pull-right'><i class='fa fa-clock-o'></i>&nbsp;" + post.TimeSince + "</span>" +
                    "</td>" +
                "</tr>"
            ));
        }
    }

    private void SetupTodoList()
    {
        TodoItem[] todoItems = Master.currentUser.TodoItems();
        SetupStatsBox(ref lblYourTodo, todoItems.Length);
        int todoCount = 0;
        int doneCount = 0;
        foreach (TodoItem todoItem in todoItems)
        {
            LiteralControl todoHtml = new LiteralControl(
                "<li id='todoListItem-" + todoItem.TodoItemID + "' data-todo_item_id='" + todoItem.TodoItemID + "' class='todo-list-item clickable' onclick=\"$('.loading-overlay').show();window.location.href='" + todoItem.LinkBack + "'\" style='padding-left:5px;'>" +
                    "<div class='col-xl-1 col-lg-2 col-md-2 col-sm-1 col-xs-2 no-padding text-center handle ui-sortable-handle' style='margin:0;'>" +
                        "<i class='fa fa-ellipsis-v'></i> <i class='fa fa-ellipsis-v'></i>" +
                        "<input type='checkbox' onclick='showTodoListButtons()' style='margin:0 5px;position:relative;top:1px;left:1px;' />" +
                    "</div>" +
                    "<div class='col-xl-9 col-lg-7 col-md-6 col-sm-9 col-xs-7 no-padding text ellipsis' style='max-width:initial;display:inline;margin:0;' data-toggle='tooltip' data-original-title=\"" + todoItem.Title + "\">" + todoItem.Title + "</div>" +
                    "<div class='col-xl-2 col-lg-3 col-md-4 col-sm-2 col-xs-3 no-padding' style='top:4px;'>" +
                        "<small class='label todo-type-label-" + todoItem.TodoType + "'>" + Enum.GetName(typeof(TodoItem.TodoTypes), todoItem.TodoType) + "</small>" +
                    "</div>" +
                    "<div class='clearfix'></div>" +
                "</li>"
            );
            if (todoItem.Done)
            {
                doneCount++;
                lstTodoItemsDone.Controls.Add(todoHtml);
            }
            else
            {
                todoCount++;
                lstTodoItems.Controls.Add(todoHtml);
            }
            if (doneCount > 0) { noTodoItemsDone.AddCssClass("hidden"); }
            if (todoCount > 0) { noTodoItems.AddCssClass("hidden"); }
        }
    }

    private void SetupRecentUsers()
    {
        PageAccessLog[] pageAccessLog = PageAccessLog.GetRecentPageAccess();
        tblRecentUsersBody.InnerHtml = "";
        if (pageAccessLog.Length > 0) {
            tblRecentUsersBody.Controls.Add(new LiteralControl(
                "<tr>" +
                    "<th class='col-xxl-6 col-lg-6 col-xs-7' style='padding:0 0 0 8px;'>User</th>" +
                    "<th class='col-lg-4 col-sm-5 col-xs-4' style='padding:0 0 0 8px;'>Page</th>" +
                    "<th class='col-lg-2 col-sm-1 hidden-md hidden-xs' style='padding:0 8px;'>Activity</th>" +
                "</tr>"
            ));
        }
        foreach (PageAccessLog pageAccess in pageAccessLog)
        {
            if (pageAccess.User.OnlineStatus == global::User.OnlineStatusType.Offline) { continue; }
            tblRecentUsersBody.Controls.Add(new LiteralControl(
                "<tr class='table-body'>" +
                    "<td style='position:relative;'>" +
                        pageAccess.User.DisplayHTML +
                    "</td>" +
                    "<td class='no-pad-right ellipsis' style='vertical-align:middle;'><a href='" + pageAccess.PageRewrite + "'>" + pageAccess.PageDescription + "</a></td>" +
                    "<td class='hidden-md hidden-xs' style='vertical-align:middle;'>" + "<span class='time'><i class='fa fa-clock-o'></i>&nbsp;" + commons.GetTimeSince(pageAccess.TimeCreated) + "</span></td>" +
                "</tr>"
            ));
        }
    }

    private void SetupStatsBox(ref HtmlGenericControl control, int count)
    {
        string countLabel = count.ToString();
        control.InnerText = countLabel;
        if (countLabel.Length == 1)
        {
            control.AddCssClass("resize-font-1");
        }
        else if (countLabel.Length == 2)
        {
            control.AddCssClass("resize-font-2");
        }
        else if (countLabel.Length == 3)
        {
            control.AddCssClass("resize-font-3");
        }
        else if (countLabel.Length == 4)
        {
            control.AddCssClass("resize-font-4");
        }
        else if (countLabel.Length == 5)
        {
            lblYourPosts.AddCssClass("resize-font-5");
        }
    }

    [WebMethod]
    public static bool SaveTodoList(Dictionary<string, object>[] sortableData)
    {
        foreach (Dictionary<string, object> sortable in sortableData)
        {
            if (((string)sortable["elementId"]).Contains("-"))
            {
                string elementId = ((string)sortable["elementId"]).Substring(((string)sortable["elementId"]).IndexOf("-") + 1);
                string sql = "UPDATE todo_items SET sort_order = @sort_order WHERE todo_item_id = @todo_item_id";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@sort_order", (int)sortable["sortOrder"] },
                    { "@todo_item_id", elementId }
                });
            }
        }
        return true;
    }
}