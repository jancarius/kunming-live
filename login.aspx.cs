using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.IO;
using YAF.Core;
using YAF.Utils;
using YAF.Classes.Data;
using Facebook;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        switch (Request.QueryString["action"])
        {
            case "login":
                Dictionary<string, string> postData = (Dictionary<string, string>)commons.ProcessPostData(new Dictionary<string, string>());
                string sql = "SELECT * FROM users WHERE user_name = @user_name";
                SqlConnection conn = new SqlConnection(commons.connString);
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@user_name", postData["username"]);
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.Read())
                {
                    User.Password passwordHash = global::User.HashPassword(postData["password"], (byte[])sdr["password_salt"]);
                    string storedHash = (string)sdr["password_hash"];
                    sdr.Close();
                    conn.Close();
                    if (storedHash == passwordHash.Hash)
                    {
                        FormsAuthentication.SetAuthCookie(postData["username"], Convert.ToBoolean(postData["rememberMe"]));
                        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, postData["username"], DateTime.Now, DateTime.Now.AddDays(1), Convert.ToBoolean(postData["rememberMe"]), "", "/");
                        string encTicket = FormsAuthentication.Encrypt(ticket);
                        HttpCookie authCookie = new HttpCookie(".YAFNET_Authentication", encTicket);
                        authCookie.Path = "/";
                        HttpContext.Current.Response.Cookies.Add(authCookie);
                        commons.ReturnString("true");
                    }
                    commons.ReturnString("false");
                }
                sdr.Close();
                conn.Close();
                commons.ReturnString("false");
                return;
            case "register":
                Dictionary<string, string> registerPostData = (Dictionary<string, string>)commons.ProcessPostData(new Dictionary<string, string>());
                bool fail = false;
                string failType = "";

                //TODO: Validate variables server side

                string registerSql = "SELECT * FROM users WHERE user_name = @user_name";
                SqlConnection registerConn = new SqlConnection(commons.connString);
                SqlCommand verifyCmd = new SqlCommand(registerSql, registerConn);
                verifyCmd.Parameters.AddWithValue("@user_name", registerPostData["username"]);
                registerConn.Open();
                SqlDataReader userReader = verifyCmd.ExecuteReader();
                if (userReader.Read())
                {
                    if (registerPostData["username"].ToLower() == ((string)userReader["user_name"]).ToLower())
                    {
                        failType = "Username & ";
                        fail = true;
                    }
                }
                userReader.Close();

                sql = "SELECT * FROM users WHERE email_address = @email_address";
                verifyCmd.CommandText = sql;
                verifyCmd.Parameters.AddWithValue("@email_address", registerPostData["email"]);
                userReader = verifyCmd.ExecuteReader();
                if (userReader.Read())
                {
                    if (registerPostData["email"].ToLower() == ((string)userReader["email_address"]).ToString().ToLower())
                    {
                        failType += "Email Address";
                        fail = true;
                    }
                }
                userReader.Close();

                if (fail)
                {
                    if (failType.EndsWith(" & "))
                    {
                        failType = failType.Remove(failType.Length - 3);
                    }
                    registerConn.Close();
                    commons.ReturnString(failType);
                }

                try
                {
                    sql = "INSERT INTO users (user_name,email_address,password_hash,password_salt,admin,last_login,reset_password,inactive) VALUES (@user_name,@email_address,@password_hash,@password_salt,0,GETDATE(),0,0)";
                    SqlCommand registerCmd = new SqlCommand(sql, registerConn);
                    User.Password hash = global::User.HashPassword(registerPostData["password"]);
                    registerCmd.Parameters.AddWithValue("@user_name", registerPostData["username"]);
                    registerCmd.Parameters.AddWithValue("@password_hash", hash.Hash);
                    registerCmd.Parameters.AddWithValue("@password_salt", hash.Salt);
                    registerCmd.Parameters.AddWithValue("@email_address", registerPostData["email"]);
                    registerCmd.ExecuteNonQuery();
                    registerConn.Close();

                    MembershipCreateStatus memberStatus = new MembershipCreateStatus();
                    MembershipUser user = Membership.CreateUser(registerPostData["username"], hash.Hash, registerPostData["email"], "default", "default", true, out memberStatus);
                    RoleMembershipHelper.SetupUserRoles(1, registerPostData["username"]);
                    int? userId = RoleMembershipHelper.CreateForumUser(user, 1);
                    if (userId == null) { throw new Exception("Failed Registering Forum User"); }
                    YafUserProfile profile = YafUserProfile.GetProfile(registerPostData["username"]);
                    profile.Save();
                    LegacyDb.user_save(
                        userID: userId,
                        boardID: 1,
                        userName: registerPostData["username"],
                        displayName: registerPostData["username"],
                        email: registerPostData["email"],
                        timeZone: 480,
                        languageFile: null,
                        culture: null,
                        themeFile: null,
                        textEditor: null,
                        useMobileTheme: null,
                        approved: null,
                        pmNotification: 1,
                        autoWatchTopics: 0,
                        dSTUser: false,
                        hideUser: null,
                        notificationType: null);
                    LegacyDb.user_savenotification(
                        userID: userId,
                        pmNotification: true,
                        autoWatchTopics: false,
                        notificationType: 10,
                        dailyDigest: false);

                    FormsAuthentication.SetAuthCookie(registerPostData["username"], false);
                    commons.ReturnString("Valid");
                }
                catch (Exception ex)
                {
                    registerConn.Close();
                    commons.ReturnString(ex.ToString());
                }
                return;
            case "facebookLogin":

                return;
            case "facebookRegister":

                return;
            case "getBackground":
                string[] bgFiles = Directory.GetFiles(HttpContext.Current.Server.MapPath("dist/img/bg/"), "*.jpg");
                if (bgFiles.Length == 0)
                {
                    commons.ReturnString("");
                }
                commons.ReturnString(bgFiles[new Random().Next(1, bgFiles.Length) - 1].Substring(bgFiles[0].IndexOf("dist\\img")));
                return;
        }
    }

}