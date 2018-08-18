using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;

public partial class classifieds : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        foreach (Classified.Categories type in Enum.GetValues(typeof(Classified.Categories)))
        {
            ddlClassifiedType.Items.Add(new ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }
        foreach (Classified.EmploymentType type in Enum.GetValues(typeof(Classified.EmploymentType)))
        {
            ddlClassifiedEmployment.Items.Add(new ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }
        foreach (Classified.MarketplaceType type in Enum.GetValues(typeof(Classified.MarketplaceType)))
        {
            ddlClassifiedMarketplace.Items.Add(new ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }
        foreach (Classified.HousingType type in Enum.GetValues(typeof(Classified.HousingType)))
        {
            ddlClassifiedHousing.Items.Add(new ListItem(type.ToString(), Convert.ToInt32(type).ToString()));
        }

        int? viewId = null;
        int viewIdParse;
        if (int.TryParse(Request.QueryString["id"], out viewIdParse))
        {
            viewId = viewIdParse;
        }
        switch (Request.QueryString["view"])
        {
            case "marketplace":
                pnlPageTitle.Controls.Add(new LiteralControl("Classifieds <small>Marketplace</small>"));
                pnlPageBreadcrumb.Controls.Add(new LiteralControl("Marketplace"));
                pnlClassifieds.Controls.Add(new LiteralControl(GetClassifieds(viewId, Classified.Categories.Marketplace)));
                break;
            case "employment":
                pnlPageTitle.Controls.Add(new LiteralControl("Classifieds <small>Employment</small>"));
                pnlPageBreadcrumb.Controls.Add(new LiteralControl("Employment"));
                pnlClassifieds.Controls.Add(new LiteralControl(GetClassifieds(viewId, Classified.Categories.Employment)));
                break;
            case "housing":
                pnlPageTitle.Controls.Add(new LiteralControl("Classifieds <small>Housing</small>"));
                pnlPageBreadcrumb.Controls.Add(new LiteralControl("Housing"));
                pnlClassifieds.Controls.Add(new LiteralControl(GetClassifieds(viewId, Classified.Categories.Housing)));
                break;
            default:
                pnlPageTitle.Controls.Add(new LiteralControl("Classifieds <small>View All</small>"));
                pnlPageBreadcrumb.Visible = false;
                pnlPageBreadcrumbSource.Attributes.Add("class", "active");
                pnlClassifieds.Controls.Add(new LiteralControl(GetClassifieds(viewId)));
                break;
        }
        hiddenViewParam.Value = Request.QueryString["view"];
        hiddenIDParam.Value = Request.QueryString["id"];
        hiddenEditParam.Value = Request.QueryString["edit"];
        hiddenActionParam.Value = Request.QueryString["action"];
    }

    private string GetClassifieds(int? viewId, Classified.Categories? category = null)
    {
        Classified[] classifieds = Classified.GetClassifieds(viewId, category);
        Dictionary<string, Classified> allClassifieds = new Dictionary<string, Classified>();
        string output = "";
        foreach (Classified classified in classifieds)
        {
            if (Master.dynamicStates.Keys.Contains("classified-" + classified.PostID))
            {
                if (Master.dynamicStates["classified-" + classified.PostID] == 1) { continue; }
            }
            output +=
                "<div class='col-xl-3 col-lg-4 col-sm-6 col-xs-12' style='min-height:0;'>" +
                    "<div id='classified-" + classified.PostID + "' class='box " + classified.BoxClass + "' data-dynamic='true'>" +
                        "<div class='classified-image-background'" + (classified.Images.Length > 0 ? " style=\"background:url('" + classified.Images[0].Path + "') no-repeat center center fixed;\"" : "") + "></div>" +
                        "<div class='box-header with-border' style='background-color:#fff;'>" +
                            "<div class='pull-right' style='margin:-3px'>" +
                                "<button type='button' class='btn btn-default btn-sm' data-widget='remove' data-toggle='tooltip' title='Remove' data-original-title='Remove'>" +
                                    "<i class='fa fa-times'></i>" +
                                "</button>" +
                            "</div>" +
                            "<h3 class='box-title' style='display:initial;'>" + (classified.Title.Length > 50 ? classified.Title.Substring(0, 50) + "..." : classified.Title) + "</h3>" +
                        "</div>" +
                        "<div class='box-body no-padding clickable classified-post-preview' style='position:relative;'>" +
                            (classified.Images.Length > 0 ? "<img src='" + classified.Images[0].Path + "' class='img-responsive' alt='Classified Image' style='max-height:200px;margin:0 auto;' />" : "") +
                            "<span class='classified-type'>" +
                                "<span class='" + classified.LabelClass + "'>" + classified.Category.ToString() + "</span>&nbsp;" +
                                "<i class='fa fa-angle-right'></i>&nbsp;" + classified.SubCategory.ToString() +
                            "</span>" +
                            "<span class='classified-time'>" +
                                "<i class='fa fa-clock-o'></i>&nbsp;" + classified.TimeSince +
                            "</span>" +
                            "<span class='classified-postal-code'>" +
                                "<i class='fa fa-globe'></i>&nbsp;" + classified.PostalCode +
                            "</span>" +
                            "<input type='hidden' value='" + (new JavaScriptSerializer().Serialize(classified)) + "' />" +
                        "</div>" +
                    "</div>" +
                "</div>";
        }
        return output;
    }

    [WebMethod]
    public static int? CreateClassifiedEmployment(Classified.Categories category, Classified.EmploymentType subCategory, string title, string details, string postalCode, bool sponsored, string compensation, string term, bool? internship, bool? telecommuting, string[] images)
    {
        return Classified.CreateClassified(category, subCategory, title, details, postalCode, sponsored, compensation, term, internship, telecommuting, images);
    }

    [WebMethod]
    public static int? CreateClassifiedMarketplace(Classified.Categories category, Classified.MarketplaceType subCategory, string title, string details, string postalCode, bool sponsored, string price, string condition, string make, string model, string[] images)
    {
        return Classified.CreateClassified(category, subCategory, title, details, postalCode, sponsored, price, condition, make, model, images);
    }

    [WebMethod]
    public static int? CreateClassifiedHousing(Classified.Categories category, Classified.HousingType subCategory, string title, string details, string postalCode, bool sponsored, int? meters, string rent, decimal? bedrooms, decimal? bathrooms, DateTime? available, bool? pets, bool? laundry, bool? furniture, string[] images)
    {
        return Classified.CreateClassified(category, subCategory, title, details, postalCode, sponsored, meters, rent, bedrooms, bathrooms, available, pets, laundry, furniture, images);
    }

    [WebMethod]
    public static Classified GetClassified(int classifiedId)
    {
        return Classified.GetClassified(classifiedId);
    }

    [WebMethod]
    public static string RenewClassified(int postId)
    {
        return Classified.RenewClassified(postId).ToString("MMM d");
    }

    [WebMethod]
    public static void SuspendClassified(int postId, bool suspended)
    {
        Classified.SuspendClassified(postId, suspended);
    }

    [WebMethod]
    public static void DeleteClassified(int postId)
    {
        Classified.DeleteClassified(postId);
    }
}