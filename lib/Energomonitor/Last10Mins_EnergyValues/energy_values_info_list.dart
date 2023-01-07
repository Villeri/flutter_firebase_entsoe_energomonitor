import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
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
  List<_EnergyData> _dataList = [];
  List _dataListWithTimestamp = [];
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
        _dataList.add(_EnergyData(hoursAndMinutes, responseJson[i][1]));
        _dataListWithTimestamp.add("${date}: ${responseJson[i][1]}");
      });
      //print("timestamp: ${responseJson[i][0]} energy: ${responseJson[i][1]}");
    }
  }

  _checkValue() {
    if (_dataList.isNotEmpty) {
      return Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Center(
                child: Column(
                  children: [
                    Text("TIME: ${_dataList[index].timestamp}"),
                    Text("ENERGY VALUE: ${_dataList[index].energyvalue} (Wh)"),
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("View info"),
          content: const Text(
              "The energy value data is fetched from Energomonitor-page. Press the upload-icon to save data to Firebase."),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy Info List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_outlined),
            onPressed: () {
              FirebaseDatabase.instance
                  .ref("EnergomonitorUsedEnergyValues")
                  .set({"usedEnergyValues": _dataListWithTimestamp});
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _dialogBuilder(context),
          ),
        ],
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
