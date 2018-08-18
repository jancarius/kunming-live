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
        imgProfileUpdate.ImageUrl = Master.currentUser.Avatar;

        string boxStateSql = "SELECT * FROM custom_box_states WHERE user_name = @user_name ORDER BY box_state DESC";
        ResultSet boxStateResultSet = commons.ExecuteQuery(boxStateSql, new Dictionary<string, object>
        {
            { "@user_name", Master.currentUser.Username }
        });
        if (boxStateResultSet.Length == 0)
        {
            boxEditBoxStates.Visible = false;
        }
        foreach (Result boxStateResult in boxStateResultSet)
        {
            PageAccess boxStatePage = new PageAccess((int)boxStateResult["page_id"]);
            tblEditBoxStates.Controls.Add(new LiteralControl(
                "<tr>" +
                    "<td>" + (string)boxStateResult["element_title"] + "</td>" +
                    "<td>" + boxStatePage.Description + "</td>" +
                    "<td>" + ((int)boxStateResult["box_state"] == 0 ? "<strong class='text-primary'>Collapsed</strong>" : "<strong class='text-danger'>Removed</strong>") + "</td>" +
                    "<td><button type='button' class='btn btn-default btn-xs undo-box-state' data-box-state-id='" + (int)boxStateResult["custom_box_state_id"] + "' data-toggle='tooltip' title='Undo' data-original-title='Undo'><i class='fa fa-times'></i></button></td>" +
                "</tr>"
            ));
        }
    }

    [WebMethod]
    public static User UpdateProfile(string fullName, string email, string location, string description, string profileImage)
    {
        User currentUser = new User(HttpContext.Current.User.Identity.Name);

        currentUser.FullName = fullName;
        currentUser.Email = email;
        currentUser.Location = location;
        currentUser.Description = description;
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