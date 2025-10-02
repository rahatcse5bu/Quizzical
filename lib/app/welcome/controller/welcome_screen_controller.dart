import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/welcome_screen_model.dart';

class WelcomeScreenController extends StateNotifier<WelcomeScreenState> {
  WelcomeScreenController() : super(const WelcomeScreenState());

  void startQuiz() {
    state = state.copyWith(isNavigating: true, isLoading: true);
  }

  void resetNavigation() {
    state = state.copyWith(isNavigating: false, isLoading: false);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void clearError() {
    state = state.clearError();
  }
}

final welcomeScreenControllerProvider =
    StateNotifierProvider<WelcomeScreenController, WelcomeScreenState>(
  (ref) => WelcomeScreenController(),
);

final welcomeScreenModelProvider = Provider<WelcomeScreenModel>(
  (ref) => const WelcomeScreenModel(),
);