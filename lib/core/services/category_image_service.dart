import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryImageService {
  // Unsplash API (Free - no key needed for basic usage, but rate limited)
  static const String _unsplashBaseUrl = 'https://api.unsplash.com/search/photos';
  
  // Pexels API
  static const String _pexelsApiKey = 'rGG0lxnqRo8VsbyCdebeK3QRKUWomAltPjPAF8LHCqyxbOgqK6nEA3Ap';
  static const String _pexelsBaseUrl = 'https://api.pexels.com/v1/search';
  
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  CategoryImageService({http.Client? client}) : _client = client ?? http.Client();

  /// Get image URL for a specific category
  Future<String> getCategoryImageUrl(String categoryName) async {
    try {
      // Check cache first
      final cachedUrl = CategoryImageCache.getCachedUrl(categoryName);
      if (cachedUrl != null) return cachedUrl;

      // Try Pexels first (has API key)
      final pexelsUrl = await _getPexelsImage(categoryName);
      if (pexelsUrl != null) {
        CategoryImageCache.cacheUrl(categoryName, pexelsUrl);
        return pexelsUrl;
      }

      // Try Unsplash as backup
      final unsplashUrl = await _getUnsplashImage(categoryName);
      if (unsplashUrl != null) {
        CategoryImageCache.cacheUrl(categoryName, unsplashUrl);
        return unsplashUrl;
      }

      // Fallback to predefined images
      final fallbackUrl = _getFallbackImageUrl(categoryName);
      CategoryImageCache.cacheUrl(categoryName, fallbackUrl);
      return fallbackUrl;
    } catch (e) {
      // Return fallback image on any error
      final fallbackUrl = _getFallbackImageUrl(categoryName);
      CategoryImageCache.cacheUrl(categoryName, fallbackUrl);
      return fallbackUrl;
    }
  }

  Future<String?> _getPexelsImage(String categoryName) async {
    try {
      final query = _getCategorySearchQuery(categoryName);
      final uri = Uri.parse('$_pexelsBaseUrl?query=transparent ${Uri.encodeComponent(query)} png icon illustration&per_page=5&orientation=landscape');

      final response = await _client.get(
        uri,
        headers: {
          'Authorization': _pexelsApiKey,
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final photos = data['photos'] as List<dynamic>?;

        if (photos != null && photos.isNotEmpty) {
          // Look for the best image that might have transparent background
          for (final photo in photos) {
            final photoMap = photo as Map<String, dynamic>;
            final alt = (photoMap['alt'] as String? ?? '').toLowerCase();
            
            // Prefer images with transparent-related keywords in alt text
            // if (alt.contains('transparent') || alt.contains('icon') || alt.contains('logo') || alt.contains('symbol')) {
              final src = photoMap['src'] as Map<String, dynamic>?;
              if (src != null) {
                return src['medium'] as String?;
              }
            // }
          }
          
          // Fallback to first image if no transparent-specific image found
          final firstPhoto = photos[0] as Map<String, dynamic>;
          final src = firstPhoto['src'] as Map<String, dynamic>?;
          if (src != null) {
            return src['medium'] as String?;
          }
        }
      }
    } catch (e) {
      // Silently fail and try next source
    }
    return null;
  }

  Future<String?> _getUnsplashImage(String categoryName) async {
    try {
      final query = _getCategorySearchQuery(categoryName);
      final uri = Uri.parse('$_unsplashBaseUrl?query=${Uri.encodeComponent(query)}+transparent+icon+illustration&per_page=5&orientation=landscape');

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Note: Unsplash allows limited requests without API key
          // For production use, add your Unsplash Access Key:
          // 'Authorization': 'Client-ID YOUR_ACCESS_KEY',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;

        if (results != null && results.isNotEmpty) {
          // Look for images with transparent or icon-related descriptions
          for (final result in results) {
            final resultMap = result as Map<String, dynamic>;
            final description = (resultMap['description'] as String? ?? '').toLowerCase();
            final altDescription = (resultMap['alt_description'] as String? ?? '').toLowerCase();
            
            // Prefer images with transparent-related keywords
            if (description.contains('transparent') || description.contains('icon') || 
                altDescription.contains('transparent') || altDescription.contains('icon') ||
                description.contains('logo') || altDescription.contains('logo')) {
              final urls = resultMap['urls'] as Map<String, dynamic>?;
              if (urls != null) {
                return urls['regular'] as String?;
              }
            }
          }
          
          // Fallback to first result if no transparent-specific image found
          final firstResult = results[0] as Map<String, dynamic>;
          final urls = firstResult['urls'] as Map<String, dynamic>?;
          if (urls != null) {
            return urls['regular'] as String?;
          }
        }
      }
    } catch (e) {
      // Silently fail and use fallback
    }
    return null;
  }

  String _getCategorySearchQuery(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    
    // Map category names to icon and illustration terms for transparent backgrounds
    if (lowerName.contains('general knowledge')) return 'brain icon education symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('books')) return 'book icon library symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('film')) return 'movie icon cinema symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('music')) return 'music note icon headphones symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('television')) return 'tv icon television symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('video games')) return 'gamepad icon gaming symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('comics')) return 'comic icon superhero symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('anime')) return 'anime icon japanese symbol';
    if (lowerName.contains('entertainment') && lowerName.contains('cartoon')) return 'cartoon icon animation symbol';
    if (lowerName.contains('science') && lowerName.contains('nature')) return 'microscope icon science symbol';
    if (lowerName.contains('science') && lowerName.contains('computers')) return 'computer icon technology symbol';
    if (lowerName.contains('science') && lowerName.contains('mathematics')) return 'calculator icon math symbol';
    if (lowerName.contains('sports')) return 'sports icon fitness symbol';
    if (lowerName.contains('geography')) return 'globe icon world symbol';
    if (lowerName.contains('history')) return 'history icon ancient symbol';
    if (lowerName.contains('politics')) return 'government icon building symbol';
    if (lowerName.contains('art')) return 'palette icon painting symbol';
    if (lowerName.contains('animals')) return 'animal icon wildlife symbol';
    if (lowerName.contains('vehicles')) return 'car icon vehicle symbol';
    if (lowerName.contains('mythology')) return 'mythology icon ancient symbol';
    if (lowerName.contains('celebrities')) return 'star icon celebrity symbol';
    
    // Clean up and return sanitized category name with icon suffix
    final cleanName = categoryName
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .replaceAll(':', '')
        .replaceAll('&', 'and')
        .toLowerCase()
        .trim();
    
    return '$cleanName icon symbol';
  }

  String _getFallbackImageUrl(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    
    // Use transparent PNG icons from reliable icon services
    final iconName = _getIconName(lowerName);
    final categoryId = _getCategoryId(lowerName);
    
    // Try different transparent icon services based on category ID
    if (categoryId % 3 == 0) {
      // Icons8 - colored transparent icons
      return 'https://img.icons8.com/color/400/$iconName.png';
    } else if (categoryId % 3 == 1) {
      // Icons8 - fluent style transparent icons
      return 'https://img.icons8.com/fluent/400/$iconName.png';
    } else {
      // Icons8 - office style transparent icons
      return 'https://img.icons8.com/office/400/$iconName.png';
    }
  }
  
  String _getIconName(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    
    // Map categories to specific icon names for transparent PNG icons
    if (lowerName.contains('general knowledge')) return 'brain';
    if (lowerName.contains('entertainment') && lowerName.contains('books')) return 'book';
    if (lowerName.contains('entertainment') && lowerName.contains('film')) return 'movie';
    if (lowerName.contains('entertainment') && lowerName.contains('music')) return 'music';
    if (lowerName.contains('entertainment') && lowerName.contains('television')) return 'tv';
    if (lowerName.contains('entertainment') && lowerName.contains('video games')) return 'controller';
    if (lowerName.contains('entertainment') && lowerName.contains('comics')) return 'comics';
    if (lowerName.contains('entertainment') && lowerName.contains('anime')) return 'anime';
    if (lowerName.contains('entertainment') && lowerName.contains('cartoon')) return 'animation';
    if (lowerName.contains('science') && lowerName.contains('nature')) return 'microscope';
    if (lowerName.contains('science') && lowerName.contains('computers')) return 'computer';
    if (lowerName.contains('science') && lowerName.contains('mathematics')) return 'calculator';
    if (lowerName.contains('sports')) return 'sports';
    if (lowerName.contains('geography')) return 'globe';
    if (lowerName.contains('history')) return 'history';
    if (lowerName.contains('politics')) return 'government';
    if (lowerName.contains('art')) return 'palette';
    if (lowerName.contains('animals')) return 'animals';
    if (lowerName.contains('vehicles')) return 'car';
    if (lowerName.contains('mythology')) return 'mythology';
    if (lowerName.contains('celebrities')) return 'star';
    
    // Default fallback
    return 'question-mark';
  }

  int _getCategoryId(String categoryName) {
    // Generate consistent IDs for categories using hash
    final hash = categoryName.hashCode.abs();
    // Use modulo to keep within a reasonable range of good Picsum images
    return (hash % 200) + 100; // IDs between 100-300 generally have good images
  }

  /// Batch fetch images for multiple categories
  Future<Map<String, String>> getCategoryImagesUrls(List<String> categoryNames) async {
    final Map<String, String> results = {};
    
    // Process categories in parallel for better performance
    final futures = categoryNames.map((categoryName) async {
      try {
        final url = await getCategoryImageUrl(categoryName);
        return MapEntry(categoryName, url);
      } catch (e) {
        return MapEntry(categoryName, _getFallbackImageUrl(categoryName));
      }
    });
    
    final entries = await Future.wait(futures);
    
    for (final entry in entries) {
      results[entry.key] = entry.value;
    }
    
    return results;
  }

  /// Preload images for categories to improve user experience
  Future<void> preloadCategoryImages(List<String> categoryNames) async {
    // Only preload if not already cached
    final uncachedCategories = categoryNames
        .where((name) => CategoryImageCache.getCachedUrl(name) == null)
        .toList();
    
    if (uncachedCategories.isNotEmpty) {
      await getCategoryImagesUrls(uncachedCategories);
    }
  }

  void dispose() {
    _client.close();
  }
}

class CategoryImageCache {
  static final Map<String, String> _cache = {};
  
  static String? getCachedUrl(String categoryName) {
    return _cache[categoryName.toLowerCase()];
  }
  
  static void cacheUrl(String categoryName, String url) {
    _cache[categoryName.toLowerCase()] = url;
  }
}