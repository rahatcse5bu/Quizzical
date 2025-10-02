class TriviaCategory {
  final int id;
  final String name;

  const TriviaCategory({
    required this.id,
    required this.name,
  });

  factory TriviaCategory.fromJson(Map<String, dynamic> json) {
    return TriviaCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'TriviaCategory(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TriviaCategory && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class TriviaCategoriesResponse {
  final List<TriviaCategory> triviaCategories;

  const TriviaCategoriesResponse({
    required this.triviaCategories,
  });

  factory TriviaCategoriesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoriesList = json['trivia_categories'] as List<dynamic>;
    final List<TriviaCategory> categories = categoriesList
        .map((category) => TriviaCategory.fromJson(category as Map<String, dynamic>))
        .toList();

    return TriviaCategoriesResponse(
      triviaCategories: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trivia_categories': triviaCategories.map((category) => category.toJson()).toList(),
    };
  }
}