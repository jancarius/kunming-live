<%@ WebService Language="C#" Class="master" %>

using System;
using System.IO;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class master : WebService
{
    [WebMethod]
    public bool? SaveBlogPost(BlogPost.PostTypes type, string title, string description, string content, string[] tags)
    {
        if (!global::User.VerifyAdmin()) return null;
        BlogPost.CreateBlogPost(HttpContext.Current.User.Identity.Name, type, title, description, content, tags);
        return true;
    }

    [WebMethod]
    public bool? SaveTip(string title, string mainImage, string description)
    {
        return Tip.CreateTip(title, mainImage, description);
    }

    [WebMethod]
    public bool? AddPage(string link, string description, bool admin, bool users)
    {
        if (!global::User.VerifyAdmin()) { return null; }
        PageAccess.CreatePage(link, description, admin, users);
        return true;
    }

    [WebMethod]
    public bool? AddAdmin(string fullName)
    {
        if (!global::User.VerifyAdmin()) { return null; }
        ResultSet resultSet = commons.ExecuteQuery("SELECT user_name,admin FROM users WHERE full_name = @full_name", fullName);
        if (resultSet.Length != 1) { return null; }
        if (Convert.ToBoolean(resultSet[0]["admin"])) { return false; }

        commons.ExecuteQuery("UPDATE users SET admin = 1 WHERE full_name = @full_name", fullName);

        YAF.Core.RoleMembershipHelper.AddUserToRole((string)resultSet[0]["user_name"], "Administrators");

        return true;
    }

    [WebMethod]
    public bool SaveSortables(Dictionary<string, object>[] sortableData, string pageLink)
    {
        PageAccess currentPage = new PageAccess(Path.GetFileName(pageLink));

        string anonUserId = commons.GetAnonymousUserID();

        string sortableSql = "DELETE FROM custom_sort_orders WHERE page_id = @page_id AND ";
        Dictionary<string, object> sortableParams = new Dictionary<string, object> {
            { "@page_id", currentPage.PageID }
        };

        if (HttpContext.Current.Request.IsAuthenticated)
        {
            sortableSql += "user_name = @user_name;";
            sortableParams.Add("@user_name", HttpContext.Current.User.Identity.Name);
        }
        else
        {
            sortableSql += "anonymous_user_id = @anonymous_user_id;";
            sortableParams.Add("@anonymous_user_id", anonUserId);
        }

        for (int i = 0; i < sortableData.Length; i++)
        {
            sortableSql += "INSERT INTO custom_sort_orders (" + (HttpContext.Current.Request.IsAuthenticated ? "user_name" : "anonymous_user_id") + ",page_id,element_id,container_id,sort_order) " +
                    "VALUES (" + (HttpContext.Current.Request.IsAuthenticated ? "@user_name" : "@anonymous_user_id") + ",@page_id,@element_id" + i + ",@container_id" + i + ",@sort_order" + i + ");";
            sortableParams.Add("@element_id" + i, sortableData[i]["elementId"]);
            sortableParams.Add("@container_id" + i, sortableData[i]["containerId"]);
            sortableParams.Add("@sort_order" + i, sortableData[i]["sortOrder"]);
        }

        commons.ExecuteQuery(sortableSql, sortableParams);

        return true;
    }

    [WebMethod]
    public bool SaveBoxState(string elementId, string elementTitle, int boxState, bool dynamic, string tableName = null, int? primaryId = null, bool hidden = false)
    {
        PageAccess currentPage = new PageAccess(Path.GetFileName(HttpContext.Current.Request.UrlReferrer.AbsolutePath));
        string anonUserId = commons.GetAnonymousUserID();

        string boxStateSql = "SELECT * FROM custom_box_states WHERE page_id = @page_id AND element_id = @element_id AND ";
        Dictionary<string, object> boxStateParams = new Dictionary<string, object>
        {
            { "@page_id", currentPage.PageID },
            { "@element_id", elementId },
            { "@element_title", elementTitle },
            { "@box_state", boxState },
            { "@dynamic", dynamic },
            { "@table_name", string.IsNullOrEmpty(tableName) ? (object)DBNull.Value : tableName },
            { "@primary_identifier", primaryId.HasValue ? primaryId.Value : (object)DBNull.Value },
            { "@hidden", hidden }
        };

        if (HttpContext.Current.Request.IsAuthenticated)
        {
            boxStateSql += "user_name = @user_name";
            boxStateParams.Add("@user_name", HttpContext.Current.User.Identity.Name);
        }
        else
        {
            boxStateSql += "anonymous_user_id = @anonymous_user_id;";
            boxStateParams.Add("@anonymous_user_id", anonUserId);
        }

        ResultSet boxStateResultSet = commons.ExecuteQuery(boxStateSql, boxStateParams);

        string boxStateInsertSql = "INSERT INTO custom_box_states (" + (HttpContext.Current.Request.IsAuthenticated ? "user_name" : "anonymous_user_id") + ",page_id,element_id,element_title,box_state,dynamic,table_name,primary_identifier,hidden) " +
                                    "VALUES (" + (HttpContext.Current.Request.IsAuthenticated ? "@user_name" : "@anonymous_user_id") + ",@page_id,@element_id,@element_title,@box_state,@dynamic,@table_name,@primary_identifier,@hidden);";
        if (boxStateResultSet.Length > 0)
        {
            string boxStateDeleteSql = "DELETE FROM custom_box_states WHERE page_id = @page_id AND element_id = @element_id AND " + (HttpContext.Current.Request.IsAuthenticated ? "user_name = @user_name" : "anonymous_user_id = @anonymous_user_id") + ";";
            if ((int)boxStateResultSet[0]["box_state"] == 0 && boxState == 1)
            {
                boxStateSql = boxStateDeleteSql + boxStateInsertSql;
            }
            else
            {
                boxStateSql = boxStateDeleteSql;
            }
        }
        else { boxStateSql = boxStateInsertSql; }

        commons.ExecuteQuery(boxStateSql, boxStateParams);

        return true;
    }

    [WebMethod]
    public bool? SaveTodoItem(string tableName, string primaryIdentifier, string linkBack, TodoItem.TodoTypes todoType, string title, bool remove)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        if (!remove)
        {
            return TodoItem.CreateTodoItem(tableName, primaryIdentifier, linkBack, todoType, title);
        }
        else
        {
            return TodoItem.RemoveTodoItem(tableName, primaryIdentifier);
        }
    }

    [WebMethod]
    public void UpdateOnlineStatus(User.OnlineStatusType onlineStatus)
    {
        global::User.UpdateOnlineStatus(onlineStatus);
    }

    [WebMethod]
    public void ViewNotification(int notificationId)
    {
        string sql = "UPDATE notifications SET viewed = 1 WHERE notification_id = " + notificationId;
        commons.ExecuteQuery(sql);
    }

    [WebMethod]
    public void DismissNotification(int notificationId)
    {
        string sql = "UPDATE notifications SET dismissed = 1,viewed = 1 WHERE notification_id = " + notificationId;
        commons.ExecuteQuery(sql);
    }

    [WebMethod]
    public bool TodoItemDone(int[] todoItemIds, bool done)
    {
        string sql = "UPDATE todo_items SET done = " + (done ? "1" : "0") + " WHERE todo_item_id IN (" + string.Join(",", todoItemIds.Select(x => x.ToString()).ToArray()) + ") AND user_name = '" + HttpContext.Current.User.Identity.Name + "';";
        commons.ExecuteQuery(sql);

        return true;
    }

    [WebMethod]
    public void DeleteTodoItem(int[] deleteItems)
    {
        string sql = "DELETE FROM todo_items WHERE todo_item_id IN (" + string.Join(",", deleteItems.Select(x => x.ToString()).ToArray()) + ")";
        commons.ExecuteQuery(sql);
    }

    [WebMethod]
    public User GetUser(int userId)
    {
        return new User(userId);
    }

    [WebMethod]
    public string[] GetBlogTags()
    {
        return BlogPost.GetBlogTagsArray();
    }

    [WebMethod]
    public string[] GetBusinessTags()
    {
        return Business.GetBusinessTagsArray();
    }

    [WebMethod]
    public Review[] GetReviews(string tableName, int primaryId)
    {
        Review[] reviews = Review.GetReviews(tableName, primaryId);
        Array.Sort(reviews, delegate (Review x, Review y) { return (x.UpVotes - x.DownVotes).CompareTo(y.UpVotes - y.DownVotes); });
        return reviews;
    }

    [WebMethod]
    public object SaveReview(string tableName, int primaryId, string title, int? rating, string comment, string[] reviewImages)
    {
        return Review.CreateReview(tableName, primaryId, rating, title, comment, reviewImages);
    }

    [WebMethod]
    public bool? AddVote(int reviewId, ReviewVote.VoteType voteType)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        return ReviewVote.CreateVote(reviewId, voteType);
    }

    [WebMethod]
    public bool CheckDisplayName(string displayName)
    {
        return global::User.CheckDisplayName(displayName);
    }

    [WebMethod]
    public string ResizeImage(string base64Image, string moveDirectory)
    {
        string imageExtension = base64Image.Substring(11, base64Image.IndexOf(";") - 11);
        byte[] bytes = Convert.FromBase64String(base64Image.Substring(base64Image.IndexOf(",") + 1));

        string fileName = Guid.NewGuid().ToString() + "." + imageExtension;

        string returnPath = "";
        using (MemoryStream ms = new MemoryStream(bytes))
        {
            Image image = Image.FromStream(ms);
            returnPath = commons.ResizeImage(image, imageExtension);
            if (moveDirectory != null)
            {
                returnPath = commons.SaveBase64Image(returnPath, moveDirectory);
            }
        }
        return returnPath;
    }

    [WebMethod]
    public void MoveTempImage(string tempImagePath, string directory)
    {
        commons.SaveBase64Image(tempImagePath, directory);
    }

    [WebMethod]
    public bool CheckLogin()
    {
        return HttpContext.Current.Request.IsAuthenticated;
    }

    [WebMethod]
    public bool? ApproveEvent(int eventId, bool approved, string deniedReason = "")
    {
        return Event.ApproveEvent(eventId, approved, deniedReason);
    }

    [WebMethod]
    public bool? ApproveBusiness(int businessId, bool approved, string deniedReason = "")
    {
        return Business.ApproveBusiness(businessId, approved, deniedReason);
    }

    [WebMethod]
    public void AddFriendNote(string note, string username)
    {
        Friend.AddFriendNote(note, username);
    }

    [WebMethod]
    public void FavoriteFriend(bool favorite, string username)
    {
        Friend.FavoriteFriend(favorite, username);
    }

    [WebMethod]
    public bool CheckUsername(string username)
    {
        return global::User.CheckUsername(username);
    }

    [WebMethod]
    public bool CheckEmail(string email)
    {
        return global::User.CheckEmail(email);
    }

    [WebMethod]
    public Dictionary<string, List<Dictionary<string, object>>> Search(string searchText)
    {
        Dictionary<string, List<Dictionary<string, object>>> searchResults = new Dictionary<string, List<Dictionary<string, object>>>();

        // Search Blog/Articles
        string sql = "SELECT * FROM blog_posts WHERE title LIKE '%' + @search_text + '%' OR description LIKE '%' + @search_text + '%' OR full_content LIKE '%' + @search_text + '%' OR " +
                "blog_post_id IN (SELECT DISTINCT blog_post_id FROM blog_post_tags WHERE tag LIKE '%' + @search_text + '%')";
        ResultSet resultSet = commons.ExecuteQuery(sql, searchText);
        searchResults.Add("Blog/Articles", new List<Dictionary<string, object>>());
        foreach (Result result in resultSet)
        {
            searchResults["Blog/Articles"].Add(new Dictionary<string, object>
            {
                { "BlogID", (int)result["blog_post_id"] },
                { "Title", (string)result["title"] },
                { "Content", (string)result["full_content"] },
                { "Link", "https://www.kunminglive.com/blog-posts/" + Convert.ToString(result["blog_post_id"]).ToString() + "/" + Convert.ToString(result["title"]).Replace(" ", "-") }
            });
        }

        // Events Calendar
        sql = "SELECT * FROM events WHERE business_name LIKE '%' + @search_text + '%' OR title LIKE '%' + @search_text + '%' OR location LIKE '%' + @search_text + '%' OR details LIKE '%' + @search_text + '%'";
        resultSet = commons.ExecuteQuery(sql, searchText);
        searchResults.Add("Events Calendar", new List<Dictionary<string, object>>());
        foreach (Result result in resultSet)
        {
            searchResults["Events Calendar"].Add(new Dictionary<string, object>
            {
                { "EventID", (int)result["event_id"] },
                { "Business", (string)result["business_name"] },
                { "Title", (string)result["title"] },
                { "Location", (string)result["location"] },
                { "Details", (string)result["details"] },
                { "Link", "https://www.kunminglive.com/events-calendar/" + Convert.ToString(result["event_id"]) + "/" + Convert.ToString(result["title"]).RemoveSpecialCharacters().Replace(" ", "-") }
            });
        }

        // Forum TODO


        // Local Businesses
        sql = "SELECT * FROM businesses WHERE description LIKE '%' + @search_text + '%' OR name_english LIKE '%' + @search_text + '%' OR name_chinese LIKE '%' + @search_text + '%' OR " +
                "address_english LIKE '%' + @search_text + '%' OR address_chinese LIKE '%' + @search_text + '%' OR city_english LIKE '%' + @search_text + '%' OR city_chinese LIKE '%' + @search_text + '%' OR " +
                "province_english LIKE '%' + @search_text + '%' OR province_chinese LIKE '%' + @search_text + '%' OR country_english LIKE '%' + @search_text + '%' OR country_chinese LIKE '%' + @search_text + '%' OR " +
                "business_id IN (SELECT DISTINCT business_id FROM business_tags WHERE tag LIKE '%' + @search_text + '%')";
        resultSet = commons.ExecuteQuery(sql, searchText);
        searchResults.Add("Local Businesses", new List<Dictionary<string, object>>());
        foreach (Result result in resultSet)
        {
            searchResults["Local Businesses"].Add(new Dictionary<string, object>
            {
                { "BusinessID", (int)result["business_id"] },
                { "Description", (string)result["description"] },
                { "Name", (string)result["name_english"] + " " + (string)result["name_chinese"] },
                { "Address (English)", (string)result["address_english"] },
                { "Address (Chinese)", (string)result["address_chinese"] },
                { "City (English)", (string)result["city_english"] },
                { "City (Chinese)", (string)result["city_chinese"] },
                { "Province (English)", (string)result["province_english"] },
                { "Province (Chinese)", (string)result["province_chinese"] },
                { "Country (English)", (string)result["country_english"] },
                { "Country (Chinese)", (string)result["country_chinese"] },
                { "Link", "https://www.kunminglive.com/things-to-do/" + Convert.ToString((Business.BusinessTypes)result["business_type"]).ToLower() + "/" + Convert.ToInt32(result["business_id"]).ToString() + "/" + Convert.ToString(result["name_english"]).RemoveSpecialCharacters().Replace(" ", "-") }
            });
        }

        // Tips & Tricks TODO
        sql = "SELECT * FROM tips WHERE title LIKE '%' + @search_text + '%' OR description LIKE '%' + @search_text + '%'";
        resultSet = commons.ExecuteQuery(sql, searchText);
        searchResults.Add("Tips & Tricks", new List<Dictionary<string, object>>());
        foreach (Result result in resultSet)
        {
            searchResults["Tips & Tricks"].Add(new Dictionary<string, object>
            {
                { "TipID", (int)result["tip_id"] },
                { "Title", (string)result["title"] },
                { "Description", (string)result["description"] },
                { "Link", "https://www.kunminglive.com/tips/" + Convert.ToString(result["tip_id"]) + "/" + Convert.ToString(result["title"]).RemoveSpecialCharacters().Replace(" ", "-") }
            });
        }

        // Traveler Resources TODO


        // Reviews TODO


        // Classifieds
        sql = "SELECT * FROM classified_posts WHERE post_title LIKE '%' + @search_text + '%' OR post_description LIKE '%' + @search_text + '%'";
        resultSet = commons.ExecuteQuery(sql, searchText);
        searchResults.Add("Classified Posts", new List<Dictionary<string, object>>());
        foreach(Result result in resultSet)
        {
            searchResults["Classified Posts"].Add(new Dictionary<string, object>
            {
                { "ClassifiedID", (int)result["classified_post_id"] },
                { "Title", (string)result["post_title"] },
                { "Description", (string)result["post_description"] },
                { "Link", "https://www.kunminglive.com/classifieds/" + Convert.ToString(result["category"]).ToLower() + "/" + Convert.ToString(result["classified_post_id"]) + "/" + Convert.ToString(result["post_title"]).RemoveSpecialCharacters().Replace(" ", "-") }
            });
        }

        return searchResults;
    }

    [WebMethod]
    public string GetChatBox(int conversationId)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        return Conversation.CreateChatBox(conversationId);
    }

    [WebMethod]
    public string CreateConversation(string title, string[] usernames, string message)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        return Conversation.CreateConversation(usernames, title, message);
    }

    [WebMethod]
    public int? SendMessage(int conversationId, string message)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        return Conversation.SendMessage(conversationId, message);
    }

    [WebMethod]
    public Conversation.UpdateData UpdateChats(List<Dictionary<string, string>> openChats, int lastConversationId)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        return Conversation.UpdateChats(openChats, lastConversationId);
    }

    [WebMethod]
    public void LeaveChat(int conversationId)
    {
        Conversation.LeaveChat(conversationId);
    }

    [WebMethod]
    public void InviteUser(int conversationId, string[] fullNames)
    {
        Conversation.InviteUser(conversationId, fullNames);
    }

    [WebMethod]
    public User[] GetFriends(string username = null)
    {
        if (username == null) { username = HttpContext.Current.User.Identity.Name; }
        return global::User.GetUsers();
    }

    [WebMethod(MessageName = "GetFriendNames")]
    public string[] GetUserFullNames()
    {
        return GetUserFullNames(null);
    }

    [WebMethod(MessageName = "GetFriendNamesExclude")]
    public string[] GetUserFullNames(string[] excludeUsernames)
    {
        string sql = "SELECT full_name FROM users WHERE user_name <> '" + HttpContext.Current.User.Identity.Name + "'";
        if (excludeUsernames != null)
        {
            sql += " AND full_name NOT IN ('" + string.Join("','", excludeUsernames) + "')";
        }
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<string> users = new List<string>();
        foreach (Result result in resultSet)
        {
            users.Add((string)result["full_name"]);
        }
        return users.ToArray();
    }

    [WebMethod]
    public bool? RequestFriend(string username)
    {
        return Friend.RequestFriend(username);
    }

    [WebMethod]
    public void UpdateUserMeasurement(User.Measurement measurement)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return; }
        string sql = "UPDATE users SET measurement = @measurement WHERE user_name = @user_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@measurement", measurement },
            { "@user_name", HttpContext.Current.User.Identity.Name }
        });
    }

    [WebMethod]
    public string[] GetNonAdmins()
    {
        string sql = "SELECT full_name FROM users WHERE admin = 0";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<string> nonAdmins = new List<string>();
        foreach(Result result in resultSet)
        {
            nonAdmins.Add((string)result["full_name"]);
        }
        return nonAdmins.ToArray();
    }

    [WebMethod]
    public bool? Signin(string username, bool rememberMe, string password)
    {
        return global::User.SigninUser(username, rememberMe, password);
    }

    [WebMethod]
    public string Register(string username, string password, string email)
    {
        return global::User.RegisterUser(username, password, email);
    }

    [WebMethod]
    public string RegisterSocial(string email, string name, string socialAuthToken, string picture)
    {
        return global::User.RegisterUser(null, null, email, name, socialAuthToken, picture, true);
    }

    [WebMethod]
    public void ForgotSignin(string username, string email)
    {
        global::User.ForgotSignin(username, email);
    }

    [WebMethod]
    public bool ResetPassword(string guid, string newPassword)
    {
        return global::User.ResetPassword(guid, newPassword);
    }

    [WebMethod]
    public void Signout()
    {
        HttpContext.Current.Response.Cookies.Clear();
        FormsAuthentication.SignOut();
    }

    [WebMethod]
    public bool JavascriptError(string message, string stringifyParams)
    {
        commons.LogError(new Exception(message), stringifyParams);
        return true;
    }
}