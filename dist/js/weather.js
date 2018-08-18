var monthLabels = moment.months();

var avgTemp = {
    C: {
        Low: [2, 3, 6, 11, 15, 17, 17, 16, 15, 12, 7, 3],
        Mid: [8, 10, 13, 16, 19, 20, 20, 20, 18, 16, 12, 8],
        High: [14, 16, 19, 22, 23, 23, 23, 23, 21, 19, 16, 13]
    },
    F: {
        Low: [36, 37, 43, 52, 59, 63, 63, 61, 59, 53, 44, 37],
        Mid: [46, 50, 55, 61, 66, 68, 68, 68, 64, 61, 54, 46],
        High: [57, 61, 66, 72, 73, 73, 73, 73, 70, 66, 61, 55]
    }
};
var avgTempChart = new Chart("averageTemperature", {
    type: "line",
    data: {
        labels: monthLabels,
        datasets: [
            {
            label: "Low (C)",
            data: avgTemp.C.Low,
            backgroundColor: "rgb(90,214,245)",
            borderColor: "rgb(90,214,245)",
            pointBackgroundColor: "rgb(90,214,245)",
            pointBorderColor: "rgb(90,214,245)",
            pointHoverBorderColor: "rgb(90,214,245)",
            pointRadius: 5,
            pointHitRadius: 15
        },{
            label: "Avg (C)",
            data: avgTemp.C.Mid,
            backgroundColor: "rgb(247,191,102)",
            borderColor: "rgb(247,191,102)",
            pointBackgroundColor: "rgb(247,191,102)",
            pointBorderColor: "rgb(247,191,102)",
            pointHoverBorderColor: "rgb(247,191,102)",
            pointRadius: 5,
            pointHitRadius: 15
        },{
            label: "High (C)",
            data: avgTemp.C.High,
            backgroundColor: "rgb(233,139,127)",
            borderColor: "rgb(233,139,127)",
            pointBackgroundColor: "rgb(233,139,127)",
            pointBorderColor: "rgb(233,139,127)",
            pointHoverBorderColor: "rgb(233,139,127)",
            pointRadius: 5,
            pointHitRadius: 15
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
            labels: {
                boxWidth: 12
            }
        },
        tooltips: {
            mode: 'index'
        }
    }
});

$("#btnShowTempC").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowTempF").removeClass("active");
    $(this).addClass("active");
    avgTempChart.data.datasets[0].label = "Low (F)";
    avgTempChart.data.datasets[0].data = avgTemp.C.Low;
    avgTempChart.data.datasets[1].label = "Avg (F)";
    avgTempChart.data.datasets[1].data = avgTemp.C.Mid;
    avgTempChart.data.datasets[2].label = "High (F)";
    avgTempChart.data.datasets[2].data = avgTemp.C.High;
    avgTempChart.update();
});

$("#btnShowTempF").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowTempC").removeClass("active");
    $(this).addClass("active");
    avgTempChart.data.datasets[0].label = "Low (F)";
    avgTempChart.data.datasets[0].data = avgTemp.F.Low;
    avgTempChart.data.datasets[1].label = "Avg (F)";
    avgTempChart.data.datasets[1].data = avgTemp.F.Mid;
    avgTempChart.data.datasets[2].label = "High (F)";
    avgTempChart.data.datasets[2].data = avgTemp.F.High;
    avgTempChart.update();
});

var avgRain = {
    mm: [16, 16, 20, 24, 97, 181, 202, 204, 119, 79, 42, 12],
    in: [0.63, 0.63, 0.78, 0.94, 3.82, 7.13, 7.95, 8.03, 4.69, 3.11, 1.65, 0.47],
    Days: [4, 5, 6, 7, 12, 17, 21, 19, 16, 13, 7, 4]
};
var avgRainChart = new Chart("averageRainfall", {
    type: "bar",
    data: {
        labels: monthLabels,
        datasets: [
            {
                label: "Rainfall (mm)",
                data: avgRain.mm,
                backgroundColor: "rgb(90,214,245)",
                borderColor: "rgb(90,214,245)",
                yAxisID: "top-y-axis"
            }, {
                type: "line",
                label: "Rainy Days",
                data: avgRain.Days,
                backgroundColor: "rgb(233,139,127)",
                borderColor: "rgb(233,139,127)",
                pointBackgroundColor: "rgb(233,139,127)",
                pointHoverBackgroundColor: "rgb(233,139,127)",
                pointBorderColor: "rgb(233,139,127)",
                pointHoverBorderColor: "rgb(233,139,127)",
                yAxisID: "bottom-y-axis"
            }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        tooltips: {
            mode: 'index'
        },
        legend: {
            labels: {
                boxWidth: 12
            }
        },
        scales: {
            yAxes: [{
                id: "top-y-axis",
                position: "left",
                type: "linear",
                gridLines: {
                    display: false
                }
            }, {
                id: "bottom-y-axis",
                position: "right",
                type: "linear"
            }]
        }
    }
});

$("#btnShowRainMM").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowRainIN").removeClass("active");
    $(this).addClass("active");
    avgRainChart.data.datasets[0].label = "Rainfall (mm)";
    avgRainChart.data.datasets[0].data = avgRain.mm;
    avgRainChart.update();
});
$("#btnShowRainIN").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowRainMM").removeClass("active");
    $(this).addClass("active");
    avgRainChart.data.datasets[0].label = "Rainfall (in)";
    avgRainChart.data.datasets[0].data = avgRain.in;
    avgRainChart.update();
});

var avgFeel = {
    Humidity: [82, 69, 62, 70, 64, 76, 82, 72, 74, 75, 72, 71],
    Clouds: [41, 25, 29, 58, 16, 49, 53, 33, 39, 40, 40, 35]
};
var avgFeelChart = new Chart("averageFeel", {
    type: "bar",
    data: {
        labels: monthLabels,
        datasets: [
            {
                label: "Humidity (%)",
                data: avgFeel.Humidity,
                backgroundColor: "rgb(247,191,102)",
                borderColor: "rgb(247,191,102)"
            }, {
                type: "line",
                label: "Clouds (%)",
                data: avgFeel.Clouds,
                backgroundColor: "rgb(90,214,245)",
                borderColor: "rgb(90,214,245)",
                pointBackgroundColor: "rgb(90,214,245)",
                pointHoverBackgroundColor: "rgb(90,214,245)",
                pointBorderColor: "rgb(90,214,245)",
                pointHoverBorderColor: "rgb(90,214,245)"
            }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        tooltips: {
            mode: 'index'
        },
        legend: {
            labels: {
                boxWidth: 12
            }
        },
        scales: {
            yAxes: [{
                position: "left",
                type: "linear",
                gridLines: {
                    display: false
                },
                ticks: {
                    max: 100,
                    min: 0,
                    stepSize: 20
                }
            }]
        }
    }
});

var avgSun = {
    Hrs: [190.5, 231.5, 252.5, 173.5, 363.5, 266.5, 243, 355.5, 309.5, 186, 155.5, 169.5],
    Days: [16, 12, 11, 12, 11, 2, 0, 0, 8, 16, 12, 14],
    UV: [3, 4, 2, 5, 6, 4, 6, 6, 6, 5, 4, 3]
}
var avgSunChart = new Chart("averageSun", {
    type: "bar",
    data: {
        labels: monthLabels,
        datasets: [
            {
                type: "line",
                label: "UV Index",
                data: avgSun.UV,
                fill: false,
                backgroundColor: "rgb(152,150,199)",
                borderColor: "rgb(152,150,199)",
                pointBackgroundColor: "rgb(152,150,199)",
                pointHoverBackgroundColor: "rgb(152,150,199)",
                pointBorderColor: "rgb(152,150,199)",
                pointHoverBorderColor: "rgb(152,150,199)",
                yAxisID: "right-uv-axis"
            }, {
                label: "Hours",
                data: avgSun.Hrs,
                backgroundColor: "rgb(233,139,127)",
                borderColor: "rgb(233,139,127)",
                yAxisID: "left-hours-axis"
            }, {
                type: "line",
                label: "Days",
                data: avgSun.Days,
                backgroundColor: "rgb(247,191,102)",
                borderColor: "rgb(247,191,102)",
                pointBackgroundColor: "rgb(247,191,102)",
                pointHoverBackgroundColor: "rgb(247,191,102)",
                pointBorderColor: "rgb(247,191,102)",
                pointHoverBorderColor: "rgb(247,191,102)",
                yAxisID: "right-days-axis"
            }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        tooltips: {
            mode: 'index'
        },
        legend: {
            labels: {
                boxWidth: 12
            }
        },
        scales: {
            yAxes: [{
                id: "left-hours-axis",
                position: "left",
                type: "linear",
                gridLines: {
                    display: false
                }
            }, {
                id: "right-days-axis",
                position: "right",
                type: "linear",
                ticks: {
                    max: 30,
                    min: 0,
                    step: 5
                }
            }, {
                id: "right-uv-axis",
                position: "right",
                type: "linear",
                gridLines: {
                    display: false
                },
                ticks: {
                    max: 11,
                    min: 1
                }
            }]
        }
    }
});

var avgWind = {
    MPH: {
        Max: [7.6, 10.1, 13, 15.9, 13.2, 11.4, 5.6, 7.8, 7.4, 6.7, 8.3, 7.6],
        Gust: [6.5, 8.3, 9.8, 12.1, 10.3, 9.4, 4.7, 6.3, 6.3, 5.8, 6.7, 6.3],
        Avg: [4.3, 5.4, 7.2, 11, 9.2, 8.3, 3.4, 4.7, 4.5, 4.5, 4.9, 4.7]
    },
    KMH: {
        Max: [12.2, 16.3, 20.9, 25.6, 21.2, 18.3, 9, 12.6, 11.9, 10.8, 13.4, 12.2],
        Gust: [10.5, 13.4, 15.8, 19.5, 16.6, 15.1, 7.6, 10.1, 10.1, 9.3, 10.8, 10.1],
        Avg: [6.9, 8.7, 11.6, 17.7, 14.8, 13.4, 5.5, 7.6, 7.2, 7.2, 7.9, 7.6]
    },
    AQI: [54, 62, 65, 58, 58, 40, 39, 38, 40, 40, 59, 66]
};
var avgAirChart = new Chart("averageAir", {
    type: "line",
    data: {
        labels: monthLabels,
        datasets: [
            {
                label: "AQI",
                data: avgWind.AQI,
                fill: false,
                backgroundColor: "rgb(152,150,199)",
                borderColor: "rgb(152,150,199)",
                pointBackgroundColor: "rgb(152,150,199)",
                pointHoverBackgroundColor: "rgb(152,150,199)",
                pointBorderColor: "rgb(152,150,199)",
                pointHoverBorderColor: "rgb(152,150,199)",
                pointRadius: 5,
                pointHitRadius: 15,
                yAxisID: "right-aqi-axis"
            }, {
                label: "Avg (KMH)",
                data: avgWind.KMH.Avg,
                backgroundColor: "rgb(90,214,245)",
                borderColor: "rgb(90,214,245)",
                pointBackgroundColor: "rgb(90,214,245)",
                pointHoverBackgroundColor: "rgb(90,214,245)",
                pointBorderColor: "rgb(90,214,245)",
                pointHoverBorderColor: "rgb(90,214,245)",
                pointRadius: 5,
                pointHitRadius: 15,
                yAxisID: "left-wind-axis"
            }, {
                label: "Gust (KMH)",
                data: avgWind.KMH.Gust,
                backgroundColor: "rgb(247,191,102)",
                borderColor: "rgb(247,191,102)",
                pointBackgroundColor: "rgb(247,191,102)",
                pointHoverBackgroundColor: "rgb(247,191,102)",
                pointBorderColor: "rgb(247,191,102)",
                pointHoverBorderColor: "rgb(247,191,102)",
                pointRadius: 5,
                pointHitRadius: 15,
                yAxisID: "left-wind-axis"
            }, {
                label: "Max (KMH)",
                data: avgWind.KMH.Max,
                backgroundColor: "rgb(233,139,127)",
                borderColor: "rgb(233,139,127)",
                pointBackgroundColor: "rgb(233,139,127)",
                pointHoverBackgroundColor: "rgb(233,139,127)",
                pointBorderColor: "rgb(233,139,127)",
                pointHoverBorderColor: "rgb(233,139,127)",
                pointRadius: 5,
                pointHitRadius: 15,
                yAxisID: "left-wind-axis"
            }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        tooltips: {
            mode: 'index'
        },
        legend: {
            labels: {
                boxWidth: 12
            }
        },
        scales: {
            yAxes: [{
                id: "left-wind-axis",
                position: "left",
                type: "linear",
                gridLines: {
                    display: false
                }
            }, {
                id: "right-aqi-axis",
                position: "right",
                type: "linear",
                ticks: {
                    max: 250,
                    min: 0,
                    step: 50
                }
            }]
        }
    }
});

$("#btnShowAirKMH").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowAirMPH").removeClass("active");
    $(this).addClass("active");
    avgAirChart.data.datasets[1].label = "Avg (KMH)";
    avgAirChart.data.datasets[1].data = avgWind.KMH.Avg;
    avgAirChart.data.datasets[2].label = "Gust (KMH)";
    avgAirChart.data.datasets[2].data = avgWind.KMH.Gust;
    avgAirChart.data.datasets[3].label = "Max (KMH)";
    avgAirChart.data.datasets[3].data = avgWind.KMH.Max;
    avgAirChart.update();
});
$("#btnShowAirMPH").click(function () {
    if ($(this).hasClass("active")) { return; }
    $("#btnShowAirKMH").removeClass("active");
    $(this).addClass("active");
    avgAirChart.data.datasets[1].label = "Avg (MPH)";
    avgAirChart.data.datasets[1].data = avgWind.MPH.Avg;
    avgAirChart.data.datasets[2].label = "Gust (MPH)";
    avgAirChart.data.datasets[2].data = avgWind.MPH.Gust;
    avgAirChart.data.datasets[3].label = "Max (MPH)";
    avgAirChart.data.datasets[3].data = avgWind.MPH.Max;
    avgAirChart.update();
});