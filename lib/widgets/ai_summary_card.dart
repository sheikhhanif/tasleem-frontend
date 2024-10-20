// lib/widgets/ai_summary_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AISummaryCard extends StatelessWidget {
  final String summary;

  AISummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MarkdownBody(
          data: summary,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      ),
    );
  }
}
