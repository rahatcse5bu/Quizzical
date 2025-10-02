import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/quiz_config_model.dart';
import '../../category/model/category_selection_model.dart';

class QuizConfigurationController extends StateNotifier<QuizConfigurationState> {
  QuizConfigurationController() : super(const QuizConfigurationState());

  void setNumberOfQuestions(int count) {
    if (count >= 5 && count <= 50) {
      state = state.copyWith(numberOfQuestions: count);
    }
  }

  void setDifficulty(DifficultyLevel difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setQuizType(QuizType type) {
    state = state.copyWith(type: type);
  }

  void incrementQuestions() {
    final newCount = state.numberOfQuestions + 1;
    if (newCount <= 50) {
      setNumberOfQuestions(newCount);
    }
  }

  void decrementQuestions() {
    final newCount = state.numberOfQuestions - 1;
    if (newCount >= 5) {
      setNumberOfQuestions(newCount);
    }
  }

  void onSliderChanged(int count) {
    setNumberOfQuestions(count);
  }

  void resetToDefaults() {
    state = const QuizConfigurationState(
      numberOfQuestions: 10,
      difficulty: DifficultyLevel.any,
      type: QuizType.any,
    );
  }

  QuizConfiguration createConfiguration(QuizCategory selectedCategory) {
    return QuizConfiguration(
      categoryId: selectedCategory.id,
      categoryName: selectedCategory.name,
      numberOfQuestions: state.numberOfQuestions,
      difficulty: state.difficulty,
      type: state.type,
    );
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.clearError();
  }
}

// Providers
final quizConfigurationControllerProvider =
    StateNotifierProvider<QuizConfigurationController, QuizConfigurationState>(
  (ref) => QuizConfigurationController(),
);

final quizConfigModelProvider = Provider<QuizConfigModel>(
  (ref) => QuizConfigModel(),
);

// Provider to pass selected category
final selectedCategoryProvider = StateProvider<QuizCategory?>((ref) => null);