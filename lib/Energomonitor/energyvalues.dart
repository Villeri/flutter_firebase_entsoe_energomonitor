import 'package:flutter/material.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyPrices/last10mins_energyprices.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyValues/last10mins_energyvalues.dart';

class EnergyValues extends StatefulWidget {
  EnergyValues({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<EnergyValues> createState() => _EnergyValuesState();
}

class _EnergyValuesState extends State<EnergyValues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Used energy prices and values"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Last10MinsEnergyValues(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("Last 10mins energy values"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Last10MinsEnergyPrices(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("Last 10mins energy prices"),
            ),
          ],
        ),
      ),
    );
  }
}
