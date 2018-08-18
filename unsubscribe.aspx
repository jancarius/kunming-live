<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Request.QueryString["u"] != null)
        {
            string userId = Request.QueryString["u"];
            string sql = "UPDATE users SET email_unsubscribed = 1 WHERE user_id = @user_id";
            commons.ExecuteQuery(sql);
            form1.Controls.Add(new LiteralControl("<div style='font-weight:bold;font-size:18px;'>Unsubscribed</div>"));
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    </form>
</body>
</html>
