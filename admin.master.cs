using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.Services;
using System.Data.SqlClient;
using System.IO;
using System.IO.Compression;
using System.Text;

public partial class admin : System.Web.UI.MasterPage
{
    public PageAccess currentPage;
    public User currentUser { get; set; }
    public Dictionary<string, int> dynamicStates { get; set; }

    protected void Page_Init(object sender, EventArgs e)
    {
        CheckQueryStrings();

        currentUser = new User(HttpContext.Current.User.Identity.Name);
        currentPage = new PageAccess(Path.GetFileName(HttpContext.Current.Request.Url.AbsolutePath));
        hiddenPageInfo.Value = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(currentPage);

        SetActiveTab();

        contentWrapper.Attributes.Add("data-style", commons.GetRandomBackgroundStyle());

        string anonUserId = commons.GetAnonymousUserID();
        SetupSortables(anonUserId);
        SetupStates(anonUserId);

        SetupWeather();
        
        if (Request.IsAuthenticated)
        {
            SetupAuthenicatedInterface();
        }
        else
        {
            if (currentPage.UserAccess || currentPage.Inactive)
            {
                if (Request.UrlReferrer != null)
                {
                    if (Path.GetFileName(Request.UrlReferrer.AbsolutePath) == currentPage.Link)
                    {
                        Response.Redirect("/");
                    }
                    Response.Redirect(Request.UrlReferrer.AbsoluteUri);
                }
                Response.Redirect("/");
            }
            lvLoggedIn.Visible = false;
            lblUsernameTopbar.Text = "Sign In";
        }
        
        if (Request.Cookies["sidebar-collapse"] != null)
        {
            if (Request.Cookies["sidebar-collapse"].Value == "true")
            {
                AdminBody.AddCssClass("sidebar-collapse");
            }
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        
    }

    private void SetupAuthenicatedInterface()
    {
        if (currentPage.AdminAccess || currentPage.Inactive)
        {
            if (!currentUser.Admin)
            {
                if (Request.UrlReferrer != null)
                {
                    Response.Redirect(Request.UrlReferrer.AbsoluteUri);
                }
                else
                {
                    Response.Redirect("/");
                }
            }
        }

        if (currentUser.Admin)
        {
            phAdminFunctions.Visible = true;
            klAdminModals.Visible = true;
        }

        SetupTodoItems();
        SetupNotifications();
        SetupConversations();
        SetupFriends();

        switch (currentUser.OnlineStatus)
        {
            case User.OnlineStatusType.Online:
                btnOnlineStatusMenu.InnerHtml = "<i class='fa fa-circle text-success'></i>&nbsp;Online";
                break;
            case User.OnlineStatusType.Busy:
                btnOnlineStatusMenu.InnerHtml = "<i class='fa fa-circle text-yellow'></i>&nbsp;Busy";
                break;
            case User.OnlineStatusType.Offline:
                btnOnlineStatusMenu.InnerHtml = "<i class='fa fa-circle text-danger'></i>&nbsp;Offline";
                break;
        }

        lvNotLoggedIn.Visible = false;
        lblUsernameDropdown.Text = currentUser.FullName;
        lblUsernameTopbar.Text = currentUser.FullName;
        lblTagline.Text = currentUser.Tagline;
        lblMemberSince.Text = currentUser.TimeCreated.ToString("MMM. yyyy");
        imgCollapsedProfileImage.ImageUrl = currentUser.Avatar;
        imgNavbarProfileImage.ImageUrl = currentUser.Avatar;
        currentUser.PasswordHash = null;
        currentUser.PasswordSalt = null;
        hiddenUserInfo.Value = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(currentUser);
    }

    private void SetupSortables(string anonUserId)
    {
        string sql = "SELECT * FROM custom_sort_orders WHERE page_id = @page_id AND ";
        Dictionary<string, object> sortableParams = new Dictionary<string, object>
        {
            { "@page_id", currentPage.PageID }
        };

        if (Request.IsAuthenticated)
        {
            sql += "user_name = @user_name";
            sortableParams.Add("@user_name", HttpContext.Current.User.Identity.Name);
        }
        else
        {
            sql += "anonymous_user_id = @anonymous_user_id";
            sortableParams.Add("@anonymous_user_id", anonUserId);
        }

        ResultSet sortableResultSet = commons.ExecuteQuery(sql, sortableParams);
        foreach (Result sortableResult in sortableResultSet)
        {
            Control sortableDiv = Page.FindRecursive((string)sortableResult["element_id"]);
            sortableDiv.Parent.Controls.Remove(sortableDiv);
            Page.FindRecursive((string)sortableResult["container_id"]).Controls.Add(sortableDiv);
        }
    }

    private void SetupStates(string anonUserId)
    {
        string sql = "SELECT * FROM custom_box_states WHERE page_id = @page_id AND ";

        Dictionary<string, object> stateParams = new Dictionary<string, object>
        {
            { "@page_id", currentPage.PageID }
        };

        if (Request.IsAuthenticated)
        {
            sql += "user_name = @user_name";
            stateParams.Add("@user_name", HttpContext.Current.User.Identity.Name);
        }
        else
        {
            sql += "anonymous_user_id = @anonymous_user_id";
            stateParams.Add("@anonymous_user_id", anonUserId);
        }

        ResultSet stateResultSet = commons.ExecuteQuery(sql, stateParams);
        List<string> collapsedElements = new List<string>();
        dynamicStates = new Dictionary<string, int>();
        foreach (Result stateResult in stateResultSet)
        {
            if (Convert.ToBoolean(stateResult["dynamic"])) {
                dynamicStates.Add((string)stateResult["element_id"], (int)stateResult["box_state"]);
                continue;
            }
            Control stateDiv = Page.FindRecursive((string)stateResult["element_id"]);
            switch ((int)stateResult["box_state"])
            {
                case 0:
                    stateDiv.AddCssClass("collapsed-box");
                    collapsedElements.Add((string)stateResult["element_id"]);
                    break;
                case 1:
                    stateDiv.Visible = false;
                    break;
            }
        }
        hiddenBoxStates.Value = string.Join(",", collapsedElements.ToArray());
    }

    private void SetupTodoItems()
    {
        string todoItemsValue = "";
        TodoItem[] todoItems = currentUser.TodoItems(false);
        if (todoItems.Length > 0)
        {
            pnlTasksList.InnerHtml = "";
            lblTasksCount.InnerText = todoItems.Length.ToString();
            lblTasksInnerCount.InnerText = todoItems.Length.ToString();
        }
        else
        {
            pnlTasksList.InnerHtml = 
                "<li><a href='#' style='cursor:default;'>" +
                    "<i class='fa fa-check text-black'></i>&nbsp;You Haven't Saved Any Items" +
                "</a></li>";
        }
        foreach (TodoItem todoItem in todoItems)
        {
            todoItemsValue += todoItem.TableName + "-" + todoItem.PrimaryIdentifier + "|";
            pnlTasksList.Controls.Add(new LiteralControl(
                "<li data-todo_item_id='" + todoItem.TodoItemID + "'>" +
                    "<div class='notification-buttons'>" +
                        "<i class='fa fa-eye fa-2x' data-toggle='tooltip' data-original-title='View' onclick='window.location.href=\"" + todoItem.LinkBack + "\"'></i>" +
                        "<i class='fa fa-check-circle fa-2x' data-toggle='tooltip' data-original-title='Mark Completed' onclick=\"$(this).tooltip('hide');todoMenuDone(" + todoItem.TodoItemID.ToString() + ");\"></i>" +
                        "<i class='fa fa-trash fa-2x' data-toggle='tooltip' data-original-title='Delete' onclick=\"$(this).tooltip('hide');todoMenuDelete(" + todoItem.TodoItemID.ToString() + ");\"></i>" +
                    "</div>" +
                    "<a href='#'>" +
                        "<div class='pull-left text-center " + TodoItem.CssClasses.Background(todoItem.TodoType) + "' style='width:24px;height:24px;border-radius:50%;padding-top:5px;'>" +
                            "<i class='" + TodoItem.CssClasses.Icon(todoItem.TodoType) + "'></i>" +
                        "</div>" +
                        "<h3 class='ellipsis' style='max-width:initial;'>&nbsp;&nbsp;" + todoItem.Title + "</h3>" +
                    "</a>" +
                "</li>"
            ));
        }
        if (todoItemsValue.Length > 0)
        {
            todoItemsValue = todoItemsValue.Substr(0, todoItemsValue.Length - 1);
            hiddenTodoItems.Value = todoItemsValue;
        }
    }

    private void SetupNotifications()
    {
        Notification[] notifications = Notification.GetNotifications();
        int unviewedNotifications = 0;
        pnlNotificationList.InnerHtml = "";
        foreach (Notification notification in notifications)
        {
            if (!notification.Viewed)
            {
                unviewedNotifications++;
            }
            pnlNotificationList.Controls.Add(new LiteralControl(
                "<li data-notification_id='" + notification.NotificationID + "'" + (notification.Viewed ? "" : " class='bg-success'") + ">" +
                    "<div class='notification-buttons'>" +
                        "<i class='fa fa-eye fa-2x' data-toggle='tooltip' data-original-title='View' onclick=\"showNotificationBar(" + notification.NotificationID + ",'" + notification.Url + "')\"></i>" +
                        (notification.Description.Length > 0 ? "<i class='fa fa-info-circle fa-2x' data-toggle='tooltip' data-original-title='" + notification.Description + "'></i>" : "") +
                        (notification.Viewed ? "" : "<i class='fa fa-check-circle fa-2x' data-toggle='tooltip' data-original-title='Mark as Read' onclick=\"showNotificationBar(" + notification.NotificationID + ")\"></i>") +
                        "<i class='fa fa-trash fa-2x' data-toggle='tooltip' data-original-title='Delete' onclick='dismissNotificationBar(" + notification.NotificationID + ")'></i>" +
                    "</div>" +
                    "<a href='#'>" +
                        "<i class='fa " + notification.IconClass + "'></i> " + notification.Title +
                        "<span class='time pull-right text-sm'><i class='fa fa-clock-o'></i> " + notification.ElapsedTime + "</span>" +
                    "</a>" +
                "</li>"
            ));
        }
        if (notifications.Length == 0)
        {
            pnlNotificationList.Controls.Add(new LiteralControl(
                "<li>" +
                    "<a href='#' style='cursor:default;'>" +
                        "<i class='fa fa-check text-black'></i> No New Notifications" +
                    "</a>" +
                "</li>"
            ));
        }
        if (unviewedNotifications > 0)
        {
            lblYouHaveNotificationCount.InnerText = unviewedNotifications.ToString();
            lblNotificationCount.InnerText = unviewedNotifications.ToString();
        }
        else
        {
            lblNotificationCount.Visible = false;
        }
    }

    private void SetupConversations()
    {
        btnShowCreateConversation.Visible = true;
        List<Dictionary<string, object>> conversationsInfo = Conversation.GetConversations();
        int unreadCount = 0;
        pnlMessagesList.InnerHtml = "";
        string[] openConversations = new string[] { };
        if (Request.Cookies["open-conversations"] != null)
        {
            openConversations = Request.Cookies["open-conversations"].Value.Split(',');
        }
        foreach (Dictionary<string, object> conversationInfo in conversationsInfo)
        {
            unreadCount += (int)conversationInfo["Unread"];

            int unread = (int)conversationInfo["Unread"];
            string title = (string)conversationInfo["Title"];
            int conversationId = (int)conversationInfo["ConversationID"];

            pnlMessagesList.Controls.Add(new LiteralControl(
                "<li data-conversation_id='" + conversationId.ToString() + "'" + (unread > 0 ? " class='unread-conversation'" : "") + ">" +
                    "<a href='#'>" +
                        "<span data-toggle='tooltip' class='badge " + (unread > 0 ? "bg-green" : "bg-gray") + " pull-right chat-new-messages' data-original-title='" + unread + " Unread Messages'>" + unread + "</span>" +
                        "<h4>" +
                            title +
                        "</h4>" +
                    "</a>" +
                "</li>"
            ));

            bool collapsed = false;
            foreach(string openConversation in openConversations)
            {
                string[] convoSplit = openConversation.Split('|');
                if (convoSplit[0] == conversationId.ToString())
                {
                    if (convoSplit[1] == "true")
                    {
                        collapsed = true;
                    }
                    conversationsContainer.Controls.Add(new LiteralControl(
                        Conversation.CreateChatBox(conversationId, collapsed)
                    ));
                }
            }
        }
        if (conversationsInfo.Count == 0)
        {
            pnlMessagesList.Controls.Add(new LiteralControl(
                "<li>" +
                    "<a href='#'>" +
                        "<h4 class='text-center text-italic'>No Conversations</h3>" +
                    "</a>" +
                "</li>"
            ));
        }
        if (unreadCount == 0)
        {
            lblMessagesCount.AddCssClass("hidden");
        }
        else
        {
            lblMessagesCount.InnerText = unreadCount.ToString();
            lblMessagesMenuCount.InnerText = unreadCount.ToString();
        }
    }

    private void SetupFriends()
    {
        Friend[] friends = Friend.GetFriends();
        if (friends.Length == 0)
        {
            pnlFriendsList.Controls.Add(new LiteralControl(
                "<li>" +
                    "<a href=\"/introduction#friends\" class=\"text-italic\">" +
                        "<h4 class=\"pull-left\" style=\"margin:4px 7px 0 0;\">No Friends</h4>" +
                        "<i class='fa fa-2x fa-question-circle'></i>" +
                    "</a>" +
                "</li>"
            ));
        }
        foreach(Friend friend in friends)
        {
            pnlFriendsList.Controls.Add(new LiteralControl(
                "<li data-show_info=\"false\" data-username=\"" + friend.YourFriend.Username + "\" data-favorite=\"" + (friend.Favorite ? "true" : "false") + "\">" +
                    friend.YourFriend.DisplayHTML +
                    "<span class='pull-right' style='display:none;'>" +
                        "<i class='fa fa-comments' data-toggle='tooltip' data-original-title='Send Message'></i>" +
                        "<i class='fa fa-commenting" + (friend.Notes.Length > 0 ? " text-green" : "") + "' data-toggle='tooltip' data-html='true' data-original-title='" + (friend.Notes.Length > 0 ? friend.Notes : "Attach Comment") + "'></i>" +
                        "<i class='fa fa-star" + (friend.Favorite ? " text-yellow" : "") + "' data-toggle='tooltip' data-original-title='" + (friend.Favorite ? "Unfavorite" : "Favorite") + "'></i>" +
                    "</span>" +
                "</li>"
            ));
        }
    }

    private void SetupWeather()
    {
        WeatherHourly[] nowWeather = WeatherHourly.GetWeather(true);
        if (nowWeather.Length == 1)
        {
            User.Measurement measureType = User.Measurement.Metric;
            if (Request.IsAuthenticated)
            {
                measureType = (User.Measurement)commons.GetFieldById("users", "measurement", "user_name", HttpContext.Current.User.Identity.Name);
            }
            currentWeatherIcon.Controls.Add(new LiteralControl(
                "<img src='https://www.kunminglive.com/dist/img/icons/weather/" + nowWeather[0].Icon + ".png' alt='Weather Icon: " + nowWeather[0].Icon + "' style='height:20px;margin-top:-3px;' />"
            ));
            lblWeatherNowTemperatureOuterC.InnerHtml = 
                "<span class='celsius-temp" + (measureType == User.Measurement.Metric ? "" : " hidden") + "'>" + nowWeather[0].Celsius.ToString("0") + "</span>" +
                "<span class='fahrenheit-temp" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "'>" + nowWeather[0].Fahrenheit.ToString("0") + "</span>&deg;";
            ddlWeatherDescription.InnerHtml = "<strong>Currently:&nbsp;</strong>" +
                "<span class='celsius-temp" + (measureType == User.Measurement.Metric ? "" : " hidden") + "'>" + nowWeather[0].Celsius.ToString("0") + "</span>" +
                "<span class='fahrenheit-temp" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "'>" + nowWeather[0].Fahrenheit.ToString("0") + "</span>&deg;&nbsp;" + nowWeather[0].Description;
        }
    }

    private void CheckQueryStrings()
    {
        if (Request.QueryString["confirm"] != null)
        {
            string confirmSql = "SELECT user_name FROM email_confirmations WHERE email_confirmation_identifier = @email_confirmation_identifier";
            ResultSet confirmResultSet = commons.ExecuteQuery(confirmSql, new Dictionary<string, object>
            {
                { "@email_confirmation_identifier", Request.QueryString["confirm"] }
            });
            if (confirmResultSet.Length == 1)
            {
                confirmSql = "UPDATE users SET email_confirmed = 1 WHERE user_name = '" + (string)confirmResultSet[0]["user_name"] + "';" +
                            "DELETE FROM email_confirmations WHERE user_name = '" + (string)confirmResultSet[0]["user_name"] + "';";
                commons.ExecuteQuery(confirmSql);
                commons.SetAuthCookie((string)confirmResultSet[0]["user_name"]);
                Response.Redirect("/");
            }
        }
    }

    private void SetActiveTab()
    {
        switch (Path.GetFileName(Request.Url.AbsolutePath).ToLower())
        {
            case "controltower.aspx":
                tabControlTower.Attributes.Add("class", "active");
                break;
            case "blog.aspx":
                tabBlog.Attributes.Add("class", "active");
                break;
            case "eventscalendar.aspx":
                tabEventsCalendar.Attributes.Add("class", "active");
                break;
            case "messageboard.aspx":
                switch (Request.QueryString["f"])
                {
                    case "3":
                        tabGeneralDiscussion.Attributes.Add("class", "active");
                        break;
                    case "4":
                        tabKunmingLivnig.Attributes.Add("class", "active");
                        break;
                    case "5":
                        tabTravelTourism.Attributes.Add("class", "active");
                        break;
                    case "6":
                        tabGroupMeetups.Attributes.Add("class", "active");
                        break;
                    default:
                        tabForumList.Attributes.Add("class", "active");
                        break;
                }
                tabForum.Attributes.Add("class", "treeview active");
                break;
            case "corner.aspx":
                tabCorner.Attributes.Add("class", "active");
                break;
            case "businesses.aspx":
                switch (Request.QueryString["view"])
                {
                    case "restaurants":
                        tabRestaurants.Attributes.Add("class", "active");
                        break;
                    case "shopping":
                        tabShopping.Attributes.Add("class", "active");
                        break;
                    case "services":
                        tabServices.Attributes.Add("class", "active");
                        break;
                    case "entertainment":
                        tabEntertainment.Attributes.Add("class", "active");
                        break;
                    default:
                        tabBusinessesAll.Attributes.Add("class", "active");
                        break;
                }
                tabBusinesses.Attributes.Add("class", "treeview active");
                break;
            case "tips.aspx":
                tabTips.Attributes.Add("class", "active");
                break;
            case "resources.aspx":
                tabResources.Attributes.Add("class", "active");
                break;
            case "classifieds.aspx":
                switch (Request.QueryString["view"])
                {
                    case "marketplace":
                        tabMarketplace.Attributes.Add("class", "active");
                        break;
                    case "rentals":
                        tabEmployment.Attributes.Add("class", "active");
                        break;
                    case "employment":
                        tabRentals.Attributes.Add("class", "active");
                        break;
                    default:
                        tabClassifiedsAll.Attributes.Add("class", "active");
                        break;
                }
                tabClassifieds.Attributes.Add("class", "treeview active");
                break;
            case "weather.aspx":
                tabWeather.Attributes.Add("class", "active");
                break;
            case "adoption.aspx":
                tabAdoption.Attributes.Add("class", "active");
                break;
            case "privacypolicy.aspx":
                tabPrivacyPolicy.Attributes.Add("class", "active");
                break;
            case "termsofservice.aspx":
                tabToS.Attributes.Add("class", "active");
                break;
        }
    }
}