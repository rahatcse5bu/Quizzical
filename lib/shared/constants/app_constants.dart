import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF02706B); // Sea Green
  static const Color secondary = Color(0xFF87CEEB); // Sky Blue
  static const Color accent = Color(0xFFE0F6FF); // Light Blue
  static const Color error = Color(0xFFF44336); // Red
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color info = Color(0xFF2196F3); // Blue
  static const Color textColor = Color(0xFF3F414E); // Blue

}

class AppSizes {
  static const double buttonHeight = 64.0;
  static const double borderRadius = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 60.0;
  static const double padding = 24.0;
  static const double smallPadding = 16.0;
}

class AppTitle{
  static const String appTitle="Quizzical";
}
class AppTextStyles {
  static  TextStyle titleLarge = GoogleFonts.aoboshiOne(
    color: Color(0xFF3F414E),
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}
