using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ResultSet
/// </summary>
public class ResultSet
{
    List<Result> resultSet = new List<Result>();

    public void Add(Result result)
    {
        resultSet.Add(result);
    }

    public Result this[int i]
    {
        get { return resultSet[i]; }
    }

    public IEnumerator<Result> GetEnumerator()
    {
        return resultSet.GetEnumerator();
    }

    public int Length
    {
        get { return resultSet.Count; }
    }
}

public class Result
{
    Dictionary<string, object> result = new Dictionary<string, object>();

    public Result() { }

    public Result(string key, object value)
    {
        result.Add(key, value);
    }

    public void Add(string key, object value)
    {
        result.Add(key, value);
    }

    public object this[string key]
    {
        get { return result[key]; }
    }

    public Dictionary<string, object> Dictionary
    {
        get { return result; }
        set { result = value; }
    }
}