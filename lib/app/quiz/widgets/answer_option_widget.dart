import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/constants/app_constants.dart';

class AnswerOptionWidget extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool showResult;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool isEnabled;

  const AnswerOptionWidget({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.showResult,
    required this.isCorrect,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor = Colors.black87;
    IconData? icon;

    if (showResult) {
      if (isSelected) {
        if (isCorrect) {
          backgroundColor = const Color(0xFF2E8B57).withValues(alpha: 0.1);
          borderColor = const Color(0xFF2E8B57);
          textColor = const Color(0xFF2E8B57);
          icon = Icons.check_circle;
        } else {
          backgroundColor = Colors.red.shade100;
          borderColor = Colors.red;
          textColor = Colors.red.shade800;
          icon = Icons.cancel;
        }
      } else if (isCorrect) {
        backgroundColor = const Color(0xFF2E8B57).withValues(alpha: 0.1);
        borderColor = const Color(0xFF2E8B57);
        textColor = const Color(0xFF2E8B57);
        icon = Icons.check_circle;
      } else {
        backgroundColor = Colors.grey.shade50;
        borderColor = Colors.grey.shade300;
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFF2E8B57).withValues(alpha: 0.1);
      borderColor = const Color(0xFF2E8B57);
      textColor = const Color(0xFF2E8B57);
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: isEnabled && !showResult ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            if ((isSelected && !showResult) || (showResult && isCorrect))
              BoxShadow(
                color: const Color(0xFFABD1C6),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                answer,
                style: GoogleFonts.baloo2(
                  fontSize: 20.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppColors.textColor,
                ),
              ),
            ),
            if (showResult && icon != null)
              Icon(
                icon,
                color: isSelected
                    ? (isCorrect ? Color(0XFF004643) : Colors.red)
                    : (isCorrect ? Color(0XFF004643) : Colors.white),
                size: 24,
              ),
            if (!showResult)
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Color(0XFF004643) : Colors.black,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
