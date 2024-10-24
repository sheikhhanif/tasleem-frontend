// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/explore_provider.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Current selected filter: 'All', 'Tafsir', 'Hadith', 'Fatwa'
  String _selectedFilter = 'All';

  // PageController with viewportFraction less than 1 to show part of next card
  final PageController _pageController = PageController(
    viewportFraction: 0.93, // Adjust this value as needed
  );

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_scrollListener);
  }

  /// Listener to detect when user reaches the last page to load more articles.
  void _scrollListener() {
    final exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
    if (_pageController.position.atEdge) {
      bool isTop = _pageController.position.pixels == 0;
      if (!isTop) {
        // User has scrolled to the bottom (last page)
        if (exploreProvider.hasMore && !exploreProvider.isLoadingMore) {
          exploreProvider.loadMoreArticles();
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_scrollListener);
    _pageController.dispose();
    super.dispose();
  }

  /// Determines the image path based on the article's id prefix.
  String _getImagePath(String id) {
    if (id.startsWith('H')) {
      return 'assets/images/hadith.png';
    } else if (id.startsWith('TIK')) {
      return 'assets/images/tafsir.png';
    } else {
      return 'assets/images/fatwa.png';
    }
  }

  /// Builds the filter buttons row, including the "All" button.
  Widget _buildFilterButtons(
      BuildContext context, ExploreProvider exploreProvider) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton(context, 'All', exploreProvider),
          _buildFilterButton(context, 'Tafsir', exploreProvider),
          _buildFilterButton(context, 'Hadith', exploreProvider),
          _buildFilterButton(context, 'Fatwa', exploreProvider),
        ],
      ),
    );
  }

  /// Builds an individual filter button with theme support.
  Widget _buildFilterButton(
      BuildContext context, String label, ExploreProvider exploreProvider) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = label;
          exploreProvider.applyFilter(label);
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: _selectedFilter == label
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.3),
          width: 1.0,
        ),
        backgroundColor: Colors.transparent, // No background color
        foregroundColor: _selectedFilter == label
            ? colorScheme.secondary
            : colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded edges
        ),
        minimumSize: Size(60, 30), // Adjusted size
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds a shimmer effect placeholder mimicking the loading content.
  Widget _buildShimmerPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1),
      highlightColor: colorScheme.onSurface.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Shimmer for Title
            Container(
              width: double.infinity,
              height: 24.0,
              color: Colors.white,
            ),
            SizedBox(height: 8.0),

            // Shimmer for Summary
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
            SizedBox(height: 16.0),

            // Shimmer for Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite Button Placeholder
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
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Access ExploreProvider to manage explore items
    final exploreProvider = Provider.of<ExploreProvider>(context);

    // Get the filtered list of articles
    final filteredArticles = exploreProvider.articles;

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
                  'Explore',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
            ),

            // Filter Buttons Row
            _buildFilterButtons(context, exploreProvider),

            // Explore Screen Content
            Expanded(
              child: exploreProvider.isLoading && filteredArticles.isEmpty
                  ? _buildShimmerPlaceholder(context) // Initial Loading Shimmer
                  : exploreProvider.errorMessage.isNotEmpty
                  ? Center(
                child: Text(
                  exploreProvider.errorMessage,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : filteredArticles.isEmpty
                  ? Center(
                child: Text(
                  'No content available.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              )
                  : Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: exploreProvider.hasMore
                        ? filteredArticles.length + 1
                        : filteredArticles.length,
                    itemBuilder: (context, index) {
                      if (index < filteredArticles.length) {
                        final article = filteredArticles[index];
                        final imagePath = _getImagePath(article.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical:
                            4.0, // Add vertical padding
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width:
                                1.5, // Adjust border width as needed
                              ),
                              borderRadius: BorderRadius.circular(
                                  20.0), // Make the card more rounded
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Match the border radius
                              child: ArticleCard(
                                article: article,
                                imagePath: imagePath,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Shimmer Placeholder for Loading More
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius:
                              BorderRadius.circular(20.0),
                            ),
                            child: Shimmer.fromColors(
                              baseColor:
                              colorScheme.onSurface.withOpacity(0.1),
                              highlightColor:
                              colorScheme.onSurface.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    // Shimmer for Title
                                    Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8.0),

                                    // Shimmer for Summary
                                    Container(
                                      width: double.infinity,
                                      height: 16.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 4.0),
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 16.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 16.0),

                                    // Shimmer for Action Buttons
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Favorite Button Placeholder
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
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  // Optional: Loading indicator at the bottom
                  if (exploreProvider.isLoadingMore)
                    Positioned(
                      bottom: 16.0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
