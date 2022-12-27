import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EnergyPricesInfoCharts extends StatefulWidget {
  EnergyPricesInfoCharts({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<EnergyPricesInfoCharts> createState() => _EnergyPricesInfoChartsState();
}

class _EnergyPricesInfoChartsState extends State<EnergyPricesInfoCharts> {
  List<EnergyData> _dataList = [];
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
          "https://api.energomonitor.com/v1/feeds/emphhy/streams/emphif/data?limit=10"),
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
        _dataList.add(EnergyData(hoursAndMinutes, responseJson[i][1]));
      });
    }
  }

  _checkValue() {
    if (_dataList.isNotEmpty) {
      return Column(
        children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: "Price info"),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<EnergyData, String>>[
              LineSeries<EnergyData, String>(
                dataSource: _dataList,
                xValueMapper: (EnergyData energy, _) =>
                    energy.timestamp.toString(),
                yValueMapper: (EnergyData energy, _) => energy.pricevalue,
                name: "Price (€)",
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
        title: const Text("Energy prices info charts"),
      ),
      body: _checkValue(),
    );
  }
}

class EnergyData {
  EnergyData(this.timestamp, this.pricevalue);

  final String timestamp;
  final double pricevalue;
}
