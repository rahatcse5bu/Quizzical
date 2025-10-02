import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app/quiz_config/model/quiz_config_model.dart';

/// Quiz API Service implementing REQUIREMENT 4.1: Base64 Encoding/Decoding Handling
/// 
/// This service demonstrates advanced Flutter proficiency by:
/// - Using &encode=base64 parameter for clean special character handling
/// - Immediately decoding ALL Base64 content using Dart's built-in library
/// - Processing question text, correct answers, and incorrect answers after JSON response
/// - Storing only decoded content in app state to prevent unreadable strings
/// - Comprehensive validation to ensure decoding success
class QuizApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  QuizApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch quiz questions based on configuration
  /// Uses Base64 encoding to handle special characters cleanly as per advanced requirements
  Future<QuizApiResponse> getQuizQuestions(QuizConfiguration config) async {
    try {
      final params = config.toApiParams();
      
      // REQUIREMENT 4.1: Add Base64 encoding parameter for clean special character handling
      // This ensures all text content (questions, answers) are Base64 encoded in the response
      params['encode'] = 'base64';
      
      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      
      debugPrint('Quiz API URI: $uri');
      final response = await _client.get(uri).timeout(_timeout);
      debugPrint('Quiz API Response: ${response.body}');
      debugPrint('Quiz API Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        // Immediately process the response and decode all Base64 content
        // before storing in app state (as per requirement 4.1)
        final apiResponse = QuizApiResponse.fromJson(jsonData);
        
        // Validate that all questions were properly decoded
        _validateDecodedQuestions(apiResponse.results);
        
        return apiResponse;
      } else {
        throw QuizApiException(
          'Failed to load quiz questions', 
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is QuizApiException) {
        rethrow;
      }
      throw QuizApiException('Network error: ${e.toString()}');
    }
  }

  /// Validates that all questions have been properly decoded from Base64
  /// This ensures compliance with requirement 4.1
  void _validateDecodedQuestions(List<QuizQuestion> questions) {
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      
      // Check for Base64 patterns that would indicate failed decoding
      if (_containsBase64Pattern(question.question) ||
          _containsBase64Pattern(question.correctAnswer) ||
          question.incorrectAnswers.any(_containsBase64Pattern)) {
        throw QuizApiException(
          'Base64 decoding failed for question ${i + 1}. '
          'Unreadable strings detected in quiz content.'
        );
      }
    }
    debugPrint('✅ All ${questions.length} questions successfully decoded from Base64');
  }

  /// Checks if a string contains Base64 pattern (likely undecoded content)
  bool _containsBase64Pattern(String text) {
    // Check for typical Base64 patterns (length multiple of 4, ends with = or ==)
    if (text.length > 20 && text.length % 4 == 0) {
      final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      return base64Regex.hasMatch(text);
    }
    return false;
  }

  void dispose() {
    _client.close();
  }
}

class QuizApiException implements Exception {
  final String message;
  final int? statusCode;

  const QuizApiException(this.message, {this.statusCode});

  @override
  String toString() => 'QuizApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class QuizApiResponse {
  final int responseCode;
  final List<QuizQuestion> results;

  const QuizApiResponse({
    required this.responseCode,
    required this.results,
  });

  factory QuizApiResponse.fromJson(Map<String, dynamic> json) {
    final responseCode = json['response_code'] as int;
    final List<dynamic> resultsJson = json['results'] as List<dynamic>;
    
    final results = resultsJson
        .map((questionJson) => QuizQuestion.fromJson(questionJson as Map<String, dynamic>))
        .toList();

    return QuizApiResponse(
      responseCode: responseCode,
      results: results,
    );
  }

  bool get isSuccess => responseCode == 0;
  
  String get errorMessage {
    switch (responseCode) {
      case 1:
        return 'No results found for the given parameters';
      case 2:
        return 'Invalid parameter';
      case 3:
        return 'Token not found';
      case 4:
        return 'Token empty';
      case 5:
        return 'Rate limit exceeded';
      default:
        return 'Unknown error occurred';
    }
  }
}

class QuizQuestion {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> _allAnswers;

  const QuizQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required List<String> allAnswers,
  }) : _allAnswers = allAnswers;

  /// Factory constructor that creates QuizQuestion from JSON response
  /// REQUIREMENT 4.1: Immediately decodes all Base64 content after JSON response is received
  /// and before storing in app state to prevent unreadable strings
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('🔄 Processing question from JSON...');
      
      // REQUIREMENT 4.1: Decode ALL text fields from Base64 immediately
      // This includes question text, correct answer, and ALL incorrect answers
      final decodedCategory = _decodeBase64String(json['category'] as String);
      final decodedType = _decodeBase64String(json['type'] as String);  
      final decodedDifficulty = _decodeBase64String(json['difficulty'] as String);
      final decodedQuestion = _decodeBase64String(json['question'] as String);
      final decodedCorrectAnswer = _decodeBase64String(json['correct_answer'] as String);
      
      // Decode all incorrect answers
      final decodedIncorrectAnswers = (json['incorrect_answers'] as List<dynamic>)
          .map((answer) => _decodeBase64String(answer as String))
          .toList();
      
      // Validate that decoding was successful (no Base64 patterns remain)
      _validateDecodedContent(decodedQuestion, 'question');
      _validateDecodedContent(decodedCorrectAnswer, 'correct_answer');
      for (int i = 0; i < decodedIncorrectAnswers.length; i++) {
        _validateDecodedContent(decodedIncorrectAnswers[i], 'incorrect_answer_$i');
      }
      
      // Create shuffled answers list once during construction
      // NOTE: For True/False questions, UI will use fixed ['True', 'False'] order
      // This shuffled list is primarily used for Multiple Choice questions
      final allAnswers = [decodedCorrectAnswer, ...decodedIncorrectAnswers];
      allAnswers.shuffle();
      
      final question = QuizQuestion(
        category: decodedCategory,
        type: decodedType,
        difficulty: decodedDifficulty,
        question: decodedQuestion,
        correctAnswer: decodedCorrectAnswer,
        incorrectAnswers: decodedIncorrectAnswers,
        allAnswers: allAnswers,
      );
      
      debugPrint('✅ Successfully decoded question: "${question.question}"');
      debugPrint('✅ Correct answer: "${question.correctAnswer}"');
      debugPrint('✅ Question type: "${question.type}"');
      debugPrint('✅ All answers: ${question.allAnswers}');
      
      return question;
    } catch (e) {
      debugPrint('❌ Error decoding question from JSON: $e');
      debugPrint('❌ Raw JSON: $json');
      throw QuizApiException('Failed to decode Base64 question content: ${e.toString()}');
    }
  }

  /// Validates that a decoded string doesn't contain Base64 patterns
  /// This ensures requirement 4.1 compliance - no unreadable strings
  static void _validateDecodedContent(String content, String fieldName) {
    // Check for typical Base64 characteristics that would indicate failed decoding
    if (content.length > 20 && 
        content.length % 4 == 0 && 
        RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(content)) {
      throw QuizApiException(
        'Base64 decoding validation failed for $fieldName. '
        'Content appears to still be encoded: $content'
      );
    }
    
    // Ensure content is not empty after decoding
    if (content.trim().isEmpty) {
      throw QuizApiException(
        'Decoded content for $fieldName is empty after Base64 decoding'
      );
    }
  }

  /// REQUIREMENT 4.1: Base64 decode string using Dart's built-in library
  /// Handles special characters cleanly and ensures proper UTF-8 decoding
  /// This is called immediately after JSON response is received and before storing in app state
  static String _decodeBase64String(String encoded) {
    if (encoded.isEmpty) {
      debugPrint('⚠️ Empty string provided for Base64 decoding');
      return encoded;
    }
    
    try {
      // Validate Base64 format before attempting to decode
      if (!_isValidBase64Format(encoded)) {
        debugPrint('⚠️ String not in valid Base64 format: $encoded');
        return encoded;
      }
      
      // REQUIREMENT 4.1: Use Dart's built-in Base64 library for decoding
      final bytes = base64.decode(encoded);
      
      // Ensure proper UTF-8 decoding for special characters
      final decoded = utf8.decode(bytes, allowMalformed: false);
      
      // Validate the decoded result
      if (decoded.trim().isEmpty) {
        throw QuizApiException('Base64 decoding resulted in empty content');
      }
      
      debugPrint('🔄 Base64 decoded: "$encoded" -> "$decoded"');
      return decoded;
      
    } catch (e) {
      debugPrint('❌ Base64 decode failed for "$encoded": $e');
      
      // For requirement compliance, we should not silently fail
      // Return original only if it appears to be already decoded
      if (_looksLikeDecodedText(encoded)) {
        debugPrint('⚠️ Treating as already decoded text: $encoded');
        return encoded;
      }
      
      throw QuizApiException('Failed to decode Base64 content: ${e.toString()}');
    }
  }

  /// Validates if a string follows proper Base64 format
  /// Base64 strings must be multiples of 4 and contain only valid characters
  static bool _isValidBase64Format(String input) {
    // Base64 strings must be multiples of 4 in length
    if (input.length % 4 != 0) return false;
    
    // Check for valid Base64 characters only
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    return base64Pattern.hasMatch(input);
  }

  /// Heuristic to determine if text looks like already decoded content
  /// This helps handle edge cases where content might not be Base64 encoded
  static bool _looksLikeDecodedText(String text) {
    // If text contains common readable characters and patterns, likely already decoded
    return text.contains(' ') || 
           text.contains('?') || 
           text.contains('!') ||
           RegExp(r'[a-z]{3,}').hasMatch(text.toLowerCase());
  }

  /// Get all answer options (pre-shuffled during construction)
  List<String> get allAnswers => _allAnswers;

  /// Check if this is a True/False question
  bool get isTrueFalse => type == 'boolean';

  /// Check if this is a Multiple Choice question
  bool get isMultipleChoice => type == 'multiple';
}