import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/trivia_api_service.dart';
import '../services/category_image_service.dart';

final triviaApiServiceProvider = Provider<TriviaApiService>((ref) {
  final service = TriviaApiService();
  
  // Dispose the service when the provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

final categoryImageServiceProvider = Provider<CategoryImageService>((ref) {
  final service = CategoryImageService();
  
  // Dispose the service when the provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});