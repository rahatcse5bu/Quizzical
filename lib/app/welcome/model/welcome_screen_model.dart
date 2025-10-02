class WelcomeScreenState {
  final bool isNavigating;
  final bool isLoading;
  final String? error;

  const WelcomeScreenState({
    this.isNavigating = false,
    this.isLoading = false,
    this.error,
  });

  WelcomeScreenState copyWith({
    bool? isNavigating,
    bool? isLoading,
    String? error,
  }) {
    return WelcomeScreenState(
      isNavigating: isNavigating ?? this.isNavigating,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  WelcomeScreenState clearError() {
    return copyWith(error: null);
  }
}

class WelcomeScreenModel {
  final String appTitle;
  final String subtitle;
  final String buttonText;
  final List<WelcomeIcon> decorativeIcons;

  const WelcomeScreenModel({
    this.appTitle = 'Quizzical',
    this.subtitle = 'Test Your Knowledge & Have Fun!',
    this.buttonText = 'GET STARTED',
    this.decorativeIcons = const [
      WelcomeIcon(icon: 'lightbulb', color: 0xFFFFC107),
      WelcomeIcon(icon: 'psychology', color: 0xFF9C27B0),
      WelcomeIcon(icon: 'school', color: 0xFF2196F3),
      WelcomeIcon(icon: 'emoji_events', color: 0xFFFF9800),
    ],
  });
}

class WelcomeIcon {
  final String icon;
  final int color;

  const WelcomeIcon({
    required this.icon,
    required this.color,
  });
}