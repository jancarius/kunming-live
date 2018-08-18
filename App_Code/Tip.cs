using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Tip Data Structure Class
/// </summary>
public class Tip
{
    public Tip(int tipId, string title, string mainImagePath, string preview, string shortDescription, string description)
    {
        TipID = tipId;
        Title = title;
        MainImagePath = mainImagePath;
        Preview = preview;
        ShortDescription = shortDescription;
        Description = description;
    }

    public int TipID { get; set; }
    public string Title { get; set; }
    public string MainImagePath { get; set; }
    public string Preview { get; set; }
    public string ShortDescription { get; set; }
    public string Description { get; set; }
    public string Link
    {
        get
        {
            return "https://www.kunminglive.com/tips/" + TipID.ToString() + "/" + Title.RemoveSpecialCharacters().Replace(" ", "-");
        }
    }

    public static Tip[] GetTips()
    {
        string sql = "SELECT * FROM tips ORDER BY sort_order DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<Tip> tips = new List<Tip>();
        foreach (Result result in resultSet)
        {
            tips.Add(new Tip(
                (int)result["tip_id"],
                (string)result["title"],
                (string)result["main_image_path"],
                (string)result["preview_description"],
                (string)result["short_description"],
                (string)result["description"]
            ));
        }
        return tips.ToArray();
    }

    public static bool? CreateTip(string title, string mainImagePath, string description)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        User currentUser = new User(HttpContext.Current.User.Identity.Name);
        if (!currentUser.Admin) { return false; }

        description = commons.CensorWords(description);

        Dictionary<int, string> images = new Dictionary<int, string>();
        int removedChars = 0;
        while (description.IndexOf("<img") >= 0)
        {
            int imageTagStartIndex = description.IndexOf("<img");
            int imageTagEndIndex = description.IndexOf(">", imageTagStartIndex) + 1;
            string imageTag = description.Substr(imageTagStartIndex, imageTagEndIndex);
            description = description.RemoveAt(imageTagStartIndex, imageTagEndIndex);
            images.Add(imageTagStartIndex + removedChars, imageTag);
            removedChars += imageTag.Length;
        }

        string previewDescription = description.Substr(0, description.IndexOf(@"//previewContent\\"));
        string shortDescription = description.Substr(0, description.IndexOf(@"//shortContent\\")).Replace(@"//previewContent\\", "");

        foreach (KeyValuePair<int, string> image in images)
        {
            description = description.Insert(image.Key, image.Value);
        }

        description = description.Replace(@"//previewContent\\", "").Replace(@"//shortContent\\", "");

        mainImagePath = commons.SaveBase64Image(mainImagePath, "dist/img/tips");

        string sql = "INSERT INTO tips (title,main_image_path,preview_description,short_description,description,sort_order) VALUES (@title,@main_image_path,@preview_description,@short_description,@description,0)";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@title", title },
            { "@main_image_path", mainImagePath },
            { "@preview_description", previewDescription },
            { "@short_description", shortDescription },
            { "@description", description }
        });
        return true;
    }
}