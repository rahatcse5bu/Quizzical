import 'package:flutter/material.dart';
import '../../../shared/constants/app_constants.dart';

class WelcomeAppLogo extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const WelcomeAppLogo({
    super.key,
    this.size = 120,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/welcome.png',
      // width: size * 0.5,
      // height: size * 0.5,
      // color: iconColor,
    );
  }
}