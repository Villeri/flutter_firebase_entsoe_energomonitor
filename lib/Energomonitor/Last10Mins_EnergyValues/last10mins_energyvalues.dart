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
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("View info"),
          content: const Text(
              "The energy value data is fetched from Energomonitor-page. Go to 'View energy values info list' -view and press the upload-icon to save data to Firebase."),
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
        title: const Text("Last 10 minutes energy values"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _dialogBuilder(context),
          ),
        ],
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
