import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import 'package:characters/characters.dart'; // Import characters package

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

  /// Preprocesses content by formatting bold text and handling line breaks.
  String _preprocessContent(String content) {
    // Handle bold text wrapped with double asterisks (**)
    content = content.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
          (match) => '\u{001B}${match[1]}\u{001B}', // Using escape sequence for custom parsing
    );

    // Replace single newlines where the previous character is not a punctuation mark with a space
    content = content.replaceAllMapped(
      RegExp(r'([^.,;:!?"])\n+'),
          (match) => '${match[1]} ',
    );

    // Replace remaining single newlines (after punctuation) with actual line breaks
    content = content.replaceAll(
      RegExp(r'[\n]+'),
      '\n\n',
    );

    // Remove extra spaces within lines (multiple spaces between words)
    content = content.replaceAll(
      RegExp(r'[^\S\n]+'), // Matches whitespace except newlines
      ' ',
    );

    // Trim leading and trailing whitespaces
    content = content.trim();

    return content;
  }

  /// Detects if the text contains Arabic characters.
  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  /// Returns a TextStyle based on whether the text contains Arabic and if it should be bold.
  TextStyle _getTextStyle({
    required bool isBold,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required String text,
  }) {
    bool isArabic = _containsArabic(text);
    return textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      height: 1.6,
      color: colorScheme.onBackground,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: isArabic ? 'Scheherazade' : null,
    ) ??
        TextStyle();
  }

  /// Parses preprocessed content into TextSpan for rendering rich text.
  List<TextSpan> _parseContentToTextSpans(
      String content,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    List<TextSpan> textSpans = [];

    // Split the content by '\n\n' for handling line breaks
    List<String> parts = content.split('\n\n');

    for (String part in parts) {
      // Check if part contains bold text (wrapped in escape sequences)
      if (part.contains('\u{001B}')) {
        bool isBold = false;
        part.split('\u{001B}').forEach((segment) {
          if (segment.isNotEmpty) {
            textSpans.add(
              TextSpan(
                text: segment,
                style: _getTextStyle(
                  isBold: isBold,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  text: segment,
                ),
              ),
            );
          }
          isBold = !isBold; // Toggle bold
        });
      } else {
        // Regular paragraph segment
        textSpans.add(
          TextSpan(
            text: part,
            style: _getTextStyle(
              isBold: false,
              textTheme: textTheme,
              colorScheme: colorScheme,
              text: part,
            ),
          ),
        );
      }

      // Add a line break between paragraphs
      textSpans.add(
        TextSpan(text: '\n\n'),
      );
    }

    return textSpans;
  }

  /// Truncates the given text to a specified length without breaking characters.
  String _truncateText(String text, int maxLength) {
    final Characters characters = text.characters;
    if (characters.length > maxLength) {
      return characters.take(maxLength).toString() + '...';
    }
    return text;
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
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: (textTheme.titleSmall?.fontSize ?? 16) * 2 * 1.2, // Approx. height for 2 lines
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _preprocessTitle(article.title),
                                  style: textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
          ],
        ),
      ),
    );
  }

  /// Preprocesses the title by removing extra spaces and newlines.
  String _preprocessTitle(String title) {
    // Replace newlines with spaces and trim extra spaces
    return title.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
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
    // Preprocess the article content
    final formattedContent = _preprocessContent(article.content);

    return SingleChildScrollView(
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: _parseContentToTextSpans(
            formattedContent,
            textTheme,
            colorScheme,
          ),
        ),
      ),
    );
  }
}
