using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Friend
/// </summary>
public class Friend
{
    public Friend(string friendName, string notes, bool favorite)
    {
        YourFriend = new User(friendName);
        Notes = notes;
        Favorite = favorite;
    }

    public User YourFriend;
    public string Notes;
    public bool Favorite;

    public static Friend[] GetFriends(string username = null)
    {
        string sql = "SELECT * FROM friends WHERE user_name = @user_name and accepted = 1 ORDER BY favorite DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql, username ?? HttpContext.Current.User.Identity.Name);
        List<Friend> friends = new List<Friend>();
        foreach (Result result in resultSet)
        {
            friends.Add(new Friend(
                (string)result["friend_name"],
                username ?? (string)result["notes"],
                Convert.ToBoolean(result["favorite"])
            ));
        }
        return friends.ToArray();
    }

    public static bool? RequestFriend(string username, string notes = "")
    {
        if (username == HttpContext.Current.User.Identity.Name) { return null; }
        User sender = new User(HttpContext.Current.User.Identity.Name);
        User recipient = new User(username);
        Dictionary<string, object> friendsParams = new Dictionary<string, object>
        {
            { "@user_name", sender.Username },
            { "@friend_name", recipient.Username },
            { "@notes", "" }
        };
        string sql = "SELECT * FROM friends WHERE user_name = @user_name AND friend_name = @friend_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, friendsParams);
        if (resultSet.Length == 0)
        {
            sql = "INSERT INTO friends (user_name,friend_name,notes,favorite,accepted) VALUES (@user_name,@friend_name,@notes,0,0)";
            commons.ExecuteQuery(sql, friendsParams);
            commons.CreateNotification("Friend Request Received", "You have received a friend request from " + sender.FullName + ". Click \"Delete\" to Ignore. Click \"View\" to Accept.", Notification.Types.Request, sender.ProfileLink + "/accept-friend-pending", false, recipient.Username);
            string body = "You have received a friend request from " + sender.FullName + ".<br/><br/>View User Profile: <a href=\"" + sender.ProfileLink + "/accept-friend-pending\">" + sender.ProfileLink + "/accept-friend-pending</a><br/><br/>" +
                "Accept Friend Request: <a href\"" + sender.ProfileLink + "/accept-friend\">" + sender.ProfileLink + "/accept-friend</a>";
            commons.SendEmail(recipient, "Kunming LIVE! Friend Request", body);
            return true;
        }
        else { return false; }
    }

    public static bool? AcceptFriend(string username, string notes = "")
    {
        if (username == HttpContext.Current.User.Identity.Name) { return null; }
        User sender = new User(username);
        User recipient = new User(HttpContext.Current.User.Identity.Name);
        string sql = "SELECT accepted FROM friends WHERE user_name = @user_name AND friend_name = @friend_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", sender.Username },
            { "@friend_name", recipient.Username }
        });
        if (resultSet.Length == 1)
        {
            if (!Convert.ToBoolean(resultSet[0]["accepted"]))
            {
                sql = "UPDATE friends SET accepted = 1 WHERE user_name = @user_name AND friend_name = @friend_name";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@user_name", sender.Username },
                    { "@friend_name", recipient.Username }
                });

                sql = "INSERT INTO friends (user_name,friend_name,notes,favorite,accepted) VALUES (@user_name,@friend_name,@notes,0,1)";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@user_name", recipient.Username },
                    { "@friend_name", sender.Username },
                    { "@notes", notes }
                });

                commons.CreateNotification("Friend Request Accepted", "Your friend request has been accepted by " + recipient.FullName + ". You may contact them through the right sidebar.", Notification.Types.Request, recipient.ProfileLink, false, sender.Username);
                string body = "Your friend request has been accepted by " + recipient.FullName + ". You may view their profile by following the link below, and may easily contact them through the right sidebar on the website.<br/><br/><a href=\"" + recipient.ProfileLink + "\">" + recipient.ProfileLink + "</a>";
                commons.SendEmail(sender, "Kunming LIVE! Friend Request Accepted", body);
                return true;
            } else { return false; }
        }
        else { return false; }
    }

    public static void AddFriendNote(string note, string username)
    {
        string sql = "UPDATE friends SET notes = @notes WHERE user_name = @user_name AND friend_name = @friend_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@notes", note },
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@friend_name", username }
        });
    }

    public static void FavoriteFriend(bool favorite, string username)
    {
        string sql = "UPDATE friends SET favorite = @favorite WHERE user_name = @user_name AND friend_name = @friend_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@favorite", favorite },
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@friend_name", username }
        });
    }
}