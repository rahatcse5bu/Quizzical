import '../../../core/services/trivia_quiz_api_service.dart';

const Object _noChange = Object();

class QuizState {
  final bool isLoading;
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, String> userAnswers;
  final QuizStatus status;
  final String? error;
  final int timeRemaining;
  final bool showAnswerFeedback;
  final String? selectedAnswer;

  const QuizState({
    this.isLoading = false,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.status = QuizStatus.notStarted,
    this.error,
    this.timeRemaining = 30,
    this.showAnswerFeedback = false,
    this.selectedAnswer,
  });

  QuizState copyWith({
    bool? isLoading,
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    Map<int, String>? userAnswers,
    QuizStatus? status,
    String? error,
    int? timeRemaining,
    bool? showAnswerFeedback,
    Object? selectedAnswer = _noChange,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      status: status ?? this.status,
      error: error ?? this.error,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      showAnswerFeedback: showAnswerFeedback ?? this.showAnswerFeedback,
      selectedAnswer: selectedAnswer == _noChange ? this.selectedAnswer : selectedAnswer as String?,
    );
  }

  // Helper getters
  QuizQuestion? get currentQuestion => 
      currentQuestionIndex < questions.length ? questions[currentQuestionIndex] : null;
  
  bool get hasNextQuestion => currentQuestionIndex < questions.length - 1;
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  bool get isQuizCompleted => status == QuizStatus.completed;
  
  int get totalQuestions => questions.length;
  int get answeredQuestions => userAnswers.length;
  
  double get progress => totalQuestions > 0 ? (currentQuestionIndex + 1) / totalQuestions : 0.0;
  
  String get progressText => '${currentQuestionIndex + 1}/$totalQuestions';
}

enum QuizStatus {
  notStarted,
  inProgress,
  paused,
  completed,
  timeUp,
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final Map<int, QuizAnswerResult> answerResults;
  final Duration timeTaken;
  final String categoryName;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.answerResults,
    required this.timeTaken,
    required this.categoryName,
  });

  double get percentage => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;
  
  String get grade {
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great!';
    if (percentage >= 70) return 'Good!';
    if (percentage >= 60) return 'Not Bad!';
    return 'Keep Trying!';
  }

  String get percentageText => '${percentage.round()}%';
}

class QuizAnswerResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final List<String> allOptions;

  const QuizAnswerResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.allOptions,
  });
}