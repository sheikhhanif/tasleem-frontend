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
      ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: widget.onClose));
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
      _scrollToBottom();
    }
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      addSearchQuery(query);
      _searchController.clear();
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Search Result Content
        Expanded(
          child: _searchResults.isEmpty
              ? Center(child: Text('No search results.'))
              : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Query Title
                    Text(
                      result.query,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Display AI Summary
                    if (result.aiSummary.isNotEmpty)
                      SummarySection(summary: result.aiSummary),
                    SizedBox(height: 8),
                    // Display Swipeable Cards
                    if (result.contextDocuments.isNotEmpty)
                      SwipeableCards(documents: result.contextDocuments),
                    // Loading Indicator
                    if (result.isLoading)
                      Center(child: CircularProgressIndicator()),
                    // Error Message
                    if (result.isError)
                      Center(child: Text('An error occurred.')),
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
                    color: Colors.grey[800], // Background color for the search box
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
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // Send Icon Button inside the search box
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.tealAccent),
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
