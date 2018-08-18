<%@ WebService Language="C#" Class="background" %>

using System;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Globalization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// [System.Web.Script.Services.ScriptService]
public class background : System.Web.Services.WebService
{
    [WebMethod]
    public void StartHourly()
    {
        if (VerifySource())
        {
            GetWeather();
            ProcessCompleted("Hourly");
        }
    }

    [WebMethod]
    public void StartDaily()
    {
        if (VerifySource())
        {
            CleanTmpImages();
            CleanSavedItems();
            CleanLogs();
            ProcessCompleted("Daily");
        }
    }

    private bool VerifySource()
    {
        string requestIp = HttpContext.Current.Request.Headers.Get("CF-Connecting-IP");
        if (requestIp != "103.198.77.142")
        {
            if (global::User.VerifyAdmin()) { return true; }
            HttpContext.Current.Response.Write("Invalid Access Attempt! Administrators Notified...");
            commons.LogAction("Invalid Background Processes Request");
            commons.SendEmail(new User("Jancarius"), "WARNING: Invalid Request - Background Processes", "An attempt to exceute the background processes was made from an invalid IP address. Check 'Action Log' for further details.");
            return false;
        } else { return true; }
    }

    private void ProcessCompleted(string type)
    {
        HttpContext.Current.Response.Write("Successfully Executed " + type + " Process");
        //commons.SendEmail(new User("Jancarius"), "Background Process (" + type + ")", "Background Processes Completed");
    }

    private void CleanTmpImages()
    {
        string[] files = Directory.GetFiles(Server.MapPath("dist/img/tmp"));
        try
        {
            foreach (string file in files)
            {
                FileInfo info = new FileInfo(file);
                if (info.LastWriteTime < DateTime.Now.AddDays(-1))
                {
                    info.Delete();
                }
            }
        }
        catch (Exception ex) { commons.LogError(ex, "Failed to Clean Tmp Images: " + string.Join("|", files)); }
    }

    private void CleanSavedItems()
    {
        try
        {
            // Events
            string sql = "SELECT * FROM events WHERE end_date < @end_date AND expired = 0";
            ResultSet resultSet = commons.ExecuteQuery(sql, DateTime.Now.Date);
            foreach (Result result in resultSet)
            {
                sql = "UPDATE events SET expired = 1 WHERE event_id = @event_id;" +
                    "DELETE FROM todo_items WHERE table_name = 'events' AND primary_identifier = @event_id;" +
                    "DELETE FROM custom_box_states WHERE table_name = 'events' AND primary_identifier = @event_id;";
                commons.ExecuteQuery(sql, (int)result["event_id"]);

                string body = "Your Event on Kunming LIVE!, \"" + (string)result["title"] + "\", has expired. If you have another event or changes have been made to this event and you want to update it, " +
                        "please login and visit your profile at <a href=\"https://kunminglive.com/manageprofile.aspx\">https://kunminglive.com/manageprofile.aspx</a>. Thank you for sharing with other users.";
                commons.SendEmail(new User((string)result["user_name"]), "Kunming LIVE! Event Expired", body);
            }
            // TODO: Warn users of upcoming expirations //

            // Classified Posts
            sql = "SELECT * FROM classified_posts WHERE time_created < @time_created AND expired = 0";
            resultSet = commons.ExecuteQuery(sql, DateTime.Now.Date.AddMonths(-1));
            foreach (Result result in resultSet)
            {
                sql = "UPDATE classified_posts SET expired = 1 WHERE classified_post_id = @classified_id;" +
                    "DELETE FROM todo_items WHERE table_name = 'classified_posts' AND primary_identifier = @classified_id;" +
                    "DELETE FROM custom_box_states WHERE table_name = 'classified_posts' AND primary_identifier = @classified_id;";
                commons.ExecuteQuery(sql, (int)result["classified_post_id"]);

                string body = "Your Classified Ad on Kunming LIVE, \"" + (string)result["post_title"] + "\", has expired. If you need to post another ad or want to renew this ad " +
                        "please visit your profile at <a href=\"https://kunminglive.com/manageprofile.aspx\">https://kunminglive.com/manageprofile.aspx</a>. Thank you for contributing.";
                commons.SendEmail(new User((string)result["user_name"]), "Kunming LIVE! Classified Ad Expired", body);
            }
        }
        catch (Exception ex) { commons.LogError(ex, "Failed to Clean Saved Items"); }
    }

    private void CleanLogs()
    {
        string sql = "DELETE FROM action_log WHERE time_created < @time_created;" +
                "DELETE FROM error_log WHERE time_created < @time_created;";
        commons.ExecuteQuery(sql, DateTime.Now.AddMonths(-1));
        sql = "DELETE FROM weather_daily WHERE forecast_date < @time_created;" +
                "DELETE FROM weather_hourly WHERE forecast_time < @time_created;" +
                "DELETE FROM page_access_log WHERE time_created < @time_created;";
        commons.ExecuteQuery(sql, DateTime.Now.AddDays(-7));
    }

    private void GetWeather()
    {
        string apiAddress = "https://api.darksky.net/forecast/e73a1e421ee58680c4339c6f41f718a9/25.0216327,102.6009669";
        WebRequest req = WebRequest.Create(apiAddress);
        Stream res = req.GetResponse().GetResponseStream();
        StreamReader reader = new StreamReader(res);
        string json = reader.ReadToEnd();

        try
        {
            var weather = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<dynamic>(json);
            if (weather["hourly"].Count > 0)
            {
                for (int i = 0; i < weather["hourly"]["data"].Length; i++)
                {
                    var data = weather["hourly"]["data"][i];
                    DateTime forecastTime = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["time"]).ToLocalTime();
                    string description = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(data["summary"].ToString());
                    string icon = data["icon"].ToString();
                    decimal tempF = Convert.ToDecimal(data["temperature"]) + 3;
                    decimal tempFeelsF = Convert.ToDecimal(data["apparentTemperature"]) + 3;
                    decimal rainChance = 0;
                    WeatherHourly.PrecipitationType rainType = WeatherHourly.PrecipitationType.None;
                    if (data.ContainsKey("precipType"))
                    {
                        string precipType = Convert.ToString(data["precipType"]);
                        switch (precipType)
                        {
                            case "rain":
                                rainType = WeatherHourly.PrecipitationType.Rain;
                                break;
                            case "snow":
                                rainType = WeatherHourly.PrecipitationType.Snow;
                                break;
                            case "sleet":
                                rainType = WeatherHourly.PrecipitationType.Sleet;
                                break;
                            default:
                                rainType = WeatherHourly.PrecipitationType.None;
                                break;
                        }
                        rainChance = Convert.ToDecimal(data["precipProbability"] * 100);
                    }
                    decimal windSpeedMI = Convert.ToDecimal(data["windSpeed"]);
                    decimal windGustMI = windSpeedMI;
                    if (data.ContainsKey("windGust"))
                    {
                        windGustMI = Convert.ToDecimal(data["windGust"]);
                    }
                    int windDirection = Convert.ToInt32(data["windBearing"]);
                    int humidity = Convert.ToInt32(data["humidity"] * 100);
                    int clouds = 0;
                    if (data.ContainsKey("cloudCover"))
                    {
                        clouds = Convert.ToInt32(data["cloudCover"] * 100);
                    }
                    int uvIndex = 0;
                    if (data.ContainsKey("uvIndex"))
                    {
                        uvIndex = Convert.ToInt32(data["uvIndex"]);
                    }

                    string sql = "SELECT COUNT(weather_hourly_id) FROM weather_hourly WHERE forecast_time = @forecast_time";
                    ResultSet resultSet = commons.ExecuteQuery(sql, forecastTime);
                    if (Convert.ToInt32(resultSet[0][""]) == 1)
                    {
                        sql = "UPDATE weather_hourly SET description=@description,icon=@icon,temp_fahrenheit=@temp_fahrenheit,temp_feels_fahrenheit=@temp_feels_fahrenheit,rain_chance=@rain_chance,precipitation_type=@precipitation_type," +
                                "wind_speed_mi=@wind_speed_mi,wind_gust_mi=@wind_gust_mi,wind_direction=@wind_direction,humidity=@humidity,clouds=@clouds,uv_index=@uv_index WHERE forecast_time = @forecast_time";
                    }
                    else
                    {
                        sql = "INSERT INTO weather_hourly (forecast_time,description,icon,temp_fahrenheit,temp_feels_fahrenheit,rain_chance,precipitation_type,wind_speed_mi,wind_gust_mi,wind_direction,humidity,clouds,uv_index) " +
                                "VALUES (@forecast_time,@description,@icon,@temp_fahrenheit,@temp_feels_fahrenheit,@rain_chance,@precipitation_type,@wind_speed_mi,@wind_gust_mi,@wind_direction,@humidity,@clouds,@uv_index)";
                    }
                    commons.ExecuteQuery(sql, new Dictionary<string, object>
                    {
                        { "@forecast_time", forecastTime },
                        { "@description", description },
                        { "@icon", icon },
                        { "@temp_fahrenheit", tempF },
                        { "@temp_feels_fahrenheit", tempFeelsF },
                        { "@rain_chance", rainChance },
                        { "@precipitation_type", rainType },
                        { "@wind_speed_mi", windSpeedMI },
                        { "@wind_gust_mi", windGustMI },
                        { "@wind_direction", windDirection },
                        { "@humidity", humidity },
                        { "@clouds", clouds },
                        { "@uv_index", uvIndex }
                    });
                }
            }
            if (weather["daily"].Count > 0)
            {
                for (int i = 0; i < weather["daily"]["data"].Length; i++)
                {
                    var data = weather["daily"]["data"][i];
                    DateTime forecastDate = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["time"]).ToLocalTime().Date;
                    string description = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(data["summary"].ToString());
                    string icon = data["icon"].ToString();
                    DateTime sunrise = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["sunriseTime"]).ToLocalTime();
                    DateTime sunset = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["sunsetTime"]).ToLocalTime();
                    decimal rainChance = 0;
                    WeatherHourly.PrecipitationType rainType = WeatherHourly.PrecipitationType.None;
                    if (data.ContainsKey("precipType"))
                    {
                        string precipType = Convert.ToString(data["precipType"]);
                        switch (precipType)
                        {
                            case "rain":
                                rainType = WeatherHourly.PrecipitationType.Rain;
                                break;
                            case "snow":
                                rainType = WeatherHourly.PrecipitationType.Snow;
                                break;
                            case "sleet":
                                rainType = WeatherHourly.PrecipitationType.Sleet;
                                break;
                            default:
                                rainType = WeatherHourly.PrecipitationType.None;
                                break;
                        }
                        rainChance = Convert.ToDecimal(data["precipProbability"] * 100);
                    }
                    decimal tempFHigh = Convert.ToDecimal(data["temperatureHigh"]) + 3;
                    decimal tempFHighFeel = Convert.ToDecimal(data["apparentTemperatureHigh"]) + 3;
                    DateTime tempHighTime = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["temperatureHighTime"]).ToLocalTime();
                    decimal tempFLow = Convert.ToDecimal(data["temperatureLow"]) + 3;
                    decimal tempFLowFeel = Convert.ToDecimal(data["apparentTemperatureLow"]) + 3;
                    DateTime tempLowTime = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["temperatureLowTime"]).ToLocalTime();
                    decimal windSpeedMI = Convert.ToDecimal(data["windSpeed"]);
                    decimal windGustMI = windSpeedMI;
                    DateTime windGustTime = tempLowTime;
                    if (data.ContainsKey("windGust"))
                    {
                        windGustMI = Convert.ToDecimal(data["windGust"]);
                        windGustTime = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["windGustTime"]).ToLocalTime();
                    }
                    int windDirection = Convert.ToInt32(data["windBearing"]);
                    int humidity = Convert.ToInt32(data["humidity"] * 100);
                    int clouds = 0;
                    if (data.ContainsKey("cloudCover"))
                    {
                        clouds = Convert.ToInt32(data["cloudCover"] * 100);
                    }
                    int uvIndex = 0;
                    DateTime uvIndexTime = tempHighTime;
                    if (data.ContainsKey("uvIndex"))
                    {
                        uvIndex = Convert.ToInt32(data["uvIndex"]);
                        uvIndexTime = new DateTime(1970,1,1,0,0,0,0,DateTimeKind.Utc).AddSeconds(data["uvIndexTime"]).ToLocalTime();
                    }

                    string sql = "SELECT COUNT(weather_daily_id) FROM weather_daily WHERE forecast_date = @forecast_date";
                    ResultSet resultSet = commons.ExecuteQuery(sql, forecastDate);
                    if (Convert.ToInt32(resultSet[0][""]) == 1)
                    {
                        sql = "UPDATE weather_daily SET description=@description,icon=@icon,sunrise=@sunrise,sunset=@sunset,rain_chance=@rain_chance,rain_type=@rain_type,fahrenheit_high=@fahrenheit_high,fahrenheit_high_feels=@fahrenheit_high_feels," +
                                "temperature_high_time=@temperature_high_time,fahrenheit_low=@fahrenheit_low,fahrenheit_low_feels=@fahrenheit_low_feels,temperature_low_time=@temperature_low_time,humidity=@humidity,wind_speed_mi=@wind_speed_mi," +
                                "wind_gust_mi=@wind_gust_mi,wind_gust_time=@wind_gust_time,wind_direction=@wind_direction,clouds=@clouds,uv_index=@uv_index,uv_index_time=@uv_index_time WHERE forecast_date = @forecast_date";
                    }
                    else
                    {
                        sql = "INSERT INTO weather_daily (forecast_date,description,icon,sunrise,sunset,rain_chance,rain_type,fahrenheit_high,fahrenheit_high_feels,temperature_high_time,fahrenheit_low,fahrenheit_low_feels,temperature_low_time," +
                                "humidity,wind_speed_mi,wind_gust_mi,wind_gust_time,wind_direction,clouds,uv_index,uv_index_time) " +
                                "VALUES (@forecast_date,@description,@icon,@sunrise,@sunset,@rain_chance,@rain_type,@fahrenheit_high,@fahrenheit_high_feels,@temperature_high_time,@fahrenheit_low,@fahrenheit_low_feels,@temperature_low_time," +
                                "@humidity,@wind_speed_mi,@wind_gust_mi,@wind_gust_time,@wind_direction,@clouds,@uv_index,@uv_index_time)";
                    }
                    commons.ExecuteQuery(sql, new Dictionary<string, object>
                    {
                        { "@forecast_date", forecastDate },
                        { "@description", description },
                        { "@icon", icon },
                        { "@sunrise", sunrise },
                        { "@sunset", sunset },
                        { "@rain_chance", rainChance },
                        { "@rain_type", rainType },
                        { "@fahrenheit_high", tempFHigh },
                        { "@fahrenheit_high_feels", tempFHighFeel },
                        { "@temperature_high_time", tempHighTime },
                        { "@fahrenheit_low", tempFLow },
                        { "@fahrenheit_low_feels", tempFLowFeel },
                        { "@temperature_low_time", tempLowTime },
                        { "@humidity", humidity },
                        { "@wind_speed_mi", windSpeedMI },
                        { "@wind_gust_mi", windGustMI },
                        { "@wind_gust_time", windGustTime },
                        { "@wind_direction", windDirection },
                        { "@clouds", clouds },
                        { "@uv_index", uvIndex },
                        { "@uv_index_time", uvIndexTime }
                    });
                }
            }
            else { commons.LogError(new Exception("Weather Object: " + weather.ToString()), json); }
        }
        catch (Exception ex) { commons.LogError(ex, json); }
    }
}