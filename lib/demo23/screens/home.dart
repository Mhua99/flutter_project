import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/demo23/constanins.dart';
import 'package:flutter_project/demo23/home_controller.dart';
import 'package:flutter_project/demo23/models/TyrePsi.dart';
import 'package:flutter_svg/svg.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/temp_details.dart';
import 'components/tesla_bottom_navigationbar.dart';
import 'components/tyre_psi_card.dart';
import 'components/tyres.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationController;

  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  late List<Animation<double>> _tyreAnimations;

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    /**
   * 用于给动画添加曲线效果，控制动画的节奏和时间分布
   */
    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      /**
      * curve: Interval(0.6, 1) 表示动画运行的时间区间
      * 360 毫秒开始，到600毫秒结束
      * 开始时间：600 毫秒 × 0.6 = 360 毫秒
      * 结束时间：600 毫秒 × 1.0 = 600 毫秒
      * 执行时长：600 - 360 = 240 毫秒
      */
      curve: Interval(0.6, 1),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.2, 0.4),
    );
    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.45, 0.65),
    );
    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.7, 1),
    );
  }

  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animationTyre1Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: Interval(0.34, 0.5),
    );
    _animationTyre2Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: Interval(0.5, 0.66),
    );
    _animationTyre3Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: Interval(0.66, 0.82),
    );
    _animationTyre4Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: Interval(0.82, 1),
    );
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setupTyreAnimation();

    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * AnimatedBuilder
     * 监听 animation 参数中的动画控制器，当动画值发生变化时，自动重建子树
     */
    return AnimatedBuilder(
      /**
       * animation 监听这些对象的变化，当其中任何一个对象发出变化通知时，重新调用 builder 函数构建 UI
       * Listenable.merge 是一个工具方法，用于将多个 Listenable 对象合并成一个单一的 Listenable 对象。
       */
      animation: Listenable.merge([
        _controller,
        _batteryAnimationController,
        _tempAnimationController,
        _tyreAnimationController,
      ]),
      /**
       * 当上述任何一个动画控制器发生变化时，会重新构建 builder 这个部分
       */
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              /**
               * index 点击的下一个索引
               * _controller.selectedBottomTab 当前的索引
               */
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_controller.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }

              if (index == 2) {
                _tempAnimationController.forward();
              } else if (_controller.selectedBottomTab == 2 && index != 2) {
                _tempAnimationController.reverse(from: 0.4);
              }

              if (index == 3) {
                _tyreAnimationController.forward();
              } else if (_controller.selectedBottomTab == 3 && index != 3) {
                _tyreAnimationController.reverse();
              }

              _controller.showTyreController(index);
              _controller.tyreStatusController(index);
              // Make sure you call it before [onBottomNavigationTabChange]
              _controller.onBottomNavigationTabChange(index);
            },
            // 高亮显示当前选中的 tab
            selectedTab: _controller.selectedBottomTab,
          ),
          body: SafeArea(
            /**
             * LayoutBuilder  主要作用是根据父级组件提供的约束条件来构建子组件
             * 可以获取父级组件传递下来的约束信息（最大宽度、最大高度、最小宽度、最小高度）
             */
            child: LayoutBuilder(
              builder: (context, constrains) {
                // constrains.maxWidth 是父组件允许的最大宽度
                // constrains.maxHeight 是父组件允许的最大高度
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                    ),
                    Positioned(
                      left: constrains.maxWidth / 2 * _animationCarShift.value,
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: constrains.maxHeight * 0.1,
                        ),
                        child: SvgPicture.asset(
                          "lib/demo23/assets/icons/Car.svg",
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // 门锁
                    AnimatedPositioned(
                      // 过渡时间
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      // AnimatedOpacity 透明度
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          // 默认是否锁住
                          isLock: _controller.isRightDoorLock,
                          // 按钮点击事件
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.13
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.17
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),

                    // 电池
                    Opacity(
                      /**
                       * 透明度值来自 _animationBattery 动画
                       * 当动画值为 0 时完全透明，为 1 时完全不透明
                       * 实现电池图标淡入淡出的动画效果
                       */
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        "lib/demo23/assets/icons/Battery.svg",
                        width: constrains.maxWidth * 0.45,
                      ),
                    ),

                    // 电池状态
                    Positioned(
                      /**
                       * 50 * (1 - _animationBatteryStatus.value) 的取值范围确实是 0 到 50
                       * 最大值 50：动画开始时的位置
                       * 最小值 0：动画结束时的位置
                       */
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(constrains: constrains),
                      ),
                    ),

                    // 温度页面
                    Positioned(
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      top: 60 * (1 - _animationTempShowInfo.value),
                      child: Opacity(
                        opacity: _animationTempShowInfo.value,
                        child: TempDetails(controller: _controller),
                      ),
                    ),
                    // 汽车颜色变化
                    Positioned(
                      right: -180 * (1 - _animationCoolGlow.value),
                      /**
                       * AnimatedSwitcher 是 Flutter 中一个专门用于在两个或多个子组件之间切换时添加动画效果的组件。
                       * 当子组件发生变化时，自动添加切换动画
                       * 可以在新组件进入和旧组件退出时都添加动画效果
                       */
                      child: AnimatedSwitcher(
                        // 切换动画持续时间
                        duration: defaultDuration,
                        child: _controller.isCoolSelected
                            ? Image.asset(
                                "lib/demo23/assets/images/Cool_glow_2.png",
                                key: UniqueKey(),
                                width: 200,
                              )
                            : Image.asset(
                                "lib/demo23/assets/images/Hot_glow_4.png",
                                key: UniqueKey(),
                                width: 200,
                              ),
                      ),
                    ),

                    // 四个轮胎
                    if (_controller.isShowTyre) ...tyres(constrains),

                    if (_controller.isShowTyreStatus)
                      /**
                       * GridView 使用懒加载方式构建网格布局, 只会构建当前可见的子项，提高性能
                       */
                      GridView.builder(
                        // 构建4个元素
                        itemCount: 4,
                        // 禁用滚动，使网格固定不可滚动
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // 横轴显示2列
                          crossAxisCount: 2,
                          // 主轴间距
                          mainAxisSpacing: defaultPadding,
                          // 横轴间距
                          crossAxisSpacing: defaultPadding,
                          // 子项宽高比
                          childAspectRatio:
                              constrains.maxWidth / constrains.maxHeight,
                        ),
                        /**
                         * 使用 ScaleTransition 实现缩放动画
                         */
                        itemBuilder: (context, index) => ScaleTransition(
                          // 轮胎动画
                          scale: _tyreAnimations[index],
                          child: TyrePsiCard(
                            isBottomTwoTyre: index > 1,
                            tyrePsi: demoPsiList[index],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
