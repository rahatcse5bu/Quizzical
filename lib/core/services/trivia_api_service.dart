import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trivia_category.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class TriviaApiService {
  static const String _baseUrl = 'https://opentdb.com';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  TriviaApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all available trivia categories
  Future<List<TriviaCategory>> getCategories() async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/api_category.php');
      
      final response = await _client
          .get(uri)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
        final TriviaCategoriesResponse categoriesResponse = TriviaCategoriesResponse.fromJson(jsonData);
        
        return categoriesResponse.triviaCategories;
      } else {
        throw ApiException(
          'Failed to load categories', 
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Dispose of the HTTP client
  void dispose() {
    _client.close();
  }
}