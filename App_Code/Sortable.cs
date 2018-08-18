using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Structure Class for Sortable Elements
/// </summary>
public class Sortable
{
    public Sortable()
    {

    }

    public int PageID { get; set; }

    public int UserID { get; set; }

    public string ElementID { get; set; }

    public string ContainerID { get; set; }

    public int SortOrder { get; set; }


}