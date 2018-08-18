using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class mailbox : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int inboxTotalCount = 0;
        int inboxUnreadCount = 0;
        Mail[] mails = Mail.GetMailFolder(Mail.Folders.Inbox);
        foreach (Mail mail in mails)
        {
            tblInboxBody.Controls.AddAt(0, new LiteralControl(MailMessageRow(mail)));
            //if (mail.Unread) { inboxUnreadCount++; }
            inboxTotalCount++;
        }

        Dictionary<Mail.Folders, int> folderCounts = Mail.MailCount();

        string totalMessagesText = "1-" + (inboxTotalCount >= 25 ? "25" : inboxTotalCount.ToString()) + "/" + inboxTotalCount;
        showTotalMessagesTop.InnerText = totalMessagesText;
        showTotalMessagesBottom.InnerText = totalMessagesText;
        showNewMessages.InnerText = inboxUnreadCount.ToString() + " new messages";
        showInboxNewMessages.InnerText = inboxUnreadCount.ToString();
        showSentMessages.InnerText = folderCounts[Mail.Folders.Sent].ToString();
        showDraftsMessages.InnerText = folderCounts[Mail.Folders.Drafts].ToString();
        showTrashMessages.InnerText = folderCounts[Mail.Folders.Trash].ToString();
    }

    private string MailMessageRow(Mail mail)
    {
        return "<tr data-message_id='" + mail.MailID + "' data-thread_id='" + mail.ThreadID + "' class='clickable' onclick='viewMail(this)'>" +
                    "<td>" +
                        "<input type='checkbox'></td>" +
                        //"<td class='mailbox-star'><a href='#'><i class='fa " + (mail.Starred ? "fa-star" : "fa-star-o") + " text-yellow'></i></a></td>" +
                        //"<td class='mailbox-read'><i class='fa " + (mail.Unread ? "fa-envelope" : "fa-envelope-open-o") + "'></i></td>" +
                        "<td class='mailbox-name'><a href='read-mail.html'>" + mail.Sender.FullName + "</a></td>" +
                        "<td class='mailbox-subject'><b>" + mail.Subject + "</b> - " + mail.BodyPreview +
                    "</td>" +
                    "<td class='mailbox-date'>" + mail.TimeSince + "</td>" +
                "</tr>";
    }

    [WebMethod]
    public static Dictionary<string, string>[] GetUserEmails()
    {
        return global::User.GetUsers();
    }

    [WebMethod]
    public static bool? SendMail(string[] recipients, string subject, string body)
    {
        return Mail.SendMail(subject, body, recipients);
    }

    [WebMethod]
    public static object SendReply(string body, string threadId)
    {
        return Mail.SendReply(threadId, body);
    }

    [WebMethod]
    public static Mail[] GetMails(Mail.Folders folder)
    {
        return Mail.GetMailFolder(folder);
    }

    [WebMethod]
    public static Mail[] GetThread(string threadId)
    {
        return Mail.GetThread(threadId);
    }
}