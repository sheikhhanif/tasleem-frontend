// lib/widgets/full_content_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/content_model.dart';

class FullContentModal extends StatelessWidget {
  final ContentModel document;

  FullContentModal({required this.document});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Initial size of the modal
      minChildSize: 0.4, // Minimum size when dragged down
      maxChildSize: 0.95, // Maximum size (almost full screen)
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
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
              // Header with Icon and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.article,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24, // Reduced size
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Full Content',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 18, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.of(context).pop(),
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
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14, // Reduced font size
                        height: 1.5,
                      ),
                      h1: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 20, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
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
