import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/category_selection_model.dart';
import '../../../core/models/trivia_category.dart';
import '../../../core/services/trivia_api_service.dart';
import '../../../core/services/category_image_service.dart';
import '../../../core/providers/service_providers.dart';

class CategorySelectionController extends StateNotifier<CategorySelectionState> {
  final TriviaApiService _apiService;
  final CategoryImageService _imageService;

  CategorySelectionController(this._apiService, this._imageService) 
      : super(const CategorySelectionState()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final List<TriviaCategory> triviaCategories = await _apiService.getCategories();
      final List<QuizCategory> quizCategories = triviaCategories
          .map((trivia) => QuizCategory.fromTriviaCategory(
                id: trivia.id,
                name: trivia.name,
              ))
          .toList();

      // Set categories first (without images)
      state = state.copyWith(
        isLoading: false,
        categories: quizCategories,
      );

      // Load images in background
      _loadCategoryImages(quizCategories);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _loadCategoryImages(List<QuizCategory> categories) async {
    final updatedCategories = <QuizCategory>[];

    for (final category in categories) {
      try {
        // Check cache first
        String? cachedUrl = CategoryImageCache.getCachedUrl(category.name);
        
        if (cachedUrl != null) {
          updatedCategories.add(category.copyWithImageUrl(cachedUrl));
        } else {
          // Fetch image URL
          final imageUrl = await _imageService.getCategoryImageUrl(category.name);
          CategoryImageCache.cacheUrl(category.name, imageUrl);
          updatedCategories.add(category.copyWithImageUrl(imageUrl));
        }
      } catch (e) {
        // Keep category without image on error
        updatedCategories.add(category);
      }
    }

    // Update state with images
    state = state.copyWith(categories: updatedCategories);
  }

  void selectCategory(QuizCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearSelection() {
    state = state.copyWith(selectedCategory: null);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void clearError() {
    state = state.clearError();
  }

  void refreshCategories() {
    _loadCategories();
  }
}

final categorySelectionControllerProvider =
    StateNotifierProvider<CategorySelectionController, CategorySelectionState>(
  (ref) {
    final apiService = ref.watch(triviaApiServiceProvider);
    final imageService = ref.watch(categoryImageServiceProvider);
    return CategorySelectionController(apiService, imageService);
  },
);

final categorySelectionModelProvider = Provider<CategorySelectionModel>(
  (ref) => const CategorySelectionModel(),
);