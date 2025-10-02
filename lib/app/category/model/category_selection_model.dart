class CategorySelectionState {
  final bool isLoading;
  final List<QuizCategory> categories;
  final QuizCategory? selectedCategory;
  final String? error;

  const CategorySelectionState({
    this.isLoading = false,
    this.categories = const [],
    this.selectedCategory,
    this.error,
  });

  CategorySelectionState copyWith({
    bool? isLoading,
    List<QuizCategory>? categories,
    QuizCategory? selectedCategory,
    String? error,
  }) {
    return CategorySelectionState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error ?? this.error,
    );
  }

  CategorySelectionState clearError() {
    return copyWith(error: null);
  }
}

class QuizCategory {
  final int id;
  final String name;
  final String icon;
  final int color;
  final int questionCount;
  final String? imageUrl;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.questionCount,
    this.imageUrl,
  });

  /// Creates a QuizCategory from API TriviaCategory
  factory QuizCategory.fromTriviaCategory({
    required int id,
    required String name,
    String? imageUrl,
  }) {
    return QuizCategory(
      id: id,
      name: name,
      icon: _getIconForCategory(name),
      color: _getColorForCategory(name),
      questionCount: 10, // Default question count
      imageUrl: imageUrl,
    );
  }

  /// Creates a copy of this QuizCategory with updated imageUrl
  QuizCategory copyWithImageUrl(String imageUrl) {
    return QuizCategory(
      id: id,
      name: name,
      icon: icon,
      color: color,
      questionCount: questionCount,
      imageUrl: imageUrl,
    );
  }


  static String _getIconForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('entertainment') && lowerName.contains('film')) {
      return 'movie';
    } else if (lowerName.contains('entertainment') && lowerName.contains('music')) {
      return 'music_note';
    } else if (lowerName.contains('entertainment') && lowerName.contains('book')) {
      return 'menu_book';
    } else if (lowerName.contains('entertainment') && lowerName.contains('television')) {
      return 'tv';
    } else if (lowerName.contains('entertainment') && lowerName.contains('video_games')) {
      return 'sports_esports';
    } else if (lowerName.contains('science')) {
      return 'science';
    } else if (lowerName.contains('sports')) {
      return 'sports_soccer';
    } else if (lowerName.contains('history')) {
      return 'history_edu';
    } else if (lowerName.contains('geography')) {
      return 'public';
    } else if (lowerName.contains('art')) {
      return 'palette';
    } else if (lowerName.contains('animals')) {
      return 'pets';
    } else if (lowerName.contains('mythology')) {
      return 'auto_stories';
    } else if (lowerName.contains('politics')) {
      return 'account_balance';
    } else if (lowerName.contains('celebrities')) {
      return 'star';
    } else if (lowerName.contains('vehicles')) {
      return 'directions_car';
    } else {
      return 'quiz';
    }
  }

  static int _getColorForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('entertainment')) {
      return 0xFFE91E63; // Pink
    } else if (lowerName.contains('science')) {
      return 0xFF4CAF50; // Green
    } else if (lowerName.contains('sports')) {
      return 0xFFF44336; // Red
    } else if (lowerName.contains('history')) {
      return 0xFFFF9800; // Orange
    } else if (lowerName.contains('geography')) {
      return 0xFF2196F3; // Blue
    } else if (lowerName.contains('art')) {
      return 0xFF9C27B0; // Purple
    } else if (lowerName.contains('animals')) {
      return 0xFF4CAF50; // Green
    } else if (lowerName.contains('mythology')) {
      return 0xFF795548; // Brown
    } else if (lowerName.contains('politics')) {
      return 0xFF607D8B; // Blue Grey
    } else {
      return 0xFF2196F3; // Default Blue
    }
  }
}

class CategorySelectionModel {
  final String screenTitle;

  const CategorySelectionModel({
    this.screenTitle = 'Select Category',
  });
}