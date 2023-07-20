import 'dart:async';

import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'package:projek1/view/admin/DataAdmin.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:projek1/view/login.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    StartScreen();
  }

  // startscreen
  StartScreen() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Login();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FooterView(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Romis Code",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
        footer: Footer(
          padding: EdgeInsets.only(bottom: 50),
          backgroundColor: Colors.white,
          child: Text(
            "Copyright @2023, Romis Code.",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Color(0xFF162A49),
            ),
          ),
        ),
      ),
    );
  }
}
