// lib/widgets/article_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import 'package:characters/characters.dart'; // Import characters package
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart'; // Import the provider
import '../utils/text_utils.dart'; // Import TextUtils
import 'package:share_plus/share_plus.dart'; // Import the share_plus package

class ArticleCard extends StatelessWidget {
  final Article article;
  final String imagePath; // Parameter for image path

  ArticleCard({required this.article, required this.imagePath});

  /// Launches the given URL in the default browser.
  Future<void> _launchURL(String url, BuildContext context) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the source URL.')),
      );
    }
  }

  /// Determines the category based on the article ID.
  String _getCategory() {
    if (article.id.startsWith('H')) {
      return 'Hadith';
    } else if (article.id.startsWith('TIK')) {
      return 'Tafsir';
    } else if (article.id.startsWith('F')) {
      return 'Fatwa';
    } else {
      return 'Article';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final maxCardHeight = MediaQuery.of(context).size.height * 0.8;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxCardHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ), // Light grey border
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          color: Colors.transparent, // No background color
        ),
        clipBehavior: Clip.antiAlias, // Ensures the child is clipped properly
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Full Overlay
            Stack(
              children: [
                // Image Section
                _buildImageSection(),

                // Full Overlay
                Container(
                  height: 100, // Match the image height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
                  ),
                ),

                // Positioned Buttons and Title within the Overlay
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0, // Ensure padding at the bottom
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Category Button
                          _buildCategoryButton(context, colorScheme, textTheme),

                          // Source Button
                          _buildSourceButton(context, colorScheme, textTheme),
                        ],
                      ),
                      SizedBox(height: 8.0),

                      // Title with Scrollable Effect
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0), // Add padding between buttons and title
                          child: Container(
                            // Removed decoration color for title container as per user instruction
                            child: SingleChildScrollView(
                              child: Text(
                                TextUtils.preprocessTitle(article.title),
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildContent(context, textTheme, colorScheme),
              ),
            ),

            // **Added Buttons Section**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Love Button (Left)
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final isFavorite = favoritesProvider.isFavorite(article);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? colorScheme.onSurface.withOpacity(0.7) : colorScheme.onSurface.withOpacity(0.7),
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            favoritesProvider.removeArticle(article);

                          } else {
                            favoritesProvider.addArticle(article);

                          }
                        },
                        tooltip: isFavorite ? 'Remove from History' : 'Add to History',
                      );
                    },
                  ),

                  // Share Button (Right)
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    onPressed: () {
                      // Share the article title and link
                      Share.share('${article.title}\n${article.link}');
                    },
                    tooltip: 'Share',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the image section using asset images.
  Widget _buildImageSection() {
    return Image.asset(
      imagePath, // Use the provided image path
      height: 100, // Original small height
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 100,
          color: Colors.grey.shade200, // Light grey background for error
          child: Icon(Icons.image, color: Colors.grey, size: 50),
        );
      },
    );
  }

  /// Builds the Category Button with original design.
  Widget _buildCategoryButton(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        // Implement navigation or filtering based on category
        // Example: Navigate to category-specific screen
        print('Category: ${_getCategory()}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: colorScheme.tertiary, // Original button color
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          _getCategory(),
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white, // Original text color
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Builds the Source Button with original design.
  Widget _buildSourceButton(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => _launchURL(article.link, context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: colorScheme.secondary, // Original button color
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'Source',
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white, // Original text color
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Displays the content of the article.
  Widget _buildContent(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    // Preprocess the article content using TextUtils
    final formattedContent = TextUtils.preprocessContent(article.content);

    return SingleChildScrollView(
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: TextUtils.parseContentToTextSpans(
            formattedContent,
            textTheme,
            colorScheme,
          ),
        ),
      ),
    );
  }
}
