import 'package:flutter/material.dart';
import 'package:flutter_project/demo24/screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tesla Animated App",
      home: HomePage(),
    );
  }
}
