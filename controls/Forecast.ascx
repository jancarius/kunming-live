<%@ Control Language="C#" ClassName="Forecast" %>

<script runat="server">
    public bool Compact { get; set; }
    public User.Measurement measureType = User.Measurement.Metric;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.IsAuthenticated) {
            measureType = (User.Measurement)commons.GetFieldById("users", "measurement", "user_name", HttpContext.Current.User.Identity.Name);
        }
        WeatherHourly[] weatherHourly = WeatherHourly.GetWeather();
        string hourlyHtml = "";
        foreach (WeatherHourly weather in weatherHourly)
        {
            hourlyHtml +=
                "<tr>" +
                    "<td>" + weather.ForecastTime.ToString("M/dd HH:mm") + "</td>" +
                    "<td><img src='https://www.kunminglive.com/dist/img/icons/weather/" + weather.Icon + ".png' alt='Weather Icon: " + weather.Icon + "' style='width:30px;' /></td>" +
                    "<td style='white-space:normal;text-align:left;'>" + weather.Description + "</td>" +
                    "<td>" +
                        "<span class='celsius-temp" + (measureType == User.Measurement.Metric ? "" : " hidden") + "'>" + weather.Celsius.ToString("0") + "</span>" +
                        "<span class='fahrenheit-temp" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "'>" + weather.Fahrenheit.ToString("0") + "</span>&deg;" +
                    "</td>" +
                    "<td>" + weather.RainChance.ToString("0") + "%</td>" +
                    "<td>" + weather.RainType.ToString() + "</td>" +
                    "<td>" +
                        "<span class='kmh-wind" + (measureType == User.Measurement.Metric ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='" + weather.WindGustKM.ToString("0.##") + " KMH Gusts'>" + weather.WindSpeedKM.ToString("0.##") + " KMH</span>" +
                        "<span class='mph-wind" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='" + weather.WindGustMI.ToString("0.##") + " MPH Gusts'>" + weather.WindSpeedMI.ToString("0.##") + " MPH</span>&nbsp;" +
                        "<img src='https://www.kunminglive.com/dist/img/icons/weather/direction.png' alt='Wind Direction: " + weather.WindDirection + " Degrees' style='transform:rotate(" + weather.WindDirection + "deg);' />" +
                    "</td>" +
                    "<td>" + weather.Humidity + "%</td>" +
                    "<td>" + weather.Clouds + "%</td>" +
                    "<td>" + weather.UVIndex + "</td>" +
                "</tr>";
        }

        showForecast.Controls.Add(new LiteralControl(
            "<table id='showHourlyForecast_" + this.ID + "' class='forecast-table table table-striped'>" +
                "<tbody>" +
                    "<tr>" +
                        "<th>Time</th>" +
                        "<th></th>" +
                        "<th></th>" +
                        "<th>Temp</th>" +
                        "<th colspan='2'>Precipitation</th>" +
                        "<th>Wind</th>" +
                        "<th>Humidity</th>" +
                        "<th>Clouds</th>" +
                        "<th>UV</th>" +
                    "</tr>" +
                    hourlyHtml +
                "</tbody>" +
            "</table>"
        ));

        WeatherDaily[] weatherDaily = WeatherDaily.GetWeather();
        int index = 0;
        foreach (WeatherDaily weather in weatherDaily)
        {
            showForecastCarouselIndicators.Controls.Add(new LiteralControl(
                "<li data-target='#showForecastCarousel_" + this.ID + "' data-slide-to='" + index + "'" + (index == 0 ? " class='active'" : "") + " style='border: 1px solid #111;' data-toggle='tooltip' data-original-title='" + weather.ForecastDate.ToString("ddd MMM d") + "'></li>"
            ));
            string statCols = "col-xl-5 col-lg-5 col-md-12 col-sm-6 col-xs-12";
            string rightCols = "col-lg-8 col-lg-push-0 col-md-6 col-md-push-1 col-xs-7";
            string leftCols = "col-xl-3 col-lg-4 col-md-5 col-xs-5";
            string windCols = "col-xxl-3 col-lg-4 col-md-5 col-xs-5";
            string uvCols = "col-xxl-7 col-xxl-push-2 col-xl-push-1 col-lg-8 col-lg-push-0 col-md-6 col-md-push-1 col-xs-7";
            string topPad = "15px";
            if (Compact)
            {
                statCols = "col-xs-12";
                rightCols = "col-xs-7";
                leftCols = "col-xs-5";
                windCols = "col-xs-5";
                uvCols = "col-xs-7";
                topPad = "0";
            }
            showForecastCarouselInner.Controls.Add(new LiteralControl(
                "<div class='item" + (index == 0 ? " active" : "") + "' style='border:0;width:100%;height:100%;'>" +
                    "<div style='width:100%;height:100%;background-color:#fff;padding-top:" + topPad + ";'>" +
                        "<div class='col-xs-12 text-center' style='padding:" + topPad + " 10px 10px 10px;'>" +
                            "<strong>" + weather.ForecastDate.ToString("ddd MMM d") + "</strong>&nbsp;&nbsp;&nbsp;" + weather.Description +
                        "</div>" +
                        "<div class='" + leftCols + " no-padding text-center'>" +
                            "<img src='https://www.kunminglive.com/dist/img/icons/weather/" + weather.Icon + ".png' alt='Weather Icon: " + weather.Icon + "' style='width:80px;' />" +
                        "</div>" +
                        "<div class='" + rightCols + " no-padding'>" +
                            "<div class='" + statCols + "'>" +
                                "<strong>Hi:&nbsp;</strong><span class='celsius-temp" + (measureType == User.Measurement.Metric ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='Hi Temp Time" + weather.TemperatureHighTime.ToString("HH:mm:ss") + "'>" + weather.CelsiusHigh.ToString("0") + "</span>" +
                                "<span class='fahrenheit-temp" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='Hi Temp Time" + weather.TemperatureHighTime.ToString("HH:mm:ss") + "'>" + weather.FahrenheitHigh.ToString("0") + "</span>&deg;&nbsp;/&nbsp;" +
                                "<strong>Lo:&nbsp;</strong><span class='celsius-temp" + (measureType == User.Measurement.Metric ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='Lo Temp Time: " + weather.TemperatureLowTime.ToString("HH:mm:ss") + "'>" + weather.CelsiusLow.ToString("0") + "</span>" +
                                "<span class='fahrenheit-temp" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='Lo Temp Time: " + weather.TemperatureLowTime.ToString("HH:mm:ss") + "'>" + weather.FahrenheitLow.ToString("0") + "</span>&deg;" +
                            "</div>" +
                            "<div class='" + statCols + "'>" +
                                "<strong>Precipitation:&nbsp;</strong>" +
                                weather.RainChance.ToString("0") + "%&nbsp;&nbsp;" + weather.RainType.ToString() +
                            "</div>" +
                            "<div class='" + statCols + "'>" +
                                "<strong>Clouds:&nbsp;</strong>" + weather.Clouds + "%" +
                            "</div>" +
                            "<div class='" + statCols + "'>" +
                                "<strong>Humidity:&nbsp;</strong>" + weather.Humidity + "%" +
                            "</div>" +
                        "</div>" +
                        "<div class='col-xs-12 no-padding'>" +
                            "<div class='" + windCols + " no-padding text-center'>" +
                                "<strong>Wind:&nbsp;</strong>" +
                                "<span class='kmh-wind" + (measureType == User.Measurement.Metric ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='" + weather.WindGustKM.ToString("0.##") + " KMH Gusts'>" + weather.WindSpeedKM.ToString("0.##") + " KMH</span>" +
                                "<span class='mph-wind" + (measureType == User.Measurement.Imperial ? "" : " hidden") + "' data-toggle='tooltip' data-original-title='" + weather.WindGustMI.ToString("0.##") + " MPH Gusts'>" + weather.WindSpeedMI.ToString("0.##") + " MPH</span>&nbsp;" +
                                "<img src='https://www.kunminglive.com/dist/img/icons/weather/direction.png' alt='Wind Direction: " + weather.WindDirection + " Degrees' style='transform:rotate(" + weather.WindDirection + "deg);' />" +
                            "</div>" +
                            "<div class='" + uvCols + "'>" +
                                "<strong>UV Index:&nbsp;</strong>" + weather.UVIndex +
                            "</div>" +
                        "</div>" +
                    "</div>" +
                "</div>"
            ));

            index++;
        }

        showForecast.ID = this.ID;
        showForecastCarousel.ID = showForecastCarousel.ID + "_" + this.ID;
        showForecastCarouselInner.ID = showForecastCarouselInner.ID + "_" + this.ID;
        showForecastCarouselIndicators.ID = showForecastCarouselIndicators.ID + "_" + this.ID;
    }
</script>

<div id="showForecast" class="table-responsive" runat="server" style="margin-bottom:0!important;">
    <div id="showForecastCarousel" class="forecast-carousel carousel slide" data-ride="carousel" data-interval="false" style="display:none;margin:0 auto;width:100%;height:100%;padding-bottom:20px;" runat="server">
        <ol id="showForecastCarouselIndicators" class="carousel-indicators" style="bottom:0;" runat="server"></ol>
        <div id="showForecastCarouselInner" class="carousel-inner" style="width:100%;height:100%;" runat="server"></div>
        <a class="left carousel-control" data-target="#showForecastCarousel_<%:this.ID%>" href="#" role="button" data-slide="prev" style="width:10%;text-align:left;padding-left:10px;">
            <span class="fa fa-angle-left text-black" aria-hidden="true"></span>
        </a>
        <a class="right carousel-control" data-target="#showForecastCarousel_<%:this.ID%>" href="#" role="button" data-slide="next" style="width:10%;">
            <span class="fa fa-angle-right text-black" aria-hidden="true"></span>
        </a>
    </div>
</div>

<script>
    $(window).on("load", function () {
        $(".show-forecast-hourly").off("click").click(function (e) {
            if ($(this).hasClass("active")) { return; }
            $(this).siblings(".show-forecast-daily").removeClass("active");
            $(this).addClass("active");
            $(this).parent().siblings("small").text("Hourly");
            $(".forecast-table").slideDown(function () {
                $(this).closest(".box").find(".box-body").css("overflow-y", "auto");
            });
            $(".forecast-carousel").slideUp();
            $(this).tooltip("hide");
            e.stopPropagation();
        });
        $(".show-forecast-daily").off("click").click(function (e) {
            if ($(this).hasClass("active")) { return; }
            $(this).siblings(".show-forecast-hourly").removeClass("active");
            $(this).addClass("active");
            $(this).closest(".box").find(".box-body").css("overflow-y", "hidden");
            $(this).parent().siblings("small").text("Daily");
            $(".forecast-carousel").slideDown();
            $(".forecast-table").slideUp();
            $(this).tooltip("hide");
            e.stopPropagation();
        });

        <% if (measureType == User.Measurement.Imperial) { %>
            $(".show-forecast-c").removeClass("active");
            $(".show-forecast-f").addClass("active");
        <% } %>
        $(".show-forecast-c").off("click").click(function (e) {
            if ($(this).hasClass("active")) { return; }
            UpdateMeasurements(0);
            $(".show-forecast-f").removeClass("active");
            $(".show-forecast-c").addClass("active");
            $(".fahrenheit-temp").addClass("hidden");
            $(".celsius-temp").removeClass("hidden");
            $(".mph-wind").addClass("hidden");
            $(".kmh-wind").removeClass("hidden");
            $(this).tooltip("hide");
            e.stopPropagation();
        });
        $(".show-forecast-f").off("click").click(function (e) {
            if ($(this).hasClass("active")) { return; }
            UpdateMeasurements(1);
            $(".show-forecast-c").removeClass("active");
            $(".show-forecast-f").addClass("active");
            $(".celsius-temp").addClass("hidden");
            $(".fahrenheit-temp").removeClass("hidden");
            $(".kmh-wind").addClass("hidden");
            $(".mph-wind").removeClass("hidden");
            $(this).tooltip("hide");
            e.stopPropagation();
        });

        function UpdateMeasurements(measurementType) {
            callBack("master.asmx/UpdateUserMeasurement", { measurement: measurementType }, null, false);
        }
    });
</script>