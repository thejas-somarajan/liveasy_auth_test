import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
