// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/history_screen.dart';
import 'screens/search_result_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to get the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Tasleem Search',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Set the theme mode based on ThemeProvider
      theme: AppThemes.lightTheme, // Apply the light theme
      darkTheme: AppThemes.darkTheme, // Apply the dark theme
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0; // Tracks the current bottom navigation index
  bool _isSearchModalOpen = false; // Flag to track if the search modal is open
  late SearchResultScreenState _searchScreenState; // Reference to SearchResultScreen's state

  // List of screens managed by the bottom navigation bar
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onSearchBarTap: _openSearchModal, // Function to open the search modal
        onSearch: _openSearchModalWithQuery, // Function to open the search modal with a query
      ),
      ExploreScreen(),
      HistoryScreen(),
    ];
  }

  // Function to open the search modal without an initial query
  void _openSearchModal() {
    if (!_isSearchModalOpen) {
      setState(() {
        _isSearchModalOpen = true;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows the modal to take custom height
        backgroundColor: Colors.transparent, // Makes the modal background transparent
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9, // Sets the modal height to 90% of the screen
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background, // Use theme background color
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SearchResultScreen(
                onInitialize: (state) {
                  _searchScreenState = state; // Capture the state reference
                },
                onClose: () {
                  setState(() {
                    _isSearchModalOpen = false;
                  });
                },
              ),
            ),
          );
        },
      ).whenComplete(() {
        // Reset the flag when the modal is closed
        setState(() {
          _isSearchModalOpen = false;
        });
      });
    }
  }

  // Function to open the search modal with an initial query
  void _openSearchModalWithQuery(String query) {
    if (!_isSearchModalOpen) {
      _openSearchModal();
      // Delay adding the query to ensure the modal is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchScreenState.addSearchQuery(query);
      });
    } else {
      _searchScreenState.addSearchQuery(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to utilize theme-based colors
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface, // Use theme surface color
        unselectedItemColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
