import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/quiz_state_model.dart';
import '../../quiz_config/model/quiz_config_model.dart';
import '../../../core/services/trivia_quiz_api_service.dart';

class QuizController extends StateNotifier<QuizState> {
  final QuizApiService _apiService;
  Timer? _timer;
  late QuizConfiguration _configuration;
  final DateTime _startTime = DateTime.now();

  QuizController(this._apiService) : super(const QuizState());

  Future<void> startQuiz(QuizConfiguration configuration) async {
    _configuration = configuration;
    
    // Reset all quiz state before starting a new quiz
    _stopTimer();
    state = const QuizState().copyWith(isLoading: true, status: QuizStatus.notStarted);

    try {
      final response = await _apiService.getQuizQuestions(configuration);
      
      if (response.isSuccess && response.results.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          questions: response.results,
          status: QuizStatus.inProgress,
          timeRemaining: 30, // 30 seconds per question
        );
        _startTimer();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectAnswer(String answer) {
    if (state.status != QuizStatus.inProgress || state.showAnswerFeedback) return;

    state = state.copyWith(selectedAnswer: answer);
  }

  void submitAnswer() {
    if (state.selectedAnswer == null || state.showAnswerFeedback) return;

    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) return;

    // Store the answer
    final newAnswers = Map<int, String>.from(state.userAnswers);
    newAnswers[state.currentQuestionIndex] = state.selectedAnswer!;

    state = state.copyWith(
      userAnswers: newAnswers,
      showAnswerFeedback: true,
    );

    _stopTimer();

    // Auto proceed to next question after 2 seconds
    Timer(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (state.hasNextQuestion) {
      // Clear selection, feedback, and move to next question in a single state update
      state = state.copyWith(
        selectedAnswer: null,
        showAnswerFeedback: false,
        currentQuestionIndex: state.currentQuestionIndex + 1,
        timeRemaining: 30,
      );
      
      _startTimer();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    _stopTimer();
    state = state.copyWith(
      status: QuizStatus.completed,
      showAnswerFeedback: false,
    );
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      } else {
        // Time's up for this question
        _onTimeUp();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimeUp() {
    _stopTimer();
    
    if (state.selectedAnswer == null) {
      // Auto-submit empty answer if no selection
      final newAnswers = Map<int, String>.from(state.userAnswers);
      newAnswers[state.currentQuestionIndex] = ''; // Empty answer for timeout
      
      state = state.copyWith(
        userAnswers: newAnswers,
        showAnswerFeedback: true,
      );
    }

    // Auto proceed after showing feedback
    Timer(const Duration(seconds: 2), () {
      if (state.hasNextQuestion) {
        nextQuestion();
      } else {
        _completeQuiz();
      }
    });
  }

  QuizResult generateResult() {
    final answerResults = <int, QuizAnswerResult>{};
    int correctCount = 0;

    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];
      final userAnswer = state.userAnswers[i] ?? '';
      final isCorrect = userAnswer == question.correctAnswer;
      
      if (isCorrect) correctCount++;

      answerResults[i] = QuizAnswerResult(
        question: question.question,
        userAnswer: userAnswer,
        correctAnswer: question.correctAnswer,
        isCorrect: isCorrect,
        allOptions: question.isTrueFalse 
            ? ['True', 'False']
            : question.allAnswers,
      );
    }

    return QuizResult(
      totalQuestions: state.questions.length,
      correctAnswers: correctCount,
      incorrectAnswers: state.questions.length - correctCount,
      answerResults: answerResults,
      timeTaken: DateTime.now().difference(_startTime),
      categoryName: _configuration.categoryName,
    );
  }

  void pauseQuiz() {
    _stopTimer();
    state = state.copyWith(status: QuizStatus.paused);
  }

  void resumeQuiz() {
    if (state.status == QuizStatus.paused) {
      state = state.copyWith(status: QuizStatus.inProgress);
      _startTimer();
    }
  }

  void resetQuiz() {
    _stopTimer();
    state = const QuizState();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

// Providers
final quizApiServiceProvider = Provider<QuizApiService>((ref) {
  final service = QuizApiService();
  ref.onDispose(() => service.dispose());
  return service;
});

final quizControllerProvider = StateNotifierProvider<QuizController, QuizState>((ref) {
  final apiService = ref.watch(quizApiServiceProvider);
  return QuizController(apiService);
});

// Provider for quiz result
final quizResultProvider = StateProvider<QuizResult?>((ref) => null);