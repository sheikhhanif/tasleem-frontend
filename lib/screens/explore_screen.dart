import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/explore_provider.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';

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
              child: exploreProvider.isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
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
                  : PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
