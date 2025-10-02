import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/constants/app_constants.dart';

class WelcomeTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const WelcomeTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        SizedBox(height: 0.h),
        subtitle != null
            ? Text(
                subtitle!,
                style: GoogleFonts.balooBhai2(
                  color: Color(0xFF3F414E),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            : Wrap(),
      ],
    );
  }
}
