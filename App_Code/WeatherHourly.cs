using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Weather
/// </summary>
public class WeatherHourly
{
    public WeatherHourly(int weatherHourlyId, DateTime forecastTime, string description, string icon, decimal fahrenheit, decimal feelsFahrenheit,
        decimal rainChance, PrecipitationType rainType, decimal windSpeed, decimal windGust, int windDirection, int humidity, int clouds, int uv)
    {
        HourlyID = weatherHourlyId;
        ForecastTime = forecastTime;
        Description = description;
        Icon = icon;
        Fahrenheit = fahrenheit;
        FahrenheitFeels = feelsFahrenheit;
        RainChance = rainChance;
        RainType = rainType;
        WindSpeedMI = windSpeed;
        WindGustMI = windGust;
        WindDirection = windDirection;
        Humidity = humidity;
        Clouds = clouds;
        UVIndex = uv;
    }

    public int HourlyID { get; private set; }
    public DateTime ForecastTime { get; private set; }
    public string Description { get; private set; }
    public string Icon { get; private set; }
    public decimal Fahrenheit { get; private set; }
    public decimal Celsius
    {
        get
        {
            return (Fahrenheit - 32M) * (5M / 9M);
        }
    }
    public decimal FahrenheitFeels { get; private set; }
    public decimal CelsiusFeels
    {
        get
        {
            return (FahrenheitFeels - 32M) * (5M / 9M);
        }
    }
    public decimal RainChance { get; private set; }
    public PrecipitationType RainType { get; private set; }
    public decimal WindSpeedMI { get; private set; }
    public decimal WindSpeedKM
    {
        get
        {
            return WindSpeedMI * 1.609344M;
        }
    }
    public decimal WindGustMI { get; private set; }
    public decimal WindGustKM
    {
        get
        {
            return WindGustMI * 1.609344M;
        }
    }
    public int WindDirection { get; private set; }
    public int Humidity { get; private set; }
    public int Clouds { get; private set; }
    public int UVIndex { get; private set; }

    public static WeatherHourly[] GetWeather(bool onlyNow = false)
    {
        string sql = "";
        if (onlyNow)
        {
            sql = "SELECT TOP 1 * FROM weather_hourly WHERE forecast_time = FORMAT(GETDATE(), 'yyyy-MM-dd HH:00:00')";
        }
        else
        {
            sql = "SELECT TOP 49 * FROM weather_hourly WHERE forecast_time > DATEADD(HOUR,-1,GETDATE()) ORDER BY forecast_time DESC";
        }
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<WeatherHourly> weather = new List<WeatherHourly>();
        foreach (Result result in resultSet)
        {
            weather.Add(new WeatherHourly(
                (int)result["weather_hourly_id"],
                (DateTime)result["forecast_time"],
                (string)result["description"],
                (string)result["icon"],
                (decimal)result["temp_fahrenheit"],
                (decimal)result["temp_feels_fahrenheit"],
                (decimal)result["rain_chance"],
                (PrecipitationType)result["precipitation_type"],
                (decimal)result["wind_speed_mi"],
                (decimal)result["wind_gust_mi"],
                (int)result["wind_direction"],
                (int)result["humidity"],
                (int)result["clouds"],
                (int)result["uv_index"]
            ));
        }
        WeatherHourly[] weatherArray = weather.ToArray();
        Array.Reverse(weatherArray);
        return weatherArray;
    }

    public enum PrecipitationType
    {
        Rain,
        Snow,
        Sleet,
        None
    }
}