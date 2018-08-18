using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web.Security;
using YAF.Core;
using YAF.Utils;
using YAF.Classes.Data;
using System.IO;
using System.Drawing.Imaging;

/// <summary>
/// Summary description for User
/// </summary>
public class User
{
    private string avatar;
    private string emailAddress;
    private bool emailConfirmed;
    private string fullName;
    private OnlineStatusType onlineStatus;

    private static string loadSql = "SELECT u.*,y.NumPosts FROM users u JOIN yaf_User y ON u.user_name = y.Name";

    public User(int userId)
    {
        string sql = loadSql + " WHERE u.user_id = @user_id";
        ResultSet resultSet = commons.ExecuteQuery(sql, userId);
        if (resultSet.Length == 0) { return; }
        setupUser(resultSet[0]);
    }

    public User(string username)
    {
        if (string.IsNullOrEmpty(username)) { return; }
        string sql = loadSql + " WHERE u.user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, username);
        if (resultSet.Length == 0) { return; }
        setupUser(resultSet[0]);
    }

    public User(string email, bool isEmail)
    {
        if (string.IsNullOrEmpty(email)) { return; }
        string sql = loadSql + " WHERE u.email_address = @email_address";
        ResultSet resultSet = commons.ExecuteQuery(sql, email);
        if (resultSet.Length == 0) { return; }
        setupUser(resultSet[0]);
    }

    public User(Result result)
    {
        setupUser(result);
    }

    private void setupUser(Result result)
    {
        UserID = (int)result["user_id"];
        Username = (string)result["user_name"];
        this.emailAddress = (string)result["email_address"];
        this.emailConfirmed = Convert.ToBoolean(result["email_confirmed"]);
        EmailUnsubscribed = Convert.ToBoolean(result["email_unsubscribed"]);
        PasswordHash = (string)result["password_hash"];
        PasswordSalt = (byte[])result["password_salt"];
        SocialToken = result["social_auth_token"] as string;
        Location = result["location"] as string;
        Description = result["description"] as string;
        this.fullName = (string)result["full_name"];
        FullNameChanged = Convert.ToBoolean(result["full_name_changed"]);
        Tagline = result["tagline"] as string;
        PostCount = (int)result["NumPosts"];
        Admin = Convert.ToBoolean(result["admin"]);
        LastLogin = (DateTime)result["last_login"];
        TimeCreated = (DateTime)result["time_created"];
        onlineStatus = (OnlineStatusType)result["online_status"];
        MeasurementEnum = (Measurement)result["measurement"];
        avatar = result["avatar"] as string;
        try
        {
            Uri avatarUri = new Uri(avatar);
            HttpWebRequest avatarRequest = (HttpWebRequest)WebRequest.Create(HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/" + avatarUri.AbsolutePath);
            avatarRequest.Method = "HEAD";
            avatarRequest.ContentType = "text/plain";
            avatarRequest.GetResponse();
            avatar = avatarUri.AbsoluteUri;
        }
        catch { avatar = "https://www.kunminglive.com/dist/img/profile/male_placeholder_signedin.png"; }
        IP = result["ip"] as string;
        Inactive = Convert.ToBoolean(result["inactive"]);

        if (Username == HttpContext.Current.User.Identity.Name)
        {
            UpdateUserLogin(Username);
            LastLogin = DateTime.Now;
            IP = HttpContext.Current.Request.Headers.Get("CF-Connecting-IP");
        }
    }

    public int UserID { get; private set; }
    public string Username { get; private set; }

    public string Avatar {
        get
        {
            return avatar;
        }
        set
        {
            string savePath = HttpContext.Current.Server.MapPath("dist/img/profile/");

            string base64 = value;
            string imgExt = base64.Substr(base64.IndexOf("/") + 1, base64.IndexOf(";"));
            base64 = base64.Substring(base64.IndexOf(",") + 1);
            
            byte[] bytes = Convert.FromBase64String(base64);

            System.Drawing.Image image;
            MemoryStream ms = new MemoryStream(bytes);
            image = System.Drawing.Image.FromStream(ms);
            string[] profilePath = Directory.GetFiles(savePath, Username + "_*");
            for (int i = 0; i < profilePath.Length; i++)
            {
                File.Delete(profilePath[i]);
            }

            ImageCodecInfo codecInfo = commons.GetEncoder(imgExt);

            EncoderParameters encoderParameters = new EncoderParameters(1);
            EncoderParameter qualityParameter = new EncoderParameter(Encoder.Quality, 70L);
            encoderParameters.Param[0] = qualityParameter;

            savePath += Username + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + imgExt;
            image.Save(savePath, codecInfo, encoderParameters);
            
            avatar = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/dist/img/profile/" + Path.GetFileName(savePath);
            LegacyDb.user_saveavatar(UserMembershipHelper.GetUserIDFromProviderUserKey(UserMembershipHelper.GetUser(Username).ProviderUserKey), avatar, null, null);
        }
    }

    public string Email
    {
        get { return emailAddress; }
        set
        {
            emailAddress = value;
            EmailConfirmed = false;
            // TODO: Send Email Confirmation
        }
    }
    public bool EmailConfirmed { get; private set; }
    public bool EmailUnsubscribed { get; set; }
    public string PasswordHash { get; set; }
    public byte[] PasswordSalt { get; set; }
    public string SocialToken { get; set; }
    public bool IsSocial {
        get
        {
            return SocialToken == null;
        }
    }
    public string Location { get; set; }
    public string Description { get; set; }
    public string FullName { get { return fullName; }
        set
        {
            if (FullNameChanged) { return; }
            if (fullName == value) { return; }
            if (commons.ExecuteQuery("SELECT user_id FROM users WHERE full_name = '" + value + "'").Length > 0) { return; }
            fullName = value;
            FullNameChanged = true;
        }
    }
    public bool FullNameChanged { get; set; }
    public string Tagline { get; set; }
    public int PostCount { get; private set; }
    public bool Admin { get; set; }
    public Measurement MeasurementEnum { get; set; }
    public string MeasurementString
    {
        get
        {
            return MeasurementEnum.ToString();
        }
    }
    public DateTime LastLogin { get; set; }
    public string LastLoginString
    {
        get
        {
            return LastLogin.ToString("MMM. d yyyy HH:mm");
        }
    }
    public DateTime TimeCreated { get; set; }
    public string TimeCreatedString
    {
        get
        {
            return TimeCreated.ToString("MMM. yyyy");
        }
    }
    public OnlineStatusType OnlineStatus {
        get
        {
            TimeSpan difference = DateTime.Now - LastLogin;
            if (difference.TotalMinutes > 5)
            {
                return OnlineStatusType.Offline;
            }
            else { return onlineStatus; }
        }
        set
        {
            onlineStatus = value;
        }
    }
    public string OnlineStatusColor
    {
        get
        {
            switch (OnlineStatus)
            {
                case OnlineStatusType.Online:
                    return "text-success";
                case OnlineStatusType.Busy:
                    return "text-yellow";
                case OnlineStatusType.Offline:
                    return "text-danger";
                default: return "";
            }
        }
    }
    public string IP { get; private set; }
    public bool Inactive { get; set; }
    public bool IsMe {
        get
        {
            return Username == HttpContext.Current.User.Identity.Name;
        }
    }
    public TodoItem[] TodoItems(bool getCompleted = true) {
        return TodoItem.GetTodoItems(Username, getCompleted);
    }
    public string ProfileLink
    {
        get
        {
            return "https://www.kunminglive.com/view-profile/" + UserID.ToString() + "/" + FullName.RemoveSpecialCharacters().Replace(" ", "-");
        }
    }
    public string DisplayHTML
    {
        get
        {
            return
                "<a href=\"" + ProfileLink + "\" class=\"user-display-html valign no-padding\" style=\"position:relative;\">" +
                    "<img src=\"" + Avatar + "\" alt=\"" + FullName + " Avatar\" class=\"img-circle\" width=\"50\" />" +
                    "<i class=\"fa fa-circle " + OnlineStatusColor + "\" data-toggle=\"tooltip\" data-original-title=\"" + OnlineStatus.ToString() + "\"></i>" +
                    "<span>" + FullName + "</span>" +
                "</a>";
        }
    }

    public void SaveChanges()
    {
        if (!emailConfirmed)
        {
            string confirmationGuid = Guid.NewGuid().ToString();
            string confirmationSql = "INSERT INTO email_confirmations (email_confirmation_identifier,user_name) VALUES (@email_confirmation_identifier,@user_name)";
            commons.ExecuteQuery(confirmationSql, new Dictionary<string, object>
                {
                    { "@email_confirmation_identifier", confirmationGuid },
                    { "@user_name", Username }
                });
            string subject = "Kunming LIVE! Email Confirmation";
            string body = "You've changed your email. Click the following link to confirm your email. If you did not perform this action, please contact admin@kunminglive.com.<br /><br />https://kunminglive.com/?confirm=" + confirmationGuid;
            commons.SendEmail(new User(Username), subject, body);
        }
        
        Description = commons.CensorWords(Description);
        Tagline = commons.CensorWords(Tagline);

        string sql = "UPDATE users SET email_address=@email_address,email_confirmed=@email_confirmed,email_unsubscribed=@email_unsubscribed,password_hash=@password_hash,password_salt=@password_salt,social_auth_token=@social_auth_token," +
            "avatar=@avatar,location=@location,description=@description,full_name=@full_name,full_name_changed=@full_name_changed,tagline=@tagline,admin=@admin,inactive=@inactive,measurement=@measurement WHERE user_name=@user_name;";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", Username },
            { "@email_address", emailAddress },
            { "@email_confirmed", emailConfirmed },
            { "@email_unsubscribed", EmailUnsubscribed },
            { "@password_hash", PasswordHash },
            { "@password_salt", PasswordSalt },
            { "@social_auth_token", SocialToken ?? (object)DBNull.Value },
            { "@avatar", avatar },
            { "@ip", IP },
            { "@location", Location ?? (object)DBNull.Value },
            { "@description", Description ?? (object)DBNull.Value },
            { "@full_name", FullName },
            { "@full_name_changed", FullNameChanged },
            { "@tagline", Tagline ?? (object)DBNull.Value },
            { "@admin", Admin },
            { "@inactive", Inactive },
            { "@measurement", MeasurementEnum }
        });
    }

    public static void UpdateOnlineStatus(OnlineStatusType onlineStatus)
    {
        string sql = "UPDATE users SET online_status = @online_status WHERE user_name = '" + HttpContext.Current.User.Identity.Name + "'";
        commons.ExecuteQuery(sql, onlineStatus);
    }

    public static User[] GetUsers()
    {
        List<User> users = new List<User>();
        ResultSet resultSet = commons.ExecuteQuery(loadSql);
        foreach(Result result in resultSet)
        {
            users.Add(new User(result));
        }
        return users.ToArray();
    }

    public static User[] GetUsers(string[] usernames)
    {
        string sql = loadSql + " WHERE u.user_name IN ('" + string.Join("','", usernames) + "')";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<User> users = new List<User>();
        foreach (Result result in resultSet)
        {
            users.Add(new User(result));
        }
        return users.ToArray();
    }

    public static string[] MapFullNames(string[] fullNames)
    {
        string sql = "SELECT user_name FROM users WHERE full_name IN ('" + string.Join("','", fullNames) + "')";
        List<string> usernames = new List<string>();
        foreach (Result result in commons.ExecuteQuery(sql))
        {
            usernames.Add((string)result["user_name"]);
        }
        return usernames.ToArray();
    }

    public static bool CheckDisplayName(string displayName)
    {
        string sql = "SELECT COUNT(user_id) FROM users WHERE full_name = @full_name AND user_name <> '" + HttpContext.Current.User.Identity.Name + "'";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@full_name", displayName }
        });
        if ((int)resultSet[0][""] > 0)
        {
            return false;
        }
        return true;
    }

    public static bool CheckUsername(string username)
    {
        string sql = "SELECT user_id FROM users WHERE user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username }
        });
        if (resultSet.Length == 1)
        {
            return false;
        }
        return true;
    }

    public static bool CheckEmail(string email)
    {
        string sql = "SELECT COUNT(user_id) FROM users WHERE email_address = @email_address AND user_name <> '" + HttpContext.Current.User.Identity.Name + "'";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@email_address", email }
        });
        if ((int)resultSet[0][""] > 0)
        {
            return false;
        }
        return true;
    }

    public static bool VerifyAdmin()
    {
        if (HttpContext.Current.Request.IsAuthenticated)
        {
            if (HttpContext.Current.User.IsInRole("Administrators"))
            {
                return true;
            }
        }
        return false;
    }

    public static bool? SigninUser(string username, bool rememberMe, string password = null)
    {
        string sql = "SELECT * FROM users WHERE user_name = @user_name OR social_auth_token = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username }
        });
        if (resultSet.Length == 1)
        {
            if (!Convert.ToBoolean(resultSet[0]["email_confirmed"]) || Convert.ToBoolean(resultSet[0]["inactive"]))
            {
                return null;
            }
            if (password != null)
            {
                Password passwordHash = HashPassword(password, (byte[])resultSet[0]["password_salt"]);
                string storedHash = (string)resultSet[0]["password_hash"];
                if (storedHash != passwordHash.Hash)
                {
                    return false;
                }
            }
            else if (resultSet[0]["social_auth_token"] == DBNull.Value)
            {
                return false;
            }
            commons.SetAuthCookie((string)resultSet[0]["user_name"], rememberMe);
            return true;
        } else { return false; }
    }

    public static void ForgotSignin(string username, string email)
    {
        string sql = "SELECT * from users WHERE user_name = @user_name OR email_address = @email_address";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username },
            { "@email_address", email }
        });
        if (resultSet.Length == 1)
        {
            Result result = resultSet[0];
            username = (string)result["user_name"];
            email = (string)result["email_address"];
            string fullName = (string)result["full_name"];

            string guid = Guid.NewGuid().ToString();

            sql = "UPDATE password_resets SET complete = 1 WHERE user_name = @user_name";
            commons.ExecuteQuery(sql, username);

            sql = "INSERT INTO password_resets (user_name,guid,complete) VALUES (@user_name,@guid,0)";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@user_name", username },
                { "@guid", guid }
            });

            string body = "Follow the link below to reset your password.<br/><br/><a href=\"https://www.kunminglive.com/reset-password/" + guid + "\">https://www.kunminglive.com/reset-password/" + guid + "</a>";
            commons.SendEmail(new User(username), "Kunming LIVE! Reset Password", body);
        }
    }

    public static bool ResetPassword(string guid, string newPassword)
    {
        string sql = "SELECT * FROM password_resets WHERE guid = @guid AND complete = 0";
        ResultSet resultSet = commons.ExecuteQuery(sql, guid);
        if (resultSet.Length == 1)
        {
            Result result = resultSet[0];
            Password hash = HashPassword(newPassword);
            sql = "UPDATE users SET password_hash = @password_hash, password_salt = @password_salt WHERE user_name = @user_name";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@password_hash", hash.Hash },
                { "@password_salt", hash.Salt },
                { "@user_name", (string)result["user_name"] }
            });

            sql = "UPDATE password_resets SET complete = 1 WHERE user_name = @user_name";
            commons.ExecuteQuery(sql, (string)result["user_name"]);

            commons.SetAuthCookie((string)result["user_name"]);

            return true;
        } else { return false; }
    }

    public static void UpdateUserLogin(string username)
    {
        string sql = "UPDATE users SET last_login = @last_login,ip = @ip WHERE user_name = @user_name";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@last_login", DateTime.Now },
            { "@ip", HttpContext.Current.Request.Headers.Get("CF-Connecting-IP") },
            { "@user_name", username }
        });
    }

    public static string RegisterUser(string username, string password, string email, string fullName = null, string socialToken = null, string picture = null, bool confirmed = false)
    {
        bool fail = false;
        string failType = "";
        //TODO: Validate variables server side
        if (socialToken == null)
        {
            string existsSql = "SELECT * FROM users WHERE user_name = @user_name OR email_address = @email_address";
            ResultSet existsResultSet = commons.ExecuteQuery(existsSql, new Dictionary<string, object>
            {
                { "@user_name", username },
                { "@email_address", email }
            });
            if (existsResultSet.Length == 1)
            {
                if (username.ToLower() == existsResultSet[0]["user_name"].ToString().ToLower())
                {
                    failType = "Username & ";
                    fail = true;
                }
                if (email.ToLower() == existsResultSet[0]["email_address"].ToString().ToLower())
                {
                    failType += "Email Address & ";
                    fail = true;
                }
            }

            if (fail)
            {
                if (failType.EndsWith(" & "))
                {
                    failType = failType.Remove(failType.Length - 3);
                }
                return failType + " Already in Use";
            }

            fullName = username;
        }
        else
        {
            username = Guid.NewGuid().ToString();
            password =  Guid.NewGuid().ToString();
        }

        string checkSql = "SELECT COUNT(user_id) FROM users WHERE full_name = @full_name";
        ResultSet checkResultSet = commons.ExecuteQuery(checkSql, new Dictionary<string, object>
            {
                { "@full_name", fullName }
            });
        int foundCount = 0;
        while ((int)checkResultSet[0][""] > 0)
        {
            foundCount++;
            checkResultSet = commons.ExecuteQuery(checkSql, new Dictionary<string, object>
                {
                    { "@full_name", fullName + " " + foundCount.ToString() }
                });
        }
        if (foundCount > 0)
        {
            fullName = fullName + " " + foundCount.ToString();
        }
        
        if (picture != null)
        {
            WebClient pictureClient = new WebClient();
            string savePath = HttpContext.Current.Server.MapPath("dist/img/profile/") + username + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + Path.GetExtension(picture.Substring(0, picture.IndexOf('?')));
            pictureClient.DownloadFile(picture, savePath);
            int pictureUserId = UserMembershipHelper.GetUserIDFromProviderUserKey(UserMembershipHelper.GetUser(username).ProviderUserKey);
            LegacyDb.user_saveavatar(pictureUserId, picture, null, null);
        } else { picture = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/dist/img/profile/male_placeholder_signedin.png"; }

        Password hash = HashPassword(password);
        string sql = "INSERT INTO users (user_name,email_address,email_confirmed,email_unsubscribed,password_hash,password_salt,social_auth_token,avatar,ip,full_name,full_name_changed,admin,last_login,time_created,online_status,measurement,reset_password,inactive) VALUES " +
            "(@user_name,@email_address,@email_confirmed,0,@password_hash,@password_salt,@social_auth_token,@avatar,@ip,@full_name,0,0,@last_login,@time_created,0,0,0,0)";
        Dictionary<string, object> insertUserParams = new Dictionary<string, object>
        {
            { "@user_name", username },
            { "@email_address", email },
            { "@email_confirmed", confirmed },
            { "@password_hash", hash.Hash },
            { "@password_salt", hash.Salt },
            { "@social_auth_token", socialToken ?? (object)DBNull.Value },
            { "@avatar", picture },
            { "@ip", HttpContext.Current.Request.Headers.Get("CF-Connecting-IP") },
            { "@full_name", fullName },
            { "@last_login", DateTime.Now },
            { "@time_created", DateTime.Now }
        };
        commons.ExecuteQuery(sql, insertUserParams);

        HttpCookie anonymousUserId = HttpContext.Current.Request.Cookies["anonymousUserId"];
        if (anonymousUserId != null) {
            sql = "UPDATE custom_box_states SET user_name = @user_name WHERE anonymous_user_id = @anonymous_user_id;" +
                "UPDATE custom_sort_orders SET user_name = @user_name WHERE anonymous_user_id = @anonymous_user_id;";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@user_name", username },
                { "@anonymous_user_id", anonymousUserId.Value }
            });
            HttpCookie anonCookie = new HttpCookie("anonymousUserId");
            anonCookie.Expires = DateTime.Now.AddDays(-1);
            HttpContext.Current.Response.Cookies.Add(anonCookie);
        }
            
        MembershipCreateStatus memberStatus = new MembershipCreateStatus();
        MembershipUser user = Membership.CreateUser(username, hash.Hash, email, "default", "default", true, out memberStatus);
        RoleMembershipHelper.SetupUserRoles(1, username);
        int? userId = RoleMembershipHelper.CreateForumUser(user, 1);
        if (userId == null) { throw new Exception("Failed Registering Forum User"); }
        YafUserProfile profile = YafUserProfile.GetProfile(username);
        profile.Save();
        LegacyDb.user_save(
            userID: userId,
            boardID: 1,
            userName: username,
            displayName: fullName,
            email: email,
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

        if (!confirmed)
        {
            string confirmationGuid = Guid.NewGuid().ToString();
            string confirmationSql = "INSERT INTO email_confirmations (email_confirmation_identifier,user_name) VALUES (@email_confirmation_identifier,@user_name)";
            commons.ExecuteQuery(confirmationSql, new Dictionary<string, object>
                {
                    { "@email_confirmation_identifier", confirmationGuid },
                    { "@user_name", username }
                });
            string subject = "Kunming LIVE! Email Confirmation";
            string body = "Thank you for signing up to Kunming LIVE! Click the following link to confirm your email.<br /><br />https://kunminglive.com/?confirm=" + confirmationGuid;
            commons.SendEmail(new User(username), subject, body);
            return "Confirm";
        }
        else
        {
            commons.SetAuthCookie(username);
        }
        commons.SendEmail(new User("Jancarius"), "New User Registered", new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(insertUserParams));
        return "Valid";
    }

    public static Password HashPassword(string password, byte[] salt = null)
    {
        if (salt == null)
        {
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);
        }
        var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
        byte[] hash = pbkdf2.GetBytes(20);
        byte[] hashBytes = new byte[36];
        Array.Copy(salt, 0, hashBytes, 0, 16);
        Array.Copy(hash, 0, hashBytes, 16, 20);
        string passwordHash = Convert.ToBase64String(hashBytes);
        Password savedHash = new Password(passwordHash, salt);

        return savedHash;
    }

    public enum OnlineStatusType
    {
        Online,
        Busy,
        Offline
    }

    public enum Measurement
    {
        Metric,
        Imperial
    }

    public class Password
    {
        public string Hash;
        public byte[] Salt;

        public Password(string hash, byte[] salt)
        {
            this.Hash = hash;
            this.Salt = salt;
        }
    }
}