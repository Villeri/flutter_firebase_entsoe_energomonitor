import 'package:flutter/material.dart';

class EnergyPricesInfoList extends StatefulWidget {
  EnergyPricesInfoList({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  String accessToken;

  @override
  State<EnergyPricesInfoList> createState() => _EnergyPricesInfoListState();
}

class _EnergyPricesInfoListState extends State<EnergyPricesInfoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Energy prices info list"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Energy prices info list"),
          ],
        ),
      ),
    );
  }
}
