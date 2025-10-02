import 'package:go_router/go_router.dart';
import '../../app/welcome/view/welcome_screen.dart';
import '../../app/category/view/category_selection_screen.dart';
import '../../app/quiz_config/view/quiz_configuration_screen.dart';
import '../../app/quiz/view/quiz_screen.dart';
import '../../app/quiz/view/quiz_result_screen.dart';
import '../../app/category/model/category_selection_model.dart';
import '../../app/quiz/model/quiz_state_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/category-selection',
      name: 'categorySelection',
      builder: (context, state) => const CategorySelectionScreen(),
    ),
    GoRoute(
      path: '/quiz-config',
      name: 'quizConfig',
      builder: (context, state) {
        final categoryJson = state.extra as Map<String, dynamic>?;
        if (categoryJson == null) {
          // If no category data, redirect to category selection
          return const CategorySelectionScreen();
        }
        
        final category = QuizCategory(
          id: categoryJson['id'] as int,
          name: categoryJson['name'] as String,
          icon: categoryJson['icon'] as String,
          color: categoryJson['color'] as int,
          questionCount: categoryJson['questionCount'] as int,
          imageUrl: categoryJson['imageUrl'] as String?,
        );
        
        return QuizConfigurationScreen(selectedCategory: category);
      },
    ),
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null) {
          // If no params, redirect to category selection
          return const CategorySelectionScreen();
        }
        
        return QuizScreen(
          category: params['category'] as String,
          difficulty: params['difficulty'] as String,
          type: params['type'] as String,
          amount: params['amount'] as int,
        );
      },
    ),
    GoRoute(
      path: '/quiz-result',
      name: 'quizResult',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null) {
          // If no params, redirect to welcome
          return const WelcomeScreen();
        }
        
        return QuizResultScreen(
          result: params['result'] as QuizResult,
        );
      },
    ),
    // Test route for result screen
    GoRoute(
      path: '/test-result',
      name: 'testResult',
      builder: (context, state) {
        // Create a test result for demonstration
        final testResult = QuizResult(
          totalQuestions: 10,
          correctAnswers: 8,
          incorrectAnswers: 2,
          answerResults: {},
          timeTaken: const Duration(minutes: 2, seconds: 30),
          categoryName: 'General Knowledge',
        );
        
        return QuizResultScreen(result: testResult);
      },
    ),
  ],
);