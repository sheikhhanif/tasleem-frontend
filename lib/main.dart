// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'providers/explore_provider.dart'; // Import ExploreProvider
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
        onSearchBarTap: _openSearchModalFromSearchBar,
        onSearch: _openSearchModalWithQuery,
      ),
      ChangeNotifierProvider(
        create: (_) => ExploreProvider(), // Provide ExploreProvider to ExploreScreen
        child: ExploreScreen(),
      ),
      HistoryScreen(),
    ];
  }

  // Function to open the search modal with autoFocus parameter
  void _openSearchModal({required bool autoFocus}) {
    if (!_isSearchModalOpen) {
      setState(() {
        _isSearchModalOpen = true;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows the modal to adjust when the keyboard appears
        backgroundColor: Colors.transparent, // Makes the modal background transparent
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.92, // Sets the modal height to 92% of the screen
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
                autoFocus: autoFocus, // Pass the autoFocus parameter
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

  // Function called when the search bar is tapped
  void _openSearchModalFromSearchBar() {
    _openSearchModal(autoFocus: true); // Set autoFocus to true
  }

  // Function called when a suggested question is tapped
  void _openSearchModalWithQuery(String query) {
    if (!_isSearchModalOpen) {
      _openSearchModal(autoFocus: false); // Set autoFocus to false
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
        backgroundColor: Theme.of(context).colorScheme.background, // Use theme surface color
        unselectedItemColor: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.color
            ?.withOpacity(0.6),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        iconSize: 22, // Smaller icon size
        selectedFontSize: 0, // Smaller label font size
        elevation: 0,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '',
          ),
        ],
      ),
    );
  }
}