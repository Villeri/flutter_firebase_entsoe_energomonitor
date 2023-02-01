import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

Future<UserData> fetchUserData() async {
  String token = "xvJzxavnABRYj15L2h910TurGK2WDr";
  final response = await http.get(
    Uri.parse("https://api.energomonitor.com/v1/users/ustrx"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );
  final responseJson = jsonDecode(response.body);
  return UserData.fromJson(responseJson);
}

class UserData {
  final String email;
  final String id;
  final String username;

  const UserData({
    required this.email,
    required this.id,
    required this.username,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json["email"] ?? "No email found",
      id: json["id"] ?? "No id found",
      username: json["username"] ?? "No username found",
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late Future<UserData> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("User info"),
          content: const Text(
              "This user info is fetched from app.energomonitor.com webpage."),
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
        title: const Text("User Info"),
        actions: [
          IconButton(
            onPressed: () => _dialogBuilder(context),
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<UserData>(
          future: futureUserData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    "Email: ${snapshot.data!.email}",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "ID: ${snapshot.data!.id}",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Username: ${snapshot.data!.username}",
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
