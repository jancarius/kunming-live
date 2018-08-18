using System;
using System.Collections.Generic;
using System.Web;
using System.IO;

/// <summary>
/// Structure Class for Businesses
/// </summary>
public class Business
{
    public Business(int businessId, string username, BusinessTypes businessType, string mainImagePath, string description, MultiLingual name, MultiLingual address, MultiLingual city, MultiLingual province, MultiLingual country,
        string postalCode, string phoneNumber, string website, int cost, int value, int service, int atmosphere, string coordinates, TodoItem.TodoTypes todoType, bool approved, bool denied, bool inactive)
    {
        BusinessID = businessId;
        Creator = new User(username);
        Type = businessType;
        MainImagePath = mainImagePath;
        Description = description;
        Name = name;
        Address = address;
        City = city;
        Province = province;
        Country = country;
        PostalCode = postalCode;
        PhoneNumber = phoneNumber;
        Website = website;
        Cost = cost;
        Value = value;
        Service = service;
        Atmosphere = atmosphere;
        Coordinates = coordinates;
        TodoType = todoType;
        Approved = approved;
        Denied = denied;
        Inactive = inactive;

        List<BusinessTag> tags = new List<BusinessTag>();
        string sql = "SELECT * FROM business_tags WHERE business_id = " + BusinessID + " ORDER BY tag ASC";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            tags.Add(new BusinessTag((int)result["business_tag_id"], (int)result["business_id"], (string)result["tag"], this));
        }
        Tags = tags.ToArray();

        List<BusinessImage> images = new List<BusinessImage>();
        sql = "SELECT * FROM business_images WHERE business_id = " + BusinessID + " ORDER BY sort_order ASC";
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            images.Add(new BusinessImage((int)result["business_image_id"], (int)result["business_id"], (string)result["business_image_path"], (int)result["sort_order"]));
        }
        SubImages = images.ToArray();

        int reviewSum = 0;
        int reviewCount = 0;
        List<Review> reviews = new List<Review>();
        sql = "SELECT rating FROM reviews WHERE table_name = 'businesses' AND primary_identifier = " + BusinessID;
        resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            reviewCount++;
            reviewSum += (int)result["rating"];
        }
        if (reviewCount > 0)
        {
            double averageRating = reviewSum / reviewCount;
            StarRating = (int)Math.Ceiling(averageRating);
        }
        else
        {
            StarRating = 0;
        }
    }

    public User Creator { get; private set; }
    public int BusinessID { get; private set; }
    public BusinessTypes Type { get; set; }
    public string MainImagePath { get; private set; }
    public string Description { get; set; }
    public MultiLingual Name { get; set; }
    public MultiLingual Address { get; set; }
    public MultiLingual City { get; set; }
    public MultiLingual Province { get; set; }
    public MultiLingual Country { get; set; }
    public string PostalCode { get; set; }
    public string PhoneNumber { get; set; }
    public string Website { get; set; }
    public int Cost { get; set; }
    public int Value { get; set; }
    public int Service { get; set; }
    public int Atmosphere { get; set; }
    public int StarRating { get; private set; }
    public string Coordinates { get; set; }
    public BusinessTag[] Tags { get; private set; }
    public BusinessImage[] SubImages { get; private set; }
    public TodoItem.TodoTypes TodoType { get; private set; }
    public bool Approved { get; private set; }
    public bool Denied { get; private set; }
    public bool Inactive { get; private set; }
    public string Link { get { return "https://www.kunminglive.com/things-to-do/" + Type.ToString().ToLower() + "/" + BusinessID.ToString() + "/" + Name.English.RemoveSpecialCharacters().Replace(" ", "-"); } }
    public string EditLink { get { return "https://www.kunminglive.com/things-to-do/" + Type.ToString().ToLower() + "/edit/" + BusinessID.ToString(); } }

    public void SaveChanges()
    {

    }
    public static Business[] GetBusinesses(string username)
    {
        return GetBusinesses(BusinessTypes.All, false, 0, null, null, null, null, null, username);
    }
    public static Business[] GetBusinesses(BusinessTypes businessType, int? showBusinesses, string tag = null)
    {
        return GetBusinesses(businessType, true, 0, null, null, null, tag == null ? null : new string[] { tag }, showBusinesses);
    }
    public static Business[] GetBusinesses(BusinessTypes businessType, bool approved = true, int count = 0, string primarySort = null, string secondarySort = null, int? minimumRating = null, string[] tags = null, int? showBusinesses = null, string username = null)
    {
        if (count == 0) { count = 10; }
        string sql = "SELECT" + (count > 0 ? " TOP " + count : "") + " * FROM businesses WHERE (" + (approved ? "approved = 1 OR " : "") + "user_name = '" + (username == null ? HttpContext.Current.User.Identity.Name : username) + "' OR " + Convert.ToInt32(User.VerifyAdmin()).ToString() + " = 1) AND inactive = 0 AND ";
        if (username != null)
        {
            sql = sql.Replace("inactive = 0 AND ", "");
        }
        if (businessType != BusinessTypes.All)
        {
            sql += "business_type = " + (int)businessType + " AND ";
        }
        if (tags != null)
        {
            sql += "business_id IN (SELECT business_id FROM business_tags WHERE tag IN ('" + string.Join("','", tags) + "')) AND ";
        }
        if (minimumRating != null)
        {
            sql += "business_id IN (SELECT primary_identifier FROM reviews WHERE table_name = 'businesses' GROUP BY primary_identifier HAVING CEILING(AVG(rating)) > " + (minimumRating-1) + ") AND ";
        }
        if (primarySort != null)
        {
            switch(primarySort)
            {
                case "costUp":
                    primarySort = "cost ASC";
                    break;
                case "costDown":
                    primarySort = "cost DESC";
                    break;
                case "rating":
                    sql += "business_id IN (SELECT TOP " + count + " primary_identifier FROM reviews WHERE table_name = 'businesses' GROUP BY primary_identifier ORDER BY AVG(rating) DESC) AND ";
                    primarySort = null;
                    break;
                case "value":
                    primarySort = "value DESC";
                    break;
                case "service":
                    primarySort = "service DESC";
                    break;
                case "atmosphere":
                    primarySort = "atmosphere DESC";
                    break;
            }
        }
        if (secondarySort != null)
        {
            switch (secondarySort)
            {
                case "costUp":
                    secondarySort = "cost ASC";
                    break;
                case "costDown":
                    secondarySort = "cost DESC";
                    break;
                case "rating":
                    sql += "business_id IN (SELECT TOP " + count + " primary_identifier FROM reviews WHERE table_name = 'businesses' GROUP BY primary_identifier ORDER BY AVG(rating) DESC) AND ";
                    secondarySort = null;
                    break;
                case "value":
                    secondarySort = "value DESC";
                    break;
                case "service":
                    secondarySort = "service DESC";
                    break;
                case "atmosphere":
                    secondarySort = "atmosphere DESC";
                    break;
            }
        }
        if (sql.EndsWith("AND "))
        {
            sql = sql.Substring(0, sql.LastIndexOf("AND "));
        }
        else if (sql.EndsWith("WHERE "))
        {
            sql = sql.Substring(0, sql.LastIndexOf("WHERE "));
        }
        if (showBusinesses.HasValue)
        {
            sql += "OR business_id = " + showBusinesses.Value.ToString() + " ";
            if (string.IsNullOrEmpty(primarySort)) { primarySort = "business_id ASC"; }
            primarySort = "CASE WHEN business_id = " + showBusinesses.Value.ToString() + " THEN '1' END DESC," + primarySort;
        }
        if (primarySort != null || secondarySort != null)
        {
            sql += "ORDER BY " + (primarySort == null ? "" : primarySort + ",") + (secondarySort == null ? "" : secondarySort);
            sql = sql.TrimEnd(',');
        }
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<Business> businesses = new List<Business>();
        foreach (Result result in resultSet)
        {
            businesses.Add(new Business(
                (int)result["business_id"],
                (string)result["user_name"],
                (BusinessTypes)result["business_type"],
                (string)result["main_image_path"],
                (string)result["description"],
                new MultiLingual((string)result["name_english"], (string)result["name_chinese"]),
                new MultiLingual((string)result["address_english"], (string)result["address_chinese"]),
                new MultiLingual((string)result["city_english"], (string)result["city_chinese"]),
                new MultiLingual((string)result["province_english"], (string)result["province_chinese"]),
                new MultiLingual((string)result["country_english"], (string)result["country_chinese"]),
                (string)result["postal_code"],
                result["phone_number"] as string,
                result["website"] as string,
                (int)result["cost"],
                (int)result["value"],
                (int)result["service"],
                (int)result["atmosphere"],
                (string)result["coordinates"],
                (TodoItem.TodoTypes)result["todo_type"],
                Convert.ToBoolean(result["approved"]),
                Convert.ToBoolean(result["denied"]),
                Convert.ToBoolean(result["inactive"])
            ));
        }
        return businesses.ToArray();
    }

    public static string GetBusinessTags(BusinessTypes type)
    {
        string html = "";
        string sql = "SELECT DISTINCT business_tags.tag FROM business_tags ";
        if (type != BusinessTypes.All)
        {
            sql += "JOIN businesses ON business_tags.business_id = businesses.business_id WHERE businesses.business_type = " + Convert.ToInt32(type).ToString() + " ";
        }
        sql += (type != BusinessTypes.All ? "AND" : "WHERE" ) + " business_tags.business_id IN (SELECT business_id FROM businesses WHERE approved = 1 OR user_name = '" + HttpContext.Current.User.Identity.Name + "')";
        ResultSet resultSet = commons.ExecuteQuery(sql);
        foreach (Result result in resultSet)
        {
            string tag = (string)result["tag"];
            ResultSet tagsResultSet = commons.ExecuteQuery("SELECT COUNT(tag) FROM business_tags WHERE tag = @tag", new Dictionary<string, object> { { "@tag", tag } });
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

    public static string[] GetBusinessTagsArray()
    {
        List<string> tags = new List<string>();
        ResultSet resultSet = commons.ExecuteQuery("SELECT DISTINCT tag FROM business_tags WHERE business_id IN (SELECT business_id FROM businesses WHERE approved = 0 OR user_name = '" + HttpContext.Current.User.Identity.Name + "')");
        foreach (Result result in resultSet)
        {
            tags.Add((string)result["tag"]);
        }
        return tags.ToArray();
    }

    public static int? CreateBusiness(string mainImage, BusinessTypes type, string description, MultiLingual name, MultiLingual address, MultiLingual city, MultiLingual province, MultiLingual country,
        string postalCode, string phoneNumber, string website, int cost, int value, int service, int atmosphere, string coordinates, TodoItem.TodoTypes todoType, string[] tags, string[] subImages, int? editBusinessId = null)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }

        description = commons.CensorWords(description);
        
        string mainImagePath = commons.SaveBase64Image(mainImage, "/dist/img/business_images");

        string sql;

        if (editBusinessId.HasValue)
        {
            sql = "UPDATE businesses SET user_name=@user_name,business_type=@business_type,main_image_path=@main_image_path,description=@description,name_english=@name_english,name_chinese=@name_chinese," +
                "address_english=@address_english,address_chinese=@address_chinese,city_english=@city_english,city_chinese=@city_chinese,province_english=@province_english,province_chinese=@province_chinese," +
                "country_english=@country_english,country_chinese=@country_chinese,postal_code=@postal_code,phone_number=@phone_number,website=@website,cost=@cost,value=@value,service=@service,atmosphere=@atmosphere," +
                "coordinates=@coordinates,todo_type=@todo_type,approved=@approved,denied=0 WHERE business_id = " + editBusinessId.Value;
        }
        else
        {
            sql = "INSERT INTO businesses (user_name,business_type,main_image_path,description,name_english,name_chinese,address_english,address_chinese,city_english,city_chinese," +
                "province_english,province_chinese,country_english,country_chinese,postal_code,phone_number,website,cost,value,service,atmosphere,coordinates,todo_type,approved,denied,inactive) " +
                "OUTPUT INSERTED.business_id VALUES (@user_name,@business_type,@main_image_path,@description,@name_english,@name_chinese,@address_english,@address_chinese,@city_english,@city_chinese," +
                "@province_english,@province_chinese,@country_english,@country_chinese,@postal_code,@phone_number,@website,@cost,@value,@service,@atmosphere,@coordinates,@todo_type,@approved,0,0)";
        }
        Dictionary<string, object> businessParams = new Dictionary<string, object>
        {
            { "@user_name", HttpContext.Current.User.Identity.Name },
            { "@business_type", type },
            { "@main_image_path", mainImagePath },
            { "@description", description },
            { "@name_english", name.English },
            { "@name_chinese", name.Chinese },
            { "@address_english", address.English },
            { "@address_chinese", address.Chinese },
            { "@city_english", city.English },
            { "@city_chinese", city.Chinese },
            { "@province_english", province.English },
            { "@province_chinese", province.Chinese },
            { "@country_english", country.English },
            { "@country_chinese", country.Chinese },
            { "@postal_code", postalCode },
            { "@phone_number", phoneNumber },
            { "@website", website },
            { "@cost", cost },
            { "@value", value },
            { "@service", service },
            { "@atmosphere", atmosphere },
            { "@coordinates", coordinates },
            { "@todo_type", todoType },
            { "@approved", User.VerifyAdmin() }
        };
        ResultSet businessResultSet = commons.ExecuteQuery(sql, businessParams);

        int businessId;

        if (editBusinessId.HasValue)
        {
            businessId = editBusinessId.Value;
            sql = "DELETE FROM business_tags WHERE business_id = " + businessId + ";" +
                "DELETE FROM business_images WHERE business_id = " + businessId + ";";
            commons.ExecuteQuery(sql);
        } else
        {
            businessId = (int)businessResultSet[0]["business_id"];
        }
        sql = "INSERT INTO business_tags (business_id,tag) VALUES (@business_id,@tag)";
        foreach (string tag in tags)
        {
            commons.ExecuteQuery(sql, new Dictionary<string, object>
                    {
                        { "@business_id", businessId },
                        { "@tag", tag }
                    });
        }

        sql = "INSERT INTO business_images (business_id,business_image_path,sort_order) VALUES (@business_id,@business_image_path,@sort_order)";
        for (int i = 0; i < subImages.Length; i++)
        {
            string subImagePath = commons.SaveBase64Image(subImages[i], "/dist/img/business_images");
            commons.ExecuteQuery(sql, new Dictionary<string, object> {
                        { "@business_id", businessId },
                        { "@business_image_path", subImagePath },
                        { "@sort_order", i }
                    });
        }

        if (!User.VerifyAdmin())
        {
            string approvalBody = name.English + "<br/><br/>" + description;
            string approvalSubj = "KL! New Business Approval";
            commons.CreateNotification("Business Pending Approval", "Your Business has been submitted for approval. You will be notified of approval or denial.", Notification.Types.Business, HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/businesses.aspx?&id=" + businessId);
            commons.SendEmail(new User(HttpContext.Current.User.Identity.Name), approvalSubj, approvalBody);
            commons.SendEmail(new User("Jancarius"), approvalSubj, new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(businessParams));
        }

        return businessId;
    }

    public static bool? ApproveBusiness(int businessId, bool approved, string deniedReason = "")
    {
        if (HttpContext.Current.Request.IsAuthenticated)
        {
            if (!User.VerifyAdmin()) { return null; }
        }
        else { return null; }

        string sql = "SELECT user_name FROM businesses WHERE business_id = " + businessId;
        string username = (string)commons.ExecuteQuery(sql)[0]["user_name"];

        string uriLeftPart = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority);
        if (approved)
        {
            sql = "UPDATE businesses SET approved = 1 WHERE business_id = " + businessId;
            string body = "Thank you for submitting a Business. It has been approved and can now be viewed by the public at <a href='https://kunminglive.com/businesses.aspx?view=all&id=" + businessId + "'>Kunming LIVE!</a>.";
            commons.SendEmail(new User(username), "Kunming LIVE! Business Approved", body);
            commons.CreateNotification("Business Approved", "Your Business has been approved and is now available to the public. Thank you for sharing!", Notification.Types.Business, "/businesses.aspx?view=all&id=" + businessId, false, username);
        }
        else
        {
            sql = "UPDATE businesses SET denied = 1 WHERE business_id = " + businessId;
            string body = "Thank you for submitting a Business. Unfortunately your business has been denied for the following reason(s). Please correct the issue and resubmit the business.<br/><br/>" + deniedReason;
            commons.SendEmail(new User(username), "Kunming LIVE! Business Denied", body);
            commons.CreateNotification("Business Denied", "Unfortunately your business has been denied for: " + deniedReason + ". Please edit your business to correct the reason for denial. Click \"Eye\" Icon.", Notification.Types.Business, "/businesses.aspx?view=all&edit=" + businessId, true, username);
        }

        commons.ExecuteQuery(sql);
        return true;
    }

    public static void SuspendBusiness(int businessId, bool suspended)
    {
        string sql = "UPDATE businesses SET inactive = @inactive WHERE business_id = " + businessId;
        commons.ExecuteQuery(sql, suspended);
    }

    public static void DeleteBusiness(int businessId)
    {
        string sql = "DELETE FROM review_images WHERE review_id IN (SELECT review_id FROM reviews WHERE table_name = 'businesses' AND primary_identifier = @business_id);" +
                    "DELETE FROM review_votes WHERE review_id IN (SELECT review_id FROM reviews WHERE table_name = 'businesses' AND primary_identifier = @business_id);" +
                    "DELETE FROM reviews WHERE table_name = 'businesses' AND primary_identifier = @business_id;" +
                    "DELETE FROM business_tags WHERE business_id = @business_id;" +
                    "DELETE FROM business_images WHERE business_id = @business_id;" +
                    "DELETE FROM businesses WHERE business_id = @business_id;";
        commons.ExecuteQuery(sql, businessId);
    }

    public enum BusinessTypes
    {
        Restaurants,
        Shopping,
        Services,
        Entertainment,
        All
    }

    public class BusinessImage
    {
        public BusinessImage(int imageId, int businessId, string imagePath, int sortOrder)
        {
            ImageID = imageId;
            BusinessID = businessId;
            ImagePath = imagePath;
            SortOrder = sortOrder;
        }

        public int ImageID { get; private set; }

        public int BusinessID { get; private set; }

        public string ImagePath { get; private set; }

        public int SortOrder { get; private set; }
    }

    public class BusinessTag
    {
        public BusinessTag(int tagId, int businessId, string tag, Business business)
        {
            Business = business;
            TagID = tagId;
            BusinessID = businessId;
            Tag = tag;
        }

        public Business Business { get; private set; }
        public int TagID { get; private set; }
        public int BusinessID { get; private set; }
        public string Tag { get; private set; }
        public string Link
        {
            get
            {
                return "https://www.kunminglive.com/things-to-do/" + Business.Type.ToString().ToLower() + "/tag/" + Tag.Replace(" ", "+");
            }
        }
    }

    public class MultiLingual
    {
        public MultiLingual() { }

        public MultiLingual(string english, string chinese)
        {
            English = english;
            Chinese = chinese;
        }

        public string English { get; set; }

        public string Chinese { get; set; }
    }
}