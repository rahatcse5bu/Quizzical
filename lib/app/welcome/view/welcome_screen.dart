import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_constants.dart';
import '../controller/welcome_screen_controller.dart';
import '../widgets/welcome_app_logo.dart';
import '../widgets/welcome_title.dart';
import '../../../shared/widgets/custom_quiz_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(welcomeScreenControllerProvider);
    final screenController = ref.read(welcomeScreenControllerProvider.notifier);
    final screenModel = ref.read(welcomeScreenModelProvider);

    return Scaffold(
      body: Container(
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Color(0xFF87CEEB), // Sky Blue
        //       Color(0xFFE0F6FF), // Light Blue
        //     ],
        //   ),
        // ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // App Logo
                const WelcomeAppLogo(),

                const SizedBox(height: 40),

                // App Title and Subtitle
                WelcomeTitle(
                  title: AppTitle.appTitle,
                  // subtitle: screenModel.subtitle,
                ),

                const Spacer(),

                // Start Quiz Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomQuizButton(
                    text: screenModel.buttonText,
                    isLoading: screenState.isLoading,
                    onPressed: () {
                      screenController.startQuiz();
                      context.go('/category-selection');
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Error Message (if any)
                if (screenState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      screenState.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
