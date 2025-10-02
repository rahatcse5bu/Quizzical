import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/constants/app_constants.dart';
import '../model/category_selection_model.dart';
import '../../../shared/constants/category_illustrations.dart';

class NetworkImageCategoryCard extends StatelessWidget {
  final QuizCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const NetworkImageCategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visual = CategoryIllustrations.getCategoryVisual(category.name);
    final cardColor = _getCardColor(category.name);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cardColor.withValues(alpha: 0.6), cardColor.withValues(alpha: 0.6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.3),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 5),
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
          border:  Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // Illustration Section (Top)
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: _buildIllustrationWidget(visual, cardColor),
                ),
              ),

              // Title Section (Bottom)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatCategoryName(category.name),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        color: AppColors.textColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationWidget(CategoryVisual visual, Color cardColor) {
    return Container(
      child: Center(
        child: Icon(visual.illustration, size: 100, color: Colors.white),
      ),
    );
  }

  Color _getCardColor(String categoryName) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFF97316), // Orange
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFA855F7), // Violet
      AppColors.primary, // Custom Primary Color
    ];

    // Use category name hash to consistently assign colors
    final hash = categoryName.toLowerCase().hashCode;
    return colors[hash.abs() % colors.length];
  }

  String _formatCategoryName(String name) {
    // Remove "Entertainment:" prefix and clean up category names
    String formatted = name
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .trim();

    // Capitalize first letter of each word
    return formatted
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : word,
        )
        .join(' ');
  }
}
