import 'package:flutter/material.dart';
import './routers/routers.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          centerTitle: true
        )
      ),
      initialRoute: "/",
      onGenerateRoute: onGenerateRoute
    );
  }
}
