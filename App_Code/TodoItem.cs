using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Structure Class for Todo Lists
/// </summary>
public class TodoItem
{
    public TodoItem(int todoItemId, string tableName, int primaryIdentifier, string linkBack, string username, TodoTypes todoType, string title, int? sortOrder, bool done)
    {
        TodoItemID = todoItemId;
        TableName = tableName;
        PrimaryIdentifier = primaryIdentifier;
        LinkBack = linkBack;
        Username = username;
        TodoType = todoType;
        Title = title;
        SortOrder = sortOrder;
        Done = done;
    }

    public int TodoItemID { get; private set; }
    public string TableName { get; private set; }
    public int PrimaryIdentifier { get; private set; }
    public string LinkBack { get; private set; }
    public string Username { get; private set; }
    public TodoTypes TodoType { get; set; }
    public string Title { get; set; }
    public int? SortOrder { get; set; }
    public bool Done { get; set; }

    public static TodoItem[] GetTodoItems(string username = null, bool getCompleted = true)
    {
        if (username == null)
        {
            username = HttpContext.Current.User.Identity.Name;
        }
        string sql = "SELECT * FROM todo_items WHERE user_name = @user_name ";
        if (!getCompleted)
        {
            sql += "AND done = 0 ";
        }
        sql += "ORDER BY sort_order ASC";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@user_name", username }
        });

        List<TodoItem> todoItems = new List<TodoItem>();
        foreach(Result result in resultSet)
        {
            todoItems.Add(new TodoItem(
                (int)result["todo_item_id"],
                (string)result["table_name"],
                (int)result["primary_identifier"],
                (string)result["link_back"],
                (string)result["user_name"],
                (TodoTypes)result["todo_type"],
                result["title"] as string?? "",
                result["sort_order"] as int?,
                Convert.ToBoolean(result["done"])
            ));
        }

        return todoItems.ToArray();
    }

    public static bool CreateTodoItem(string tableName, string primaryIdentifier, string linkBack, TodoTypes todoType, string title)
    {
        string username = HttpContext.Current.User.Identity.Name;
        string sql = "SELECT * FROM todo_items WHERE table_name = @table_name AND primary_identifier = @primary_identifier AND user_name = @user_name";
        ResultSet resultSet = commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@table_name", tableName },
            { "@primary_identifier", primaryIdentifier },
            { "@user_name", username }
        });

        if (resultSet.Length > 0)
        {
            return false;
        }

        sql = "INSERT INTO todo_items (table_name,primary_identifier,link_back,user_name,todo_type,title,done) VALUES (@table_name,@primary_identifier,@link_back,@user_name,@todo_type,@title,0)";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@table_name", tableName },
            { "@primary_identifier", primaryIdentifier },
            { "@link_back", linkBack },
            { "@user_name", username },
            { "@todo_type", todoType },
            { "@title", title },
            { "@notes", "" },
            { "@due_date", DBNull.Value }
        });

        return true;
    }

    public static bool RemoveTodoItem(string tableName, string primaryIdentifier)
    {
        string sql = "DELETE FROM todo_items WHERE table_name = @table_name AND primary_identifier = @primary_identifier";
        commons.ExecuteQuery(sql, new Dictionary<string, object>
        {
            { "@table_name", tableName },
            { "@primary_identifier", primaryIdentifier }
        });
        return true;
    }

    public enum TodoTypes
    {
        Entertainment = 0,
        Event = 1,
        Meetup = 2,
        Activity = 3,
        Nightlife = 4,
        Restaurant = 5,
        Services = 6,
        Shopping = 7,
        Tip = 8
    }

    public static  class CssClasses
    {
        public static string Label(TodoTypes type)
        {
            switch (type)
            {
                case TodoTypes.Activity:
                    return "todo-type-label-Activity";
                case TodoTypes.Entertainment:
                    return "todo-type-label-Entertainment";
                case TodoTypes.Event:
                    return "todo-type-label-Event";
                case TodoTypes.Meetup:
                    return "todo-type-label-Meetup";
                case TodoTypes.Nightlife:
                    return "todo-type-label-Nightlife";
                case TodoTypes.Restaurant:
                    return "todo-type-label-Restaurant";
                case TodoTypes.Services:
                    return "todo-type-label-Services";
                case TodoTypes.Shopping:
                    return "todo-type-label-Shopping";
                case TodoTypes.Tip:
                    return "todo-type-label-Tip";
                default:
                    return "";
            }
        }

        public static string Box(TodoTypes type)
        {
            switch (type)
            {
                case TodoItem.TodoTypes.Activity:
                    return "box-danger";
                case TodoItem.TodoTypes.Entertainment:
                    return "box-warning";
                case TodoItem.TodoTypes.Event:
                    return "box-info";
                case TodoItem.TodoTypes.Meetup:
                    return "box-primary";
                case TodoItem.TodoTypes.Nightlife:
                    return "box-night";
                case TodoItem.TodoTypes.Restaurant:
                    return "box-success";
                case TodoItem.TodoTypes.Services:
                    return "box-default";
                case TodoItem.TodoTypes.Shopping:
                    return "box-purple";
                case TodoTypes.Tip:
                    return "box-maroon";
                default:
                    return "";
            }
        }

        public static string Background(TodoTypes type)
        {
            switch (type)
            {
                case TodoItem.TodoTypes.Activity:
                    return "bg-danger";
                case TodoItem.TodoTypes.Entertainment:
                    return "bg-warning";
                case TodoItem.TodoTypes.Event:
                    return "bg-info";
                case TodoItem.TodoTypes.Meetup:
                    return "bg-primary";
                case TodoItem.TodoTypes.Nightlife:
                    return "bg-night";
                case TodoItem.TodoTypes.Restaurant:
                    return "bg-success";
                case TodoItem.TodoTypes.Services:
                    return "bg-default";
                case TodoItem.TodoTypes.Shopping:
                    return "bg-purple";
                case TodoTypes.Tip:
                    return "bg-maroon";
                default:
                    return "";
            }
        }

        public static string Icon(TodoTypes type)
        {
            switch (type)
            {
                case TodoTypes.Activity:
                    return "fa fa-dove";
                case TodoTypes.Entertainment:
                    return "fa fa-bowling-ball";
                case TodoTypes.Event:
                    return "fa fa-calendar";
                case TodoTypes.Meetup:
                    return "fa fa-users";
                case TodoTypes.Nightlife:
                    return "fa fa-moon";
                case TodoTypes.Restaurant:
                    return "fa fa-cutlery";
                case TodoTypes.Services:
                    return "fa fa-wrench";
                case TodoTypes.Shopping:
                    return "fa fa-shopping-cart";
                case TodoTypes.Tip:
                    return "fa fa-info-circle";
                default: return "";
            }
        }
    }
}