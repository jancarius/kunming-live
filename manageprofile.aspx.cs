using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using YAF.Core;
using YAF.Classes.Data;

public partial class profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblEmail.InnerText = Master.currentUser.Email;
        lblFullName.InnerText = Master.currentUser.FullName;
        lblDescription.InnerText = Master.currentUser.Description;
        lblLocation.InnerText = Master.currentUser.Location;
        lblMeasurement.InnerText = Master.currentUser.MeasurementString;
        imgProfileUpdate.ImageUrl = Master.currentUser.Avatar;

        SetupEditBoxStates();
        SetupEditClassifiedPosts();
        SetupEditEvents();
        SetupEditBusinesses();
    }

    private void SetupEditBoxStates()
    {
        string sql = "SELECT * FROM custom_box_states WHERE hidden = 0 AND user_name = '" + Master.currentUser.Username + "' ORDER BY box_state DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length > 0) {
            tblEditBoxStatesNone.Style.Add("display", "none");
            tblEditBoxStates.Controls.Add(new LiteralControl(
                "<tr class='table-header'>" +
                    "<th class='col-xs-5'>Box Title</th>" +
                    "<th class='col-xs-4'>Page</th>" +
                    "<th class='col-xs-2'>State</th>" +
                    "<th class='col-xs-1'></th>" +
                "</tr>"
            ));
        }
        foreach (Result result in resultSet)
        {
            PageAccess boxStatePage = new PageAccess((int)result["page_id"]);
            tblEditBoxStates.Controls.Add(new LiteralControl(
                "<tr>" +
                    "<td>" + (string)result["element_title"] + "</td>" +
                    "<td>" + boxStatePage.Description + "</td>" +
                    "<td>" + ((int)result["box_state"] == 0 ? "<strong class='text-primary'>Collapsed</strong>" : "<strong class='text-danger'>Removed</strong>") + "</td>" +
                    "<td><i class='fa fa-times clickable undo-box-state' data-box-state-id='" + (int)result["custom_box_state_id"] + "' data-toggle='tooltip' title='Undo' data-original-title='Undo'></i></td>" +
                "</tr>"
            ));
        }
    }

    private void SetupEditClassifiedPosts()
    {
        Classified[] classifieds = Classified.GetClassifieds(Master.currentUser.Username);
        if (classifieds.Length > 0) {
            tblEditClassifiedPostsNone.Style.Add("display", "none");
            tblEditClassifiedPosts.Controls.Add(new LiteralControl(
                "<tr class='table-header'>" +
                    "<th class='col-xs-6'>Post Title</th>" +
                    "<th class='col-xs-3'>Expires</th>" +
                    "<th class='col-xs-3'></th>" +
                "</tr>"
            ));
        }
        
        foreach (Classified classified in classifieds)
        {
            string classifiedId = classified.PostID.ToString();
            bool inactive = classified.Inactive;
            DateTime expirationDate = classified.TimeCreated.Date.AddMonths(1);
            tblEditClassifiedPosts.Controls.Add(new LiteralControl(
                "<tr data-post_id='" + classifiedId + "'" + (inactive ? " class='bg-gray'" : "") + ">" +
                    "<td class='ellipsis'><a href=\"" + classified.Link + "'>" + classified.Title + "</a></td>" +
                    "<td class='text-center text-bold no-padding " + (expirationDate < DateTime.Now.Date ? "bg-danger" : "bg-success" ) + "' style='vertical-align:middle;'>" + expirationDate.ToString("MMM d") + "</td>" +
                    "<td class='text-center no-padding' style='vertical-align:middle;'>" +
                        "<i class='fa fa-edit clickable' data-toggle='tooltip' data-original-title='Edit' onclick='window.location.href=\"" + classified.EditLink + "'\"></i>&nbsp;&nbsp;" +
                        (classified.Expired ?
                            "<i class='fa fa-refresh clickable' data-toggle='tooltip' data-original-title='Renew'></i>&nbsp;&nbsp;"
                        : "") +
                        (inactive ? "<i class='fa fa-play clickable' data-toggle='tooltip' data-original-title='Resume'></i>&nbsp;&nbsp;"
                            : "<i class='fa fa-pause clickable' data-toggle='tooltip' data-original-title='Suspend'></i>&nbsp;&nbsp;") +
                        "<i class='fa fa-trash clickable' data-toggle='tooltip' data-original-title='Delete'></i>" +
                    "</td>" +
                "</tr>"
            ));
        }
    }

    private void SetupEditEvents()
    {
        Event[] events = Event.GetEvents(Master.currentUser.Username);
        if (events.Length > 0) {
            tblEditEventsNone.Style.Add("display", "none");
            tblEditEvents.Controls.Add(new LiteralControl(
                "<tr class='table-header'>" +
                    "<th class='col-xs-9'>Event Title</th>" +
                    "<th class='col-xs-3'></th>" +
                "</tr>"
            ));
        }
        foreach(Event thisEvent in events)
        {
            string eventId = thisEvent.EventID.ToString();
            bool inactive = thisEvent.Inactive;
            tblEditEvents.Controls.Add(new LiteralControl(
                "<tr data-post_id='" + eventId + "'" + (inactive ? " class='bg-gray'" : "") + ">" +
                    "<td class='ellipsis'><a href=\"" + thisEvent.Link + "\">" + thisEvent.Title + "</a></td>" +
                    "<td class='text-center'>" +
                        "<i class='fa fa-edit clickable' data-toggle='tooltip' data-original-title='Edit' onclick='window.location.href=\"" + thisEvent.EditLink + "\"'></i>&nbsp;&nbsp;" +
                        (inactive ?
                            "<i class='fa fa-play clickable' data-toggle='tooltip' data-original-title='Resume'></i>&nbsp;&nbsp;"
                        : "<i class='fa fa-pause clickable' data-toggle='tooltip' data-original-title='Suspend'></i>&nbsp;&nbsp;") + 
                        "<i class='fa fa-trash clickable' data-toggle='tooltip' data-original-title='Delete'></i>" +
                    "</td>" +
                "</tr>"
            ));
        }
    }

    private void SetupEditBusinesses()
    {
        Business[] businesses = Business.GetBusinesses(Master.currentUser.Username);
        if (businesses.Length > 0) {
            tblEditBusinessesNone.Style.Add("display", "none");
            tblEditBusinesses.Controls.Add(new LiteralControl(
                "<tr class='table-header'>" +
                    "<th class='col-xs-9'>Business Name</th>" +
                    "<th class='col-xs-3'></th>" +
                "</tr>"
            ));
        }
        foreach (Business business in businesses)
        {
            string businessId = business.BusinessID.ToString();
            bool inactive = business.Inactive;
            tblEditBusinesses.Controls.Add(new LiteralControl(
                "<tr data-post_id='" + businessId + "'" + (inactive ? " class='bg-gray'" : "") + ">" +
                    "<td class='ellipsis'>" +
                        "<a href=\"" + business.Link + "\">" + business.Name.English + " " + business.Name.Chinese + "</a>" +
                    "</td>" +
                    "<td class='text-center'>" +
                        "<i class='fa fa-edit clickable' data-toggle='tooltip' data-original-title='Edit' onclick='window.location.href=\"" + business.EditLink + "\"'></i>&nbsp;&nbsp;" +
                        (inactive ?
                            "<i class='fa fa-play clickable' data-toggle='tooltip' data-original-title='Resume'></i>&nbsp;&nbsp;"
                        : "<i class='fa fa-pause clickable' data-toggle='tooltip' data-original-title='Suspend'></i>&nbsp;&nbsp;") +
                        "<i class='fa fa-trash clickable' data-toggle='tooltip' data-original-title='Delete'></i>" +
                    "</td>" +
                "</tr>"
            ));
        }
    }

    [WebMethod]
    public static User UpdateProfile(string fullName, string email, string location, string description, string profileImage, User.Measurement measurement)
    {
        if (!global::User.CheckDisplayName(fullName) || !global::User.CheckEmail(email))
        {
            return null;
        }
        User currentUser = new User(HttpContext.Current.User.Identity.Name);

        currentUser.FullName = fullName;
        currentUser.Email = email;
        currentUser.Location = location;
        currentUser.Description = description;
        currentUser.MeasurementEnum = measurement;
        if (profileImage.Length > 0)
        {
            currentUser.Avatar = profileImage;
        }
        currentUser.SaveChanges();
        
        return currentUser;
    }

    [WebMethod]
    public static int UndoCustomBoxState(int customBoxStateId)
    {
        string customBoxStateSql = "DELETE FROM custom_box_states WHERE custom_box_state_id = @custom_box_state_id";
        commons.ExecuteQuery(customBoxStateSql, new Dictionary<string, object>
                {
                    { "@custom_box_state_id", customBoxStateId }
                });
        return customBoxStateId;
    }
}