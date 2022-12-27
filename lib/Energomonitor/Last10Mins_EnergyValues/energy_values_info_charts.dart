import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class EnergyValuesInfoCharts extends StatefulWidget {
  EnergyValuesInfoCharts({
    super.key,
    required this.accessToken,
  });

  String accessToken;

  @override
  State<EnergyValuesInfoCharts> createState() => _EnergyValuesInfoChartsState();
}

class _EnergyValuesInfoChartsState extends State<EnergyValuesInfoCharts> {
  List<EnergyData> dataList = [];
  String date = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    String token = widget.accessToken;
    final response = await http.get(
      Uri.parse(
          "https://api.energomonitor.com/v1/feeds/emphhy/streams/emphig/data?limit=10"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final responseJson = jsonDecode(response.body);
    for (var i = 0; i < responseJson.length; i++) {
      setState(() {
        date = DateTime.fromMillisecondsSinceEpoch(responseJson[i][0] * 1000)
            .toString();
        final splittedDate = date.split(" ");
        final time = splittedDate[1];
        final hoursAndMinutes =
            "${time[0]}${time[1]}${time[2]}${time[3]}${time[4]}";
        dataList.add(EnergyData(hoursAndMinutes, responseJson[i][1]));
      });
      //print("timestamp: ${responseJson[i][0]} energy: ${responseJson[i][1]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy info charts"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartesianChart(
                              dataList: dataList,
                            )));
              },
              child: const Text("Cartesian chart"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SparkLineChart(
                              dataList: dataList,
                            )));
              },
              child: const Text("SparkLine chart"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SparkBarChart(
                              dataList: dataList,
                            )));
              },
              child: const Text("SparkBar chart"),
            ),
          ],
        ),
      ),
    );
  }
}

//****************************************************************************** CARTESIAN CHART ******************************************************************************
class CartesianChart extends StatefulWidget {
  const CartesianChart({
    Key? key,
    required this.dataList,
  }) : super(key: key);

  final List<EnergyData> dataList;

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  _checkValue() {
    if (widget.dataList.isNotEmpty) {
      return Column(
        children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: "Energy info"),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<EnergyData, String>>[
              LineSeries<EnergyData, String>(
                dataSource: widget.dataList,
                xValueMapper: (EnergyData energy, _) =>
                    energy.timestamp.toString(),
                yValueMapper: (EnergyData energy, _) => energy.energyvalue,
                name: "Spent energy (Wh)",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartesian chart"),
      ),
      body: _checkValue(),
    );
  }
}

//****************************************************************************** SPARK LINE CHART ******************************************************************************
class SparkLineChart extends StatefulWidget {
  const SparkLineChart({
    Key? key,
    required this.dataList,
  }) : super(key: key);

  final List<EnergyData> dataList;

  @override
  State<SparkLineChart> createState() => _SparkLineChartState();
}

class _SparkLineChartState extends State<SparkLineChart> {
  _checkValue() {
    if (widget.dataList.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SfSparkLineChart.custom(
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                marker: const SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all,
                ),
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => widget.dataList[index].timestamp,
                yValueMapper: (int index) => widget.dataList[index].energyvalue,
                dataCount: 10,
              ),
            ),
          )
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SparkLine chart"),
      ),
      body: _checkValue(),
    );
  }
}

//****************************************************************************** SPARK BAR CHART ******************************************************************************
class SparkBarChart extends StatefulWidget {
  const SparkBarChart({Key? key, required this.dataList}) : super(key: key);

  final List<EnergyData> dataList;

  @override
  State<SparkBarChart> createState() => _SparkBarChartState();
}

class _SparkBarChartState extends State<SparkBarChart> {
  _checkValue() {
    if (widget.dataList.isNotEmpty) {
      return Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SfSparkBarChart.custom(
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => widget.dataList[index].timestamp,
                yValueMapper: (int index) => widget.dataList[index].energyvalue,
                dataCount: 10,
              ),
            ),
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SparkBar chart"),
      ),
      body: _checkValue(),
    );
  }
}

class EnergyData {
  EnergyData(this.timestamp, this.energyvalue);

  final String timestamp;
  final int energyvalue;
}
