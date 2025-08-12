import 'package:flutter/material.dart';
import 'package:flutter_project/demo02/Utils/const.dart';
import 'package:flutter_project/demo02/models/cats_model.dart';

import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  // 底部导航栏索引
  int selectedIndex = 0;
  // 底部导航栏图标
  List<IconData> icons = [
    Icons.home_outlined,
    Icons.favorite_outline_rounded,
    Icons.chat,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea 确保子组件不会被设备的物理边界遮挡，如状态栏、导航栏、刘海屏等
      body: SafeArea(
        child: Column(
          children: [
            _getHeader(),
            SizedBox(height: 20,),
            _getBanner(),
            SizedBox(height: 30,),
            _getTitle("Categories"),
            SizedBox(height: 25,),
            _getCategoryItem(),
            SizedBox(height: 20,),
            _getTitle("Adopt Pet"),
            SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: List.generate(cats.length, (index) {
                  final cat = cats[index];
                  return _petItem(cat, size);
                }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          // MainAxisAlignment.spaceEvenly 所有间距相等
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(icons.length, (index) => GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                width: 50,
                padding: const EdgeInsets.all(5),
                child: Stack(
                  // 允许子组件（通知徽章）超出父组件边界显示，实现徽章部分悬空的效果。
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Icon(
                          icons[index],
                          size: 30,
                          color: selectedIndex == index
                              ? blue
                              : black.withAlpha(130),
                        ),
                        const SizedBox(height: 5),
                        selectedIndex == index
                            ? Container(
                          height: 5,
                          width: 5,
                          decoration: const BoxDecoration(
                            // 将容器形状设置为圆形
                            shape: BoxShape.circle,
                            color: blue,
                          ),
                        )
                            : Container(),
                      ],
                    ),
                    index == 2
                        ? Positioned(
                      right: 0,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: buttonColor,
                        ),
                        child: const Text(
                          "4",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _getBanner(){
    return Padding(
      // x 轴的padding 为 20
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 180,
          width: double.infinity,
          color: blueBackground,
          child: Stack(
            children: [
              Positioned(
                  bottom: -20,
                  right: -30,
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: 12,
                    child: Image.asset(
                      "assets/demo02/rTnrpap6c.png",
                      color: pawColor2,
                    ),
                  )
              ),
              Positioned(
                  bottom: -35,
                  left: -15,
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: -12,
                    child: Image.asset(
                      "assets/demo02/rTnrpap6c.png",
                      color: pawColor2,
                    ),
                  )
              ),
              Positioned(
                  top: -40,
                  left: 120,
                  width: 110,
                  height: 110,
                  child: Transform.rotate(
                    angle: -16,
                    child: Image.asset(
                      "assets/demo02/rTnrpap6c.png",
                      color: pawColor2,
                    ),
                  )
              ),
              Positioned(
                bottom: 2,
                right: 20,
                child: Image.asset(
                  "assets/demo02/cat1.png",
                  height: 170,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Join Our Animal \n Lovers Community",
                      // TextStyle 的 height 属性是用来控制文本行高的，具体解释如下
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amberAccent
                      ),
                      child: Text(
                        "Join Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _getHeader(){
    return Column(
      children: [
        Padding(
          // x 轴 设置内边距 20
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "location",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
              SizedBox(width: 5,),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: blue,
                size: 18,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text.rich(
                  TextSpan(
                      text: "Chicago ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: black,
                      ),
                      children: [
                        TextSpan(
                          text: "US",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]
                  )
              ),
              // 占据剩余空间：在 Row、Column 或 Flex 布局中自动占据所有可用的剩余空间
              Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  // 背景颜色
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
                child: Icon(Icons.search),
              ),
              // SizedBox(width: 10,),
              Container(
                margin: EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
                child: Stack(
                  children: [
                    Icon(Icons.notifications_outlined),
                    Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            // 红色圆点
                            shape: BoxShape.circle,
                            color: Colors.red
                          ),
                        )
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ],
    );
  }

  Padding _getTitle(name){
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text(
                "View All",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber
                ),
              ),
              SizedBox(width: 10,),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber
                ),
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  SingleChildScrollView _getCategoryItem(){
    // SingleChildScrollView 是 Flutter 提供的一个可以滚动单个子组件的 Widget。当内容超出父容器的边界时，用户可以通过滑动来查看完整内容。
    return SingleChildScrollView(
      // 横向滚动
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 20,),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            ),
            child: Icon(
              Icons.tune_rounded,
            ),
          ),
          SizedBox(width: 20,),
          ...List.generate(categories.length, (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedCategory == index ? buttonColor : Color.fromRGBO(0, 0, 0, 0.03),
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedCategory == index ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Padding _petItem(Cat cat, Size size){
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Details(cat: cat),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: size.height * 0.3,
            width: size.width * 0.55,
            color: cat.color.withAlpha(128),
            child: Stack(
              children: [
                Positioned(
                  bottom: -10,
                  right: -10,
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: 12,
                    child: Image.asset(
                      "assets/demo02/rTnrpap6c.png",
                      color: cat.color,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -25,
                  width: 90,
                  height: 90,
                  child: Transform.rotate(
                    angle: -11.5,
                    child: Image.asset(
                      "assets/demo02/rTnrpap6c.png",
                      color: cat.color,
                      // 保持宽高比并填满容器，可能裁剪边缘
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  right: 10,
                  child: Hero(
                    tag: cat.image,
                    child: Image.asset(
                      cat.image,
                      height: size.height * 0.23,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: blue,
                                  size: 18,
                                ),
                                Text(
                                  "${cat.distance} km",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      // 显示圆形头像或图标
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          cat.fav
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: cat.fav ? Colors.red : black.withAlpha(136),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
