import 'package:flutter/material.dart';

class CategoryIllustrations {
  static const Map<String, CategoryVisual> _categoryVisuals = {
    // General Knowledge
    'general knowledge': CategoryVisual(
      gradient: [Color(0xFF4A90E2), Color(0xFF7BB3F7)],
      emoji: '🧠',
      illustration: Icons.psychology_outlined,
    ),
    
    // Entertainment - Books
    'entertainment: books': CategoryVisual(
      gradient: [Color(0xFF6BCF7F), Color(0xFF4CAF50)],
      emoji: '📚',
      illustration: Icons.menu_book_outlined,
    ),
    
    // Entertainment - Film
    'entertainment: film': CategoryVisual(
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF5252)],
      emoji: '🎬',
      illustration: Icons.movie_outlined,
    ),
    
    // Entertainment - Music
    'entertainment: music': CategoryVisual(
      gradient: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
      emoji: '🎵',
      illustration: Icons.music_note_outlined,
    ),
    
    // Entertainment - Television
    'entertainment: television': CategoryVisual(
      gradient: [Color(0xFFFFB74D), Color(0xFFFF9800)],
      emoji: '📺',
      illustration: Icons.tv_outlined,
    ),
    
    // Entertainment - Video Games
    'entertainment: video games': CategoryVisual(
      gradient: [Color(0xFF26C6DA), Color(0xFF00BCD4)],
      emoji: '🎮',
      illustration: Icons.sports_esports_outlined,
    ),
    
    // Science & Nature
    'science & nature': CategoryVisual(
      gradient: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
      emoji: '🔬',
      illustration: Icons.science_outlined,
    ),
    
    // Science - Computers
    'science: computers': CategoryVisual(
      gradient: [Color(0xFF42A5F5), Color(0xFF2196F3)],
      emoji: '💻',
      illustration: Icons.computer_outlined,
    ),
    
    // Science - Mathematics
    'science: mathematics': CategoryVisual(
      gradient: [Color(0xFFEF5350), Color(0xFFF44336)],
      emoji: '📐',
      illustration: Icons.calculate_outlined,
    ),
    
    // Sports
    'sports': CategoryVisual(
      gradient: [Color(0xFFFF7043), Color(0xFFFF5722)],
      emoji: '⚽',
      illustration: Icons.sports_soccer_outlined,
    ),
    
    // Geography
    'geography': CategoryVisual(
      gradient: [Color(0xFF29B6F6), Color(0xFF03A9F4)],
      emoji: '🌍',
      illustration: Icons.public_outlined,
    ),
    
    // History
    'history': CategoryVisual(
      gradient: [Color(0xFFFFCA28), Color(0xFFFFC107)],
      emoji: '🏛️',
      illustration: Icons.history_edu_outlined,
    ),
    
    // Politics
    'politics': CategoryVisual(
      gradient: [Color(0xFF78909C), Color(0xFF607D8B)],
      emoji: '🏛️',
      illustration: Icons.account_balance_outlined,
    ),
    
    // Art
    'art': CategoryVisual(
      gradient: [Color(0xFFAB47BC), Color(0xFF9C27B0)],
      emoji: '🎨',
      illustration: Icons.palette_outlined,
    ),
    
    // Animals
    'animals': CategoryVisual(
      gradient: [Color(0xFF8BC34A), Color(0xFF689F38)],
      emoji: '🐾',
      illustration: Icons.pets_outlined,
    ),
    
    // Vehicles
    'vehicles': CategoryVisual(
      gradient: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
      emoji: '🚗',
      illustration: Icons.directions_car_outlined,
    ),
    
    // Mythology
    'mythology': CategoryVisual(
      gradient: [Color(0xFFD4AF37), Color(0xFFB8860B)],
      emoji: '🏺',
      illustration: Icons.auto_stories_outlined,
    ),
    
    // Celebrities
    'celebrities': CategoryVisual(
      gradient: [Color(0xFFE91E63), Color(0xFFC2185B)],
      emoji: '⭐',
      illustration: Icons.star_outlined,
    ),
    
    // Entertainment - Comics
    'entertainment: comics': CategoryVisual(
      gradient: [Color(0xFF7E57C2), Color(0xFF673AB7)],
      emoji: '💥',
      illustration: Icons.auto_awesome_outlined,
    ),
    
    // Entertainment - Japanese Anime & Manga
    'entertainment: japanese anime & manga': CategoryVisual(
      gradient: [Color(0xFFEC407A), Color(0xFFE91E63)],
      emoji: '🎌',
      illustration: Icons.face_retouching_natural_outlined,
    ),
    
    // Entertainment - Cartoon & Animations
    'entertainment: cartoon & animations': CategoryVisual(
      gradient: [Color(0xFFFF7043), Color(0xFFFF5722)],
      emoji: '🎪',
      illustration: Icons.animation_outlined,
    ),
  };

  static CategoryVisual getCategoryVisual(String categoryName) {
    final key = categoryName.toLowerCase();
    return _categoryVisuals[key] ?? _getDefaultVisual();
  }

  static CategoryVisual _getDefaultVisual() {
    return const CategoryVisual(
      gradient: [Color(0xFF9E9E9E), Color(0xFF757575)],
      emoji: '❓',
      illustration: Icons.help_outline,
    );
  }
}

class CategoryVisual {
  final List<Color> gradient;
  final String emoji;
  final IconData illustration;

  const CategoryVisual({
    required this.gradient,
    required this.emoji,
    required this.illustration,
  });
}