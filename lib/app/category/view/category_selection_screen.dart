import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/constants/app_constants.dart';
import '../controller/category_selection_controller.dart';
import '../widgets/network_image_category_card.dart';
import '../widgets/grid_category_loading_card.dart';
import '../../../shared/widgets/custom_quiz_button.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(categorySelectionControllerProvider);
    final screenController = ref.read(
      categorySelectionControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppTitle.appTitle,
          style:  GoogleFonts.aoboshiOne(
            fontSize: 36.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3F414E),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () => context.go('/'),
        // ),
        // backgroundColor: Colors.grey.shade50,
        // elevation: 0,
        // foregroundColor: Colors.black87,
      ),
      body: screenState.isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 8.w,
                  ),
                  child: Container(
                    height: 20.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Grid shimmer
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: 8, // Show 8 loading placeholders for better visual
                    itemBuilder: (context, index) => GridCategoryLoadingCard(
                      index: index,
                    ),
                  ),
                ),
              ],
            )
          : screenState.error != null && screenState.categories.isEmpty
          ? _buildErrorView(context, screenState.error!, screenController)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 15.w,
                  ),
                  child: Text(
                    'Choose a category to focus on:',
                    style: GoogleFonts.amethysta(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA1A4B2),
                    ),
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                    itemCount: screenState.categories.length,
                    itemBuilder: (context, index) {
                      final category = screenState.categories[index];
                      final isSelected =
                          screenState.selectedCategory?.id == category.id;

                      return NetworkImageCategoryCard(
                        category: category,
                        onTap: () {
                          screenController.selectCategory(category);
                          
                          // Navigate directly to quiz configuration
                          context.pushNamed(
                            'quizConfig',
                            extra: {
                              'id': category.id,
                              'name': category.name,
                              'icon': category.icon,
                              'color': category.color,
                              'questionCount': category.questionCount,
                              'imageUrl': category.imageUrl,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                // Error Message (if any)
                if (screenState.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      screenState.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String error,
    CategorySelectionController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomQuizButton(
              text: 'TRY AGAIN',
              onPressed: () => controller.refreshCategories(),
            ),
          ],
        ),
      ),
    );
  }
}
