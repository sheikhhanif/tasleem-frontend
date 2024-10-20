// lib/widgets/search_modal.dart

import 'package:flutter/material.dart';

class SearchModal extends StatefulWidget {
  final Function(String) onSearch;

  SearchModal({required this.onSearch});

  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSend() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query);
      Navigator.of(context).pop(); // Close the modal after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    // To make the modal full-screen when needed
    return DraggableScrollableSheet(
      expand: false,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // Modal background color
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Enhanced Search Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16), // Left padding
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for Islamic Knowledge...',
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => _handleSend(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.teal[700]),
                      onPressed: _handleSend,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Display Search Results Here
              // Replace this with actual search results
              Container(
                height: 300,
                color: Colors.grey[100],
                child: Center(
                  child: Text(
                    'Search Results Appear Here',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
