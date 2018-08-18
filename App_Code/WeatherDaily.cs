using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for WeatherDaily
/// </summary>
public class WeatherDaily
{
    public WeatherDaily(int dailyId, DateTime forecastDate, string description, string icon, DateTime sunrise, DateTime sunset, decimal rainChance, PrecipitationType rainType, decimal fahrenheitHigh, decimal fahrenheitHighFeels, DateTime temperatureHighTime,
        decimal fahrenheitLow, decimal fahrenheitLowFeels, DateTime temperatureLowTime, int humidity, decimal windSpeedMI, decimal windGustMI, DateTime windGustTime, int windDirection, int clouds, int uvIndex, DateTime uvIndexTime)
    {
        DailyID = dailyId;
        ForecastDate = forecastDate;
        Description = description;
        Icon = icon;
        Sunrise = sunrise;
        Sunset = sunset;
        RainChance = rainChance;
        RainType = rainType;
        FahrenheitHigh = fahrenheitHigh;
        FahrenheitHighFeels = fahrenheitHighFeels;
        TemperatureHighTime = temperatureHighTime;
        FahrenheitLow = fahrenheitLow;
        FahrenheitLowFeels = fahrenheitLowFeels;
        TemperatureLowTime = temperatureLowTime;
        Humidity = humidity;
        WindSpeedMI = windSpeedMI;
        WindGustMI = windGustMI;
        WindGustTime = windGustTime;
        WindDirection = windDirection;
        Clouds = clouds;
        UVIndex = uvIndex;
        UVIndexTime = uvIndexTime;
    }

    public int DailyID { get; private set; }
    public DateTime ForecastDate { get; private set; }
    public string Description { get; private set; }
    public string Icon { get; private set; }
    public DateTime Sunrise { get; private set; }
    public DateTime Sunset { get; private set; }
    public decimal RainChance { get; private set; }
    public PrecipitationType RainType { get; private set; }
    public decimal FahrenheitHigh { get; private set; }
    public decimal CelsiusHigh
    {
        get
        {
            return (FahrenheitHigh - 32M) * (5M / 9M);
        }
    }
    public decimal FahrenheitHighFeels { get; private set; }
    public decimal CelsiusHighFeels
    {
        get
        {
            return (FahrenheitHighFeels - 32M) * (5M / 9M);
        }
    }
    public DateTime TemperatureHighTime { get; private set; }
    public decimal FahrenheitLow { get; private set; }
    public decimal CelsiusLow
    {
        get
        {
            return (FahrenheitLow - 32M) * (5M / 9M);
        }
    }
    public decimal FahrenheitLowFeels { get; private set; }
    public decimal CelsiusLowFeels
    {
        get
        {
            return (FahrenheitLowFeels - 32M) * (5M / 9M);
        }
    }
    public DateTime TemperatureLowTime { get; private set; }
    public int Humidity { get; private set; }
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
    public DateTime WindGustTime { get; private set; }
    public int WindDirection { get; private set; }
    public int Clouds { get; private set; }
    public int UVIndex { get; private set; }
    public DateTime UVIndexTime { get; private set; }

    public static WeatherDaily[] GetWeather(bool onlyToday = false)
    {
        string sql = "";
        if (onlyToday)
        {
            sql += "SELECT TOP 1 * FROM weather_daily WHERE forecast_date = CONVERT(DATE, GETDATE())";
        }
        else
        {
            sql += "SELECT TOP 8 * FROM weather_daily WHERE forecast_date >= CONVERT(DATE, GETDATE()) ORDER BY forecast_date DESC";
        }
        ResultSet resultSet = commons.ExecuteQuery(sql);
        List<WeatherDaily> weather = new List<WeatherDaily>();
        foreach (Result result in resultSet)
        {
            weather.Add(new WeatherDaily(
                (int)result["weather_daily_id"],
                (DateTime)result["forecast_date"],
                (string)result["description"],
                (string)result["icon"],
                (DateTime)result["sunrise"],
                (DateTime)result["sunset"],
                (decimal)result["rain_chance"],
                (PrecipitationType)result["rain_type"],
                (decimal)result["fahrenheit_high"],
                (decimal)result["fahrenheit_high_feels"],
                (DateTime)result["temperature_high_time"],
                (decimal)result["fahrenheit_low"],
                (decimal)result["fahrenheit_low_feels"],
                (DateTime)result["temperature_low_time"],
                (int)result["humidity"],
                (decimal)result["wind_speed_mi"],
                (decimal)result["wind_gust_mi"],
                (DateTime)result["wind_gust_time"],
                (int)result["wind_direction"],
                (int)result["clouds"],
                (int)result["uv_index"],
                (DateTime)result["uv_index_time"]
            ));
        }
        WeatherDaily[] weatherArray = weather.ToArray();
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