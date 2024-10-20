// lib/widgets/results_list.dart

import 'package:flutter/material.dart';
import '../models/content_model.dart';
import '../services/api_service.dart';
import '../screens/content_detail_screen.dart';

class ResultsList extends StatelessWidget {
  final List<ContentModel> results;

  ResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return Container();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(result.metadata['reference'] ?? result.title),
          subtitle: Text(
            result.summary.length > 100
                ? result.summary.substring(0, 100) + '...'
                : result.summary,
          ),
          onTap: () async {
            try {
              final content = await ApiService.getContent(result.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetailScreen(
                    content: content,
                    title: result.title,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error fetching content: $e')),
              );
            }
          },
        );
      },
    );
  }
}
