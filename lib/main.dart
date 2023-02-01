import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_energyprices/userinfo.dart';
import "package:http/http.dart" as http;
import 'package:syncfusion_flutter_charts/charts.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

enum FuturePricesSettingsOptions { optionOne, optionTwo }

enum SpentEnergyHistorySettingsOptions { optionOne, optionTwo }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sähkönkulutus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SampleItem? selectedMenu;
  FuturePricesSettingsOptions? selectedFuturePricesOption =
      FuturePricesSettingsOptions.optionOne;
  String accessToken = "xvJzxavnABRYj15L2h910TurGK2WDr";
  List<CurrentEnergyValuesData> currentEnergyValuesList = [];
  String date = "";
  bool show_list = false;
  String title = "";
  bool futurePricesEditingViewOpened = false;
  final futurePricesSettingsOneDifferentDateController =
      TextEditingController();
  final futurePricesSettingsTwoDifferentDatesController1 =
      TextEditingController();
  final futurePricesSettingsTwoDifferentDatesController2 =
      TextEditingController();
  String futurePricesSettingsOneDifferentDate = "";
  String futurePricesDateOneDifferentDate = "";
  String futurePricesSettingsTwoDifferentDates1 = "";
  String futurePricesDateTwoDifferentDates1 = "";
  String futurePricesSettingsTwoDifferentDates2 = "";
  String futurePricesDateTwoDifferentDates2 = "";
  bool spentEnergyHistoryEditingViewOpened = false;
  SpentEnergyHistorySettingsOptions? selectedSpentEnergyHistorySettingsOption =
      SpentEnergyHistorySettingsOptions.optionOne;
  final spentEnergyHistorySettingsOneDifferentDateController =
      TextEditingController();
  String spentEnergyHistorySettingsOneDifferentDate = "";
  String spentEnergyHistoryOneDifferentDate = "";
  final spentEnergyHistorySettingsTwoDifferentDatesController1 =
      TextEditingController();
  final spentEnergyHistorySettingsTwoDifferentDatesController2 =
      TextEditingController();
  String spentEnergyHistorySettingsTwoDifferentDates1 = "";
  String spentEnergyHistoryDateTwoDifferentDates1 = "";
  String spentEnergyHistorySettingsTwoDifferentDates2 = "";
  String spentEnergyHistoryDateTwoDifferentDates2 = "";

  @override
  void initState() {
    super.initState();
    getCurrentEnergyValues();
  }

  @override
  void dispose() {
    futurePricesSettingsOneDifferentDateController.dispose();
    futurePricesSettingsTwoDifferentDatesController1.dispose();
    futurePricesSettingsTwoDifferentDatesController2.dispose();
    spentEnergyHistorySettingsOneDifferentDateController.dispose();
    spentEnergyHistorySettingsTwoDifferentDatesController1.dispose();
    spentEnergyHistorySettingsTwoDifferentDatesController2.dispose();
    super.dispose();
  }

  Widget energomonitorListItem({required Map dataItem}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${dataItem["value"]} kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            dataItem["time"],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Pvm: ${dataItem["post_datetime"]}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget energomonitorListItemTwoDates(
      {required Map dataItem1, required Map dataItem2}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${dataItem1["value"]} kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "${dataItem2["value"]} kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            dataItem1["time"],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            dataItem2["time"],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Pvm: ${dataItem1["post_datetime"]}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            "Pvm: ${dataItem2["post_datetime"]}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget entsoEListItem({required Map dataItem2}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Päivämäärä: ${dataItem2["date"]}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "00:00: ${dataItem2["00:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "01:00: ${dataItem2["01:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "02:00: ${dataItem2["02:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "03:00: ${dataItem2["03:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "04:00: ${dataItem2["04:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "05:00: ${dataItem2["05:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "06:00: ${dataItem2["06:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "07:00: ${dataItem2["07:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "08:00: ${dataItem2["08:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "09:00: ${dataItem2["09:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "10:00: ${dataItem2["10:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "11:00: ${dataItem2["11:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "12:00: ${dataItem2["12:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "13:00: ${dataItem2["13:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "14:00: ${dataItem2["14:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "15:00: ${dataItem2["15:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "16:00: ${dataItem2["16:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "17:00: ${dataItem2["17:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "18:00: ${dataItem2["18:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "19:00: ${dataItem2["19:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "20:00: ${dataItem2["20:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "21:00: ${dataItem2["21:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "22:00: ${dataItem2["22:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "23:00: ${dataItem2["23:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "24:00: ${dataItem2["24:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget entsoEListItemTwoDates(
      {required Map dataItem3, required Map dataItem4}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Päivämäärä1: ${dataItem3["date"]}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Päivämäärä2: ${dataItem4["date"]}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "00:00: ${dataItem3["00:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "00:00: ${dataItem4["00:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "01:00: ${dataItem3["01:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "01:00: ${dataItem4["01:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "02:00: ${dataItem3["02:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "02:00: ${dataItem4["02:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "03:00: ${dataItem3["03:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "03:00: ${dataItem4["03:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "04:00: ${dataItem3["04:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "04:00: ${dataItem4["04:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "05:00: ${dataItem3["05:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "05:00: ${dataItem4["05:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "06:00: ${dataItem3["06:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "06:00: ${dataItem4["06:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "07:00: ${dataItem3["07:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "07:00: ${dataItem4["07:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "08:00: ${dataItem3["08:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "08:00: ${dataItem4["08:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "09:00: ${dataItem3["09:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "09:00: ${dataItem4["09:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "10:00: ${dataItem3["10:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "10:00: ${dataItem4["10:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "11:00: ${dataItem3["11:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "11:00: ${dataItem4["11:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "12:00: ${dataItem3["12:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "12:00: ${dataItem4["12:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "13:00: ${dataItem3["13:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "13:00: ${dataItem4["13:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "14:00: ${dataItem3["14:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "14:00: ${dataItem4["14:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "15:00: ${dataItem3["15:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "15:00: ${dataItem4["15:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "16:00: ${dataItem3["16:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "16:00: ${dataItem4["16:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "17:00: ${dataItem3["17:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "17:00: ${dataItem4["17:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "18:00: ${dataItem3["18:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "18:00: ${dataItem4["18:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "19:00: ${dataItem3["19:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "19:00: ${dataItem4["19:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "20:00: ${dataItem3["20:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "20:00: ${dataItem4["20:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "21:00: ${dataItem3["21:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "21:00: ${dataItem4["21:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "22:00: ${dataItem3["22:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "22:00: ${dataItem4["22:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "23:00: ${dataItem3["23:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "23:00: ${dataItem4["23:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "24:00: ${dataItem3["24:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Text(
            "24:00: ${dataItem4["24:00"]} € / kWh",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  getCurrentEnergyValues() async {
    final response = await http.get(
      Uri.parse(
          "https://api.energomonitor.com/v1/feeds/emphhy/streams/emphig/data?limit=10"),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
    final responseJson = jsonDecode(response.body);
    for (var i = 0; i < responseJson.length; i++) {
      setState(() {
        date = DateTime.fromMillisecondsSinceEpoch(responseJson[i][0] * 1000)
            .toString();
        final splitDate = date.split(" ");
        final time = splitDate[1];
        final hoursAndMinutes =
            "${time[0]}${time[1]}${time[2]}${time[3]}${time[4]}";
        currentEnergyValuesList
            .add(CurrentEnergyValuesData(hoursAndMinutes, responseJson[i][1]));
      });
    }
  }

  checkCurrentEnergyValuesDropdownValue() {
    if (show_list) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: currentEnergyValuesList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  children: [
                    Text("Aika: ${currentEnergyValuesList[index].timestamp}"),
                    Text(
                        "Kulutus: ${currentEnergyValuesList[index].value} kWh"),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          });
    }
    return const Text("");
  }

  handleFuturePricesSettingsRadioButtons() {
    if (selectedFuturePricesOption == FuturePricesSettingsOptions.optionOne) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: futurePricesSettingsOneDifferentDateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    futurePricesSettingsOneDifferentDateController.clear();
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futurePricesSettingsOneDifferentDate =
                      futurePricesSettingsOneDifferentDateController.text;
                });
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (selectedFuturePricesOption ==
        FuturePricesSettingsOptions.optionTwo) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: futurePricesSettingsTwoDifferentDatesController1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    futurePricesSettingsTwoDifferentDatesController1.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: futurePricesSettingsTwoDifferentDatesController2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    futurePricesSettingsTwoDifferentDatesController2.clear();
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futurePricesSettingsTwoDifferentDates1 =
                      futurePricesSettingsTwoDifferentDatesController1.text;
                  futurePricesSettingsTwoDifferentDates2 =
                      futurePricesSettingsTwoDifferentDatesController2.text;
                });
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  editFuturePricesSettings() {
    if (futurePricesEditingViewOpened) {
      return Column(
        children: [
          ListTile(
            title: const Text("Valitse muu päivämäärä"),
            leading: Radio<FuturePricesSettingsOptions>(
              value: FuturePricesSettingsOptions.optionOne,
              groupValue: selectedFuturePricesOption,
              onChanged: (FuturePricesSettingsOptions? value) {
                setState(() {
                  selectedFuturePricesOption = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text("Vertaile kahta päivämäärää"),
            leading: Radio<FuturePricesSettingsOptions>(
              value: FuturePricesSettingsOptions.optionTwo,
              groupValue: selectedFuturePricesOption,
              onChanged: (FuturePricesSettingsOptions? value) {
                setState(() {
                  selectedFuturePricesOption = value;
                });
              },
            ),
          ),
          handleFuturePricesSettingsRadioButtons(),
        ],
      );
    }
    return const Text("");
  }

  handleHistoryListChange() {
    Query dbRef = FirebaseDatabase.instance.ref().child("Entso-E_Prices");
    if (futurePricesSettingsOneDifferentDate == "" &&
        futurePricesEditingViewOpened == false) {
      return FirebaseAnimatedList(
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem2 = snapshot.value as Map;
          dataItem2["key"] = snapshot.key;
          return entsoEListItem(dataItem2: dataItem2);
        },
      );
    } else if (futurePricesSettingsOneDifferentDate != "") {
      setState(() {
        futurePricesDateOneDifferentDate =
            "${futurePricesSettingsOneDifferentDate[6]}${futurePricesSettingsOneDifferentDate[7]}${futurePricesSettingsOneDifferentDate[8]}${futurePricesSettingsOneDifferentDate[9]}-${futurePricesSettingsOneDifferentDate[3]}${futurePricesSettingsOneDifferentDate[4]}-${futurePricesSettingsOneDifferentDate[0]}${futurePricesSettingsOneDifferentDate[1]}";
      });
      return FirebaseAnimatedList(
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem2 = snapshot.value as Map;
          dataItem2["key"] = snapshot.key;
          if (dataItem2["date"] == futurePricesDateOneDifferentDate) {
            return entsoEListItem(dataItem2: dataItem2);
          } else {
            return const Text("");
          }
        },
      );
    } else if (futurePricesSettingsTwoDifferentDates1 != "" &&
        futurePricesSettingsTwoDifferentDates2 != "") {
      setState(() {
        futurePricesDateTwoDifferentDates1 =
            "${futurePricesSettingsTwoDifferentDates1[6]}${futurePricesSettingsTwoDifferentDates1[7]}${futurePricesSettingsTwoDifferentDates1[8]}${futurePricesSettingsTwoDifferentDates1[9]}-${futurePricesSettingsTwoDifferentDates1[3]}${futurePricesSettingsTwoDifferentDates1[4]}-${futurePricesSettingsTwoDifferentDates1[0]}${futurePricesSettingsTwoDifferentDates1[1]}";
        futurePricesDateTwoDifferentDates2 =
            "${futurePricesSettingsTwoDifferentDates2[6]}${futurePricesSettingsTwoDifferentDates2[7]}${futurePricesSettingsTwoDifferentDates2[8]}${futurePricesSettingsTwoDifferentDates2[9]}-${futurePricesSettingsTwoDifferentDates2[3]}${futurePricesSettingsTwoDifferentDates2[4]}-${futurePricesSettingsTwoDifferentDates2[0]}${futurePricesSettingsTwoDifferentDates2[1]}";
      });
      return FirebaseAnimatedList(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem3 = snapshot.value as Map;
          Map dataItem4 = snapshot.value as Map;
          dataItem3["key"] = snapshot.key;
          dataItem4["key"] = snapshot.key;
          if (dataItem3["date"] == futurePricesDateTwoDifferentDates1 ||
              dataItem4["date"] == futurePricesDateTwoDifferentDates2) {
            return Column(
              children: [
                entsoEListItemTwoDates(
                  dataItem3: dataItem3,
                  dataItem4: dataItem4,
                ),
                //Text(dataItem3["date"]),
                //Text(dataItem4["date"]),
              ],
            );
          } else {
            return const Text("");
          }
        },
      );
    } else {
      return const Text("");
    }
  }

  handleSpentEnergyHistorySettingsRadioButtons() {
    if (selectedSpentEnergyHistorySettingsOption ==
        SpentEnergyHistorySettingsOptions.optionOne) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: spentEnergyHistorySettingsOneDifferentDateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    spentEnergyHistorySettingsOneDifferentDateController
                        .clear();
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  spentEnergyHistorySettingsOneDifferentDate =
                      spentEnergyHistorySettingsOneDifferentDateController.text;
                });
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (selectedSpentEnergyHistorySettingsOption ==
        SpentEnergyHistorySettingsOptions.optionTwo) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller:
                  spentEnergyHistorySettingsTwoDifferentDatesController1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    spentEnergyHistorySettingsTwoDifferentDatesController1
                        .clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller:
                  spentEnergyHistorySettingsTwoDifferentDatesController2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Syötä päivämäärä (dd.mm.yyyy)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    spentEnergyHistorySettingsTwoDifferentDatesController2
                        .clear();
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  spentEnergyHistorySettingsTwoDifferentDates1 =
                      spentEnergyHistorySettingsTwoDifferentDatesController1
                          .text;
                  spentEnergyHistorySettingsTwoDifferentDates2 =
                      spentEnergyHistorySettingsTwoDifferentDatesController2
                          .text;
                });
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  editSpentEnergyHistorySettings() {
    if (spentEnergyHistoryEditingViewOpened) {
      return Column(
        children: [
          ListTile(
            title: const Text("Valitse päivämäärä"),
            leading: Radio<SpentEnergyHistorySettingsOptions>(
              value: SpentEnergyHistorySettingsOptions.optionOne,
              groupValue: selectedSpentEnergyHistorySettingsOption,
              onChanged: (SpentEnergyHistorySettingsOptions? value) {
                setState(() {
                  selectedSpentEnergyHistorySettingsOption = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text("Vertaile kahta päivämäärää"),
            leading: Radio<SpentEnergyHistorySettingsOptions>(
              value: SpentEnergyHistorySettingsOptions.optionTwo,
              groupValue: selectedSpentEnergyHistorySettingsOption,
              onChanged: (SpentEnergyHistorySettingsOptions? value) {
                setState(() {
                  selectedSpentEnergyHistorySettingsOption = value;
                });
              },
            ),
          ),
          handleSpentEnergyHistorySettingsRadioButtons(),
        ],
      );
    } else {
      return const Text("");
    }
  }

  handleSpentEnergyListChange() {
    Query dbRef = FirebaseDatabase.instance
        .ref()
        .child("Energomonitor_Spent_Energy_Values");
    if (spentEnergyHistorySettingsOneDifferentDate == "" &&
        spentEnergyHistoryEditingViewOpened == false) {
      return FirebaseAnimatedList(
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem = snapshot.value as Map;
          dataItem["key"] = snapshot.key;
          return energomonitorListItem(dataItem: dataItem);
        },
      );
    } else if (spentEnergyHistorySettingsOneDifferentDate != "") {
      setState(() {
        spentEnergyHistoryOneDifferentDate =
            "${spentEnergyHistorySettingsOneDifferentDate[6]}${spentEnergyHistorySettingsOneDifferentDate[7]}${spentEnergyHistorySettingsOneDifferentDate[8]}${spentEnergyHistorySettingsOneDifferentDate[9]}-${spentEnergyHistorySettingsOneDifferentDate[3]}${spentEnergyHistorySettingsOneDifferentDate[4]}-${spentEnergyHistorySettingsOneDifferentDate[0]}${spentEnergyHistorySettingsOneDifferentDate[1]}";
      });
      return FirebaseAnimatedList(
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem = snapshot.value as Map;
          dataItem["key"] = snapshot.key;
          if (dataItem["date"] == spentEnergyHistoryOneDifferentDate) {
            return energomonitorListItem(dataItem: dataItem);
          } else {
            return const Text("");
          }
        },
      );
    } else if (spentEnergyHistorySettingsTwoDifferentDates1 != "" &&
        spentEnergyHistorySettingsTwoDifferentDates2 != "") {
      setState(() {
        spentEnergyHistoryDateTwoDifferentDates1 =
            "${spentEnergyHistorySettingsTwoDifferentDates1[6]}${spentEnergyHistorySettingsTwoDifferentDates1[7]}${spentEnergyHistorySettingsTwoDifferentDates1[8]}${spentEnergyHistorySettingsTwoDifferentDates1[9]}-${spentEnergyHistorySettingsTwoDifferentDates1[3]}${spentEnergyHistorySettingsTwoDifferentDates1[4]}-${spentEnergyHistorySettingsTwoDifferentDates1[0]}${spentEnergyHistorySettingsTwoDifferentDates1[1]}";
        spentEnergyHistoryDateTwoDifferentDates2 =
            "${spentEnergyHistorySettingsTwoDifferentDates2[6]}${spentEnergyHistorySettingsTwoDifferentDates2[7]}${spentEnergyHistorySettingsTwoDifferentDates2[8]}${spentEnergyHistorySettingsTwoDifferentDates2[9]}-${spentEnergyHistorySettingsTwoDifferentDates2[3]}${spentEnergyHistorySettingsTwoDifferentDates2[4]}-${spentEnergyHistorySettingsTwoDifferentDates2[0]}${spentEnergyHistorySettingsTwoDifferentDates2[1]}";
      });
      return FirebaseAnimatedList(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map dataItem1 = snapshot.value as Map;
          Map dataItem2 = snapshot.value as Map;
          dataItem1["key"] = snapshot.key;
          dataItem2["key"] = snapshot.key;
          if (dataItem1["date"] == spentEnergyHistoryDateTwoDifferentDates1 ||
              dataItem2["date"] == spentEnergyHistoryDateTwoDifferentDates2) {
            return Column(
              children: [
                energomonitorListItemTwoDates(
                  dataItem1: dataItem1,
                  dataItem2: dataItem2,
                ),
                //Text(dataItem3["date"]),
                //Text(dataItem4["date"]),
              ],
            );
          } else {
            return const Text("");
          }
        },
      );
    } else {
      return const Text("");
    }
  }

  handleViewChange() {
    if (selectedMenu == null ||
        selectedMenu.toString() == "SampleItem.itemOne") {
      if (currentEnergyValuesList.isNotEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Tämänhetkinen kulutus:"),
            const SizedBox(height: 10),
            Text(
              "${currentEnergyValuesList[9].value.toString()} kWh",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: "Kulutus viimeisen 10 minuutin aikana"),
              legend: Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<CurrentEnergyValuesData, String>>[
                LineSeries<CurrentEnergyValuesData, String>(
                  dataSource: currentEnergyValuesList,
                  xValueMapper: (CurrentEnergyValuesData energy, _) =>
                      energy.timestamp.toString(),
                  yValueMapper: (CurrentEnergyValuesData energy, _) =>
                      energy.value,
                  name: "Spent energy (Wh)",
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: show_list
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  show_list ? show_list = false : show_list = true;
                });
              },
              label: const Text("Näytä listamuodossa"),
            ),
            checkCurrentEnergyValuesDropdownValue(),
          ],
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (selectedMenu.toString() == "SampleItem.itemTwo") {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                spentEnergyHistoryEditingViewOpened
                    ? spentEnergyHistoryEditingViewOpened = false
                    : spentEnergyHistoryEditingViewOpened = true;
              });
            },
            icon: spentEnergyHistoryEditingViewOpened
                ? const Icon(Icons.expand_less)
                : const Icon(Icons.expand_more),
            label: const Text("Muokkaa asetuksia"),
          ),
          editSpentEnergyHistorySettings(),
          const SizedBox(
            height: 5,
          ),
          handleSpentEnergyListChange(),
        ],
      );
    } else if (selectedMenu.toString() == "SampleItem.itemThree") {
      Query dbRef = FirebaseDatabase.instance.ref().child("Entso-E_Prices");
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                futurePricesEditingViewOpened
                    ? futurePricesEditingViewOpened = false
                    : futurePricesEditingViewOpened = true;
              });
            },
            icon: futurePricesEditingViewOpened
                ? const Icon(Icons.expand_less)
                : const Icon(Icons.expand_more),
            label: const Text("Muokkaa asetuksia"),
          ),
          editFuturePricesSettings(),
          const SizedBox(
            height: 5,
          ),
          handleHistoryListChange(),
        ],
      );
    }
  }

  handleTitleChange() {
    if (selectedMenu == null ||
        selectedMenu.toString() == "SampleItem.itemOne") {
      title = "Nykyinen kulutus";
    } else if (selectedMenu.toString() == "SampleItem.itemTwo") {
      title = "Historia";
    } else if (selectedMenu.toString() == "SampleItem.itemThree") {
      title = "Tulevaisuuden sähkönhinnat";
    } else {
      title = "Sähkönkulutus";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(handleTitleChange()),
        leading: PopupMenuButton<SampleItem>(
          initialValue: selectedMenu,
          onSelected: (SampleItem item) {
            setState(() {
              selectedMenu = item;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemOne,
              child: Text("Nykyinen kulutus"),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemTwo,
              child: Text("Historia"),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemThree,
              child: Text("Tulevaisuuden hinta"),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: "User info",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserInfo()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            handleViewChange(),
          ],
        ),
      ),
    );
  }
}

//Datamodel tämänhetkisiä energia-arvoja varten, käytetään energomonitorin apista haettuun dataan mutta ei käytetä firebasen dataan.
class CurrentEnergyValuesData {
  CurrentEnergyValuesData(this.timestamp, this.value);

  final String timestamp;
  final int value;
}
