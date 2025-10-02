class QuizConfigurationState {
  final bool isLoading;
  final int numberOfQuestions;
  final DifficultyLevel difficulty;
  final QuizType type;
  final String? error;
  final bool canStart;

  const QuizConfigurationState({
    this.isLoading = false,
    this.numberOfQuestions = 10,
    this.difficulty = DifficultyLevel.any,
    this.type = QuizType.any,
    this.error,
    this.canStart = true,
  });

  QuizConfigurationState copyWith({
    bool? isLoading,
    int? numberOfQuestions,
    DifficultyLevel? difficulty,
    QuizType? type,
    String? error,
    bool? canStart,
  }) {
    return QuizConfigurationState(
      isLoading: isLoading ?? this.isLoading,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      error: error ?? this.error,
      canStart: canStart ?? this.canStart,
    );
  }

  QuizConfigurationState clearError() {
    return copyWith(error: null);
  }
}

enum DifficultyLevel {
  any('Any Difficulty', 'any'),
  easy('Easy', 'easy'),
  medium('Medium', 'medium'),
  hard('Hard', 'hard');

  const DifficultyLevel(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;
}

enum QuizType {
  any('Any Type', 'any'),
  multipleChoice('Multiple Choice', 'multiple'),
  trueFalse('True / False', 'boolean');

  const QuizType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;
}

class QuizConfiguration {
  final int categoryId;
  final String categoryName;
  final int numberOfQuestions;
  final DifficultyLevel difficulty;
  final QuizType type;

  const QuizConfiguration({
    required this.categoryId,
    required this.categoryName,
    required this.numberOfQuestions,
    required this.difficulty,
    required this.type,
  });

  Map<String, String> toApiParams() {
    final params = <String, String>{
      'amount': numberOfQuestions.toString(),
      'category': categoryId.toString(),
    };

    if (difficulty != DifficultyLevel.any) {
      params['difficulty'] = difficulty.apiValue;
    }

    if (type != QuizType.any) {
      params['type'] = type.apiValue;
    }

    return params;
  }
}

class QuizConfigModel {
  final String screenTitle = 'Configuration';
  final String numberOfQuestionsLabel = 'Number of Questions';
  final String difficultyLabel = 'Difficulty Level';
  final String typeLabel = 'Question Type';
  final String startButtonText = 'START';
  
  final List<int> questionCountOptions = [5, 10, 15, 20, 25, 30];
  final int minQuestions = 5;
  final int maxQuestions = 50;
  final int defaultQuestions = 10;
}