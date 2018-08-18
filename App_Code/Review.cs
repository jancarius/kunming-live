using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

/// <summary>
/// Summary description for Review
/// </summary>
public class Review
{
    public Review(int reviewId, string tableName, int primaryId, User author, int? rating, string title, string comment)
    {
        ReviewID = reviewId;
        TableName = tableName;
        PrimaryID = primaryId;
        Author = author;
        Rating = rating;
        Title = title;
        Comment = comment;

        List<ReviewImage> reviewImages = new List<ReviewImage>();
        ResultSet resultSet = commons.ExecuteQuery("SELECT * FROM review_images WHERE review_id = " + reviewId);
        foreach (Result result in resultSet)
        {
            reviewImages.Add(new ReviewImage((int)result["review_image_id"], (string)result["review_image_path"], (int)result["sort_order"]));
        }
        Images = reviewImages.ToArray();

        UpVotes = 0;
        DownVotes = 0;
        List<ReviewVote> reviewVotes = new List<ReviewVote>();
        resultSet = commons.ExecuteQuery("SELECT * FROM review_votes WHERE review_id = " + reviewId);
        foreach (Result result in resultSet)
        {
            ReviewVote reviewVote = new ReviewVote((int)result["review_vote_id"], (string)result["user_name"], (ReviewVote.VoteType)result["vote_type"]);
            reviewVotes.Add(reviewVote);
            if (reviewVote.Vote == ReviewVote.VoteType.Up)
            {
                UpVotes++;
            }
            else if (reviewVote.Vote == ReviewVote.VoteType.Down)
            {
                DownVotes++;
            }
        }
        Votes = reviewVotes.ToArray();
    }

    public int ReviewID { get; private set; }
    public string TableName { get; private set; }
    public int PrimaryID { get; private set; }
    public User Author { get; private set; }
    public int? Rating { get; set; }
    public string Title { get; set; }
    public string Comment { get; set; }
    public ReviewImage[] Images { get; private set; }
    public ReviewVote[] Votes { get; private set; }
    public int UpVotes { get; private set; }
    public int DownVotes { get; private set; }

    public void SaveChanges()
    {
        string sql = "UPDATE reviews SET rating = @rating, title = @title, comment = @comment WHERE review_id = @review_id";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@rating", Rating },
            { "@title", Title },
            { "@comment", Comment },
            { "@review_id", ReviewID }
        });
    }

    public static Review[] GetReviews(string tableName, int primaryId)
    {
        string sql = "SELECT * FROM reviews WHERE table_name = @table_name AND primary_identifier = @primary_identifier";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@table_name", tableName },
            { "@primary_identifier", primaryId }
        });
        List<Review> reviews = new List<Review>();
        foreach (Result result in resultSet)
        {
            reviews.Add(new Review(
                (int)result["review_id"],
                (string)result["table_name"],
                (int)result["primary_identifier"],
                new User((int)result["user_id"]),
                result["rating"] as int?,
                (string)result["title"],
                (string)result["comment"]
            ));
        }
        return reviews.ToArray();
    }

    public static object CreateReview(string tableName, int primaryId, int? rating, string title, string comment, string[] imagesBase64)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }

        title = commons.CensorWords(title);
        comment = commons.CensorWords(comment);

        User currentUser = new User(HttpContext.Current.User.Identity.Name);
        string reviewSql = "";
        ResultSet resultSet;
        if (tableName != "blog_posts")
        {
            reviewSql = "SELECT * FROM reviews WHERE table_name = @table_name AND primary_identifier = @primary_identifier AND user_id = @user_id";
            resultSet = commons.ExecuteQuery(reviewSql, new Dictionary<string, object>
            {
                { "@table_name", tableName },
                { "@primary_identifier", primaryId },
                { "@user_id", currentUser.UserID }
            });
            if (resultSet.Length > 0) { return false; }
        }

        reviewSql = "INSERT INTO reviews (table_name,primary_identifier,user_id,rating,title,comment,time_created) OUTPUT INSERTED.review_id VALUES (@table_name,@primary_identifier,@user_id,@rating,@title,@comment,@time_created)";
        resultSet = commons.ExecuteQuery(reviewSql, new Dictionary<string, object>
        {
            { "@table_name", tableName },
            { "@primary_identifier", primaryId },
            { "@user_id", currentUser.UserID },
            { "@rating", rating.HasValue ? rating.Value : (object)DBNull.Value },
            { "@title", title },
            { "@comment", comment },
            { "@time_created", DateTime.Now }
        });
        int reviewId = (int)resultSet[0]["review_id"];

        reviewSql = "INSERT INTO review_images (review_id,review_image_path,sort_order) VALUES (@review_id,@review_image_path,@sort_order)";
        for (int i = 0; i < imagesBase64.Length; i++)
        {
            string reviewImagePath = commons.SaveBase64Image(imagesBase64[i], "/dist/img/reviews");
            commons.ExecuteQuery(reviewSql, new Dictionary<string, object> {
                { "@review_id", reviewId },
                { "@review_image_path", reviewImagePath },
                { "@sort_order", i }
            });
        }

        return new Review(reviewId, tableName, primaryId, currentUser, rating, title, comment);
    }

    public static string GetPrimaryColumnName(string tableName)
    {
        switch (tableName)
        {
            case "businesses":
                return "business_id";
            case "events":
                return "event_id";
            case "blog_posts":
                return "blog_post_id";
            default:
                return null;
        }
    }
}

public class ReviewImage
{
    public ReviewImage(int reviewImageId, string path, int sortOrder)
    {
        ReviewImageID = reviewImageId;
        Path = path;
        SortOrder = sortOrder;
    }

    public int ReviewImageID { get; private set; }

    public string Path { get; set; }

    public int SortOrder { get; set; }
}

public class ReviewVote
{
    public ReviewVote(int reviewVoteId, string username, VoteType voteType)
    {
        ReviewVoteID = reviewVoteId;
        Username = username;
        Vote = voteType;
    }

    public int ReviewVoteID { get; set; }

    public string Username { get; set; }

    public VoteType Vote { get; set; }

    public enum VoteType
    {
        Up,
        Down
    }

    public static bool CreateVote(int reviewId, VoteType voteType)
    {
        string sql = "SELECT review_vote_id,vote_type FROM review_votes WHERE review_id = @review_id AND user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@review_id", reviewId },
                { "@user_name", HttpContext.Current.User.Identity.Name }
            });
        if (resultSet.Length > 0)
        {
            if ((VoteType)resultSet[0]["vote_type"] == voteType)
            {
                return false;
            }
            else
            {
                sql = "UPDATE review_votes SET vote_type = @vote_type WHERE review_vote_id = @review_vote_id";
                commons.ExecuteQuery(sql, new Dictionary<string, object>
                    {
                        { "@vote_type", voteType },
                        { "@review_vote_id", (int)resultSet[0]["review_vote_id"] }
                    });
                return true;
            }
        }
        else
        {
            sql = "INSERT INTO review_votes (review_id,user_name,vote_type) VALUES (@review_id,@user_name,@vote_type)";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
                {
                    { "@review_id", reviewId },
                    { "@user_name", HttpContext.Current.User.Identity.Name },
                    { "@vote_type", voteType }
                });
            return true;
        }
    }
}