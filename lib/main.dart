import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_energyprices/Energomonitor/energyvalues.dart';
import 'package:flutter_firebase_energyprices/EntsoE/energyprices.dart';
import 'package:flutter_firebase_energyprices/userinfo.dart';

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
      title: 'Flutter Demo',
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
  String accessToken = "UgwoEZqFlIyX3O5oE0Jnsnt2TWl0Ga";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase test"),
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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EnergyPrices()));
              },
              child: const Text("Energy prices"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnergyValues(
                              accessToken: accessToken,
                            )));
              },
              child: const Text("Used energy values"),
            ),
          ],
        ),
      ),
    );
  }
}
