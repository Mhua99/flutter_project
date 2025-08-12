import 'package:flutter/material.dart';
import 'package:flutter_project/demo06/pages/tabs.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Tabs() ,
    );
  }
}
