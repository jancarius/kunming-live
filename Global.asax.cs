using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebApplication1
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_EndRequest(object sender, EventArgs e)
        {
            // Censor Sensitive Words
            ResponseFilterStream filter = new ResponseFilterStream(HttpContext.Current.Response.Filter);
            filter.TransformString += sensitiveWords_TransformString;
            HttpContext.Current.Response.Filter = filter;
        }

        string sensitiveWords_TransformString(string output)
        {
            output = output.Replace("construction", "*******");
            return output;
        }
    }
}