using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using YAF.Classes.Data;
using YAF.Core;
using YAF.Types.Flags;

/// <summary>
/// Summary description for BlogPost
/// </summary>
public class BlogPost
{
    public BlogPost(int blogPostId, User author, string title, string description, PostTypes postType, string previewContent, string shortContent, string fullContent, DateTime timeCreated)
    {
        BlogPostID = blogPostId;
        Author = author;
        Title = title;
        Description = description;
        PostType = postType;
        PreviewContent = previewContent;
        ShortContent = shortContent;
        FullContent = fullContent;
        TimeCreated = timeCreated;
        CommentCount = (int)commons.ExecuteQuery("SELECT COUNT(review_id) FROM reviews WHERE table_name = 'blog_posts' AND primary_identifier = " + BlogPostID)[0][""];
        GetTags();
    }
    
    public int BlogPostID { get; private set; }
    public User Author { get; set; }
    public List<BlogTag> Tags { get; private set; }
    public PostTypes PostType { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public string PreviewContent { get; set; }
    public string ShortContent { get; set; }
    public string FullContent { get; set; }
    public DateTime TimeCreated { get; private set; }
    public int CommentCount { get; private set; }
    public string ElapsedTime
    {
        get
        {
            return commons.GetTimeSince(TimeCreated);
        }
    }
    public string Link
    {
        get
        {
            return "https://www.kunminglive.com/blog-posts/" + BlogPostID.ToString() + "/" + Title.Replace(" ", "-");
        }
    }

    private void GetTags()
    {
        Tags = new List<BlogTag>();
        string filterTagSql = "SELECT * FROM blog_post_tags WHERE blog_post_id = @blog_post_id ORDER BY tag";
        SqlConnection filterTagConn = new SqlConnection(commons.connString);
        SqlCommand filterTagCmd = new SqlCommand(filterTagSql, filterTagConn);
        filterTagCmd.Parameters.AddWithValue("blog_post_id", BlogPostID);
        filterTagConn.Open();
        SqlDataReader filterTagReader = filterTagCmd.ExecuteReader();
        while (filterTagReader.Read())
        {
            string filterTag = (string)filterTagReader["tag"];
            string filterTagCountSql = "SELECT COUNT(tag) FROM blog_post_tags WHERE tag = @tag";
            SqlConnection filterTagCountConn = new SqlConnection(commons.connString);
            SqlCommand filterTagCountCmd = new SqlCommand(filterTagCountSql, filterTagCountConn);
            filterTagCountCmd.Parameters.AddWithValue("@tag", filterTag);
            filterTagCountConn.Open();
            int filterTagCount = (int)filterTagCountCmd.ExecuteScalar();
            filterTagCountConn.Close();
            BlogTag blogTag = new BlogTag(filterTag, filterTagCount, this);
            Tags.Add(blogTag);
        }
        filterTagReader.Close();
        filterTagConn.Close();
    }

    public void SaveChanges()
    {
        string sql = "UPDATE blog_posts SET title = @title, description = @description, preview_content = @preview_content, short_content = @short_content, full_content = @full_content, post_type = @post_type WHERE blog_post_id = " + BlogPostID + ";";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@title", Title },
            { "@description", Description },
            { "@preview_content", PreviewContent },
            { "@short_content", ShortContent },
            { "@full_content", FullContent },
            { "@post_type", PostType }
        });
    }

    public static string GetBlogTags()
    {
        string html = "";
        ResultSet resultSet = commons.ExecuteQuery("SELECT DISTINCT tag FROM blog_post_tags");
        foreach (Result result in resultSet)
        {
            string tag = (string)result["tag"];
            ResultSet tagsResultSet = commons.ExecuteQuery("SELECT COUNT(tag) FROM blog_post_tags WHERE tag = @tag", new Dictionary<string, object> { { "@tag", tag } });
            int tagCount = (int)tagsResultSet[0][""];
            if (tagCount >= 6)
            {
                tagCount = 6;
            }
            else if (tagCount <= 2)
            {
                tagCount = 2;
            }
            tagCount = tagCount * 3 + 4;
            html += "<span id='tag" + tag + "' title='" + tag + "' class='btn btn-small btn-flat btn-primary tag-filters' style='margin: 0 0 5px 5px;font-size: " + tagCount + "px'><i class='fa fa-tag'></i> " + tag + "</span>";
        }

        return html;
    }

    public static string[] GetBlogTagsArray()
    {
        List<string> tags = new List<string>();
        ResultSet resultSet = commons.ExecuteQuery("SELECT DISTINCT tag FROM blog_post_tags");
        foreach(Result result in resultSet)
        {
            tags.Add((string)result["tag"]);
        }
        return tags.ToArray();
    }

    public static BlogPost[] GetBlogPosts(int postCount, string[] tagFilters = null, string[] typeFilters = null, DateTime? oldestPost = null, DateTime? newestPost = null, bool preview = false)
    {
        tagFilters = tagFilters ?? null;
        typeFilters = typeFilters ?? null;
        oldestPost = oldestPost ?? (DateTime)System.Data.SqlTypes.SqlDateTime.MinValue;
        newestPost = newestPost ?? (DateTime)System.Data.SqlTypes.SqlDateTime.MaxValue;
        
        string sql = "SELECT TOP " + postCount + " * FROM blog_posts WHERE ";
        if (tagFilters != null)
        {
            sql += "blog_post_id IN (SELECT DISTINCT blog_post_id FROM blog_post_tags WHERE tag IN ('" + string.Join("','", tagFilters) + "')) AND ";
        }
        if (typeFilters != null)
        {
            sql += "post_type IN ('" + string.Join("','", typeFilters) + "') AND ";
        }
        sql += "time_created >= @created_after AND time_created <= @created_before ORDER BY time_created DESC;";

        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object> {
            { "@created_after", oldestPost },
            { "@created_before", newestPost }
        });

        List<BlogPost> blogPosts = new List<BlogPost>();
        
        foreach (Result result in resultSet)
        {
            blogPosts.Add(new BlogPost(
                (int)result["blog_post_id"],
                new User((int)result["user_id"]),
                (string)result["title"],
                (string)result["description"],
                (PostTypes)result["post_type"],
                (string)result["preview_content"],
                (string)result["short_content"],
                (string)result["full_content"],
                (DateTime)result["time_created"]
            ));
        }

        return blogPosts.ToArray();
    }

    public static bool CreateBlogPost(string username, PostTypes type, string title, string description, string content, string[] tags)
    {
        User blogUser = new User(username);
        if (!blogUser.Admin)
        {
            return false;
        }

        content = commons.CensorWords(content);

        content = content.Replace(" width:", " width:-moz-fill-available; width: -webkit-fill-available; width: fill-available; max-width:").Replace(" height:", " max-height:").Replace("<h2>", "<h2 style='margin-top: 0'>");

        Dictionary<int, string> images = new Dictionary<int, string>();
        int removedChars = 0;
        while (content.IndexOf("<img") >= 0)
        {
            int imageTagStartIndex = content.IndexOf("<img");
            int imageTagEndIndex = content.IndexOf(">", imageTagStartIndex) + 1;
            string imageTag = content.Substr(imageTagStartIndex, imageTagEndIndex);
            content = content.RemoveAt(imageTagStartIndex, imageTagEndIndex);
            images.Add(imageTagStartIndex + removedChars, imageTag);
            removedChars += imageTag.Length;
        }

        string previewContent = content.Substr(0, description.IndexOf(@"//previewContent\\"));
        string shortContent = content.Substr(0, description.IndexOf(@"//shortContent\\")).Replace(@"//previewContent\\", "");

        foreach (KeyValuePair<int, string> image in images)
        {
            content = content.Insert(image.Key, image.Value);
        }

        var messageFlags = new MessageFlags
        {
            IsHtml = true,
            IsBBCode = false,
            IsPersistent = true,
            IsApproved = true
        };
        User currentUser = new User(HttpContext.Current.User.Identity.Name);

        string blogPostSql = "INSERT INTO blog_posts (user_id,title,description,preview_content,short_content,full_content,time_created,post_type) " +
            "OUTPUT INSERTED.blog_post_id VALUES (@user_id,@title,@description,@preview_content,@short_content,@full_content,@time_created,@post_type)";
        ResultSet blogPostResultSet = commons.ExecuteQuery(blogPostSql, new Dictionary<string, object>
                {
                    { "@user_id", blogUser.UserID },
                    { "@title", title },
                    { "@description", description },
                    { "@preview_content", previewContent },
                    { "@short_content", shortContent },
                    { "@full_content", content },
                    { "@time_created", DateTime.Now },
                    { "@post_type", type }
                });
        int blogPostId = (int)blogPostResultSet[0]["blog_post_id"];

        blogPostSql = "INSERT INTO blog_post_tags (blog_post_id,tag) VALUES (@blog_post_id, @tag)";
        foreach (string tag in tags)
        {
            commons.ExecuteQuery(blogPostSql, new Dictionary<string, object>
                    {
                        { "@blog_post_id", blogPostId },
                        { "@tag", tag }
                    });
        }

        return true;
    }

    public static long CreateNewTopic(int forumid, int userid, string username, string status, string styles, string description, string subject, string post, string ip, int priority, int flags)
    {
        long messageId = 0;
        return YAF.Classes.Data.LegacyDb.topic_save(
            forumid,
            subject,
            status,
            styles,
            description,
            post,
            userid,
            priority,
            username,
            ip,
            DateTime.UtcNow,
            string.Empty,
            flags,
            ref messageId);
    }

    public enum PostTypes
    {
        Announcement,
        Article,
        BlogPost,
        Update
    }

    public class BlogTag
    {
        public BlogTag(string tag, int size, BlogPost blogPost)
        {
            BlogPost = blogPost;
            Tag = tag;
            if (size >= 6) { size = 6; }
            else if (size <= 2) { size = 2; }
            Size = size * 3 + 4;
        }

        public BlogPost BlogPost { get; private set; }
        public string Tag { get; private set; }
        public int Size { get; private set; }
        public string Link
        {
            get
            {
                return "https://www.kunminglive.com/blog-articles/tag/" + Tag.Replace(" ", "+");
            }
        }
    }
}