import 'package:flutter/material.dart';
import 'package:flutter_project/demo24/screens/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final PageController _pageController = PageController();
  double _progress = 0.33;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      plantetImage("assets/demo24/image1.png"),
                      plantetImage("assets/demo24/image2.png"),
                      plantetImage("assets/demo24/image3.png"),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              "Explore the\n universe!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Learn more about the \nuniverse where we all live.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.white54),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 130,
              width: 130,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    // 旋转其子组件
                    child: RotatedBox(
                      // 表示旋转 2 个 90 度，即 180 度旋转
                      quarterTurns: 2,
                      // 内置的圆形进度指示器
                      child: CircularProgressIndicator(
                        // 设置进度条的线宽为 4 像素
                        strokeWidth: 4,
                        color: const Color.fromARGB(255, 103, 117, 247),
                        value: _progress == 0.99 ? 1 : _progress,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _progress += 0.33;
                      });

                      if (_pageController.hasClients) {
                        // animateToPage 方法用于在 PageView 中平滑切换到指定页面
                        _pageController.animateToPage(
                          _pageController.page!.toInt() + 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      }
                      // 当用户浏览完所有引导页后执行跳转
                      if (_pageController.page!.toInt() == 2) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainPage()),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox plantetImage(image) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Image.asset(image, fit: BoxFit.fitWidth),
    );
  }
}
