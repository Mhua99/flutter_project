import 'package:flutter/material.dart';
import 'package:flutter_project/demo24/modal/category.dart';
import 'package:flutter_project/demo24/modal/image.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        /**
         * SingleChildScrollView
         * 滚动组件
         */
        child: SingleChildScrollView(
          /**
           * BouncingScrollPhysics 是 Flutter 中的一种滚动物理效果
           */
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                profileAndTitle(),
                SizedBox(height: 30),
                selectCategory(),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContentCard(size, "Mars", mars, "270"),
                    buildContentCard(size, "Venus", venus, "176"),
                  ],
                ),
                SizedBox(height: 15),
                coverImageOfPlanet(
                  size,
                  cassiniSaturn,
                  "Cassini \non Saturn",
                  "251 views",
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContentCard(size, "Mercury", mercury, "340"),
                    buildContentCard(size, "Earth", earth, "746"),
                  ],
                ),
                SizedBox(height: 40),
                coverImageOfPlanet(
                  size,
                  earthSurvey,
                  "Earth Survey",
                  "555 views",
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContentCard(size, "Uranus", uranus, "601"),
                    buildContentCard(size, "Jupiter", jupiter, "100"),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContentCard(size, "Saturn", saturn, "111"),
                    buildContentCard(size, "Neptune", neptune, "90"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            selectedFontSize: 0,
            unselectedFontSize: 0,
            selectedItemColor: const Color.fromARGB(255, 103, 117, 247),
            unselectedItemColor: Colors.grey.shade700,
            backgroundColor: Colors.black,
            iconSize: 35,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            child: Icon(
              Icons.add_circle_outlined,
              size: 55,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container coverImageOfPlanet(Size size, image, title, views) {
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
        /**
         * fit: BoxFit.cover
         * 保持图片的宽高比，同时确保图片完全覆盖容器的整个区域
         * 可能会裁剪图片的部分边缘
         */
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      views,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  SizedBox buildContentCard(Size size, title, imageurl, viesw) {
    return SizedBox(
      width: size.width / 2.2,
      height: 200,
      child: Stack(
        /**
         * Clip.none：不限制子组件的绘制范围，允许子组件绘制到父组件边界之外
         */
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /**
               * 通过 Container 绘制边框
               */
              Container(
                width: size.width / 2.2,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "$viesw views",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -20,
            right: 40,
            child: Center(
              child: Image.asset(
                imageurl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox selectCategory() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: spaceCategory.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black,
                      border: Border.all(color: Colors.white38),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        spaceCategory[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.black
                              : Colors.white54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row profileAndTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            // 圆形
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(profile),
            ),
          ),
        ),
        const Text(
          'Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.grid_view_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}
