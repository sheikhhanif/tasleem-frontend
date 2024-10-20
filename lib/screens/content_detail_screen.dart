// lib/screens/content_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/content_model.dart';

class ContentDetailScreen extends StatelessWidget {
  final String content;
  final String title;

  ContentDetailScreen({required this.content, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 18, // Reduced font size
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(
          data: content,
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
    );
  }
}
