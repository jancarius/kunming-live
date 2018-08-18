using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class tips : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Tip[] tips = Tip.GetTips();
        foreach (Tip tip in tips)
        {
            lstContentsIndex.Controls.Add(new LiteralControl(
                "<li>" + tip.Title + "</li>"
            ));
            bool collapsed = false;
            if (Master.dynamicStates.Keys.Contains("tipTrick_" + tip.TipID))
            {
                if (Master.dynamicStates["tipTrick_" + tip.TipID] == 1) { continue; }
                if (Master.dynamicStates["tipTrick_" + tip.TipID] == 0) { collapsed = true; }
            }
            pnlTipsContent.Controls.Add(new LiteralControl(
                "<div class='col-xxl-3 col-lg-4 col-sm-6 col-xs-12' style='min-width:0;'>" +
                    "<div id='tipTrick_" + tip.TipID + "' class='box box-success" + (collapsed ? " collapsed-box" : "") + "' data-tip_id='" + tip.TipID + "' data-dynamic='true'>" +
                        "<div class='box-header with-border'>" +
                            "<div class='pull-right'>" +
                                "<button id='tips-" + tip.TipID + "' data-todo-title=\"" + tip.Title + "\" data-todo-type=\"" + TodoItem.TodoTypes.Tip + "\" data-link_back='tips.aspx?view=" + tip.TipID + "' type='button' class='btn btn-default btn-sm save-todo' data-toggle='tooltip' title='Save&nbsp;to&nbsp;Bucket&nbsp;List'>" +
                                    "<i class='fa fa-star clickable'></i>" +
                                "</button>" +
                                "<button type='button' class='btn btn-default btn-sm' data-widget='collapse' data-toggle='tooltip' data-original-title='Collapse'>" +
                                    (collapsed ? "<i class='fa fa-plus'></i>" : "<i class='fa fa-minus'></i>") +
                                "</button>" +
                                "<button type='button' class='btn btn-default btn-sm' data-widget='remove' data-toggle='tooltip' data-original-title='Remove'>" +
                                    "<i class='fa fa-times'></i>" +
                                "</button>" +
                            "</div>" +
                            "<h3 class='box-title' style='display:initial;'>" +
                                tip.Title +
                            "</h3>" +
                        "</div>" +
                        "<div class='box-body no-padding' style='" + (collapsed ? "display:none;" : "") + "'>" +
                            "<div class='col-xs-12 no-padding'>" +
                                "<img src='" + tip.MainImagePath + "' alt='" + tip.Title + "' class='img-responsive pull-left' />" +
                            "</div>" +
                            "<div class='col-xs-12 pad'>" +
                                tip.ShortDescription +
                            "</div>" +
                            "<button class='show-full-article btn btn-sm btn-block btn-default' type='button'>Full Article</button>" +
                            "<input type='hidden' value='" + new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(tip) + "' />" +
                        "</div>" +
                    "</div>" +
                "</div>"
            ));
        }
    }
}