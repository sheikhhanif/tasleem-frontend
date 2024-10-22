import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'package:characters/characters.dart'; // Import characters package

class FullContentModal extends StatelessWidget {
  final ContentModel document;
  final String title; // Dynamic title

  FullContentModal({
    required this.document,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Header with Icon and Dynamic Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.article,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title, // Dynamic title
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, height: 1),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child:
                  _buildRichText(document.summary, textTheme, colorScheme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to build rich text content
  Widget _buildRichText(
      String content, TextTheme textTheme, ColorScheme colorScheme) {
    // Apply preprocessing to content
    String processedContent = _preprocessContent(content);

    List<TextSpan> textSpans =
    _parseContentToTextSpans(processedContent, textTheme, colorScheme);

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: TextAlign.justify, // Justify the text content
    );
  }

  // Method to preprocess content based on Flutter logic
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

  // Detects if the text contains Arabic characters.
  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  // Returns a TextStyle based on whether the text contains Arabic and if it should be bold.
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

  // Method to parse processed content to TextSpan list
  List<TextSpan> _parseContentToTextSpans(
      String content, TextTheme textTheme, ColorScheme colorScheme) {
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
}
