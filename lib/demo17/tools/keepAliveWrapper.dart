import 'package:flutter/material.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    super.key,
    @required this.child,
    this.keepAlive = true,
  });

  final Widget? child;
  final bool keepAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

/**
 * AutomaticKeepAliveClientMixin 提供了自动保持组件活跃的功能
 */
class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  /**
   * 决定是否保持组件活跃
   */
  @override
  bool get wantKeepAlive => widget.keepAlive;
}
