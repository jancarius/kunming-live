using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class resetpassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string guid = Request.QueryString["guid"];
        if (guid == null)
        {
            Response.Redirect("https://www.kunminglive.com/");
        }
        else
        {
            hiddenGUIDParam.Value = guid;
        }
    }
}