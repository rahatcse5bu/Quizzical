import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/category_selection_model.dart';
import '../../../shared/constants/category_illustrations.dart';
import '../../../core/services/illustration_api_service.dart';

class EnhancedCategoryCard extends StatefulWidget {
  final QuizCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool useApiIllustrations;

  const EnhancedCategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.useApiIllustrations = false,
  });

  @override
  State<EnhancedCategoryCard> createState() => _EnhancedCategoryCardState();
}

class _EnhancedCategoryCardState extends State<EnhancedCategoryCard> {
  String? _apiIllustrationUrl;
  bool _isLoadingIllustration = false;

  @override
  void initState() {
    super.initState();
    if (widget.useApiIllustrations) {
      _loadApiIllustration();
    }
  }

  Future<void> _loadApiIllustration() async {
    setState(() => _isLoadingIllustration = true);
    
    try {
      final url = await IllustrationApiService.getCategoryIllustration(
        widget.category.name,
      );
      if (mounted) {
        setState(() {
          _apiIllustrationUrl = url;
          _isLoadingIllustration = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingIllustration = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final visual = CategoryIllustrations.getCategoryVisual(widget.category.name);
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: visual.gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: visual.gradient[0].withValues(alpha: 0.3),
              blurRadius: widget.isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: widget.isSelected 
              ? Border.all(color: Colors.white, width: 3)
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with illustration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration (API or local)
                  _buildIllustrationWidget(visual),
                  
                  // Selection indicator
                  if (widget.isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Category name and info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatCategoryName(widget.category.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.category.questionCount} questions',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationWidget(CategoryVisual visual) {
    if (widget.useApiIllustrations) {
      if (_isLoadingIllustration) {
        return _buildLoadingPlaceholder();
      }
      
      if (_apiIllustrationUrl != null) {
        return _buildApiIllustration(visual);
      }
    }
    // return Text("testing");
    // Fallback to local icon illustration
    return _buildLocalIllustration(visual);
  }

  Widget _buildApiIllustration(CategoryVisual visual) {
    return Container(
      width: 50,
      height: 50,
      // decoration: BoxDecoration(
      //   color: Colors.white.withValues(alpha: 0.2),
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: _apiIllustrationUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) => _buildLocalIllustration(visual),
        ),
      ),
    );
  }

  Widget _buildLocalIllustration(CategoryVisual visual) {
    return Container(
      width: 50,
      height: 50,
      // decoration: BoxDecoration(
      //   color: Colors.white.withValues(alpha: 0.2),
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Center(
        child: Icon(
          visual.illustration,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      ),
    );
  }

  String _formatCategoryName(String name) {
    // Remove "Entertainment:" prefix and clean up category names
    String formatted = name
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .trim();
    
    // Capitalize first letter of each word
    return formatted.split(' ')
        .map((word) => word.isNotEmpty 
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }
}