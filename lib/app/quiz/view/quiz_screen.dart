import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/custom_quiz_button.dart';
import '../controller/quiz_controller.dart';
import '../model/quiz_state_model.dart';
import '../../quiz_config/model/quiz_config_model.dart';
import '../widgets/quiz_progress_widget.dart';
import '../widgets/question_widget.dart';
import '../widgets/answer_option_widget.dart';
import '../../../core/services/trivia_quiz_api_service.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String category;
  final String difficulty;
  final String type;
  final int amount;

  const QuizScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.type,
    required this.amount,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  // Cache to store shuffled answers for each question to prevent continuous shuffling
  final Map<int, List<String>> _shuffledAnswersCache = {};

  @override
  void initState() {
    super.initState();
    // Clear cache and initialize quiz when screen loads
    _shuffledAnswersCache.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = QuizConfiguration(
        categoryId:
            int.tryParse(widget.category) ?? 9, // Default to General Knowledge
        categoryName: 'Quiz Category', // Will be updated with actual name
        numberOfQuestions: widget.amount,
        difficulty: _getDifficultyLevel(widget.difficulty),
        type: _getQuizType(widget.type),
      );
      ref.read(quizControllerProvider.notifier).startQuiz(config);
    });
  }

  DifficultyLevel _getDifficultyLevel(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return DifficultyLevel.easy;
      case 'medium':
        return DifficultyLevel.medium;
      case 'hard':
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.any;
    }
  }

  QuizType _getQuizType(String type) {
    switch (type.toLowerCase()) {
      case 'multiple':
        return QuizType.multipleChoice;
      case 'boolean':
        return QuizType.trueFalse;
      default:
        return QuizType.any;
    }
  }

  /// REQUIREMENT: Dynamic UI adaptation based on question type
  /// True/False (type=boolean): Displays only 2 buttons labeled "True" and "False"
  /// Multiple Choice (type=multiple): Displays 4 shuffled buttons with stable order per question
  List<Widget> _buildAnswerOptions(
    QuizQuestion currentQuestion,
    String? selectedAnswer,
    bool showAnswerFeedback,
    QuizController quizController,
    int questionIndex,
  ) {
    List<String> answerOptions;

    // REQUIREMENT: Check the type field in API response and render appropriate UI
    if (currentQuestion.isTrueFalse) {
      // TRUE/FALSE: Display exactly 2 buttons in consistent order
      answerOptions = [
        'True',
        'False',
      ]; // Fixed order, no shuffling for better UX
    } else {
      // MULTIPLE CHOICE: Use cached shuffled options to prevent continuous reshuffling
      if (!_shuffledAnswersCache.containsKey(questionIndex)) {
        // First time showing this question - create and cache shuffled answers
        final shuffledList = List<String>.from([
          currentQuestion.correctAnswer,
          ...currentQuestion.incorrectAnswers,
        ]);
        shuffledList.shuffle(); // Shuffle once and cache
        _shuffledAnswersCache[questionIndex] = shuffledList;
      }
      // Use cached shuffled answers for consistent display
      answerOptions = _shuffledAnswersCache[questionIndex]!;
    }

    return answerOptions.map((answer) {
      return Padding(
        padding:  EdgeInsets.only(bottom: 6.h),
        child: AnswerOptionWidget(
          answer: answer,
          isSelected: selectedAnswer == answer,
          isCorrect: answer == currentQuestion.correctAnswer,
          showResult: showAnswerFeedback,
          onTap: !showAnswerFeedback
              ? () => quizController.selectAnswer(answer)
              : () {}, // Empty function instead of null
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizControllerProvider);
    final quizController = ref.read(quizControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: _buildQuizContent(quizState, quizController),
    );
  }

  Widget _buildQuizContent(QuizState quizState, QuizController quizController) {
    if (quizState.isLoading) {
      return const _LoadingWidget();
    }

    if (quizState.error != null) {
      return _ErrorWidget(
        message: quizState.error!,
        onRetry: () {
          final config = QuizConfiguration(
            categoryId: int.tryParse(widget.category) ?? 9,
            categoryName: 'Quiz Category',
            numberOfQuestions: widget.amount,
            difficulty: _getDifficultyLevel(widget.difficulty),
            type: _getQuizType(widget.type),
          );
          quizController.startQuiz(config);
        },
      );
    }

    if (quizState.status == QuizStatus.completed) {
      // Navigate to result screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final result = quizController.generateResult();
        context.pushReplacement('/quiz-result', extra: {'result': result});
      });
      return const _LoadingWidget();
    }

    if (quizState.questions.isEmpty) {
      return const _LoadingWidget();
    }

    final currentQuestion = quizState.currentQuestion!;
    final selectedAnswer = quizState.selectedAnswer;

    return Column(
      children: [
        // Progress section
        QuizProgressWidget(
          currentQuestion: quizState.currentQuestionIndex + 1,
          totalQuestions: quizState.totalQuestions,
          timeRemaining: quizState.timeRemaining,
          onExit: () => _showExitDialog(context),
        ),

        // Content section
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Question
                QuestionWidget(
                  question: currentQuestion.question,
                  category: currentQuestion.category,
                  difficulty: currentQuestion.difficulty,
                ),

                 SizedBox(height: 18.h),

                // Answer options - REQUIREMENT: Dynamic UI adaptation based on question type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _buildAnswerOptions(
                      currentQuestion,
                      selectedAnswer,
                      quizState.showAnswerFeedback,
                      quizController,
                      quizState.currentQuestionIndex,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                // Submit/Next button
                if (selectedAnswer != null && !quizState.showAnswerFeedback)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomQuizButton(
                      backgroundColor: const Color(0xFF004643),
                      borderRadius: 20.r,
                      text: "Next",
                      isLoading: false,
                      onPressed: () => quizController.submitAnswer(),
                    ),
                  ),
              
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E8B57)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Quiz...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B57),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
