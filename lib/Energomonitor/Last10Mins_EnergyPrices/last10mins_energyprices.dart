import 'package:flutter/material.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyPrices/energy_prices_info_charts.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/Last10Mins_EnergyPrices/energy_prices_info_list.dart';

class Last10MinsEnergyPrices extends StatefulWidget {
  Last10MinsEnergyPrices({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<Last10MinsEnergyPrices> createState() => _Last10MinsEnergyPricesState();
}

class _Last10MinsEnergyPricesState extends State<Last10MinsEnergyPrices> {
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("View info"),
          content: const Text(
              "The energy value data is fetched from Energomonitor-page. Go to 'View energy price info charts' -view and press the upload-icon to save data to Firebase."),
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
        title: const Text("Last 10 minutes energy prices"),
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
                        builder: (context) => EnergyPricesInfoList(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("View energy price info list"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnergyPricesInfoCharts(
                              accessToken: widget.accessToken,
                            )));
              },
              child: const Text("View energy price info charts"),
            ),
          ],
        ),
      ),
    );
  }
}
