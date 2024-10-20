// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import Provider package
import '../widgets/suggested_questions_row.dart';
import '../theme_provider.dart'; // Import ThemeProvider

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchBarTap;
  final Function(String) onSearch;

  HomeScreen({
    required this.onSearchBarTap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Access ThemeProvider to manage theme state
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Get screen height to calculate logo position dynamically
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background, // Use theme background color
        body: Column(
          children: [
            // App Title and Top Row with Icon Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Icon Button (e.g., Account)
                  IconButton(
                    icon: Icon(Icons.account_circle, color: colorScheme.onBackground),
                    onPressed: () {
                      // TODO: Implement account functionality
                    },
                    tooltip: 'Account',
                  ),
                  // App Title
                  Text(
                    'Tasleem',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  // Right Icon Button (e.g., Add Person) and Theme Toggle
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.person_add, color: colorScheme.onBackground),
                        onPressed: () {
                          // TODO: Implement add person functionality
                        },
                        tooltip: 'Add Person',
                      ),
                      // Theme Toggle Button
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: colorScheme.onBackground,
                        ),
                        onPressed: () {
                          themeProvider.toggleTheme(!themeProvider.isDarkMode);
                        },
                        tooltip: themeProvider.isDarkMode
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Spacer to push logo to ~60% from top
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
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    color: colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            // Spacer to fill the remaining space above suggested questions
            SizedBox(height: screenHeight * 0.05),
            // Suggested Questions with consistent horizontal padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Consistent horizontal padding
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
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search for Islamic Knowledge...',
                          style: textTheme.bodyMedium?.copyWith(
                            color: themeProvider.isDarkMode
                                ? colorScheme.onSurface.withOpacity(0.6) // Dark Mode: darker text
                                : Colors.white70, // Light Mode: semi-transparent white
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
