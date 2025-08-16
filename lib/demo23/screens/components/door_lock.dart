import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constanins.dart';

class DoorLock extends StatelessWidget {
  const DoorLock({super.key, required this.press, required this.isLock});

  final VoidCallback press;

  // 是否锁住
  final bool isLock;

  @override
  Widget build(BuildContext context) {
    /**
     * GestureDetector用于检测用户的手势操作
     * 在这里主要用于检测用户的点击操作
     * 当用户点击门锁图标时，会调用press回调函数
     */
    return GestureDetector(
      onTap: press,
      /**
       * AnimatedSwitcher 可以同时对其新、旧子元素添加显示、隐藏动画
       * 对旧child，绑定的动画会反向执行（reverse）
       * 对新child，绑定的动画会正向指向（forward）
       */
      child: AnimatedSwitcher(
        // 过渡时间
        duration: defaultDuration,
        // 设置进入动画曲线
        switchInCurve: Curves.easeInOutBack,
        // 自定义过渡动画，使用 ScaleTransition 实现缩放效果
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: isLock
            ? SvgPicture.asset(
                "assets/demo23/assets/icons/door_lock.svg",
                key: ValueKey("lock"),
              )
            : SvgPicture.asset(
                "assets/demo23/assets/icons/door_unlock.svg",
                key: ValueKey("unlock"),
              ),
      ),
    );
  }
}