import 'package:flutter/material.dart';
import './tabs/home.dart';
import './tabs/my.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // 创建 GlobalKey 来访问 MyScreen 的状态
  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();
  final GlobalKey<MyScreenState> _myScreenKey = GlobalKey<MyScreenState>();

  int _currentIndex = 0;
  bool isFirstClickMy = false;

  // 使用 getter 替代直接初始化
  List<Widget> get _pages => [
    HomeScreen(key: _homeScreenKey),
    MyScreen(key: _myScreenKey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        /// 选中的颜色
        fixedColor: Colors.blue,

        /// 选中菜单索引
        currentIndex: _currentIndex,

        /// 如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
        type: BottomNavigationBarType.fixed,

        /// 点击事件
        onTap: (index) {
          setState(() {
            _currentIndex = index;

            /// 当切换到"我的"页面时，调用其方法
            if (index == 1) {
              if (isFirstClickMy) {
                _myScreenKey.currentState?.onPageVisible();
              } else {
                isFirstClickMy = true;
              }
            } else {
              if (_myScreenKey.currentState!.isAddCategory) {
                _myScreenKey.currentState!.isAddCategory = false;
                _homeScreenKey.currentState?.refreshCategoryList();
              }
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "笔记"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "我的"),
        ],
      ),
      // floatingActionButton: Container(
      //   height: 60,
      //   width: 60,
      //   padding: const EdgeInsets.all(5),
      //   margin: const EdgeInsets.only(top: 5),
      //   // 调整FloatingActionButton的位置
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: FloatingActionButton(
      //     backgroundColor: _currentIndex == 2 ? Colors.red : Colors.blue,
      //     foregroundColor: _currentIndex == 2 ? Colors.white : Colors.black,
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       setState(() {
      //         _currentIndex = 2;
      //       });
      //     },
      //   ),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked,
    );
  }
}
