import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "笔记",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(color: Colors.black87),
      ),
      home: HomeScreen(),
    );
  }
}
