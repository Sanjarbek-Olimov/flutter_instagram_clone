import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/services/hive_service.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = "splash_page";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initTimer() {
    Timer(const Duration(seconds: 2), () {
      _callHomePage();
    });
  }

  void _callHomePage() {
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _initNotification() async {
    await _firebaseMessaging
        .requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print(token);
      HiveDB.saveFCM(token!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromRGBO(193, 53, 132, 1),
            Color.fromRGBO(131, 58, 180, 1),
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Expanded(
              child: Center(
            child: Text(
              "Instagram",
              style: TextStyle(
                  color: Colors.white, fontSize: 45, fontFamily: "Bluevinyl"),
            ),
          )),
          Text(
            "All rights reserved",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
