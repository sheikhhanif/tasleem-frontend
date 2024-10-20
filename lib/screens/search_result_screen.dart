// lib/screens/search_result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/summary_section.dart';
import '../widgets/swipeable_cards.dart';
import '../services/api_service.dart';
import '../models/content_model.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final Function(String) onSearch;

  SearchResultScreen({required this.query, required this.onSearch});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String aiSummary = '';
  List<ContentModel> contextDocuments = [];
  bool isLoading = false;
  bool isError = false;
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _focusNode = FocusNode();

    // Listen for keyboard visibility changes
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {}); // Rebuild when the keyboard visibility changes
    });

    // Perform initial search
    _performSearch(widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      aiSummary = '';
      contextDocuments = [];
      isLoading = true;
      isError = false;
    });

    // Fetch results asynchronously (simulate)
    ApiService.askQuestion(query).listen((data) {
      if (data.containsKey('answer')) {
        setState(() {
          aiSummary += data['answer'];
        });
      }
      if (data.containsKey('context')) {
        setState(() {
          contextDocuments.addAll(
            (data['context'] as List).map((doc) => ContentModel.fromJson(doc)).toList(),
          );
        });
      }
      if (data.containsKey('error')) {
        setState(() {
          isError = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onSearch(String query) {
    widget.onSearch(query); // Trigger search
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search: ${widget.query}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: isKeyboardVisible ? 200 : 8.0, // Adjusts padding when keyboard is visible
                ),
                child: Column(
                  children: [
                    // Updated CustomSearchBar
                    CustomSearchBar(
                      controller: _searchController,
                      onSearch: _onSearch,
                      focusNode: _focusNode,
                    ),
                    if (aiSummary.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SummarySection(summary: aiSummary),
                          SizedBox(height: 20),
                        ],
                      ),
                    if (contextDocuments.isNotEmpty) ...[
                      SwipeableCards(documents: contextDocuments),
                    ],
                    if (isLoading) Center(child: CircularProgressIndicator()),
                    if (isError) Center(child: Text('An error occurred.')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
