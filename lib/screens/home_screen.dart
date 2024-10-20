// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/suggested_questions_row.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchBarTap;
  final Function(String) onSearch;

  HomeScreen({
    required this.onSearchBarTap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen height to calculate logo position
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          // App Title and Top Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Icon Button (e.g., Account)
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {},
                ),
                // App Title
                Text(
                  'Tasleem',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Right Icon Button (e.g., Add Person)
                IconButton(
                  icon: Icon(Icons.person_add, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Spacer to push logo to 60% from top
          SizedBox(height: screenHeight * 0.05),
          // Logo and Subtitle
          Column(
            children: [
              // Tasleem Logo
              Image.asset(
                'assets/images/tasleem.png',
                height: 80,
              ),
              SizedBox(height: 12),
              // Subtitle
              Text(
                'Islamic Search Starts Here',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          // Spacer to fill the remaining space above suggested questions
          SizedBox(height: screenHeight * 0.05),
          // Suggested Questions with extra horizontal padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Increased horizontal padding
            child: Column(
              children: [
                // Suggested Questions - First Row
                SuggestedQuestionsRow(
                  onQuestionTap: onSearch,
                  questions: [
                    'What is Riba?',
                    'What is Islam?',
                    'What is Zakat?',
                    'What is Halal?',
                  ],
                ),
                SizedBox(height: 12),
                // Suggested Questions - Second Row
                SuggestedQuestionsRow(
                  onQuestionTap: onSearch,
                  questions: [
                    'What is Hajj?',
                    'What is Sunnah?',
                    'What is Taqwa?',
                    'What is Salah?',
                  ],
                ),
                SizedBox(height: 12),
                // Suggested Questions - Third Row
                SuggestedQuestionsRow(
                  onQuestionTap: onSearch,
                  questions: [
                    'What is Sadaqah?',
                    'What is Shahada?',
                    'What is Jihad?',
                    'What is Du’a?',
                  ],
                ),
              ],
            ),
          ),
          // Spacer to push the search bar to the bottom
          Spacer(),
          // Search Bar at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Consistent padding
            child: GestureDetector(
              onTap: onSearchBarTap,
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.teal[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search for Islamic Knowledge...',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
