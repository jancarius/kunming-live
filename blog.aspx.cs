using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.IO;
using System.Web.Script.Serialization;

public partial class blog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string value = null;
        if (Request.QueryString["action"] == "tag")
        {
            value = Request.QueryString["value"];
        }

        timeline.Controls.Add(new LiteralControl(
            CreateTimeline(
                BlogPost.GetBlogPosts(10, value == null ? null : new string[] { value })
            )
        ));
        phTags.Controls.Add(new LiteralControl(BlogPost.GetBlogTags()));
        
        hiddenIDParam.Value = Request.QueryString["id"];
    }

    [WebMethod]
    public static string FilterPosts(Dictionary<string, string> postFilterData)
    {
        string[] dateFilter = postFilterData["dateRange"].Contains(",") ? postFilterData["dateRange"].Split(',') : new string[] { null, null };
        DateTime? oldestPost = null, newestPost = null;
        DateTime tryParse;
        if (DateTime.TryParse(dateFilter[0], out tryParse))
        {
            oldestPost = tryParse;
        }
        if (DateTime.TryParse(dateFilter[1], out tryParse))
        {
            newestPost = tryParse;
        }
        string[] tagFilters = postFilterData["tagFilters"].Length > 0 ? postFilterData["tagFilters"].Split(',') : null;
        string[] typeFilters = postFilterData["typeFilters"].Length > 0 ? postFilterData["typeFilters"].Split(',') : null;
        int postCount = Convert.ToInt32(postFilterData["postCount"]);
        return CreateTimeline(BlogPost.GetBlogPosts(postCount, tagFilters, typeFilters, oldestPost, newestPost));
    }

    private static string CreateTimeline(BlogPost[] blogPosts)
    {
        string timelineContents = "";
        List<DateTime> datesAdded = new List<DateTime>();
        foreach (BlogPost blogPost in blogPosts)
        {
            if (!datesAdded.Contains(blogPost.TimeCreated.Date))
            {
                datesAdded.Add(blogPost.TimeCreated.Date);
                string dateStamp = "<li class='time-label' style='display:inline-block'><span class='bg-green'>" + blogPost.TimeCreated.ToString("dd MMM yy") + "</span></li>";
                timelineContents += dateStamp;
            }

            string faIcon = "fa-users bg-gray";
            switch (blogPost.PostType)
            {
                case BlogPost.PostTypes.Announcement:
                    faIcon = "fa-bullhorn bg-red-active"; 
                    break;
                case BlogPost.PostTypes.Article:
                    faIcon = "fa-newspaper-o bg-navy";
                    break;
                case BlogPost.PostTypes.BlogPost:
                    faIcon = "fa-envelope bg-blue";
                    break;
                case BlogPost.PostTypes.Update:
                    faIcon = "fa-pencil-square bg-yellow-active";
                    break;
            }

            TimeSpan timeSince = DateTime.Now - blogPost.TimeCreated;
            string timeSinceStamp;
            if (timeSince.Days > 0)
            {
                timeSinceStamp = timeSince.Days + " day";
                if (timeSince.Days > 1) { timeSinceStamp += "s"; }
            }
            else if (timeSince.Hours > 0)
            {
                timeSinceStamp = timeSince.Hours + " hour";
                if (timeSince.Hours > 1) { timeSinceStamp += "s"; }
            }
            else if (timeSince.Minutes > 0)
            {
                timeSinceStamp = timeSince.Minutes + " min";
                if (timeSince.Minutes > 1) { timeSinceStamp += "s"; }
            }
            else
            {
                timeSinceStamp = timeSince.Seconds + " sec";
            }

            string tagHtml = "";
            foreach (BlogPost.BlogTag blogTag in blogPost.Tags)
            {
                tagHtml += "<span class='btn btn-small btn-flat btn-primary btn-tag' style='margin-left:5px;font-size: " + blogTag.Size + "px'><i class='fa fa-tag'></i> " + blogTag.Tag + "</span>";
            }

            string bodyhtml =
                "<h3 class='timeline-header clickable'>" +
                    blogPost.Title + " <small>" + blogPost.Description + "</small>" +
                "</h3>" +
                "<div class='timeline-body' data-blog_post_id='" + blogPost.BlogPostID + "'>" +
                    blogPost.ShortContent +
                    "<div class='col-xl-10 col-xl-push-1 no-padding'>" +
                        "<button type='button' class='btn btn-block btn-small btn-primary read-more-blog'>" +
                            "<i class='fa fa-align-left'></i> Read More..." +
                        "</button>" +
                    "</div>" +
                    "<input type='hidden' value='" + new JavaScriptSerializer().Serialize(blogPost) + "' />" +
                    "<div class='clearfix'></div>" +
                "</div>" +
                "<div class='timeline-footer'>" +
                    "<div class='user-block pull-right'>" +
                        "<a href='viewprofile.aspx?id=" + blogPost.Author.UserID + "' target='_blank'>" +
                            "<img src='" + blogPost.Author.Avatar + "' class='img-circle' alt='" + blogPost.Author.FullName + "' />" +
                            "<span class='username'>" +
                                blogPost.Author.FullName +
                            "</span>" +
                            "<span class='description'>" + blogPost.Author.Tagline + "</span>" +
                        "</a>" +
                    "</div>" +
                    "<div class='blog-tags'>" +
                        "<strong style='font-size:16px;'>Tags:</strong> " + tagHtml +
                    "</div>" +
                "</div>" +
                "<div class='clearfix'></div>";

            string faIconStamp =
                "<li id='post" + blogPost.BlogPostID + "' style='display:table'>" +
                    "<i class='fa " + faIcon + "' data-toggle='tooltip' data-original-title='" + blogPost.PostType.ToString() + "'></i>" +
                    "<div class='timeline-item'>" +
                        "<span class='time'><i class='fa fa-clock-o'></i> " + timeSinceStamp + "</span>" +
                        bodyhtml +
                    "</div>" +
                "</li>";

            timelineContents += faIconStamp;
        }

        timelineContents += "<li><i class='fa fa-clock-o bg-gray'></i></li>";

        return timelineContents;
    }
}