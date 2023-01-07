import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EnergyHistory extends StatefulWidget {
  const EnergyHistory({Key? key}) : super(key: key);

  @override
  State<EnergyHistory> createState() => _EnergyHistoryState();
}

class _EnergyHistoryState extends State<EnergyHistory> {
  List _historyList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dipose() {
    super.dispose();
  }

  _getData() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("EnergomonitorUsedEnergyValues/usedEnergyValues");
    DatabaseEvent event = await ref.once();
    var data = jsonDecode(jsonEncode(event.snapshot.value));
    if (this.mounted) {
      for (var i = 0; i < data.length; i++) {
        _historyList.add(data[i]);
      }
    }
    return _historyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy history from Firebase"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("TIME: VALUE"),
              FutureBuilder(
                future: _getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: _historyList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 50,
                          child: Center(
                            child: Text("${_historyList[index]}"),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
