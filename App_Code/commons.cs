using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.IO;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Drawing;
using System.Drawing.Imaging;

/// <summary>
/// Helper functions
/// </summary>
public static class commons
{
    public static string connString = System.Configuration.ConfigurationManager.ConnectionStrings["yafnet"].ConnectionString;
    public static string forumToken = "25cd6e51-73d8-443c-baf6-8770e24f512b";

    public static string GetAnonymousUserID()
    {
        string anonUserId = "";
        if (!HttpContext.Current.Request.IsAuthenticated)
        {
            HttpCookie anonymousUserId = HttpContext.Current.Request.Cookies.Get("anonymousUserId");
            if (HttpContext.Current.Request.Cookies.Get("anonymousUserId") == null)
            {
                anonUserId = Guid.NewGuid().ToString();
                anonymousUserId = new HttpCookie("anonymousUserId", anonUserId);
                anonymousUserId.Expires = DateTime.Now.AddYears(1);
                anonymousUserId.Path = "/";
                HttpContext.Current.Response.Cookies.Add(anonymousUserId);
            }
            else { anonUserId = anonymousUserId.Value; }
        }
        return anonUserId;
    }

    public static string GetRandomBackgroundStyle()
    {
        string[] bgFiles = Directory.GetFiles(HttpContext.Current.Server.MapPath("dist/img/bg/"), "*.jpg");
        if (bgFiles.Length > 0)
        {
            string bgFile = bgFiles[new Random().Next(1, bgFiles.Length) - 1].Substring(bgFiles[0].IndexOf("dist\\img")).Replace("\\", "/");
            return "background: url('https://www.kunminglive.com/" + bgFile + "') no-repeat center center fixed;background-size:cover;";
        }
        return "background-color: #ecf0f5;";
    }

    public static void SetAuthCookie(string username, bool rememberMe = false)
    {
        FormsAuthentication.SetAuthCookie(username, rememberMe);
        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, username, DateTime.Now, DateTime.Now.AddYears(1), rememberMe, "", "/");
        string encTicket = FormsAuthentication.Encrypt(ticket);
        HttpCookie authCookie = new HttpCookie(".YAFNET_Authentication", encTicket);
        if (rememberMe) { authCookie.Expires = DateTime.Now.AddYears(1); }
        authCookie.Path = "/";
        HttpContext.Current.Response.Cookies.Add(authCookie);
    }

    public static bool? CreateNotification(string title, string description, Notification.Types type, string url, bool urgent = false, string username = null)
    {
        if (username == null) {
            if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
            username = HttpContext.Current.User.Identity.Name;
        }
        string sql = "INSERT INTO notifications (user_name,title,description,type,url,urgent,viewed,dismissed,time_created) VALUES (@user_name,@title,@description,@type,@url,@urgent,0,0,GETDATE())";
        ResultSet resultSet = ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username },
            { "@title", title },
            { "@description", description },
            { "@type", type },
            { "@url", url },
            { "@urgent", urgent }
        });
        if (resultSet == null) { return false; }
        return true;
    }

    public static string emailHost = "hunterwebapps.com";
    public static int emailPort = 25;
    public static NetworkCredential emailCredentialsAdmin = new NetworkCredential("admin@kunminglive.com", "Garthan1");
    public static NetworkCredential emailCredentialsHunter = new NetworkCredential("hunter@kunminglive.com", "Garthan1");

    public static void SendEmail(User[] to, string subject, string body, bool subscriptionEmail = false, NetworkCredential credentials = null, MailAddress from = null, bool isHtml = true)
    {
        foreach(User user in to)
        {
            SendEmail(user, subject, body, subscriptionEmail, credentials, from, isHtml);
        }
    }
    public static void SendEmail(User to, string subject, string body, bool subscriptionEmail = false, NetworkCredential credentials = null, MailAddress from = null, bool isHtml = true)
    {
        try
        {
            if (subscriptionEmail && to.EmailUnsubscribed) { return; }
            if (credentials == null) { credentials = emailCredentialsAdmin; }
            if (from == null) { from = new MailAddress("admin@kunminglive.com", "Kunming Live"); }

            SmtpClient smtp = new SmtpClient(emailHost, emailPort);
            smtp.Credentials = credentials;

            MailMessage msg = new MailMessage(from, new MailAddress(to.Email, to.FullName));
            if (subscriptionEmail)
            {
                msg.Headers.Add("List-Unsubscribe-Post", "List-Unsubscribe=One-Click");
                msg.Headers.Add("List-Unsubscribe", "<https://kunminglive.com/unsubscribe.aspx?u=" + to.UserID + ">");
            }

            msg.Subject = subject;
            msg.Body = body;
            msg.IsBodyHtml = isHtml;

            smtp.Send(msg);
        }
        catch (Exception ex)
        {
            LogError(ex, new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(to));
        }
    }

    public static void LogError(Exception ex, string extraInfo = "")
    {
        string message = ex.ToString() + "<br/><br/>" + ex.Message + "<br/><br/>";

        string source = "";
        if (ex.Source != null)
        {
            source += ex.Source + "<br/><br/>";
        }

        string stackTrace = "";
        if (ex.StackTrace != null)
        {
            stackTrace += ex.StackTrace + "<br/><br/>";
        }

        string targetSite = "";
        if (ex.TargetSite != null)
        {
            targetSite += ex.TargetSite.Name;
        }

        Exception innerException = ex.InnerException;
        while (innerException != null)
        {
            if (innerException.Message != null)
            {
                message += innerException.Message + "<br/><br/>";
            }
            if (innerException.Source != null)
            {
                source += innerException.Source;
            }
            if (innerException.StackTrace != null)
            {
                stackTrace += innerException.StackTrace;
            }
            if (innerException.TargetSite != null)
            {
                targetSite += innerException.TargetSite.Name;
            }
            innerException = innerException.InnerException;
        };

        message += extraInfo;

        string sql = "INSERT INTO error_log (message,source,stack_trace,target_site,time_created) VALUES (@message,@source,@stack_trace,@target_site,@time_created)";
        ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@message", message },
            { "@source", source },
            { "@stack_trace", stackTrace },
            { "@target_site", targetSite },
            { "@time_created", DateTime.Now }
        });
        
        string subj = "Error in Kunming LIVE!";
        string body = message + "<br/><br/>" + extraInfo + "<br/><br/>" + source + "<br/><br/>" + stackTrace + "<br/><br/>" + targetSite + "<br/><br/>";

        SendEmail(new User("jancarius"), subj, body);
    }

    public static object GetFieldById(string table, string getColumn, string idColumn, string id)
    {
        string sql = "SELECT " + getColumn + " FROM " + table + " WHERE " + idColumn + " = @id";
        ResultSet resultSet = ExecuteQuery(sql, id);
        if (resultSet.Length == 1)
        {
            return resultSet[0][getColumn];
        } else { return null; }
    }

    public static ResultSet ExecuteQuery(string sqlStatement, object parameter)
    {
        int paramIndex = sqlStatement.IndexOf("@");

        int spaceIndex = sqlStatement.IndexOf(" ", paramIndex);
        int semiIndex = sqlStatement.IndexOf(";", paramIndex);
        int parenthesisIndex = sqlStatement.IndexOf(")", paramIndex);
        int commaIndex = sqlStatement.IndexOf(",", paramIndex);
        int eosIndex = sqlStatement.Length;

        int[] indices = { spaceIndex, semiIndex, parenthesisIndex, eosIndex, commaIndex };
        indices = indices.Where(x => x != -1).ToArray();
        Array.Sort(indices);
        
        string paramName = sqlStatement.Substr(paramIndex, indices[0]);

        return ExecuteQuery(sqlStatement, new Dictionary<string, object> { { paramName, parameter } });
    }
    public static ResultSet ExecuteQuery(string sqlStatement, Dictionary<string, object> parameters = null)
    {
        SqlConnection conn = new SqlConnection(commons.connString);
        SqlCommand cmd = new SqlCommand(sqlStatement, conn);
        if (parameters != null)
        {
            foreach (KeyValuePair<string, object> param in parameters)
            {
                cmd.Parameters.AddWithValue(param.Key, param.Value);
            }
        }
        ResultSet resultSet = new ResultSet();
        try
        {
            conn.Open();

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    Result row = new Result();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row.Add(reader.GetName(i), reader.GetValue(i));
                    }
                    resultSet.Add(row);
                }
            }
            conn.Close();
        }
        catch (Exception ex)
        {
            conn.Close();
            LogError(ex, sqlStatement + (parameters == null ? "" : string.Join(";", parameters)));
        }

        return resultSet;
    }

    public static void LogAction(string description)
    {
        string sql = "INSERT INTO action_log (user_name,ip_address,current_request,referrer_request,description,time_created) VALUES(@user_name,@ip_address,@current_request,@referrer_request,@description,@time_created)";
        string username = HttpContext.Current.User.Identity.Name;
        string ip = HttpContext.Current.Request.Headers.Get("CF-Connecting-IP");
        string current = Path.GetFileName(HttpContext.Current.Request.Url.AbsolutePath);
        string referrer = "";
        if (HttpContext.Current.Request.UrlReferrer != null) {
            referrer = Path.GetFileName(HttpContext.Current.Request.UrlReferrer.AbsolutePath);
        }
        DateTime timeCreated = DateTime.Now;
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username },
            { "@ip_address", ip },
            { "@current_request", current },
            { "@referrer_request", referrer },
            { "@description", description },
            { "@time_created", timeCreated }
        });
    }

    public static string GetTimeSince(DateTime timeSince)
    {
        TimeSpan elapse = DateTime.Now - timeSince;
        if (elapse.Days > 0) { return elapse.Days + " day" + (elapse.Days > 1 ? "s" : ""); }
        else if (elapse.Hours > 0) { return elapse.Hours + " hour" + (elapse.Hours > 1 ? "s" : ""); }
        else if (elapse.Minutes > 0) { return elapse.Minutes + " min" + (elapse.Minutes > 1 ? "s" : ""); }
        else { return elapse.Seconds + " sec" + (elapse.Seconds > 1 ? "s" : ""); }
    }

    public static string SaveBase64Image(string thumbFilePath, string directory)
    {
        string mappedDirectory = HttpContext.Current.Server.MapPath(directory);
        string filePath = thumbFilePath.Replace("_thumb", "");

        if (!Directory.Exists(mappedDirectory)) { Directory.CreateDirectory(mappedDirectory); }

        string thumbFileName = Path.GetFileName(thumbFilePath);
        string fileName = Path.GetFileName(filePath);
        
        Uri checkRelative;
        if (Uri.TryCreate(filePath, UriKind.Absolute, out checkRelative))
        {
            filePath = HttpContext.Current.Server.MapPath(new Uri(filePath).AbsolutePath);
            thumbFilePath = HttpContext.Current.Server.MapPath(new Uri(thumbFilePath).AbsolutePath);
        } else
        {
            filePath = HttpContext.Current.Server.MapPath(filePath);
            thumbFilePath = HttpContext.Current.Server.MapPath(thumbFilePath);
        }
        string mappedFile = Path.Combine(mappedDirectory, fileName);
        string mappedThumbFile = Path.Combine(mappedDirectory, thumbFileName);
        if (!File.Exists(mappedFile))
        {
            File.Move(filePath, mappedFile);
        }
        if (!File.Exists(mappedThumbFile))
        {
            File.Move(thumbFilePath, mappedThumbFile);
        }
        
        return "https://www.kunminglive.com/" + directory + "/" + thumbFileName;
    }

    public static string ResizeImage(Image image, string imageExtension)
    {
        if (!Directory.Exists(HttpContext.Current.Server.MapPath("/dist/img/tmp"))) { Directory.CreateDirectory(HttpContext.Current.Server.MapPath("/dist/img/tmp")); }

        int newHeight;
        int newWidth;
        int thumbHeight;
        int thumbWidth;
        if (image.Height > image.Width)
        {
            if (image.Height > 1024)
            {
                newHeight = 1024;
                newWidth = (int)Math.Ceiling(image.Width * (1024 / (float)image.Height));
            }
            else
            {
                newHeight = (int)Math.Ceiling((float)image.Height);
                newWidth = (int)Math.Ceiling((float)image.Width);
            }
            thumbHeight = 256;
            thumbWidth = Convert.ToInt32((256M / (decimal)newHeight) * (decimal)newWidth);
        }
        else
        {
            if (image.Width > 1024)
            {
                newWidth = 1024;
                newHeight = (int)Math.Ceiling(image.Height * (1024 / (float)image.Width));
                thumbWidth = 128;
            }
            else
            {
                newHeight = (int)Math.Ceiling((float)image.Height);
                newWidth = (int)Math.Ceiling((float)image.Width);
            }
            thumbWidth = 256;
            thumbHeight = Convert.ToInt32((256M / (decimal)newWidth) * (decimal)newHeight);
        }

        Image thumbImage = new Bitmap(image, thumbWidth, thumbHeight);
        Image resizedImage = new Bitmap(image, newWidth, newHeight);

        ImageCodecInfo codecInfo = GetEncoder(imageExtension);

        EncoderParameters encoderParameters = new EncoderParameters(4);
        encoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 50L);
        encoderParameters.Param[1] = new EncoderParameter(Encoder.ScanMethod, (int)EncoderValue.ScanMethodInterlaced);
        encoderParameters.Param[2] = new EncoderParameter(Encoder.RenderMethod, (int)EncoderValue.RenderProgressive);
        encoderParameters.Param[3] = new EncoderParameter(Encoder.Compression, 50L);

        string guid = Guid.NewGuid().ToString();
        string path = HttpContext.Current.Server.MapPath("dist/img/tmp") + "\\";
        string tempFileName = path + guid + "." + imageExtension;
        string thumbTempFileName = path + guid + "_thumb." + imageExtension;
        resizedImage.Save(tempFileName, codecInfo, encoderParameters);
        thumbImage.Save(thumbTempFileName, codecInfo, encoderParameters);

        string filePath = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + thumbTempFileName.Substring(tempFileName.IndexOf("\\dist\\img\\tmp"));
        return filePath.Replace("\\", "/");
    }

    public static ImageCodecInfo GetEncoder(string fileExtension)
    {
        ImageFormat format;
        switch (fileExtension.ToLower())
        {
            case "gif":
                format = ImageFormat.Gif;
                break;
            case "png":
                format = ImageFormat.Png;
                break;
            case "jpeg":
            case "jpg":
            default:
                format = ImageFormat.Jpeg;
                break;
        }
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
        foreach (ImageCodecInfo codec in codecs)
        {
            if (codec.FormatID == format.Guid)
            {
                return codec;
            }
        }
        return null;
    }

    public static string CensorWords(string content)
    {
        string sensitiveFile = Path.Combine(HttpContext.Current.Server.MapPath("/"), "sensitive_words.txt");
        string[] sensitiveWords = File.ReadAllLines(sensitiveFile);
        foreach (string sensitiveWord in sensitiveWords)
        {
            char[] symbols = new char[sensitiveWord.Length];
            for (int i = 0; i < symbols.Length; i++)
            {
                symbols[i] = '*';
            }
            string asterisks = new string(symbols);
            content = content.ReplaceInsensitive(sensitiveWord, asterisks);
        }
        return content;
    }

    public static Control FindRecursive(this Control control, string id)
    {
        for (int i = 0; i < control.Controls.Count; i++)
        {
            Control ctl = control.Controls[i];
            if (ctl.ID == id)
                return ctl;

            Control child = FindRecursive(ctl, id);
            if (child != null)
                return child;
        }
        return null;
    }

    public static void AddCssClass(this Control control, string cssClass)
    {
        HtmlGenericControl thisControl = (HtmlGenericControl)control;
        if (thisControl == null) { return; }
        string classes = thisControl.Attributes["class"];
        List<string> currentClasses = new List<string>();
        if (!string.IsNullOrEmpty(classes)) {
            currentClasses = classes.Split(' ').ToList<string>();
        }
        currentClasses.Add(cssClass);
        thisControl.Attributes.Remove("class");
        thisControl.Attributes.Add("class", string.Join(" ", currentClasses.ToArray()));
    }

    public static string Substr(this string str, int startIndex, int endIndex)
    {
        return str.Substring(startIndex, endIndex - startIndex);
    }

    public static string RemoveAt(this string str, int startIndex, int endIndex)
    {
        return str.Remove(startIndex, endIndex - startIndex);
    }

    public static List<int> AllIndexesOf(string str, string value)
    {
        if (String.IsNullOrEmpty(value))
            throw new ArgumentException("the string to find may not be empty", "value");
        List<int> indexes = new List<int>();
        for (int index = 0; ; index += value.Length)
        {
            index = str.IndexOf(value, index);
            if (index == -1)
            {
                return indexes;
            }
            indexes.Add(index);
        }
    }

    public static string RemoveSpecialCharacters(this string str)
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        foreach (char c in str)
        {
            if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '.' || c == '_' || c == '-' || c == ' ')
            {
                sb.Append(c);
            }
        }
        return sb.ToString();
    }

    public static string ReplaceInsensitive(this string Text, string Find, string Replacement, int Start = 1, int Count = -1)
    {
        if (Start != 1) { Text = Text.Substring(Start - 1); }

        Find = Find.ToLower();
        int difference = Replacement.Length - Find.Length;
        int TotDifference = 0;
        string TextLow = Text.ToLower();
        int P = 0;
        int NewP = 0;
        int C = 1;
        do
        {
            P = TextLow.IndexOf(Find, P);
            if (P != -1)
            {
                NewP = P + TotDifference;
                Text = Text.Substring(0, NewP) + Replacement + Text.Substring(NewP + Find.Length);
                TotDifference += difference;
                if (Count != -1 && Count == C)
                {
                    break;
                }
            }
            else
            {
                break;
            }
            C += 1;
            P += Find.Length;
        } while (true);
        return Text;
    }
}
