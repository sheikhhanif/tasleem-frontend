// lib/widgets/full_content_modal.dart

import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'package:characters/characters.dart'; // Import characters package
import '../utils/text_utils.dart'; // Import TextUtils
import 'package:share_plus/share_plus.dart'; // Import share_plus if needed
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher if needed

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
                        TextUtils.preprocessTitle(title), // Use TextUtils for title preprocessing
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
                  child: _buildRichText(document.summary, textTheme, colorScheme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to build rich text content using TextUtils
  Widget _buildRichText(
      String content, TextTheme textTheme, ColorScheme colorScheme) {
    // Apply preprocessing to content using TextUtils
    String processedContent = TextUtils.preprocessContent(content);

    List<TextSpan> textSpans = TextUtils.parseContentToTextSpans(
      processedContent,
      textTheme,
      colorScheme,
    );

    return RichText(
      textAlign: TextAlign.justify, // Justify the text content
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
