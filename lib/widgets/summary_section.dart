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
                size: 24, // Reduced size
              ),
              SizedBox(width: 8),
              Text(
                'Summary',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 20, // Reduced font size
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Display summary content
          MarkdownBody(
            data: summary,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14, // Reduced font size for better readability
                height: 1.5,
              ),
              h1: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 20, // Reduced font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
