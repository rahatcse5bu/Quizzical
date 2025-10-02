import 'package:flutter/material.dart';
import '../../category/model/category_selection_model.dart';
import '../../../shared/constants/category_illustrations.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final QuizCategory category;

  const CategoryHeaderWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final visual = CategoryIllustrations.getCategoryVisual(category.name);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: visual.gradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: visual.gradient[0].withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          // Main emoji
          Center(
            child: Text(
              visual.emoji,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}