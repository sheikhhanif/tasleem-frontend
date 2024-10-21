// lib/screens/search_result_screen.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import '../widgets/summary_section.dart';
import '../widgets/swipeable_cards.dart';
import '../services/api_service.dart';
import '../models/content_model.dart';
import 'dart:async'; // For StreamSubscription

class SearchResultScreen extends StatefulWidget {
  final Function(SearchResultScreenState) onInitialize; // Callback to pass state
  final VoidCallback onClose; // Callback when modal is closed

  SearchResultScreen({
    required this.onInitialize,
    required this.onClose,
  });

  @override
  SearchResultScreenState createState() => SearchResultScreenState();
}

class SearchResultScreenState extends State<SearchResultScreen> {
  List<SearchResult> _searchResults = [];
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  // List to keep track of all active stream subscriptions
  List<StreamSubscription<Map<String, dynamic>>> _searchSubscriptions = [];

  @override
  void initState() {
    super.initState();
    widget.onInitialize(this); // Pass the state reference
    // Listen for when the modal is closed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addLocalHistoryEntry(
        LocalHistoryEntry(onRemove: widget.onClose),
      );
    });
  }

  @override
  void dispose() {
    // Cancel all active stream subscriptions to prevent memory leaks
    for (var subscription in _searchSubscriptions) {
      subscription.cancel();
    }
    _searchSubscriptions.clear();
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Method to add a new search query
  void addSearchQuery(String query) {
    // Create a new SearchResult and add it to the beginning of the list
    final newSearchResult = SearchResult(query: query, isLoading: true);
    setState(() {
      _searchResults.insert(0, newSearchResult);
    });

    // Start listening to the stream for this search
    final subscription = ApiService.askQuestion(query).listen(
          (data) {
        if (data.containsKey('answer')) {
          setState(() {
            newSearchResult.aiSummary += data['answer'];
          });
        }
        if (data.containsKey('context')) {
          final List<dynamic> docs = data['context'];
          setState(() {
            newSearchResult.contextDocuments.addAll(
              docs.map((doc) => ContentModel.fromJson(doc)).toList(),
            );
          });
        }
        if (data.containsKey('error')) {
          setState(() {
            newSearchResult.isError = true;
            newSearchResult.isLoading = false;
          });
          // Optionally, you can cancel the subscription upon error
          // subscription.cancel();
        }
      },
      onError: (e) {
        setState(() {
          newSearchResult.isError = true;
          newSearchResult.isLoading = false;
        });
      },
      onDone: () {
        setState(() {
          newSearchResult.isLoading = false;
        });
        // No auto-scroll; remove or comment out the _scrollToBottom() call
        // _scrollToBottom();
      },
    );

    // Add the subscription to the list for management
    _searchSubscriptions.add(subscription);
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      addSearchQuery(query);
      _searchController.clear();
      _focusNode.unfocus(); // Unfocus the TextField to exit typing mode
    }
  }

  // Removed _scrollToBottom method as auto-scroll is disabled
  /*
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), // Quick scroll to adjust view
          curve: Curves.easeOut,
        );
      }
    });
  }
  */

  // Shimmer Placeholder for SummarySection
  Widget _buildShimmerSummarySection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1),
      highlightColor: colorScheme.onSurface.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Placeholder
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 10),
          // Summary Placeholder
          Container(
            width: double.infinity,
            height: 80.0, // Adjust height based on your summary's typical size
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // Shimmer Placeholder for SwipeableCards
  Widget _buildShimmerSwipeableCards() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1),
      highlightColor: colorScheme.onSurface.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Placeholder
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Container(
                width: 100,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 6),
          // Swipeable Cards Placeholder
          Container(
            height: 150, // Adjusted height for the swipeable card
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Simulated PageView with shimmer
                Expanded(
                  child: PageView.builder(
                    itemCount: 3, // Number of shimmer cards
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                // Page Indicator Placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // General Shimmer Loader
  Widget _buildShimmerLoader({
    required double height,
    double width = double.infinity,
    BorderRadius? borderRadius,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.1),
      highlightColor: colorScheme.onSurface.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withOpacity(0.5), // Theme-based color
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Search Result Content
        Expanded(
          child: _searchResults.isEmpty
              ? Center(
            child: Text(
              'No search results.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          )
              : ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.onSurface.withOpacity(0.2),
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Query Title
                    Text(
                      result.query,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16), // Increased spacing between title and summary

                    // Display AI Summary or Shimmer
                    result.isLoading && result.aiSummary.isEmpty
                        ? _buildShimmerSummarySection()
                        : (result.aiSummary.isNotEmpty
                        ? SummarySection(
                      summary: result.aiSummary,
                    )
                        : SizedBox.shrink()),

                    SizedBox(height: 16), // Increased spacing between summary and references

                    // Display Swipeable Cards or Shimmer
                    result.isLoading && result.contextDocuments.isEmpty
                        ? _buildShimmerSwipeableCards()
                        : (result.contextDocuments.isNotEmpty
                        ? SwipeableCards(
                      documents: result.contextDocuments,
                    )
                        : SizedBox.shrink()),

                    // Loading Indicator or Shimmer
                    if (result.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: _buildShimmerLoader(
                          height: 20.0,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                    // Error Message
                    if (result.isError)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'An error occurred while fetching the content.',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        // Search Bar at the bottom of the modal
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Expanded Search Field
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white, // Set color based on theme
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5.0), // Left padding inside the search box
                      // Expanded TextField without prefixIcon
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onSubmitted: (_) => _handleSearch(),
                          decoration: InputDecoration(
                            hintText: 'Ask more questions...',
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.black.withOpacity(0.6), // Adjust hint color
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, // Adjust vertical padding as needed
                              horizontal: 8.0, // Add horizontal padding if needed
                            ),
                          ),
                          style: textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black, // Set text color
                          ),
                          cursorColor: isDarkMode ? Colors.white : Colors.black, // Set cursor color
                        ),
                      ),
                      // Send Icon Button inside the search box
                      IconButton(
                        icon: Icon(Icons.send,
                            color: isDarkMode ? Colors.white : Colors.black), // Adjust icon color
                        onPressed: _handleSearch,
                        tooltip: 'Send',
                      ),
                      SizedBox(width: 1.0), // Right padding inside the search box
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Model to hold individual search results
class SearchResult {
  final String query;
  String aiSummary;
  List<ContentModel> contextDocuments;
  bool isLoading;
  bool isError;

  SearchResult({
    required this.query,
    this.aiSummary = '',
    List<ContentModel>? contextDocuments,
    this.isLoading = false,
    this.isError = false,
  }) : this.contextDocuments = contextDocuments ?? [];
}
