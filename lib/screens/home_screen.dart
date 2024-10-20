// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/suggested_questions.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onSearch;

  HomeScreen({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Matches the reference image's dark background
        body: Stack(
          children: [
            // Main content
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // App Title, Centered Logo, and Suggested Questions
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo in the center
                        Image.asset(
                          'assets/images/tasleem.png',
                          height: 80,
                        ),
                        SizedBox(height: 12),
                        // Subtitle
                        Text(
                          'Islamic Search Starts Here',
                          style: GoogleFonts.openSans(
                            fontSize: 22,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 24), // Space between subtitle and suggested questions
                        // Suggested Questions right below the subtitle
                        SuggestedQuestions(onQuestionTap: onSearch),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom-aligned search bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
                child: CustomSearchBar(
                  onSearch: onSearch, controller: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
