import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/pageViewSwiper");
              },
              child: const Text("PageViewSwiper")),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/pageViewKeepAlive");
              },
              child: const Text("pageViewKeepAlive")),
        ],
      ),
    );
  }
}
