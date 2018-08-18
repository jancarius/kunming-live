using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Change
/// </summary>
public class Change
{
    private string tableName;
    private string columnName;
    private object columnValue;

    public Change(string tableName, string columnName, object columnValue)
    {
        this.tableName = tableName;
        this.columnName = columnName;
        this.columnValue = columnValue;
    }

    public string TableName
    {
        get { return tableName; }
        set { tableName = value; }
    }

    public string ColumnName
    {
        get { return columnName; }
        set { columnName = value; }
    }

    public object ColumnValue
    {
        get { return columnValue; }
        set { columnValue = value; }
    }

    public static void UpdateChanges(List<Change> changes, string primaryColumn, int primaryId)
    {
        string sql = "BEGIN TRANSACTION;";
        SqlConnection conn = new SqlConnection(commons.connString);
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        Dictionary<string, Dictionary<string, object>> updates = new Dictionary<string, Dictionary<string, object>>();
        foreach (Change change in changes)
        {
            if (!updates.ContainsKey(change.TableName))
            {
                updates.Add(change.TableName, new Dictionary<string, object>());
            }
            updates[change.TableName].Add(change.ColumnName, change.ColumnValue);
        }
        foreach (KeyValuePair<string, Dictionary<string, object>> update in updates)
        {
            sql += "UPDATE " + update.Key + " SET ";
            foreach (KeyValuePair<string, object> columnInfo in updates[update.Key])
            {
                sql += columnInfo.Key + " = @" + columnInfo.Key + ",";
                cmd.Parameters.AddWithValue("@" + columnInfo.Key, columnInfo.Value);
            }
            sql = sql.Substring(0, sql.Length - 1) + " WHERE " + primaryColumn + " = @" + primaryColumn + ";";
        }
        sql += "COMMIT;";
        cmd.Parameters.AddWithValue("@" + primaryColumn, primaryId);
        cmd.CommandText = sql;
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
    }
}