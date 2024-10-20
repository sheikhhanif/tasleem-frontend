// lib/screens/search_result_screen.dart

import 'package:flutter/material.dart';
import '../widgets/summary_section.dart';
import '../widgets/swipeable_cards.dart';
import '../services/api_service.dart';
import '../models/content_model.dart';

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
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Method to add a new search query
  void addSearchQuery(String query) {
    setState(() {
      _searchResults.add(SearchResult(query: query, isLoading: true));
    });

    _performSearch(query);
  }

  void _performSearch(String query) async {
    try {
      await for (final data in ApiService.askQuestion(query)) {
        if (data.containsKey('answer')) {
          setState(() {
            _searchResults.last.aiSummary += data['answer'];
          });
        }
        if (data.containsKey('context')) {
          final List<dynamic> docs = data['context'];
          setState(() {
            _searchResults.last.contextDocuments.addAll(
              docs.map((doc) => ContentModel.fromJson(doc)).toList(),
            );
          });
        }
        if (data.containsKey('error')) {
          setState(() {
            _searchResults.last.isError = true;
            _searchResults.last.isLoading = false;
          });
          // Removed SnackBar as per your request
          return;
        }
      }
    } catch (e) {
      setState(() {
        _searchResults.last.isError = true;
        _searchResults.last.isLoading = false;
      });
      // Removed SnackBar as per your request
    } finally {
      setState(() {
        _searchResults.last.isLoading = false;
      });
      _scrollToNewItemAtTop();
    }
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      addSearchQuery(query);
      _searchController.clear();
      _focusNode.unfocus(); // Unfocus the TextField to exit typing mode
    }
  }

  void _scrollToNewItemAtTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Calculate the target scroll position to attempt to position the bottom of the last item at the top of the viewport
        final currentPosition = _scrollController.position.pixels;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final viewportHeight = _scrollController.position.viewportDimension;

        // Estimate a position to scroll to which attempts to move the last item top out of view
        final targetPosition = currentPosition + viewportHeight;

        _scrollController.animateTo(
          targetPosition > maxScrollExtent ? maxScrollExtent : targetPosition,  // Ensure we do not scroll beyond the max extent
          duration: Duration(milliseconds: 500), // Quick scroll to adjust view
          curve: Curves.easeOut,
        );
      }
    });
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
                padding: const EdgeInsets.only(bottom: 24.0), // Increased bottom padding for separation
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
                    SizedBox(height: 12), // Increased spacing between title and summary
                    // Display AI Summary
                    if (result.aiSummary.isNotEmpty)
                      SummarySection(
                        summary: result.aiSummary,
                      ),
                    SizedBox(height: 12), // Increased spacing between summary and references
                    // Display Swipeable Cards
                    if (result.contextDocuments.isNotEmpty)
                      SwipeableCards(
                        documents: result.contextDocuments,
                      ),
                    // Loading Indicator
                    if (result.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
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
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.8),
                        colorScheme.secondary.withOpacity(0.8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.0), // Left padding inside the search box
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
                                  ? colorScheme.onPrimary.withOpacity(0.6)
                                  : colorScheme.onPrimary.withOpacity(0.6),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            // Ensure the background is transparent
                            filled: false,
                          ),
                          style: textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? colorScheme.onPrimary.withOpacity(0.9)
                                : colorScheme.onPrimary.withOpacity(0.9),
                          ),
                          cursorColor: colorScheme.onPrimary, // Set cursor color
                        ),
                      ),
                      // Send Icon Button inside the search box
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _handleSearch,
                        tooltip: 'Send',
                      ),
                      SizedBox(width: 16.0), // Right padding inside the search box
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
