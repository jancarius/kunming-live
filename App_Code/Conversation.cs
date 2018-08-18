using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;

/// <summary>
/// Mailbox Data Structure Class
/// </summary>
public class Conversation
{
    public Conversation(int conversationId, string title, string username, DateTime timeCreated)
    {
        ConversationID = conversationId;
        Title = title;
        CreatedBy = username;
        TimeCreated = timeCreated;

        List<Message> messages = new List<Message>();
        Dictionary<int, Message> messagesById = new Dictionary<int, Message>();
        string sql = "SELECT * FROM conversation_messages WHERE conversation_id = " + conversationId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            Message message = new Message(
                (int)result["conversation_message_id"],
                this,
                new User((string)result["sender_user_name"]),
                (string)result["message_text"],
                (DateTime)result["time_created"]
            );
            messages.Add(message);
            messagesById.Add((int)result["conversation_message_id"], message);
        }

        List<Participant> participants = new List<Participant>();
        Dictionary<string, int> participantUsers = new Dictionary<string, int>();
        sql = "SELECT * FROM conversation_participants WHERE conversation_id = " + conversationId;
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            participantUsers.Add((string)result["user_name"], (int)result["conversation_participant_id"]);
        }
        User[] users = User.GetUsers(participantUsers.Keys.ToArray());
        foreach (User user in users)
        {
            Participant participant = new Participant(participantUsers[user.Username], this, user);
            participants.Add(participant);
        }

        sql = "SELECT * FROM conversation_receipts WHERE conversation_id = " + conversationId + " AND user_name = '" + HttpContext.Current.User.Identity.Name + "'";
        Receipts receipts = new Receipts();
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            bool unread = Convert.ToBoolean(result["unread"]);
            receipts.Add(messagesById[(int)result["conversation_message_id"]], unread);
            if (unread) { UnreadCount++; }
        }

        MessageReceipts = receipts;
        Participants = participants.ToArray();
        Messages = messages.ToArray();
    }

    public int ConversationID { get; private set; }
    public string Title { get; private set; }
    public string CreatedBy { get; private set; }
    public Participant[] Participants { get; private set; }
    public Message[] Messages { get; private set; }
    public Receipts MessageReceipts { get; private set; }
    public DateTime TimeCreated { get; private set; }
    public int UnreadCount { get; private set; }

    public static Conversation GetConversation(string[] usernames)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        string sql = "SELECT * FROM conversations WHERE conversation_id IN (SELECT conversation_id FROM conversation_participants GROUP BY conversation_id HAVING COUNT(conversation_participant_id) > 1)";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length == 1)
        {
            Result result = resultSet[0];

            return new Conversation(
                (int)result["conversation_id"],
                (string)result["title"],
                (string)result["created_by"],
                (DateTime)result["time_created"]
            );
        }
        else { return null; }
    }
    
    public static Conversation GetConversation(int conversationId)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        string sql = "SELECT * FROM conversations WHERE conversation_id = " + conversationId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length == 1)
        {
            Result result = resultSet[0];

            return new Conversation(
                (int)result["conversation_id"],
                (string)result["title"],
                (string)result["created_by"],
                (DateTime)result["time_created"]
            );
        }
        else { return null; }
    }

    public static List<Dictionary<string, object>> GetConversations()
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        string sql = "SELECT c.*,(SELECT COUNT(conversation_receipt_id) FROM conversation_receipts r WHERE r.conversation_id = c.conversation_id AND r.unread = 1 AND user_name = @user_name) as unread_count " +
            "FROM conversations c WHERE c.conversation_id IN (SELECT p.conversation_id FROM conversation_participants p WHERE p.user_name = @user_name)";
        ResultSet resultSet = commons.ExecuteQuery(sql, HttpContext.Current.User.Identity.Name);
        List<Dictionary<string, object>> conversationInfo = new List<Dictionary<string, object>>();
        foreach (Result result in resultSet)
        {
            conversationInfo.Add(new Dictionary<string, object>
            {
                { "ConversationID", (int)result["conversation_id"] },
                { "Title", (string)result["title"] },
                { "Unread", (int)result["unread_count"] }
            });
        }
        return conversationInfo;
    }

    public static string CreateConversation(string[] fullNames, string title, string message)
    {
        string[] usernames = User.MapFullNames(fullNames);
        Conversation conversation = GetConversation(usernames);
        if (conversation != null)
        {
            SendMessage(conversation.ConversationID, message);
            return CreateChatBox(conversation.ConversationID);
        }
        string sql = "INSERT INTO conversations (title,created_by,time_created) OUTPUT INSERTED.conversation_id VALUES (@title,@created_by,@time_created)";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@title", title },
            { "@created_by", HttpContext.Current.User.Identity.Name },
            { "@time_created", DateTime.Now }
        });
        int conversationId = (int)resultSet[0]["conversation_id"];

        sql = "INSERT INTO conversation_participants (conversation_id,user_name) VALUES (" + conversationId + ",@user_name)";
        commons.ExecuteQuery(sql, HttpContext.Current.User.Identity.Name);
        foreach (string username in usernames)
        {
            commons.ExecuteQuery(sql, username);
        }

        SendMessage(conversationId, message);

        return CreateChatBox(conversationId);
    }

    public static int SendMessage(int conversationId, string message, string username = null)
    {
        if (username == null)
        {
            username = HttpContext.Current.User.Identity.Name;
        }
        string sql = "INSERT INTO conversation_messages (conversation_id,sender_user_name,message_text,time_created) OUTPUT INSERTED.conversation_message_id VALUES (@conversation_id,@sender_user_name,@message_text,@time_created)";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@conversation_id", conversationId },
            { "@sender_user_name", username },
            { "@message_text", message },
            { "@time_created", DateTime.Now }
        });
        int messageId = (int)resultSet[0]["conversation_message_id"];

        sql = "SELECT user_name FROM conversation_participants WHERE user_name <> @user_name AND conversation_id = " + conversationId;
        resultSet = commons.ExecuteQuery(sql, username);
        foreach (Result result in resultSet)
        {
            sql = "INSERT INTO conversation_receipts (conversation_id,conversation_message_id,user_name,unread) VALUES (" + conversationId + "," + messageId + ",@user_name,1)";
            commons.ExecuteQuery(sql, (string)result["user_name"]);
        }

        sql = "UPDATE conversation_receipts SET unread = 0 WHERE user_name = @user_name AND conversation_id = " + conversationId.ToString();
        commons.ExecuteQuery(sql, HttpContext.Current.User.Identity.Name);
        return messageId;
    }

    public static string CreateChatBox(int conversationId, bool collapsed = false)
    {
        string sql = "UPDATE conversation_receipts SET unread = 0 WHERE user_name = @user_name AND conversation_id = " + conversationId.ToString();
        commons.ExecuteQuery(sql, HttpContext.Current.User.Identity.Name);

        Conversation conversation = Conversation.GetConversation(conversationId);

        string chatMessages = "";
        string participantAvatars = "";
        string title = "<h4>New Conversation</h4><input class='conversation-recipient' type='text' />";
        int unreadCount = 0;

        conversationId = conversation.ConversationID;
        title = conversation.Title;
        unreadCount = conversation.UnreadCount;

        List<string> participants = new List<string>();
        foreach (Participant participant in conversation.Participants)
        {
            participants.Add(participant.User.FullName);
            participantAvatars +=
                "<div class='col-xs-2' style='padding:0 5px' data-avatar_user_id='" + participant.User.UserID + "'>" +
                    "<a href='viewprofile.aspx?id=" + participant.User.UserID + "'><img src='" + participant.User.Avatar + "' class='img-responsive img-circle' /></a>" +
                "</div>";
        }

        foreach (Message message in conversation.Messages)
        {
            chatMessages += Message.CreateChatMessage(message.MessageID, message.Sender, message.MessageText, message.TimeCreated);
        }

        string chatBox =
            "<div class='direct-chat-wrapper col-xxl-2 col-lg-3 col-md-4 col-sm-6 col-xs-12 pull-right'>" +
                "<div class='box box-shadow box-success direct-chat direct-chat-success" + (collapsed ? " collapsed-box collapsed-chat" : "") + "' data-conversation_id='" + conversationId + "' data-conversation_participants='" + (string.Join(";", participants.ToArray())) + "'>" +
                    "<div class='box-header with-border'>" +
                        "<div class='pull-right col-sm-4 col-xs-3 no-padding' style='margin-top:-3px;'>" +
                            "<span data-toggle='tooltip' class='badge bg-green chat-new-messages' data-original-title='" + unreadCount + " Unread Messages'>" + unreadCount + "</span>" +
                            "<div class='dropdown' style='display:inline;'>" +
                                "<button type='button' class='btn btn-box-tool dropdown-toggle chat-options-button' data-toggle='tooltip' data-original-title='Options'><i class='fa fa-gear'></i></button>" +
                                "<div class='dropdown-menu'>" +
                                    "<button type='button' class='btn btn-block btn-default leave-conversation'>Leave Chat</button>" +
                                    (conversation.CreatedBy == HttpContext.Current.User.Identity.Name ?
                                        "<div class='dropdown' style='display:inline;'>" +
                                            "<button type='button' class='btn btn-block btn-default invite-conversation'>Invite User</button>" +
                                            "<div class='dropdown-menu'>" +
                                                "<div class='box box-success'>" +
                                                    "<div class='box-header'>" +
                                                        "<h3 class='box-title'>Invitee(s):</h3>" +
                                                    "</div>" +
                                                    "<div class='box-body'>" +
                                                        "<div class='col-xs-12'>" +
                                                            "<input type='text' class='invite-conversation-users' />" +
                                                        "</div>" +
                                                    "</div>" +
                                                    "<div class='box-footer'>" +
                                                        "<button type='button' class='btn btn-block btn-success do-invite-conversation-users'>Invite User(s)</button>" +
                                                    "</div>" +
                                                "</div>" +
                                            "</div>" +
                                        "</div>"
                                    : "") +
                                "</div>" +
                            "</div>" +
                            "<button type='button' class='btn btn-box-tool' data-widget='collapse' data-toggle='tooltip' data-original-title='Minimize' data-ignore='true'><i class='fa " + (collapsed ? "fa-plus" : "fa-minus") + "'></i></button>" +
                            "<button type='button' class='btn btn-box-tool' data-widget='remove' data-toggle='tooltip' data-original-title='Close' data-ignore='true' onclick=\"$(this).on('remove',function(){$(this).closest('.direct-chat-wrapper').remove()})\"><i class='fa fa-times'></i></button>" +
                        "</div>" +
                        "<h3 class='box-title col-sm-8 col-xs-9 no-padding ellipsis' style='max-width:initial;' data-toggle='tooltip' data-original-title='" + title + "'>" + title + "</h3>" +
                        "<div class='col-xs-12 no-padding chat-avatars'>" +
                            participantAvatars +
                        "</div>" +
                    "</div>" +
                    "<div class='box-body'" + (collapsed ? " style='display:none;'" : "") + ">" +
                        "<div class='direct-chat-messages'>" +
                            chatMessages +
                        "</div>" +
                    "</div>" +
                    "<div class='box-footer'" + (collapsed ? " style='display:none;'" : "") + ">" +
                        "<div class='input-group'>" +
                            "<input type='text' placeholder='Type Message ...' class='form-control conversation-message'>" +
                            "<span class='input-group-btn'>" +
                                "<button type='button' class='btn btn-success btn-flat submit-chat'>Send</button>" +
                            "</span>" +
                        "</div>" +
                    "</div>" +
                "</div>" +
            "</div>";

        return chatBox;
    }

    public static UpdateData UpdateChats(List<Dictionary<string, string>> openChats, int lastConversationId)
    {
        UpdateData updateData = new UpdateData();
        string sql = "";
        ResultSet resultSet;
        foreach (Dictionary<string, string> openChat in openChats)
        {
            sql = "SELECT * FROM conversation_messages WHERE conversation_message_id > @conversation_message_id AND conversation_id = @conversation_id ORDER BY time_created DESC";
            resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@conversation_message_id", Convert.ToInt32(openChat["lastMessageId"]) },
                { "@conversation_id", Convert.ToInt32(openChat["conversationId"]) }
            });
            string newMessages = "";
            List<string> participants = new List<string>();
            foreach (Result result in resultSet)
            {
                newMessages += Message.CreateChatMessage((int)result["conversation_message_id"], new User((string)result["sender_user_name"]), (string)result["message_text"], (DateTime)result["time_created"]);
            }

            sql = "SELECT user_name FROM conversation_participants WHERE conversation_id = " + openChat["conversationId"];
            foreach (Result result in commons.ExecuteQuery(sql))
            {
                participants.Add((string)result["user_name"]);
            }
            updateData.Add(
                new UpdateData.OpenChat(
                    Convert.ToInt32(openChat["conversationId"]),
                    newMessages,
                    User.GetUsers(participants.ToArray())));
        }

        sql = "SELECT conversation_id FROM conversations WHERE conversation_id > @conversation_id AND conversation_id IN (SELECT conversation_id FROM conversation_participants WHERE user_name = @user_name)";
        resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@conversation_id", lastConversationId },
            { "@user_name", HttpContext.Current.User.Identity.Name }
        });
        foreach (Result result in resultSet)
        {
            updateData.Add(
                new UpdateData.NewChat(
                    (int)result["conversation_id"],
                    CreateChatBox((int)result["conversation_id"], true)));
        }

        return updateData;
    }

    public static void LeaveChat(int conversationId)
    {
        SendMessage(conversationId, "Left the Chat...");
        string sql = "DELETE FROM conversation_participants WHERE user_name = @user_name AND conversation_id = " + conversationId + ";" +
            "DELETE FROM conversation_receipts WHERE user_name = @user_name AND conversation_id = " + conversationId + ";";
        commons.ExecuteQuery(sql, HttpContext.Current.User.Identity.Name);
    }

    public static void InviteUser(int conversationId, string[] fullNames)
    {
        string[] usernames = User.MapFullNames(fullNames);
        foreach (string username in usernames)
        {
            string sql = "INSERT INTO conversation_participants (conversation_id,user_name) VALUES (" + conversationId + ",@user_name)";
            commons.ExecuteQuery(sql, username);
            SendMessage(conversationId, "Joined the Chat...", username);
        }
    }

    public class Message
    {
        public Message(int messageId, Conversation conversation, User sender, string message, DateTime timeCreated)
        {
            MessageID = messageId;
            Conversation = conversation;
            Sender = sender;
            MessageText = message;
            TimeCreated = timeCreated;
        }

        public int MessageID { get; private set; }
        public Conversation Conversation { get; private set; }
        public User Sender { get; private set; }
        public string MessageText { get; private set; }
        public string MessageTextPreview
        {
            get
            {
                if (MessageText.Length > 20)
                {
                    return MessageText.Substring(0, 20) + "...";
                } else { return MessageText; }
            }
        }
        public DateTime TimeCreated { get; private set; }

        public static string CreateChatMessage(int messageId, User sender, string text, DateTime timeCreated)
        {
            bool isSender = sender.Username == HttpContext.Current.User.Identity.Name;
            return
                "<div class='direct-chat-msg" + (isSender ? " right" : "") + "' data-conversation_message_id='" + messageId.ToString() + "'>" +
                    "<div class='direct-chat-info clearfix'>" +
                        "<span class='direct-chat-name " + (isSender ? "pull-right" : "pull-left") + "'>" + sender.FullName + "</span>" +
                        "<span class='direct-chat-timestamp " + (isSender ? "pull-left" : "pull-right") + "'>" + timeCreated.ToString("MMM d @ HH:mm:ss") + "</span>" +
                    "</div>" +
                    "<img class='direct-chat-img' src='" + sender.Avatar + "' alt='Sender Avatar'>" +
                    "<div class='direct-chat-text'>" + text + "</div>" +
                "</div>";
        }
    }

    public class Participant
    {
        public Participant(int participantId, Conversation conversation, User user)
        {
            ParticipantID = participantId;
            Conversation = conversation;
            User = user;
        }

        public int ParticipantID { get; private set; }
        public Conversation Conversation { get; private set; }
        public User User { get; private set; }
    }

    public class Receipts
    {
        Dictionary<Message, Receipt> receipts = new Dictionary<Message, Receipt>();

        public Receipts()
        {

        }

        public void Add(Message message, bool unread)
        {
            receipts.Add(message, new Receipt(
                 message,
                 unread
            ));
        }

        public Receipt this[Message message]
        {
            get { return receipts[message]; }
        }
    }

    public class Receipt
    {
        public Receipt(Message message, bool unread)
        {
            Message = message;
            Unread = unread;
        }

        public Message Message { get; private set; }
        public bool Unread { get; private set; }
    }

    public class UpdateData
    {
        public List<NewChat> NewChats = new List<NewChat>();
        public List<OpenChat> OpenChats = new List<OpenChat>();
        
        public void Add(NewChat newChat)
        {
            NewChats.Add(newChat);
        }

        public void Add(OpenChat openChat)
        {
            OpenChats.Add(openChat);
        }

        public class NewChat
        {
            public NewChat(int conversationId, string chatBox)
            {
                ConversationID = conversationId;
                ChatBox = chatBox;
            }
            public int ConversationID;
            public string ChatBox;
        }

        public class OpenChat
        {
            public OpenChat(int conversationId, string newMessages, User[] participants)
            {
                ConversationID = conversationId;
                NewMessages = newMessages;
                Participants = participants;
            }
            public int ConversationID;
            public string NewMessages;
            public User[] Participants;
        }
    }
}