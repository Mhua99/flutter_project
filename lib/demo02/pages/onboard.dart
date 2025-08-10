import 'package:flutter/material.dart';
import 'package:flutter_project/demo02/Utils/const.dart';
import 'package:flutter_project/demo02/models/onboards_model.dart';
import 'package:flutter_project/demo02/pages/home.dart';

class PetsOnBoardingScreen extends StatefulWidget {
  const PetsOnBoardingScreen({super.key});

  @override
  State<PetsOnBoardingScreen> createState() => _PetsOnBoardingScreenState();
}

class _PetsOnBoardingScreenState extends State<PetsOnBoardingScreen> {

  // 页面控制器，用于控制页面的跳转和监听页
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {

    // 屏幕的宽和高
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // 计算屏幕高度的70%。
              height: size.height * 0.7,
              color: Colors.white,
              /**
               * PageView.builder 是 Flutter 中的一个可滚动组件，用于创建页面视图
               *   PageView: 一个可以水平翻页的滚动视图组件，每次滚动一页
               *   builder: 采用构建器模式，按需创建页面，提高性能
               *
               */
              child: PageView.builder(
                itemCount: onBoardData.length,
                controller: _pageController,
                // 页面切换完成后的回调函数
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                // 构建每个页面内容的回调函数
                itemBuilder: (context, index) {
                  return _headerContent(size, index);
                },
              )
          ),
          GestureDetector(
            // 点击事件
            onTap: () {
              // 是否最后一页
              if (_currentPage == onBoardData.length - 1) {
                // pushAndRemoveUntil: 跳转到新页面并移除之前的页面
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                   (route) => false);
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            },
            child: Container(
              height: 70,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: Text(
                  _currentPage == onBoardData.length - 1 ? "Get Started" : "Continue",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
          SizedBox( height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                onBoardData.length,
                    (index) => _indicatorForSlider(index: index),
              )
            ],
          )
        ],
      ),
    );
  }

  AnimatedContainer _indicatorForSlider({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: _currentPage == index ? 20 : 10,
      height: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _currentPage == index ? Colors.orange : Color.fromRGBO(0, 0, 0, 0.2),
      ),
    );
  }

  Column _headerContent(Size size, int index) {
    return Column(
      children: [
        Container(
          height: size.height * 0.4,
          width: size.width * 0.9,
          // 创建一个白色背景、带有 30 像素圆角的矩形容器
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 240,
                    width: size.width * 0.9,
                    color: orangeContainer,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: -40,
                          width: 130,
                          height: 130,
                          child: Transform.rotate(
                            angle: -11,
                            child: Image.asset(
                                "assets/demo02/rTnrpap6c.png",
                                color: pawColor1
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          right: -20,
                          width: 130,
                          height: 130,
                          child: Transform.rotate(
                            angle: -12,
                            child: Image.asset(
                                "assets/demo02/rTnrpap6c.png",
                                color: pawColor1
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 60,
                child: Image.asset(
                  onBoardData[index].image,
                  height:375,
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 35,
              color: black,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
            children: [
              TextSpan(text: "Find You "),
              TextSpan(
                text: "Dream\n",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(text: "Pet Here"),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          onBoardData[index].text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.5,
            color: Colors.black38,
          ),
        )
      ],
    );
  }

}

