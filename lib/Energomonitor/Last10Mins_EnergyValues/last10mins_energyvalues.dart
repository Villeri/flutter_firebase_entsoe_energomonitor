import 'package:flutter/material.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyValues/energy_values_info_charts.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyValues/energy_values_info_list.dart';

class Last10MinsEnergyValues extends StatefulWidget {
  Last10MinsEnergyValues({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<Last10MinsEnergyValues> createState() => _Last10MinsEnergyValuesState();
}

class _Last10MinsEnergyValuesState extends State<Last10MinsEnergyValues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Last 10 minutes energy values"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnergyValuesInfoList(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("View energy values info list"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnergyValuesInfoCharts(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("View energy values info charts"),
            ),
          ],
        ),
      ),
    );
  }
}
