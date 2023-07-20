import 'package:flutter/material.dart';
import 'package:projek1/splash.dart';
import 'package:projek1/view/admin/DataAdmin.dart';
import 'package:projek1/view/jenis/DataJenis.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      home: Splash(),
    ),
  );
}
