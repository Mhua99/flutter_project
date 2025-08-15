import 'dart:async';

import 'package:flutter/material.dart';

class Swiper extends StatefulWidget {
  final double width;
  final double height;
  final List<String> list;

  const Swiper({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    required this.list,
  });

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  int _currentIndex = 0;
  List<Widget> pageList = [];
  late PageController _pageController;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //数据
    for (var i = 0; i < widget.list.length; i++) {
      pageList.add(
        ImagePage(
          width: widget.width,
          height: widget.height,
          src: widget.list[i],
        ),
      );
    }
    //PageController
    _pageController = PageController(initialPage: 0);

    /**
     * 创建了一个每隔5秒执行一次的定时器
     */
    timer = Timer.periodic(Duration(seconds: 5), (t) {
      /**
       * _pageController.animateToPage() 方法用于平滑地切换到指定页面
       */
      _pageController.animateToPage(
        // 计算下一张要显示的页面索引
        (_currentIndex + 1) % pageList.length,
        // 设置切换动画持续200毫秒
        duration: Duration(milliseconds: 200),
        // 设置动画曲线为线性
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 取消之前创建的定时器，停止自动轮播
    timer.cancel();
    // 释放 PageController 占用的资源
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index % pageList.length;
              });
            },
            /**
             * 设置总页面数为 1000,这是一个很大的数，用于实现无限循环效果
             */
            itemCount: 1000,
            itemBuilder: (context, index) {
              return pageList[index % pageList.length];
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageList.length, (index) {
              return Container(
                margin: const EdgeInsets.all(5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ImagePage extends StatelessWidget {
  final double width;
  final double height;
  final String src;

  const ImagePage({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(src, fit: BoxFit.cover),
    );
  }
}
