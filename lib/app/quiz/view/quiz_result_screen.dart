import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../../shared/widgets/custom_quiz_button.dart';
import '../../welcome/controller/welcome_screen_controller.dart';
import '../model/quiz_state_model.dart';
import '../controller/quiz_controller.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final QuizResult result;

  const QuizResultScreen({super.key, required this.result});

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;
  final List<ConfettiPiece> _confettiPieces = [];

  @override
  void initState() {
    super.initState();

    // Initialize confetti animation - longer duration for better effect
    _confettiController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Initialize score animation
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: widget.result.percentage)
        .animate(
          CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
        );

    // Generate confetti pieces only for excellent performance
    if (widget.result.percentage >= 80) {
      _generateConfetti();
      // Run confetti animation only for excellent scores
      _confettiController.forward().then((_) {
        // Animation completed, stop updating
        _confettiController.stop();
      });
    }

    // Start score animation
    _scoreController.forward();
  }

  void _generateConfetti() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];

    for (int i = 0; i < 50; i++) {
      _confettiPieces.add(
        ConfettiPiece(
          color: colors[math.Random().nextInt(colors.length)],
          x: math.Random().nextDouble(),
          y: -0.1 - math.Random().nextDouble() * 0.5,
          rotation: math.Random().nextDouble() * 2 * math.pi,
          speed: 0.5 + math.Random().nextDouble() * 1.5,
          rotationSpeed: (math.Random().nextDouble() - 0.5) * 0.2,
          size: 8 + math.Random().nextDouble() * 12,
        ),
      );
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Color _getScoreColor() {
    if (widget.result.percentage >= 80) return const Color(0xFF81E49F);
    if (widget.result.percentage >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getResultImage() {
    if (widget.result.percentage >= 80) {
      return 'assets/images/congratulations.png'; // Excellent performance
    } else if (widget.result.percentage >= 60) {
      return 'assets/images/welcome.png'; // Good performance  
    } else {
      return 'assets/images/config-setting.png'; // Need improvement
    }
  }

  String _getResultTitle() {
    if (widget.result.percentage >= 80) {
      return 'Excellent!';
    } else if (widget.result.percentage >= 60) {
      return 'Good Job!';
    } else {
      return 'Keep Trying!';
    }
  }

  String _getResultMessage() {
    if (widget.result.percentage >= 80) {
      return 'Outstanding performance! You\'re a quiz master.\nReady for another challenge?';
    } else if (widget.result.percentage >= 60) {
      return 'Good work! You\'re on the right track.\nWant to try another category?';
    } else {
      return 'Don\'t give up! Practice makes perfect.\nTry again to improve your score.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenController = ref.read(welcomeScreenControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  // Result image based on performance
                  Image.asset(
                    _getResultImage(),
                    fit: BoxFit.contain,
                    height: 200.h,
                  ),

                  SizedBox(height: 16.h),

                  // Result title based on performance
                  Text(
                    _getResultTitle(),
                    style: GoogleFonts.aoboshiOne(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3F414E),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Score display
                  AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getScoreColor().withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: _getScoreColor().withValues(alpha: 0.1),
                                blurRadius: 16.r,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getScoreColor().withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _getScoreColor().withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 16.r,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getScoreColor(),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getScoreColor().withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 16.r,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 90.w,
                              ),
                              child: Text(
                                '${_scoreAnimation.value.round()}%',
                                style: GoogleFonts.aoboshiOne(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF3F414E),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Description text based on performance
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      _getResultMessage(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.balooTamma2(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        // height: 1,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Stats row
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: Icons.quiz_outlined,
                            label: 'Total',
                            value: '${widget.result.totalQuestions}',
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50.h,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.check_circle_outline,
                            label: 'Correct',
                            value: '${widget.result.correctAnswers}',
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50.h,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.cancel_outlined,
                            label: 'Wrong',
                            value: '${widget.result.incorrectAnswers}',
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Start Quiz Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomQuizButton(
                      text: 'PLAY AGAIN',
                      isLoading: false,
                      onPressed: () {
                        // Reset quiz state and result before starting a new game
                        ref.read(quizControllerProvider.notifier).resetQuiz();
                        ref.read(quizResultProvider.notifier).state = null;
                        screenController.startQuiz();
                        context.go('/category-selection');
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Confetti overlay - only show for excellent scores while animating
          if (widget.result.percentage >= 80 && _confettiController.value < 1.0)
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    pieces: _confettiPieces,
                    animationValue: _confettiController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: (color ?? Colors.grey.shade600).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon, 
            size: 24.sp, 
            color: color ?? Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.balooTamma2(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.balooTamma2(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class ConfettiPiece {
  double x;
  double y;
  double rotation;
  final double speed;
  final double rotationSpeed;
  final Color color;
  final double size;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.rotation,
    required this.speed,
    required this.rotationSpeed,
    required this.color,
    required this.size,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> pieces;
  final double animationValue;

  ConfettiPainter({required this.pieces, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Only animate if animation is still running
    if (animationValue >= 1.0) {
      return; // Animation completed, don't draw anything
    }

    final paint = Paint();

    for (final piece in pieces) {
      // Update position based on animation progress
      final progress = animationValue;

      // Calculate current position
      final currentY =
          piece.y + (piece.speed * progress * 5); // 5 seconds total
      final currentRotation =
          piece.rotation + (piece.rotationSpeed * progress * 5);

      // Only draw if piece is visible on screen
      if (currentY > -0.1 && currentY < 1.1) {
        // Draw confetti piece
        paint.color = piece.color.withValues(
          alpha: (1.0 - progress * 0.5),
        ); // Fade out over time

        final x = piece.x * size.width;
        final y = currentY * size.height;

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(currentRotation);

        // Draw different shapes
        if (piece.size > 15) {
          // Rectangle confetti
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: piece.size,
                height: piece.size * 0.6,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
        } else {
          // Circle confetti
          canvas.drawCircle(Offset.zero, piece.size * 0.5, paint);
        }

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ConfettiPainter &&
        (oldDelegate.animationValue != animationValue) &&
        animationValue < 1.0; // Stop repainting when animation is complete
  }
}
