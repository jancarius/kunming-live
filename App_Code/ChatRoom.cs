using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Data Structure Class for Chat Rooms
/// </summary>
public class ChatRoom
{
    public ChatRoom(string createdUsername, string joinedUsername, string title, string description, string name, bool privateChat, bool inactive)
    {
        Creator = new User(createdUsername);
        Joiner = new User(joinedUsername);
        Title = title;
        Description = description;
        Name = name;
        Private = privateChat;
        Inactive = inactive;
    }

    public User Creator { get; set; }
    public User Joiner { get; set; }
    public bool IsCreator { get { return HttpContext.Current.User.Identity.Name == Creator.Username; } }
    public string Title { get; set; }
    public string Description { get; set; }
    public string Name { get; set; }
    public bool Private { get; set; }
    public bool Inactive { get; set; }

    public static ChatRoom[] GetChatRooms()
    {
        List<ChatRoom> chatRooms = new List<ChatRoom>();
        string sql = "SELECT * FROM chat_rooms WHERE inactive = 0 AND joined_user_name IS NULL";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            chatRooms.Add(new ChatRoom(
                (string)result["created_user_name"],
                result["joined_user_name"] as string,
                (string)result["chat_room_title"],
                (string)result["chat_room_description"],
                (string)result["chat_room_name"],
                Convert.ToBoolean(result["private"]),
                Convert.ToBoolean(result["inactive"])
            ));
        }
        return chatRooms.ToArray();
    }

    public static bool? CreateChatRoom(string roomTitle, string roomDescription, string roomName, bool isPrivate)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        string sql = "DELETE FROM chat_rooms WHERE created_user_name = @user_name OR joined_user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name }
        });

        sql = "INSERT INTO chat_rooms (created_user_name,chat_room_title,chat_room_description,chat_room_name,private,inactive) VALUES (@created_user_name,@chat_room_title,@chat_room_description,@chat_room_name,@private,0)";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@created_user_name", HttpContext.Current.User.Identity.Name },
            { "@chat_room_title", roomTitle },
            { "@chat_room_description", roomDescription },
            { "@chat_room_name", roomName },
            { "@private", isPrivate }
        });
        return true;
    }
}