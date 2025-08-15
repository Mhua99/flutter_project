import 'package:flutter/material.dart';

import '../../constanins.dart';

class BatteryStatus extends StatelessWidget {
  const BatteryStatus({super.key, required this.constrains});

  final BoxConstraints constrains;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "220 mi",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(color: Colors.white),
        ),
        Text("62%", style: TextStyle(fontSize: 24)),
        /**
         * Spacer 自动占据剩余空间
         */
        Spacer(),
        Text("Charging".toUpperCase(), style: TextStyle(fontSize: 20)),
        Text("18 min remaining", style: TextStyle(fontSize: 20)),
        SizedBox(height: constrains.maxHeight * 0.14),
        /**
         * DefaultTextStyle
         * 统一样式，避免重复书写
         */
        DefaultTextStyle(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("22 mi/hr"), Text("232 v")],
          ),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
