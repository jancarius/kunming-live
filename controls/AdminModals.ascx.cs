using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_AdminModals : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        foreach (BlogPost.PostTypes type in Enum.GetValues(typeof(BlogPost.PostTypes)))
        {
            ddlBlogPostType.Items.Add(new System.Web.UI.WebControls.ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }

        string sql = "SELECT * FROM events WHERE approved = 0 AND denied = 0";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            string eventId = result["event_id"].ToString();
            User user = new User((string)result["user_name"]);
            tblApproveEvents.Controls.Add(new LiteralControl(
                "<tr data-event_id='" + (int)result["event_id"] + "'>" +
                    "<td><a href='viewprofile.aspx?id=" + user.UserID + "' target='_blank'>" + user.FullName + "</a></td>" +
                    "<td class='ellipsis'>" + (string)result["title"] + "</td>" +
                    "<td><a href='eventscalendar.aspx?view=" + eventId + "' target='_blank'>View Event</a></td>" +
                    "<td class='clickable approve-event'><i class='fa fa-check'></i></td>" +
                    "<td class='clickable deny-event'><i class='fa fa-times'></i></td>" +
                "</tr>"
            ));
        }

        sql = "SELECT * FROM businesses WHERE approved = 0 AND denied = 0";
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            string businessId = result["business_id"].ToString();
            User user = new User((string)result["user_name"]);
            tblApproveEvents.Controls.Add(new LiteralControl(
                "<tr data-business_id='" + (int)result["business_id"] + "'>" +
                    "<td><a href='viewprofile.aspx?id=" + user.UserID + "' target='_blank'>" + user.FullName + "</a></td>" +
                    "<td class='ellipsis'>" + (string)result["name_english"] + " " + (string)result["name_chinese"] + "</td>" +
                    "<td><a href='businesses.aspx?view=all&id=" + businessId + "' target='_blank'>View Business</a></td>" +
                    "<td class='clickable approve-business'><i class='fa fa-check'></i></td>" +
                    "<td class='clickable deny-business'><i class='fa fa-times'></i></td>" +
                "</tr>"
            ));
        }

        sql = "SELECT * FROM pages";
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            pnlExistingPages.Controls.Add(new LiteralControl(
                "<tr>" +
                    "<td>" + (string)result["description"] + "</td>" +
                    "<td>" + (string)result["page_link"] + "</td>" +
                    "<td class='text-center'><i class='fa fa-" + (Convert.ToBoolean(result["user_access"]) ? "check text-success" : "times text-danger") + "'></i></td>" +
                    "<td class='text-center'><i class='fa fa-" + (Convert.ToBoolean(result["administrator_access"]) ? "check text-success" : "times text-danger") + "'></i></td>" +
                "</tr>"
            ));
        }
    }
}