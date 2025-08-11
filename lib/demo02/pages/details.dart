import "package:flutter/material.dart";

import "../models/cats_model.dart";

class Details extends StatefulWidget {

  final Cat cat;

  const Details({super.key, required this.cat});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("测试页面"),
      ),
    );
  }
}
