import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionCounterWidget extends StatelessWidget {
  final int currentCount;
  final int minCount;
  final int maxCount;
  final Function(int) onChanged;

  const QuestionCounterWidget({
    super.key,
    required this.currentCount,
    required this.minCount,
    required this.maxCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Count display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select 1-50",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            Text(
              currentCount.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),

         SizedBox(height: 0.h),

        // Range Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF13A4EC),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: const Color(0xFF13A4EC),
            overlayColor: const Color(0xFF13A4EC).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackHeight: 6,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: const Color.fromARGB(255, 5, 78, 114),
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: currentCount.toDouble(),
            min: minCount.toDouble(),
            max: maxCount.toDouble(),
            divisions: maxCount - minCount,
            label: currentCount.toString(),
            onChanged: (double value) {
              onChanged(value.round());
            },
            padding: EdgeInsets.all(0),
          ),
        ),

      ],
    );
  }
}
