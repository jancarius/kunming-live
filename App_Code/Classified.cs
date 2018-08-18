using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;

/// <summary>
/// Object Model for Classified Posts
/// </summary>
public class Classified
{
    public Classified(int postId, string username, Categories category, EmploymentType subCategory, string title, string description, DateTime timeCreated, bool sponsored, bool inactive, bool expired, string postalCode,
        string compensation, string term, bool internship, bool telecommuting)
    {
        PostID = postId;
        Poster = new User(username);
        Category = category;
        SubCategory = subCategory;
        Title = title;
        Description = description;
        TimeCreated = timeCreated;
        Sponsored = sponsored;
        Inactive = inactive;
        Expired = expired;
        PostalCode = postalCode;
        Compensation = compensation;
        Term = term;
        Internship = internship;
        Telecommuting = telecommuting;

        Images = GetImages(postId);
    }

    public Classified(int postId, string username, Categories category, MarketplaceType subCategory, string title, string description, DateTime timeCreated, bool sponsored, bool inactive, bool expired, string postalCode,
        string price, string condition, string make, string model)
    {
        PostID = postId;
        Poster = new User(username);
        Category = category;
        SubCategory = subCategory;
        Title = title;
        Description = description;
        TimeCreated = timeCreated;
        Sponsored = sponsored;
        Inactive = inactive;
        Expired = expired;
        PostalCode = postalCode;
        Price = price;
        Condition = condition;
        Make = make;
        Model = model;

        Images = GetImages(postId);
    }

    public Classified(int postId, string username, Categories category, HousingType subCategory, string title, string description, DateTime timeCreated, bool sponsored, bool inactive, bool expired, string postalCode,
       int? meters, string rent, decimal? bedrooms, decimal? bathrooms, DateTime? available, bool pets, bool laundry, bool furniture)
    {
        PostID = postId;
        Poster = new User(username);
        Category = category;
        SubCategory = subCategory;
        Title = title;
        Description = description;
        TimeCreated = timeCreated;
        Sponsored = sponsored;
        Inactive = inactive;
        Expired = expired;
        PostalCode = postalCode;
        Meters = meters;
        Rent = rent;
        Bedrooms = bedrooms;
        Bathrooms = bathrooms;
        Available = available;
        Pets = pets;
        Laundry = laundry;
        Furniture = furniture;

        Images = GetImages(postId);
    }

    public int PostID { get; set; }
    public User Poster { get; set; }
    public Categories Category { get; set; }
    public string CategoryString { get { return Category.ToString(); } }
    public Enum SubCategory { get; set; }
    public string SubCategoryString { get { return SubCategory.ToString(); } }
    public string Title { get; set; }
    public string Description { get; set; }
    public DateTime TimeCreated { get; set; }
    public string TimeSince
    {
        get
        {
            return commons.GetTimeSince(TimeCreated);
        }
    }
    public bool Sponsored { get; set; }
    public bool Inactive { get; set; }
    public bool Expired { get; set; }
    public string PostalCode { get; set; }
    public string Price { get; set; }
    public string Compensation { get; set; }
    public string Term { get; set; }
    public bool Internship { get; set; }
    public bool Telecommuting { get; set; }
    public string Condition { get; set; }
    public string Make { get; set; }
    public string Model { get; set; }
    public int? Meters { get; set; }
    public string Rent { get; set; }
    public decimal? Bedrooms { get; set; }
    public decimal? Bathrooms { get; set; }
    public DateTime? Available { get; set; }
    public string AvailableString
    {
        get
        {
            if (Available.HasValue)
            {
                return Available.Value.ToString("MMM d");
            } else { return "Now"; }
        }
    }
    public bool Pets { get; set; }
    public bool Laundry { get; set; }
    public bool Furniture { get; set; }
    public string Link { get { return "https://www.kunminglive.com/classifieds/" + Category.ToString().ToLower() + "/" + PostID.ToString() + "/" + Title.RemoveSpecialCharacters().Replace(" ", "-"); } }
    public string EditLink { get { return "https://www.kunminglive.com/classifieds/" + Category.ToString().ToLower() + "/edit/" + PostID.ToString(); } }
    
    public string BoxClass
    {
        get
        {
            switch (Category)
            {
                case Categories.Employment:
                    return TodoItem.CssClasses.Box(TodoItem.TodoTypes.Event);
                case Categories.Marketplace:
                    return TodoItem.CssClasses.Box(TodoItem.TodoTypes.Activity);
                case Categories.Housing:
                    return TodoItem.CssClasses.Box(TodoItem.TodoTypes.Shopping);
                default:
                    return TodoItem.CssClasses.Box(TodoItem.TodoTypes.Services);
            }
        }
    }

    public string LabelClass
    {
        get
        {
            switch (Category)
            {
                case Categories.Employment:
                    return TodoItem.CssClasses.Label(TodoItem.TodoTypes.Event);
                case Categories.Marketplace:
                    return TodoItem.CssClasses.Label(TodoItem.TodoTypes.Activity);
                case Categories.Housing:
                    return TodoItem.CssClasses.Label(TodoItem.TodoTypes.Shopping);
                default:
                    return TodoItem.CssClasses.Label(TodoItem.TodoTypes.Services);
            }
        }
    }

    public ClassifiedImage[] Images { get; set; }

    public void Save()
    {
        
    }

    private ClassifiedImage[] GetImages(int postId)
    {
        string sql = "SELECT * FROM classified_post_images WHERE classified_post_id = " + postId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<ClassifiedImage> classifiedImages = new List<ClassifiedImage>();
        foreach (Result result in resultSet)
        {
            classifiedImages.Add(new ClassifiedImage(
                (int)result["classified_post_image_id"],
                (int)result["classified_post_id"],
                (string)result["image_path"],
                (int)result["sort_order"]
            ));
        }
        return classifiedImages.ToArray();
    }

    public static Classified[] GetClassifieds(string username)
    {
        return GetClassifieds(null, 0, null, username);
    }
    public static Classified[] GetClassifieds(int? viewId, Categories? category)
    {
        return GetClassifieds(category, 0, viewId);
    }
    public static Classified[] GetClassifieds(Categories? category, int count = 0, int? viewId = null, string username = null)
    {
        string sql = "SELECT ";
        if (count > 0)
        {
            sql += "TOP " + count + " ";
        }
        sql += "* FROM classified_posts WHERE ";
        if (username != null)
        {
            sql += "user_name = '" + username + "' ";
        }
        else
        {
            sql += "inactive = 0 AND expired = 0 ";
        }
        if (category.HasValue)
        {
            sql += "AND category = " + Convert.ToInt32(category).ToString() + " ";
        }
        string sortBy = null;
        if (viewId.HasValue)
        {
            sql += "OR classified_post_id = " + viewId.Value.ToString() + " ";
            sortBy = "CASE WHEN classified_post_id = " + viewId.Value.ToString() + " THEN '1' END DESC,";
        }

        sql += "ORDER BY " + sortBy + "time_created DESC";
        ResultSet resultSet = commons.ExecuteQuery(sql);

        List<Classified> classifieds = new List<Classified>();
        foreach(Result result in resultSet)
        {
            switch ((Categories)result["category"])
            {
                case Categories.Employment:
                    classifieds.Add(new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (EmploymentType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["compensation"] as string,
                        result["term"] as string,
                        result["internship"] != DBNull.Value,
                        result["telecommuting"] != DBNull.Value
                    ));
                    break;
                case Categories.Marketplace:
                    classifieds.Add(new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (MarketplaceType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["price"] as string,
                        result["condition"] as string,
                        result["make"] as string,
                        result["model"] as string
                    ));
                    break;
                case Categories.Housing:
                    classifieds.Add(new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (HousingType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["meters"] as int?,
                        result["rent"] as string,
                        result["bedrooms"] as decimal?,
                        result["bathrooms"] as decimal?,
                        result["available"] as DateTime?,
                        result["pets"] != DBNull.Value,
                        result["laundry"] != DBNull.Value,
                        result["furniture"] != DBNull.Value
                    ));
                    break;
            }
        }

        return classifieds.ToArray();
    }

    public static Classified GetClassified(int classifiedId)
    {
        string sql = "SELECT * FROM classified_posts WHERE classified_post_id = " + classifiedId;
        ResultSet resultSet = commons.ExecuteQuery(sql);
        if (resultSet.Length > 0)
        {
            Result result = resultSet[0];
            switch ((Categories)result["category"])
            {
                case Categories.Employment:
                    return new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (EmploymentType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["compensation"] as string,
                        result["term"] as string,
                        result["internship"] != DBNull.Value,
                        result["telecommuting"] != DBNull.Value
                    );
                case Categories.Marketplace:
                    return new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (MarketplaceType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["price"] as string,
                        result["condition"] as string,
                        result["make"] as string,
                        result["model"] as string
                    );
                case Categories.Housing:
                    return new Classified(
                        (int)result["classified_post_id"],
                        (string)result["user_name"],
                        (Categories)result["category"],
                        (HousingType)result["sub_category"],
                        (string)result["post_title"],
                        (string)result["post_description"],
                        (DateTime)result["time_created"],
                        Convert.ToBoolean(result["sponsored"]),
                        Convert.ToBoolean(result["inactive"]),
                        Convert.ToBoolean(result["expired"]),
                        (string)result["postal_code"],
                        result["meters"] as int?,
                        result["rent"] as string,
                        result["bedrooms"] as decimal?,
                        result["bathrooms"] as decimal?,
                        result["available"] as DateTime?,
                        result["pets"] != DBNull.Value,
                        result["laundry"] != DBNull.Value,
                        result["furniture"] != DBNull.Value
                    );
                default:
                    return null;
            }
        } else { return null; }
    }

    public static int? CreateClassified(Categories category, EmploymentType subCategory, string title, string details, string postalCode, bool sponsored, string compensation, string term, bool? internship, bool? telecommuting, string[] images, int? editClassifiedId = null)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        details = commons.CensorWords(details);
        string sql;
        ResultSet resultSet;
        if (editClassifiedId.HasValue)
        {
            sql = "UPDATE classified_post SET category=@category,sub_category=@sub_category,post_title=@post_title,post_description=@post_description,sponsored=@sponsored,expired=0,postal_code=@postal_code," +
                "compensation=@compensation,term=@term,internship=@internship,telcommuting=@telecommuting WHERE classified_post_id = " + editClassifiedId.Value;
        }
        else
        { 
            sql = "SELECT classified_post_id FROM classified_posts WHERE DATEADD(minute, -5, GETDATE()) < time_created AND user_name = '" + HttpContext.Current.User.Identity.Name + "'";
            resultSet = commons.ExecuteQuery(sql);
            if (resultSet.Length > 0) { return null; }

            sql = "INSERT INTO classified_posts (user_name,category,sub_category,post_title,post_description,time_created,sponsored,inactive,expired,postal_code,compensation,term,internship,telecommuting)" +
                " OUTPUT INSERTED.classified_post_id VALUES (@user_name,@category,@sub_category,@post_title,@post_description,@time_created,@sponsored,@inactive,@expired,@postal_code,@compensation,@term,@internship,@telecommuting)";
        }
        Dictionary<string, object> classifiedParams = new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@category", category },
            { "@sub_category", subCategory },
            { "@post_title", title },
            { "@post_description", details },
            { "@time_created", DateTime.Now },
            { "@sponsored", sponsored },
            { "@inactive", 0 },
            { "@expired", 0 },
            { "@postal_code", postalCode },
            { "@compensation", compensation },
            { "@term", term },
            { "@internship", internship },
            { "@telecommuting", telecommuting }
        };
        resultSet = commons.ExecuteQuery(sql, classifiedParams);
        int postId;

        if (editClassifiedId.HasValue)
        {
            postId = editClassifiedId.Value;
            sql = "DELETE FROM classified_post_images WHERE classified_post_id = " + editClassifiedId.Value;
            commons.ExecuteQuery(sql);
        }
        else
        {
            postId = (int)resultSet[0]["classified_post_id"];
        }
        
        for (int i = 0; i < images.Length; i++)
        {
            string savePath = commons.SaveBase64Image(images[i], "dist/img/classifieds");
            sql = "INSERT INTO classified_post_images (classified_post_id,image_path,sort_order) VALUES (@classified_post_id,@image_path,@sort_order)";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@classified_post_id", postId },
                { "@image_path", savePath },
                { "@sort_order", i }
            });
        }

        commons.CreateNotification("Classified Ad Posted", "Your classified ad is active and viewable by the public. Good Luck!", Notification.Types.Classified, "/classifieds.aspx?view=all&id=" + postId);
        commons.SendEmail(new User(HttpContext.Current.User.Identity.Name), "Kunming LIVE! Classified Ad", "Your classified ad is active and viewable by the public. It can be viewed here: <a href='https://kunminglive.com/classifieds.aspx?view=all&id=" + postId + "'>https://kunminglive.com/classifieds.aspx?view=all&id=" + postId + "</a><br/><br/>Good Luck!");
        commons.SendEmail(new User("Jancarius"), "KL! New Classified Ad", new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(classifiedParams));

        return postId;
    }

    public static int? CreateClassified(Categories category, MarketplaceType subCategory, string title, string details, string postalCode, bool sponsored, string price, string condition, string make, string model, string[] images, int? editClassifiedId = null)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        details = commons.CensorWords(details);
        string sql;
        ResultSet resultSet;
        if (editClassifiedId.HasValue)
        {
            sql = "UPDATE classified_post SET category=@category,sub_category=@sub_category,post_title=@post_title,post_description=@post_description,sponsored=@sponsored,expired=0,postal_code=@postal_code," +
                "price=@price,condition=@condition,make=@make,model=@model WHERE classified_post_id = " + editClassifiedId.Value;
        }
        else
        {
            sql = "SELECT classified_post_id FROM classified_posts WHERE DATEADD(minute, -5, GETDATE()) < time_created AND user_name = '" + HttpContext.Current.User.Identity.Name + "'";
            resultSet = commons.ExecuteQuery(sql);
            if (resultSet.Length > 0) { return null; }
        }

        sql = "INSERT INTO classified_posts (user_name,category,sub_category,post_title,post_description,time_created,sponsored,inactive,expired,postal_code,price,condition,make,model)" +
            " OUTPUT INSERTED.classified_post_id VALUES (@user_name,@category,@sub_category,@post_title,@post_description,@time_created,@sponsored,@inactive,@expired,@postal_code,@price,@condition,@make,@model)";
        resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@category", category },
            { "@sub_category", subCategory },
            { "@post_title", title },
            { "@post_description", details },
            { "@time_created", DateTime.Now },
            { "@sponsored", sponsored },
            { "@inactive", 0 },
            { "@expired", 0 },
            { "@postal_code", postalCode },
            { "@price", price },
            { "@condition", condition },
            { "@make", make },
            { "@model", model }
        });
        int postId;

        if (editClassifiedId.HasValue)
        {
            postId = editClassifiedId.Value;
            sql = "DELETE FROM classified_post_images WHERE classified_post_id = " + editClassifiedId.Value;
            commons.ExecuteQuery(sql);
        }
        else
        {
            postId = (int)resultSet[0]["classified_post_id"];
        }

        for (int i = 0; i < images.Length; i++)
        {
            string savePath = commons.SaveBase64Image(images[i], "dist/img/classifieds");
            sql = "INSERT INTO classified_post_images (classified_post_id,image_path,sort_order) VALUES (@classified_post_id,@image_path,@sort_order)";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@classified_post_id", postId },
                { "@image_path", savePath },
                { "@sort_order", i }
            });
        }

        return postId;
    }

    public static int? CreateClassified(Categories category, HousingType subCategory, string title, string details, string postalCode, bool sponsored, int? meters, string rent, decimal? bedrooms, decimal? bathrooms, DateTime? available, bool? pets, bool? laundry, bool? furniture, string[] images, int? editClassifiedId = null)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }

        title = commons.CensorWords(title);
        details = commons.CensorWords(details);

        string sql;
        ResultSet resultSet;
        if (editClassifiedId.HasValue)
        {
            sql = "UPDATE classified_post SET category=@category,sub_category=@sub_category,post_title=@post_title,post_description=@post_description,sponsored=@sponsored,expired=0,postal_code=@postal_code," +
                "meters=@meters,rent=@rent,bedrooms=@bedrooms,bathrooms=@bathrooms,available=@available,pets=@pets,laundry=@laundry,furniture=@furniture WHERE classified_post_id = " + editClassifiedId.Value;
        }
        else
        {
            sql = "SELECT classified_post_id FROM classified_posts WHERE DATEADD(minute, -5, GETDATE()) < time_created AND user_name = '" + HttpContext.Current.User.Identity.Name + "'";
            resultSet = commons.ExecuteQuery(sql);
            if (resultSet.Length > 0) { return null; }
        }
        
        sql = "INSERT INTO classified_posts (user_name,category,sub_category,post_title,post_description,time_created,sponsored,inactive,expired,postal_code,meters,rent,bedrooms,bathrooms,available,pets,laundry,furniture)" +
            " OUTPUT INSERTED.classified_post_id VALUES (@user_name,@category,@sub_category,@post_title,@post_description,@time_created,@sponsored,@inactive,@expired,@postal_code,@meters,@rent,@bedrooms,@bathrooms,@available,@pets,@laundry,@furniture)";
        resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@category", category },
            { "@sub_category", subCategory },
            { "@post_title", title },
            { "@post_description", details },
            { "@time_created", DateTime.Now },
            { "@sponsored", sponsored },
            { "@inactive", 0 },
            { "@expired", 0 },
            { "@postal_code", postalCode },
            { "@meters", meters },
            { "@rent", rent },
            { "@bedrooms", bedrooms },
            { "@bathrooms", bathrooms },
            { "@available", available },
            { "@pets", pets },
            { "@laundry", laundry },
            { "@furniture", furniture }
        });
        int postId;

        if (editClassifiedId.HasValue)
        {
            postId = editClassifiedId.Value;
            sql = "DELETE FROM classified_post_images WHERE classified_post_id = " + editClassifiedId.Value;
            commons.ExecuteQuery(sql);
        }
        else
        {
            postId = (int)resultSet[0]["classified_post_id"];
        }

        for (int i = 0; i < images.Length; i++)
        {
            string savePath = commons.SaveBase64Image(images[i], "dist/img/classifieds");
            sql = "INSERT INTO classified_post_images (classified_post_id,image_path,sort_order) VALUES (@classified_post_id,@image_path,@sort_order)";
            commons.ExecuteQuery(sql, new Dictionary<string, object>
            {
                { "@classified_post_id", postId },
                { "@image_path", savePath },
                { "@sort_order", i }
            });
        }

        return postId;
    }

    public static DateTime RenewClassified(int postId)
    {
        DateTime now = DateTime.Now.Date;
        string sql = "UPDATE classified_posts SET expired = 0,time_created = @time_created WHERE classified_post_id = " + postId;
        commons.ExecuteQuery(sql, now);
        return now;
    }

    public static void SuspendClassified(int postId, bool suspended)
    {
        string sql = "UPDATE classified_posts SET inactive = @inactive WHERE classified_post_id = " + postId;
        commons.ExecuteQuery(sql, suspended);
    }

    public static void DeleteClassified(int postId)
    {
        string sql = "DELETE FROM classified_post_images WHERE classified_post_id = @post_id;" +
                    "DELETE FROM classified_posts WHERE classified_post_id = @post_id;";
        commons.ExecuteQuery(sql, postId);
    }

    public enum Categories
    {
        Employment,
        Marketplace,
        Housing
    }

    public enum EmploymentType
    {
        Administrative,
        Engineering,
        Education,
        Government,
        Technology,
        Labor,
        Sales,
        Service,
        Other
    }

    public enum MarketplaceType
    {
        Appliances,
        Automotive,
        Clothing,
        Electronics,
        Furniture,
        Garden,
        General,
        Media,
        Music
    }

    public enum HousingType
    {
        Apartment,
        Bedroom,
        Business,
        House,
        Vacation
    }


    public class ClassifiedImage
    {
        public ClassifiedImage(int imageId, int classifiedId, string path, int sortOrder)
        {
            ImageID = imageId;
            ClassifiedID = classifiedId;
            Path = path;
            SortOrder = sortOrder;
        }

        public int ImageID { get; private set; }

        public int ClassifiedID { get; private set; }

        public string Path { get; private set; }

        public int SortOrder { get; private set; }
    }
}