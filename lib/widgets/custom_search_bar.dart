// lib/widgets/custom_search_bar.dart

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String) onSearch;
  final FocusNode? focusNode;

  CustomSearchBar({
    this.controller,
    required this.onSearch,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Add icon
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 8),
          // Search Input Field
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onSearch(value.trim());
                }
              },
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Voice icon
          Icon(Icons.mic, color: Colors.white),
        ],
      ),
    );
  }
}
