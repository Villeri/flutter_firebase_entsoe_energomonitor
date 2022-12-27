import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//https://api.energomonitor.com/v1/feeds/emphhy/streams/emphig/data?limit=10

class EnergyValuesInfoList extends StatefulWidget {
  EnergyValuesInfoList({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<EnergyValuesInfoList> createState() => _EnergyValuesInfoListState();
}

class _EnergyValuesInfoListState extends State<EnergyValuesInfoList> {
  List<_EnergyData> dataList = [];
  String date = "";

  @override
  void initState() {
    super.initState();
    getData();
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
        dataList.add(_EnergyData(hoursAndMinutes, responseJson[i][1]));
      });
      //print("timestamp: ${responseJson[i][0]} energy: ${responseJson[i][1]}");
    }
  }

  _checkValue() {
    if (dataList.isNotEmpty) {
      return Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Center(
                child: Column(
                  children: [
                    Text("TIME: ${dataList[index].timestamp}"),
                    Text("ENERGY VALUE: ${dataList[index].energyvalue} (Wh)"),
                  ],
                ),
              ),
            );
          },
        ),
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
        title: const Text("Energy Info List"),
      ),
      body: _checkValue(),
    );
  }
}

class _EnergyData {
  _EnergyData(this.timestamp, this.energyvalue);

  final String timestamp;
  final int energyvalue;
}
