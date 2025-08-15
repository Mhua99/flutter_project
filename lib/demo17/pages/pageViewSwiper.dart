import 'package:flutter/material.dart';
import '../widget/swiper.dart';

class PageViewSwiper extends StatefulWidget {
  const PageViewSwiper({super.key});

  @override
  State<PageViewSwiper> createState() => _PageViewSwiperState();
}

class _PageViewSwiperState extends State<PageViewSwiper> {
  List<String> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = const [
      "assets/demo10/1.png",
      "assets/demo10/2.png",
      "assets/demo10/3.png",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageViewSwiper')),
      body: ListView(children: [Swiper(list: list)]),
    );
  }
}
