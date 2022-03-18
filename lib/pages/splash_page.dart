import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = "splash_page";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _initTimer() {
    Timer(const Duration(seconds: 2), () {
      _callHomePage();
    });
  }

  void _callHomePage() {
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
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
