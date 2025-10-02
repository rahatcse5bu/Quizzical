import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../../welcome/widgets/welcome_title.dart';
import '../controller/quiz_config_controller.dart';
import '../model/quiz_config_model.dart';
import '../widgets/category_header_widget.dart';
import '../widgets/question_counter_widget.dart';
import '../widgets/config_dropdown_widget.dart';
import '../../category/model/category_selection_model.dart';
import '../../../shared/widgets/custom_quiz_button.dart';

class QuizConfigurationScreen extends ConsumerWidget {
  final QuizCategory selectedCategory;

  const QuizConfigurationScreen({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(quizConfigurationControllerProvider);
    final configController = ref.read(
      quizConfigurationControllerProvider.notifier,
    );
    final configModel = ref.read(quizConfigModelProvider);

    // Set the selected category in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCategoryProvider.notifier).state = selectedCategory;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.grey.shade50,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
      //     onPressed: () => context.pop(),
      //   ),
      //   title: Text(
      //     configModel.screenTitle,
      //     style: const TextStyle(
      //       color: Colors.black87,
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Category Header
            // Center(
            //   child: CategoryHeaderWidget(category: selectedCategory),
            // ),
            Image.asset(
              'assets/images/config-setting.png',
              // width: 100,
              height: 250,
            ),

            //  SizedBox(height: 10.h),
            WelcomeTitle(title: AppTitle.appTitle, subtitle: 'Configuration'),
            SizedBox(height: 4.h),
            // Category Name
            Text(
              _formatCategoryName(selectedCategory.name),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10.h),

            // Configuration Options
            _buildConfigurationSection(
              context,
              configState,
              configController,
              configModel,
            ),

            SizedBox(height: 10.h),

            // Start Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: CustomQuizButton(
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: AppColors.primary,
                text: configModel.startButtonText,
                isLoading: configState.isLoading,
                onPressed: configState.canStart
                    ? () => _startQuiz(
                        context,
                        configController,
                        selectedCategory,
                      )
                    : () {},
              ),
            ),

            // Error Message
            if (configState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  configState.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection(
    BuildContext context,
    QuizConfigurationState state,
    QuizConfigurationController controller,
    QuizConfigModel model,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
    
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Number of Questions
          Text(
            model.numberOfQuestionsLabel,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Text("Select 1-50", style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),),
          //  SizedBox(height: 4.h),
          QuestionCounterWidget(
            currentCount: state.numberOfQuestions,
            minCount: model.minQuestions,
            maxCount: model.maxQuestions,
            onChanged: controller.onSliderChanged,
          ),

          SizedBox(height: 10.h),

          // Difficulty Level
          ConfigDropdownWidget<DifficultyLevel>(
            label: model.difficultyLabel,
            selectedValue: state.difficulty,
            options: DifficultyLevel.values,
            getDisplayText: (difficulty) => difficulty.displayName,
            onChanged: controller.setDifficulty,
          ),

          const SizedBox(height: 24),

          // Question Type
          ConfigDropdownWidget<QuizType>(
            label: model.typeLabel,
            selectedValue: state.type,
            options: QuizType.values,
            getDisplayText: (type) => type.displayName,
            onChanged: controller.setQuizType,
          ),
        ],
      ),
    );
  }

  void _startQuiz(
    BuildContext context,
    QuizConfigurationController controller,
    QuizCategory category,
  ) {
    final configuration = controller.createConfiguration(category);

    // Navigate to quiz screen with configuration
    context.push(
      '/quiz',
      extra: {
        'category': configuration.categoryId.toString(),
        'difficulty': configuration.difficulty.apiValue,
        'type': configuration.type.apiValue,
        'amount': configuration.numberOfQuestions,
      },
    );
  }

  String _formatCategoryName(String name) {
    String formatted = name
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .trim();

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
