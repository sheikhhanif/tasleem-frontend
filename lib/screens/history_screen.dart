// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../providers/favorites_provider.dart'; // Import FavoritesProvider
import '../models/article.dart';
import '../utils/text_utils.dart'; // Import TextUtils
import 'package:share_plus/share_plus.dart'; // Import the share_plus package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for launching URLs
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class HistoryScreen extends StatefulWidget { // Changed to StatefulWidget
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Current selected filter: 'Favorite', 'Search', 'All'
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Access FavoritesProvider to get favorite articles
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteArticles = favoritesProvider.favoriteArticles;
    final isLoading = favoritesProvider.isLoading; // **Assuming FavoritesProvider has isLoading**

    // Filter articles based on the selected filter
    List<Article> filteredArticles;
    if (_selectedFilter == 'Favorite') {
      filteredArticles =
          favoriteArticles.where((article) => article.link.isNotEmpty).toList();
    } else if (_selectedFilter == 'Search') {
      filteredArticles =
          favoriteArticles.where((article) => article.link.isEmpty).toList();
    } else { // 'All'
      filteredArticles = favoriteArticles;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor:
        colorScheme.background, // Use theme background color
        body: Column(
          children: [
            // Centered App Title
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Center(
                child: Text(
                  'History',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
            ),

            // **Filter Buttons Row**
            _buildFilterButtons(context),

            // **Content Section**
            Expanded(
              child: isLoading
                  ? _buildShimmerHistoryPlaceholder(context) // Shimmer when loading
                  : filteredArticles.isEmpty
                  ? Center(
                child: Text(
                  'No history yet.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: HistoryArticleCard(article: article),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the filter buttons row with three buttons: Favorite, Search, All
  Widget _buildFilterButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton(context, 'All'),
          _buildFilterButton(context, 'Favorite'),
          _buildFilterButton(context, 'Search'),
        ],
      ),
    );
  }

  /// Builds an individual filter button with theme support.
  Widget _buildFilterButton(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool isSelected = _selectedFilter == label;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.3),
          width: 1.0,
        ),
        backgroundColor: Colors.transparent, // No background color
        foregroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded edges
        ),
        minimumSize: Size(80, 30), // Adjusted size
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface,
        ),
      ),
    );
  }

  /// Builds a shimmer effect placeholder for HistoryScreen when data is loading.
  Widget _buildShimmerHistoryPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1),
      highlightColor: colorScheme.onSurface.withOpacity(0.3),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        itemCount: 5, // Number of shimmer cards to display
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
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
                  // Shimmer for Title
                  Container(
                    width: double.infinity,
                    height: 24.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4.0),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1.0,
                  ),
                  SizedBox(height: 8.0),

                  // Shimmer for Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16.0,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4.0),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 16.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),

                  // Shimmer for Action Buttons
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Love Button Placeholder
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Share Button Placeholder
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Another Button Placeholder (if needed)
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A custom widget that displays an article in an expandable, compact card without an image.
class HistoryArticleCard extends StatefulWidget {
  final Article article;

  HistoryArticleCard({required this.article});

  @override
  _HistoryArticleCardState createState() => _HistoryArticleCardState();
}

class _HistoryArticleCardState extends State<HistoryArticleCard> {
  bool _isExpanded = false; // Tracks whether the card is expanded

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          //color: colorScheme.surface, // Match ArticleCard's background color
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5, // Border width as per requirement
          ),
        ),
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // **Title with iOS-like Divider**
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TextUtils.preprocessTitle(widget.article.title), // Use TextUtils for title preprocessing
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: _isExpanded ? null : 2,
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

        // **Content and Arrow Button**
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded Content Text
            Expanded(
              child: _isExpanded
                  ? RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: TextUtils.parseContentToTextSpans(
                    TextUtils.preprocessContent(widget.article.content),
                    textTheme,
                    colorScheme,
                  ),
                ),
              )
                  : Text(
                TextUtils.truncateText(widget.article.content, 200).replaceAll("\n", " "),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.6,
                ),
                maxLines: 3, // Restricts the text to a single line
                overflow: TextOverflow.ellipsis, // Adds ellipsis (...) if text overflows
                softWrap: true,
              ),
            )],
            ),

            // **Action Buttons (Visible Only When Expanded)**
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Love Button
                    Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, child) {
                        final isFavorite = favoritesProvider.isFavorite(widget.article);
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? colorScheme.onSurface.withOpacity(0.7) : colorScheme.onSurface.withOpacity(0.7),
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              favoritesProvider.removeArticle(widget.article);

                            } else {
                              favoritesProvider.addArticle(widget.article);

                            }
                          },
                          tooltip: isFavorite ? 'Remove from History' : 'Add to History',
                        );
                      },
                    ),

                    // **Conditionally Show Source Button Only If Link Exists**
                    if (widget.article.link.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.link_sharp,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        onPressed: () {
                          // Launch the source URL
                          _launchURL(widget.article.link);
                        },
                        tooltip: 'Source',
                      ),

                    // Share Button
                    IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      onPressed: () {
                        // Share the article title and link
                        Share.share('${widget.article.title}\n${widget.article.link}');
                      },
                      tooltip: 'Share',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Launches the given URL in the default browser.
  void _launchURL(String url) async {
    if (url.isEmpty) return; // Do nothing if the link is empty

    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the source URL.')),
      );
    }
  }
}
