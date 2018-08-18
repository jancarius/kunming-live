using System;
using System.Web;
public class CensorshipModule : IHttpModule
{
    public CensorshipModule() { }

    public void Init(HttpApplication application)
    {
        //application.BeginRequest += (new EventHandler(this.Application_BeginRequest));
        //application.EndRequest += (new EventHandler(this.Application_EndRequest));
    }

    private void Application_BeginRequest(Object source, EventArgs e)
    {
        // Create HttpApplication and HttpContext objects to access
        // request and response properties.
        HttpApplication application = (HttpApplication)source;
        HttpContext context = application.Context;
        string filePath = context.Request.FilePath;
        string fileExtension =
            VirtualPathUtility.GetExtension(filePath);
        if (fileExtension.Equals(".aspx"))
        {
            //commons.Compress();
        }
    }

    private void Application_EndRequest(Object source, EventArgs e)
    {
        // Create HttpApplication and HttpContext objects to access
        // request and response properties.
        HttpApplication application = (HttpApplication)source;
        HttpContext context = application.Context;
        string filePath = context.Request.FilePath;
        string fileExtension =
            VirtualPathUtility.GetExtension(filePath);
        if (fileExtension.Equals(".aspx"))
        {
            //commons.Compress();
        }
    }
    public void Dispose() { }
}