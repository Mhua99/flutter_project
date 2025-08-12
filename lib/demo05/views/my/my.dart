import 'package:flutter/material.dart';

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("我的"), centerTitle: true),
      body: Center(child: Text("我的页面")),
    );
  }
}
