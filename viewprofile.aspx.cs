using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class viewprofile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string action = Request.QueryString["action"];
        string userId = Request.QueryString["id"];
        User profileUser = new User(Convert.ToInt32(userId));
        switch (action)
        {
            case "accept-friend":
                Friend.AcceptFriend(profileUser.Username);
                break;
            case "accept-friend-pending":
                Friend.AcceptFriend(profileUser.Username);
                break;
        }
    }
}