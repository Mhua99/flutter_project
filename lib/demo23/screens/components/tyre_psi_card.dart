import 'package:flutter/material.dart';
import 'package:flutter_project/demo23/models/TyrePsi.dart';

import '../../constanins.dart';

class TyrePsiCard extends StatelessWidget {
  const TyrePsiCard({
    super.key,
    required this.isBottomTwoTyre,
    required this.tyrePsi,
  });

  final bool isBottomTwoTyre;
  final TyrePsi tyrePsi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: tyrePsi.isLowPressure ? redColor.withAlpha(26) : Colors.white10,
        border: Border.all(
          color: tyrePsi.isLowPressure ? redColor : primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: isBottomTwoTyre
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 下方两个轮胎
              children: [
                lowPressureText(context),
                Spacer(),
                psiText(context, psi: tyrePsi.psi.toString()),
                const SizedBox(height: defaultPadding),
                Text("${tyrePsi.temp}\u2103", style: TextStyle(fontSize: 16)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 上方两个轮胎
              children: [
                psiText(context, psi: tyrePsi.psi.toString()),
                const SizedBox(height: defaultPadding),
                Text("${tyrePsi.temp}\u2103", style: TextStyle(fontSize: 16)),
                Spacer(),
                lowPressureText(context),
              ],
            ),
    );
  }

  Column lowPressureText(BuildContext context) {
    return Column(
      children: [
        Text(
          "Low".toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Pressure".toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87.withAlpha(150),
            shadows: [
              Shadow(
                color: Colors.white, // 阴影颜色
                offset: Offset(1, 1), // 阴影偏移量 (x, y)
                blurRadius: 3, // 阴影模糊半径
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text psiText(BuildContext context, {required String psi}) {
    return Text.rich(
      TextSpan(
        text: psi,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        children: [TextSpan(text: "psi", style: TextStyle(fontSize: 24))],
      ),
    );
  }
}
