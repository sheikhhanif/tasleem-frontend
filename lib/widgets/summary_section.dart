// lib/widgets/summary_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SummarySection extends StatelessWidget {
  final String summary;

  SummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Icon and Title
        Row(
          children: [
            Icon(
              Icons.summarize_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20, // Adjusted size
            ),
            SizedBox(width: 8),
            Text(
              'Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18, // Adjusted font size for better readability
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Display summary content without justification
        MarkdownBody(
          data: summary,
          styleSheet: MarkdownStyleSheet(
            p: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16, // Increased font size for better readability
              height: 1.6, // Increased line height for comfort
            ),
            h1: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20, // Adjusted font size
              fontWeight: FontWeight.bold,
            ),
            // Additional styling as needed
          ),
        ),
      ],
    );
  }
}
