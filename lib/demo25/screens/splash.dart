import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset("assets/demo25/animation/bird.json"),
      ),
      nextScreen: HomeScreen(),
      duration: 3000,
      backgroundColor: Colors.white,
      splashIconSize: 260,
    );
  }
}
