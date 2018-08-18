using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class businesses : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        foreach (Business.BusinessTypes type in Enum.GetValues(typeof(Business.BusinessTypes)))
        {
            ddlBusinessType.Items.Add(new System.Web.UI.WebControls.ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }
        foreach (TodoItem.TodoTypes type in Enum.GetValues(typeof(TodoItem.TodoTypes)))
        {
            ddlBusinessTodoType.Items.Add(new System.Web.UI.WebControls.ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }

        Dictionary<string, string> businessData;
        string pageTitle;
        string breadcrumbTitle;
        int? viewId = null;
        if (Request.QueryString["id"] != null)
        {
            int viewIdParse;
            if (int.TryParse(Request.QueryString["id"], out viewIdParse))
            {
                viewId = viewIdParse;
            }
        }

        hiddenViewParam.Value = Request.QueryString["view"];
        hiddenIDParam.Value = Request.QueryString["id"];
        hiddenEditParam.Value = Request.QueryString["edit"];
        hiddenActionParam.Value = Request.QueryString["action"];

        string value = null;
        if (Request.QueryString["action"] == "tag")
        {
            value = Request.QueryString["value"];
        }

        switch (Request.QueryString["view"])
        {
            case "restaurants":
                businessData = CreateBusinesses(Business.GetBusinesses(Business.BusinessTypes.Restaurants, viewId, value));
                phTags.Controls.Add(new LiteralControl(Business.GetBusinessTags(Business.BusinessTypes.Restaurants)));
                hiddenBusinessType.Value = Convert.ToInt32(Business.BusinessTypes.Restaurants).ToString();
                pageTitle = "Things to Do <small>Restaurants</small>";
                breadcrumbTitle = "Restaurants";
                break;
            case "shopping":
                businessData = CreateBusinesses(Business.GetBusinesses(Business.BusinessTypes.Shopping, viewId, value));
                phTags.Controls.Add(new LiteralControl(Business.GetBusinessTags(Business.BusinessTypes.Shopping)));
                hiddenBusinessType.Value = Convert.ToInt32(Business.BusinessTypes.Shopping).ToString();
                pageTitle = "Things to Do <small>Shopping</small>";
                breadcrumbTitle = "Shopping";
                break;
            case "services":
                businessData = CreateBusinesses(Business.GetBusinesses(Business.BusinessTypes.Services, viewId, value));
                phTags.Controls.Add(new LiteralControl(Business.GetBusinessTags(Business.BusinessTypes.Services)));
                hiddenBusinessType.Value = Convert.ToInt32(Business.BusinessTypes.Services).ToString();
                pageTitle = "Things to Do <small>Services</small>";
                breadcrumbTitle = "Services";
                break;
            case "entertainment":
                businessData = CreateBusinesses(Business.GetBusinesses(Business.BusinessTypes.Entertainment, viewId, value));
                phTags.Controls.Add(new LiteralControl(Business.GetBusinessTags(Business.BusinessTypes.Entertainment)));
                hiddenBusinessType.Value = Convert.ToInt32(Business.BusinessTypes.Entertainment).ToString();
                pageTitle = "Things to Do <small>Entertainment</small>";
                breadcrumbTitle = "Entertainment";
                break;
            default:
                businessData = CreateBusinesses(Business.GetBusinesses(Business.BusinessTypes.All, viewId, value));
                phTags.Controls.Add(new LiteralControl(Business.GetBusinessTags(Business.BusinessTypes.All)));
                hiddenBusinessType.Value = Convert.ToInt32(Business.BusinessTypes.All).ToString();
                pageTitle = "Things to Do <small>View All</small>";
                breadcrumbTitle = "";
                pnlPageBreadcrumb.Visible = false;
                pnlPageBreadcrumbSource.Attributes.Add("class", "active");
                break;
        }

        pnlPageTitle.Controls.Add(new LiteralControl(pageTitle));
        pnlPageBreadcrumb.Controls.Add(new LiteralControl(breadcrumbTitle));
        pnlBusinesses.Controls.Add(new LiteralControl(businessData["content"]));
        hiddenBusinessCoordinates.Value = businessData["coordinates"];
    }

    [WebMethod]
    public static int? SaveBusiness(string mainImage, Business.BusinessTypes type, string description, Business.MultiLingual name, Business.MultiLingual address, Business.MultiLingual city, Business.MultiLingual province, Business.MultiLingual country,
        string postalCode, string phoneNumber, string website, int cost, int value, int service, int atmosphere, string coordinates, TodoItem.TodoTypes todoType, string[] tags, string[] subImages, int? editBusinessId = null)
    {
        return Business.CreateBusiness(mainImage, type, description, name, address, city, province, country, postalCode, phoneNumber, website, cost, value, service, atmosphere, coordinates, todoType, tags, subImages, editBusinessId);
    }

    [WebMethod]
    public static Dictionary<string, string> FilterBusinesses(int count, string primarySort, string secondarySort, int? minimumRating, string[] tags, Business.BusinessTypes type)
    {
        return CreateBusinesses(Business.GetBusinesses(type, true, count, primarySort, secondarySort, minimumRating, tags));
    }

    [WebMethod]
    public static Dictionary<string, string> FilterByTag(string tag, Business.BusinessTypes type, int count, string primarySort, string secondarySort, int? minimumRating)
    {
        return CreateBusinesses(Business.GetBusinesses(type, true, count, primarySort, secondarySort, minimumRating, new string[] { tag }));
    }

    [WebMethod]
    public static Business GetBusiness(int businessId)
    {
        if (!HttpContext.Current.Request.IsAuthenticated) { return null; }
        Business[] business = Business.GetBusinesses(Business.BusinessTypes.All, true, 1, null, null, null, null, businessId);
        return business.Length == 1 ? business[0] : null;
    }

    [WebMethod]
    public static void SuspendBusiness(int postId, bool suspended)
    {
        Business.SuspendBusiness(postId, suspended);
    }

    [WebMethod]
    public static void DeleteBusiness(int postId)
    {
        Business.DeleteBusiness(postId);
    }

    private static Dictionary<string, string> CreateBusinesses(Business[] businesses)
    {
        string businessContents = "";
        string[] allBusinessCoords = new string[businesses.Length];
        for (int i = 0; i < businesses.Length; i++)
        {
            string businessName = businesses[i].Name.English + " " + businesses[i].Name.Chinese;
            string businessMainPic = businesses[i].MainImagePath;
            string businessAddressEnglish =
                "<li>" + businesses[i].Address.English + "</li>" +
                "<li>" + businesses[i].City.English + "</li>" +
                "<li>" + businesses[i].Province.English + ", " + businesses[i].Country.English + " " + businesses[i].PostalCode + "</li>";
            if (!string.IsNullOrEmpty(businesses[i].PhoneNumber))
            {
                businessAddressEnglish += "<li><i class='fa fa-phone'></i> " + businesses[i].PhoneNumber + "</li>";
            }
            string businessAddressChinese =
                "<li>" + businesses[i].Address.Chinese + "</li>" +
                "<li>" + businesses[i].City.Chinese + "</li>" +
                "<li>" + businesses[i].Province.Chinese + businesses[i].Country.Chinese + businesses[i].PostalCode + "</li>";
            if (!string.IsNullOrEmpty(businesses[i].Website))
            {
                string websiteUrl = new UriBuilder(businesses[i].Website).ToString();
                businessAddressChinese += "<li class='ellipsis' style='max-width:initial;'><i class='fa fa-globe'></i> <a href='" + websiteUrl + "' target='_blank'>" + businesses[i].Website + "</a></li>";
            }
            string businessCostWidth = "width: " + (businesses[i].Cost * 20) + "%;";
            string businessValueWidth = "width: " + (businesses[i].Value * 20) + "%;";
            string businessServiceWidth = "width: " + (businesses[i].Service * 20) + "%;";
            string businessAtmosphereWidth = "width: " + (businesses[i].Atmosphere * 20) + "%;";
            string businessDescription = "<strong>" + businesses[i].Name.English + " " + businesses[i].Name.Chinese + ": </strong>" + businesses[i].Description;
            string tags = "";
            foreach (Business.BusinessTag tag in businesses[i].Tags)
            {
                tags += "<span class='btn btn-xs btn-flat btn-primary'>" + tag.Tag + "</span> ";
            }
            string businessRating =
                "<div id='lblBusinessReviews' class='rating' data-original_rating='" + businesses[i].StarRating + "' style='margin-top:10px;'>" +
                    "<input type='radio' class='rating-input' value='5' id='rating-input-2-5_" + i + "' name='rating-input-2-" + i + "' " + (businesses[i].StarRating == 5 ? "checked" : "") + ">" +
                    "<label for='rating-input-2-5_" + i + "' class='rating-star rating-input-main'></label>" +
                    "<input type='radio' class='rating-input' value='4' id='rating-input-2-4_" + i + "' name='rating-input-2-" + i + "' " + (businesses[i].StarRating == 4 ? "checked" : "") + ">" +
                    "<label for='rating-input-2-4_" + i + "' class='rating-star rating-input-main'></label>" +
                    "<input type='radio' class='rating-input' value='3' id='rating-input-2-3_" + i + "' name='rating-input-2-" + i + "' " + (businesses[i].StarRating == 3 ? "checked" : "") + ">" +
                    "<label for='rating-input-2-3_" + i + "' class='rating-star rating-input-main'></label>" +
                    "<input type='radio' class='rating-input' value='2' id='rating-input-2-2_" + i + "' name='rating-input-2-" + i + "' " + (businesses[i].StarRating == 2 ? "checked" : "") + ">" +
                    "<label for='rating-input-2-2_" + i + "' class='rating-star rating-input-main'></label>" +
                    "<input type='radio' class='rating-input' value='1' id='rating-input-2-1_" + i + "' name='rating-input-2-" + i + "' " + (businesses[i].StarRating == 1 ? "checked" : "") + ">" +
                    "<label for='rating-input-2-1_" + i + "' class='rating-star rating-input-main'></label>" +
                "</div><br />" +
                "<button type='button' class='btn btn-sm btn-primary show-business-review' data-business-id='" + businesses[i].BusinessID + "' onclick='loadReviews(this)'><i class='fa fa-users'></i> View User Reviews</button>";
            string subImages = "";
            foreach (Business.BusinessImage subImage in businesses[i].SubImages)
            {
                subImages +=
                    "<div class='col-md-3 col-sm-4 col-xs-6 business-sub-image' style='padding-bottom:15px;padding-right:0;'>" +
                        "<img alt='" + subImage.SortOrder + "' class='img-responsive clickable lazy-load' data-src='" + subImage.ImagePath + "' onclick='showImageSlideshow(this)' />" +
                    "</div>";
            }
            string businessCoords = businesses[i].Coordinates;
            allBusinessCoords[i] = businessCoords;

            string thisBusiness = "<div id='business" + i + "'>" +
                        "<div class='nav-tabs-custom' data-business_id='" + businesses[i].BusinessID + "'>" +
                            "<ul class='nav nav-tabs'>" +
                                "<li class='active'>" +
                                    "<a href='#tab1-" + i + "' data-toggle='tab'>Main</a>" +
                                "</li>" +
                                "<li>" +
                                    "<a href='#tab2-" + i + "' data-toggle='tab'>Details</a>" +
                                "</li>" +
                                "<li>" +
                                    "<a href='#tab3-" + i + "' data-toggle='tab'>Pics</a>" +
                                "</li>" +
                                "<li>" +
                                    "<a href='#tab4-" + i + "' data-toggle='tab'>Map</a>" +
                                "</li>" +
                                "<li class='header pull-right' style='margin:7px 0 0 0;' data-table_name='businesses' data-primary_identifier='" + businesses[i].BusinessID + "'>" +
                                    "<button id='businesses-" + businesses[i].BusinessID + "' data-todo-title=\"" + businessName + "\" data-todo-type=\"" + businesses[i].TodoType + "\" data-link_back=\"" + businesses[i].Link + "\" type='button' class='btn btn-default btn-sm save-todo' data-toggle='tooltip' title='Save&nbsp;to&nbsp;Bucket&nbsp;List'>" +
                                        "<i class='fa fa-star clickable'></i>" +
                                    "</button>" +
                                "</li>" +
                            "</ul>" +
                            "<div class='tab-content'>" +
                                "<div id='tab1-" + i + "' class='tab-pane active'>" +
                                    "<div class='col-lg-9 col-md-12 pull-right text-center'>" +
                                        (businesses[i].Approved ? "" : "<h3 class='no-margin text-danger'>Pending Approval</h3>") +
                                        "<h3 class='lblBusinessName' style='margin-top:0;'>" + businessName + "</h3>" +
                                    "</div>" +
                                    "<div class='col-lg-3 col-sm-4 col-xs-3 col-xxs-12 no-padding valign' style='height:120px;'>" +
                                        "<img class='imgBusinessPic img-circle img-responsive' src='" + businessMainPic + "' style='margin:0 auto 5px auto;' />" +
                                    "</div>" +
                                    "<div class='col-lg-3 col-sm-4 col-xs-3 col-xxs-6' style='padding-right:0;'>" +
                                        "<i class='fa fa-map-marker pull-left'></i>" +
                                        "<ul class='pnlAddressEnglish list-unstyled'>" +
                                            businessAddressEnglish +
                                        "</ul>" +
                                    "</div>" +
                                    "<div class='col-lg-3 col-sm-4 col-xs-3 col-xxs-6' style='padding:0 0 0 5px;'>" +
                                        "<i class='fa fa-map-marker pull-left'></i>" +
                                        "<ul class='pnlAddressChinese list-unstyled'>" +
                                            businessAddressChinese +
                                        "</ul>" +
                                    "</div>" +
                                    "<div class='col-lg-3 col-sm-8 col-xs-3 col-xxs-12 pull-right'>" +
                                        "<strong>Cost</strong>" +
                                        "<div class='progress xs no-margin'>" +
                                            "<div class='bar-cost progress-bar progress-bar-danger' role='progressbar' aria-valuenow='20' aria-valuemin='0' aria-valuemax='100' style='" + businessCostWidth + "'></div>" +
                                        "</div>" +
                                        "<strong>Value</strong>" +
                                        "<div class='progress xs no-margin'>" +
                                            "<div class='bar-value progress-bar progress-bar-warning' role='progressbar' aria-valuenow='40' aria-valuemin='0' aria-valuemax='100' style='" + businessValueWidth + "'></div>" +
                                        "</div>" +
                                        "<strong>Service</strong>" +
                                        "<div class='progress xs no-margin'>" +
                                            "<div class='bar-service progress-bar progress-bar-aqua' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='" + businessServiceWidth + "'></div>" +
                                        "</div>" +
                                        "<strong>Atmosphere</strong>" +
                                        "<div class='progress xs no-margin'>" +
                                            "<div class='bar-atmosphere progress-bar progress-bar-green' role='progressbar' aria-valuenow='80' aria-valuemin='0' aria-valuemax='100' style='" + businessAtmosphereWidth + "'></div>" +
                                        "</div>" +
                                    "</div>" +
                                    "<div class='col-xxl-8 col-lg-12 col-sm-4 col-xs-12 no-padding'>" +
                                        "<div class='col-lg-3 col-sm-12 col-xs-6 col-xxs-12 text-center'>" +
                                            "<span class='lblBusinessDistance' data-business-coords='" + businessCoords + "'></span>" +
                                        "</div>" +
                                        "<div class='col-lg-6 col-sm-12 col-xs-6 col-xxs-12'>" +
                                            "<span class='lblBusinessTags'><i class='fa fa-tags'></i> " + tags + "</span>" +
                                        "</div>" +
                                        "<div class='col-lg-3 col-sm-12 col-xs-6 col-xxs-12 text-center'>" +
                                            businessRating +
                                        "</div>" +
                                    "</div>" +
                                    "<div class='clearfix'></div>" +
                                "</div>" +
                                "<div id='tab2-" + i + "' class='tab-pane'>" +
                                    "<div class='pnlBusinessDescription'>" +
                                        businessDescription +
                                    "</div>" +
                                    "<div class='clearfix'></div>" +
                                "</div>" +
                                "<div id='tab3-" + i + "' class='tab-pane' style='height:250px;overflow:auto;'>" +
                                    "<div class='pnlBusinessSubImages carousel-images-panel'>" +
                                        subImages +
                                    "</div>" +
                                    "<div class='clearfix'></div>" +
                                "</div>" +
                                "<div id='tab4-" + i + "' class='tab-pane' style='height:250px;'>" +
                                    "<div id='mapBusiness" + i + "' class='pnlBusinessMap' data-business-coords='" + businessCoords + "' data-business_name=\"" + businessName + "\"></div>" +
                                    "<div class='clearfix'></div>" +
                                "</div>" +
                            "</div>" +
                        "</div>" +
                    "</div>";
            businessContents += thisBusiness;
        }

        Dictionary<string, string> businessData = new Dictionary<string, string>
        {
            { "content", businessContents },
            { "coordinates", string.Join(";", allBusinessCoords) }
        };

        return businessData;
    }
}