// lib/widgets/history_article_card.dart

import 'package:flutter/material.dart';
import '../models/article.dart';
import '../utils/text_utils.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryArticleCard extends StatelessWidget {
  final Article article;

  HistoryArticleCard({required this.article});

  /// Launches the given URL in the default browser.
  Future<void> _launchURL(String url, BuildContext context) async {
    if (url.isEmpty) return; // Do nothing if the link is empty

    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the source URL.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // Implement expand/collapse if needed
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Divider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextUtils.preprocessTitle(article.title),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1.0,
                ),
              ],
            ),
            SizedBox(height: 8.0),

            // Summary and Optional Arrow Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded Summary Text
                Expanded(
                  child: Text(
                    article.content,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.6,
                    ),
                  ),
                ),
                // Conditionally show the Source Icon if link exists
                if (article.link.isNotEmpty)
                  Icon(
                    Icons.link,
                    color: colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),

            // Action Buttons (if needed)
            // You can add buttons here if required, ensuring the Source button is omitted
          ],
        ),
      ),
    );
  }
}
