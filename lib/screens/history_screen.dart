// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the current theme's color scheme and text theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Access ThemeProvider to manage theme state
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background, // Use theme background color
        body: Column(
          children: [
            // App Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Icon Button (e.g., Menu)
                  IconButton(
                    icon: Icon(Icons.menu, color: colorScheme.onBackground),
                    onPressed: () {
                      // TODO: Implement menu functionality
                    },
                    tooltip: 'Menu',
                  ),
                  // App Title
                  Text(
                    'History',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  // Right Placeholder to Maintain Spacing
                  SizedBox(
                    width: 48, // Width of IconButton to maintain spacing
                  ),
                ],
              ),
            ),

            // Rest of the History Screen Content
            Expanded(
              child: Center(
                child: Text(
                  'History Content Here',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground,
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
