import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EnergyPrices extends StatefulWidget {
  const EnergyPrices({Key? key}) : super(key: key);

  @override
  State<EnergyPrices> createState() => _EnergyPricesState();
}

class _EnergyPricesState extends State<EnergyPrices> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List priceList = [];
  getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Prices");

    //HAE TIEDOT KERRAN JA TULOSTA:
    DatabaseEvent event = await ref.once();
    Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));
    if (this.mounted) {
      setState(() {
        priceList.add("00:00: ${data["00:00"]["price"]}");
        priceList.add("01:00: ${data["01:00"]["price"]}");
        priceList.add("02:00: ${data["02:00"]["price"]}");
        priceList.add("03:00: ${data["03:00"]["price"]}");
        priceList.add("04:00: ${data["04:00"]["price"]}");
        priceList.add("05:00: ${data["05:00"]["price"]}");
        priceList.add("06:00: ${data["06:00"]["price"]}");
        priceList.add("07:00: ${data["07:00"]["price"]}");
        priceList.add("08:00: ${data["08:00"]["price"]}");
        priceList.add("09:00: ${data["09:00"]["price"]}");
        priceList.add("10:00: ${data["10:00"]["price"]}");
        priceList.add("11:00: ${data["11:00"]["price"]}");
        priceList.add("12:00: ${data["12:00"]["price"]}");
        priceList.add("13:00: ${data["13:00"]["price"]}");
        priceList.add("14:00: ${data["14:00"]["price"]}");
        priceList.add("15:00: ${data["15:00"]["price"]}");
        priceList.add("16:00: ${data["16:00"]["price"]}");
        priceList.add("17:00: ${data["17:00"]["price"]}");
        priceList.add("18:00: ${data["18:00"]["price"]}");
        priceList.add("19:00: ${data["19:00"]["price"]}");
        priceList.add("20:00: ${data["20:00"]["price"]}");
        priceList.add("21:00: ${data["21:00"]["price"]}");
        priceList.add("22:00: ${data["22:00"]["price"]}");
        priceList.add("23:00: ${data["23:00"]["price"]}");
        priceList.add("24:00: ${data["24:00"]["price"]}");
      });
    }

    //ODOTA REAALIAIKAISTA PÄIVITYSTÄ:
    /*Stream<DatabaseEvent> stream = ref.onValue;
    //stream.listen((DatabaseEvent event) {
    //print("Event type: ${event.type}");
    //print("Snapshot: ${event.snapshot}");
    });*/
    return priceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy prices"),
      ),
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: priceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 50,
                      child: Center(
                        child: Text("${priceList[index]}"),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
