// lib/widgets/summary_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SummarySection extends StatelessWidget {
  final String summary;

  SummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Column(
        key: ValueKey<String>(summary),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon and Title
          Row(
            children: [
              Icon(
                Icons.summarize,
                color: Theme.of(context).colorScheme.primary,
                size: 20, // Adjusted size
              ),
              SizedBox(width: 8),
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18, // Adjusted font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Display summary content with justified alignment
          MarkdownBody(
            data: summary,
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14, // Adjusted font size
                height: 1.5,
              ),
              h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20, // Adjusted font size
                fontWeight: FontWeight.bold,
              ),
              // Add more styles if necessary
            ),
            // Enable text alignment by wrapping MarkdownBody in a Container with alignment
            // since MarkdownBody does not support text alignment directly
            // Alternatively, use custom extensions or parse the markdown differently
          ),
        ],
      ),
    );
  }
}
