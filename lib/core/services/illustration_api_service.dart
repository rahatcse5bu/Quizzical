import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching category illustrations from various public APIs
class IllustrationApiService {
  static const String _unsplashAccessKey = 'UNSPLASH_ACCESS_KEY';
  static const String _icons8ApiKey = 'ICONS8_API_KEY';

  /// Fetch illustration from Unsplash API
  /// Free tier: 50 requests per hour
  /// access key: https://unsplash.com/developers
  static Future<String?> getUnsplashIllustration(String categoryName) async {
    try {
      final query = _getCategorySearchQuery(categoryName);
      final url = Uri.parse(
        'https://api.unsplash.com/search/photos?query=$query&per_page=1&orientation=squarish'
      );
      
      final response = await http.get(
        url,
        headers: {'Authorization': 'Client-ID $_unsplashAccessKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        if (results.isNotEmpty) {
          final imageUrl = results[0]['urls']['small'] as String;
          return imageUrl;
        }
      }
    } catch (e) {
      // Log error silently - will fall back to local illustrations
    }
    return null;
  }

  /// Fetch illustration from Icons8 API
  static Future<String?> getIcons8Illustration(String categoryName) async {
    try {
      final query = _getCategorySearchQuery(categoryName);
      final url = Uri.parse(
        'https://search.icons8.com/api/iconsets/v5/search?term=$query&amount=1&format=png&size=100'
      );
      
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_icons8ApiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final icons = data['icons'] as List;
        
        if (icons.isNotEmpty) {
          final iconUrl = icons[0]['url'] as String;
          return iconUrl;
        }
      }
    } catch (e) {
      // Log error silently - will fall back to local illustrations
    }
    return null;
  }

  /// Get unDraw illustrations (free, no API key required)
  /// Note: unDraw doesn't have a search API, but provides direct SVG URLs
  static String? getUnDrawIllustration(String categoryName) {
    final unDrawMap = {
      'general knowledge': 'https://undraw.co/api/illustrations/books',
      'entertainment: books': 'https://undraw.co/api/illustrations/reading_time',
      'entertainment: film': 'https://undraw.co/api/illustrations/movie_night',
      'entertainment: music': 'https://undraw.co/api/illustrations/music',
      'entertainment: television': 'https://undraw.co/api/illustrations/netflix',
      'entertainment: video games': 'https://undraw.co/api/illustrations/gaming',
      'science & nature': 'https://undraw.co/api/illustrations/science',
      'science: computers': 'https://undraw.co/api/illustrations/programming',
      'science: mathematics': 'https://undraw.co/api/illustrations/mathematics',
      'sports': 'https://undraw.co/api/illustrations/sports',
      'geography': 'https://undraw.co/api/illustrations/world',
      'history': 'https://undraw.co/api/illustrations/ancient',
      'politics': 'https://undraw.co/api/illustrations/elections',
      'art': 'https://undraw.co/api/illustrations/arts',
      'animals': 'https://undraw.co/api/illustrations/pets',
      'vehicles': 'https://undraw.co/api/illustrations/transport',
    };

    return unDrawMap[categoryName.toLowerCase()];
  }

  /// Get Storyset illustrations (free with attribution)
  /// Direct links to their illustrations
  static String? getStoreysetIllustration(String categoryName) {
    final storeysetMap = {
      'general knowledge': 'https://storyset.com/illustration/knowledge/pana',
      'entertainment: books': 'https://storyset.com/illustration/book-lover/pana',
      'entertainment: film': 'https://storyset.com/illustration/movie-night/pana',
      'entertainment: music': 'https://storyset.com/illustration/music/pana',
      'entertainment: television': 'https://storyset.com/illustration/home-cinema/pana',
      'entertainment: video games': 'https://storyset.com/illustration/gaming/pana',
      'science & nature': 'https://storyset.com/illustration/science/pana',
      'science: computers': 'https://storyset.com/illustration/programming/pana',
      'science: mathematics': 'https://storyset.com/illustration/mathematics/pana',
      'sports': 'https://storyset.com/illustration/sports/pana',
      'geography': 'https://storyset.com/illustration/world/pana',
      'history': 'https://storyset.com/illustration/history/pana',
      'politics': 'https://storyset.com/illustration/elections/pana',
      'art': 'https://storyset.com/illustration/art/pana',
      'animals': 'https://storyset.com/illustration/animals/pana',
      'vehicles': 'https://storyset.com/illustration/transport/pana',
    };

    return storeysetMap[categoryName.toLowerCase()];
  }

  /// Helper method to convert category names to search queries
  static String _getCategorySearchQuery(String categoryName) {
    final queryMap = {
      'general knowledge': 'brain education knowledge',
      'entertainment: books': 'books reading literature',
      'entertainment: film': 'movie cinema film',
      'entertainment: music': 'music notes instruments',
      'entertainment: television': 'television tv screen',
      'entertainment: video games': 'gaming controller console',
      'entertainment: comics': 'comics superhero illustration',
      'entertainment: japanese anime & manga': 'anime manga japan',
      'entertainment: cartoon & animations': 'cartoon animation',
      'science & nature': 'science nature laboratory',
      'science: computers': 'computer technology programming',
      'science: mathematics': 'mathematics calculation numbers',
      'sports': 'sports ball game',
      'geography': 'world map globe earth',
      'history': 'history ancient monuments',
      'politics': 'politics government democracy',
      'art': 'art painting creativity',
      'animals': 'animals pets wildlife',
      'vehicles': 'vehicles cars transport',
      'mythology': 'mythology ancient gods',
      'celebrities': 'celebrities stars fame',
    };

    return queryMap[categoryName.toLowerCase()] ?? categoryName;
  }

  /// Comprehensive method that tries multiple APIs
  static Future<String?> getCategoryIllustration(String categoryName) async {
    // Try free options first
    String? illustrationUrl = getStoreysetIllustration(categoryName);
    if (illustrationUrl != null) return illustrationUrl;

    illustrationUrl = getUnDrawIllustration(categoryName);
    if (illustrationUrl != null) return illustrationUrl;

    // Try paid APIs if API keys are configured
    if (_unsplashAccessKey != 'YOUR_UNSPLASH_ACCESS_KEY') {
      illustrationUrl = await getUnsplashIllustration(categoryName);
      if (illustrationUrl != null) return illustrationUrl;
    }

    if (_icons8ApiKey != 'YOUR_ICONS8_API_KEY') {
      illustrationUrl = await getIcons8Illustration(categoryName);
      if (illustrationUrl != null) return illustrationUrl;
    }

    return null; // Fallback to local icons
  }
}

/// Configuration class for API keys
class IllustrationApiConfig {
  static const String unsplashAccessKey = 'UNSPLASH_ACCESS_KEY';
  static const String icons8ApiKey = 'ICONS8_API_KEY';
  static const String flatIconApiKey = 'FLATICON_API_KEY';
  
  /// Instructions for getting API keys:
  /// 
  /// Unsplash API:
  /// 1. Go to https://unsplash.com/developers
  /// 2. Create a developer account
  /// 3. Create a new application
  /// 4. Copy your Access Key
  /// 
  /// Icons8 API:
  /// 1. Go to https://developers.icons8.com/
  /// 2. Sign up for an account
  /// 3. Get your API key from dashboard
  /// 
  /// Flaticon API:
  /// 1. Go to https://www.flaticon.com/api
  /// 2. Register for API access
  /// 3. Get your API token
}