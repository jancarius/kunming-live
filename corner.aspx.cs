using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

public partial class corner : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ChatRoom[] chatRooms = ChatRoom.GetChatRooms();
        if (chatRooms.Length > 0)
        {
            foreach (ChatRoom chatRoom in chatRooms)
            {
                showChatRooms.Controls.Add(new LiteralControl(
                    "<tr class='chat-room-row' data-room_id='" + chatRoom.Name + "' data-is_creator='" + chatRoom.IsCreator + "'>" +
                        "<td><img src='" + chatRoom.Creator.Avatar + "' class='img-circle profile-img' /></td>" +
                        "<td>" + chatRoom.Creator.FullName + "</td>" +
                        "<td>" + chatRoom.Title + "</td>" +
                        "<td>" + chatRoom.Description + "</td>" +
                    "</tr>"
                ));
            }
        } else { showChatRooms.Controls.Add(new LiteralControl("<tr class='no-chats-available'><td class='text-center' colspan='4'><em>None Available</em></td></tr>")); }
    }

    [WebMethod]
    public static bool? CreateChat(string roomTitle, string roomDescription, string roomName, bool isPrivate)
    {
        return ChatRoom.CreateChatRoom(roomTitle, roomDescription, roomName, isPrivate);
    }

    [WebMethod]
    public static ChatRoom[] GetChats()
    {
        return ChatRoom.GetChatRooms();
    }

    [WebMethod]
    public static void UserJoined(string username, string chatRoomName)
    {
        string sql = "UPDATE chat_rooms SET joined_user_name = @joined_user_name WHERE chat_room_name = @chat_room_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@joined_user_name", username },
            { "@chat_room_name", chatRoomName }
        });
    }

    [WebMethod]
    public static bool? UserLeft(string username, string chatRoomName)
    {
        string sql = "SELECT * FROM chat_rooms WHERE created_user_name = @user_name OR joined_user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username }
        });
        if (resultSet.Length > 0)
        {
            Result result = resultSet[0];
            if ((string)result["joined_user_name"] as string == username)
            {
                sql = "UPDATE chat_rooms SET joined_user_name = null WHERE chat_room_name = @chat_room_name";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@chat_room_name", chatRoomName }
                });
                return true;
            }
            else if (result["created_user_name"] as string == username)
            {
                sql = "DELETE FROM chat_rooms WHERE chat_room_name = @chat_room_name";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@chat_room_name", chatRoomName }
                });
                return false;
            }
            else { return null; }
        }
        else { return null; }
    }

    [WebMethod]
    public static void CloseRoom(string username)
    {
        string sql = "DELETE FROM chat_rooms WHERE created_user_name = @created_user_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@created_user_name", username }
        });
    }
}