import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/constants/app_constants.dart';
import '../model/category_selection_model.dart';
import '../../../shared/constants/category_illustrations.dart';

class NetworkImageCategoryCard extends StatelessWidget {
  final QuizCategory category;

  final VoidCallback onTap;

  const NetworkImageCategoryCard({
    super.key,
    required this.category,

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
            colors: [
              cardColor.withValues(alpha: 1),
              cardColor.withValues(alpha: 1),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),

          border: Border.all(
            color: Colors.white.withValues(alpha: 0.7),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
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
      const Color(0xFFC0D1FD), // Purple
      const Color(0xFFC0FDCB), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFFF1C0FD), // Pink
      // const Color(0xFFFDFDC0), // Lime
      const Color(0xFFFDC0C1), // Blue
      // const Color(0xFFFDE4C0), // Orange
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
