<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeFile="weather.aspx.cs" Inherits="weather" %>
<%@ Register TagPrefix="kl" TagName="Forecast" Src="~/controls/Forecast.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" Runat="Server">
    <section class="content-header">
        <h1>
            <div class="box box-success">
                <div class="box-body">
                    Kunming Weather
                    <small>Trends</small>
                </div>
            </div>
        </h1>
        <ol class="breadcrumb">
            <li><a href="controltower.aspx"><i class="fa fa-dashboard"></i>Control Tower</a></li>
            <li class="active">Weather Trends</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Forecast
                        </h3>
                        <small>Hourly</small>
                        <div class="pull-right box-tools">
                            <button type="button" class="btn btn-sm btn-default show-forecast-hourly active" data-toggle="tooltip" data-original-title="Hourly Forecast">Hour</button>
                            <button type="button" class="btn btn-sm btn-default show-forecast-daily" data-toggle="tooltip" data-original-title="Daily Forecast">Day</button>
                            <button type="button" class="btn btn-sm btn-default show-forecast-c active" data-toggle="tooltip" data-original-title="Metric">C&deg;</button>
                            <button type="button" class="btn btn-sm btn-default show-forecast-f" data-toggle="tooltip" data-original-title="Imperial">F&deg;</button>
                        </div>
                    </div>
                    <div class="box-body no-padding" style="height:200px;overflow-y:auto;">
                        <kl:Forecast ID="weatherForecast" runat="server" />
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Temperature
                        </h3>
                        <small>Average</small>
                        <div class="pull-right box-tools">
                            <button id="btnShowTempC" type="button" class="btn btn-sm btn-default active" data-toggle="tooltip" data-original-title="Celsius">C&deg;</button>
                            <button id="btnShowTempF" type="button" class="btn btn-sm btn-default" data-toggle="tooltip" data-original-title="Fahrenheit">F&deg;</button>
                        </div>
                    </div>
                    <div class="box-body no-padding" style="height:200px;">
                        <canvas id="averageTemperature"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Rainfall
                        </h3>
                        <small>Average</small>
                        <div class="pull-right box-tools">
                            <button id="btnShowRainMM" type="button" class="btn btn-sm btn-default active" data-toggle="tooltip" data-original-title="Millimeters">mm</button>
                            <button id="btnShowRainIN" type="button" class="btn btn-sm btn-default" data-toggle="tooltip" data-original-title="Inches">in</button>
                        </div>
                    </div>
                    <div class="box-body no-padding" style="height:200px;">
                        <canvas id="averageRainfall"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Comfort
                        </h3>
                        <small>Average</small>
                    </div>
                    <div class="box-body no-padding" style="height:200px;">
                        <canvas id="averageFeel"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Sunshine
                        </h3>
                        <small>Average</small>
                    </div>
                    <div class="box-body no-padding" style="height:200px;">
                        <canvas id="averageSun"></canvas>
                    </div>
                    <div class="box-footer no-padding">
                        <div class="col-xs-12">
                            <div class="uv_index_color">
                                <div class="col-xs-12">
                                    <strong>UV Index</strong>
                                </div>
                                <div class="inner">
                                    <div class="uv_index_1 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_1"></div>
                                        </div>
                                        <div class="count">1</div>
                                    </div>
                                    <div class="uv_index_2 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_2"></div>
                                        </div>
                                        <div class="count">2</div>
                                    </div>
                                    <div class="uv_index_3 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_3"></div>
                                        </div>
                                        <div class="count">3</div>
                                    </div>
                                    <div class="uv_index_4 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_4"></div>
                                        </div>
                                        <div class="count">4</div>
                                    </div>
                                    <div class="uv_index_5 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_5"></div>
                                        </div>
                                        <div class="count">5</div>
                                    </div>
                                    <div class="uv_index_6 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_6"></div>
                                        </div>
                                        <div class="count">6</div>
                                    </div>
                                    <div class="uv_index_7 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_7"></div>
                                        </div>
                                        <div class="count">7</div>
                                    </div>
                                    <div class="uv_index_8 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_8"></div>
                                        </div>
                                        <div class="count">8</div>
                                    </div>
                                    <div class="uv_index_9 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_9"></div>
                                        </div>
                                        <div class="count">9</div>
                                    </div>
                                    <div class="uv_index_10 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_10"></div>
                                        </div>
                                        <div class="count">10</div>
                                    </div>
                                    <div class="uv_index_11 color_item">
                                        <div class="uv_color_wrap">
                                            <div class="uv_color uv_color_11"></div>
                                        </div>
                                        <div class="count">11+</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-4 col-md-6 col-xs-12">
                <div class="box box-success">
                    <div class="box-header">
                        <h3 class="box-title">
                            Wind/Air
                        </h3>
                        <small>Average</small>
                        <div class="pull-right box-tools">
                            <button id="btnShowAirKMH" type="button" class="btn btn-sm btn-default active" data-toggle="tooltip" data-original-title="Kilometers per Hour">KMH</button>
                            <button id="btnShowAirMPH" type="button" class="btn btn-sm btn-default" data-toggle="tooltip" data-original-title="Miles per Hour">MPH</button>
                        </div>
                    </div>
                    <div class="box-body no-padding" style="height:200px;">
                        <canvas id="averageAir"></canvas>
                    </div>
                    <div class="box-footer no-padding">
                        <div class="col-xs-12 text-center no-padding"><strong>AQI Pollution Index</strong></div>
                        <div class="col-xs-4 text-center no-padding label-success">Excellent 0-50</div>
                        <div class="col-xs-4 text-center no-padding label-info">Good 51-100</div>
                        <div class="col-xs-4 text-center no-padding label-primary">Light 101-150</div>
                        <div class="col-xs-4 text-center no-padding label-default">Medium 151-200</div>
                        <div class="col-xs-4 text-center no-padding label-warning">Heavy 201-250</div>
                        <div class="col-xs-4 text-center no-padding label-danger">Severe >250</div>
                    </div>
                </div>
            </div>

        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" Runat="Server">
    <script src="bower_components/chart.js/Chart.min.js"></script>
    <script src="dist/js/weather.js"></script>
</asp:Content>

