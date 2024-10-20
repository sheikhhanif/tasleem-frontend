// lib/widgets/full_content_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/content_model.dart';

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
      initialChildSize: 0.7, // Initial size of the modal
      minChildSize: 0.4, // Minimum size when dragged down
      maxChildSize: 0.95, // Maximum size (almost full screen)
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
                  child: MarkdownBody(
                    data: document.summary,
                    styleSheet: MarkdownStyleSheet(
                      p: textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.6,
                        color: colorScheme.onBackground,
                      ),
                      h1: textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      // Additional styles as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
