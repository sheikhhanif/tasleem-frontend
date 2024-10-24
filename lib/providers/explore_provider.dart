// lib/providers/explore_provider.dart

import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ExploreProvider extends ChangeNotifier {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentFilter = 'All';

  // **New Pagination Variables**
  bool _isLoadingMore = false; // Indicates if more articles are being loaded
  bool _hasMore = true; // Indicates if more articles are available to load

  // **Getters for Pagination**
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;

  ExploreProvider() {
    fetchExploreItems();
  }

  /// Fetches articles from the API and applies the current filter.
  Future<void> fetchExploreItems() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allArticles = await ApiService.fetchExploreItems();
      applyFilter(_currentFilter);
    } catch (e) {
      _errorMessage = e.toString();
      _filteredArticles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Applies a filter to the list of articles.
  void applyFilter(String filter) {
    _currentFilter = filter;
    if (filter == 'All') {
      _filteredArticles = _allArticles;
    } else if (filter == 'Tafsir') {
      _filteredArticles =
          _allArticles.where((article) => article.id.startsWith('TIK')).toList();
    } else if (filter == 'Hadith') {
      _filteredArticles =
          _allArticles.where((article) => article.id.startsWith('H')).toList();
    } else if (filter == 'Fatwa') {
      _filteredArticles =
          _allArticles.where((article) => article.id.startsWith('F')).toList();
    } else {
      _filteredArticles = _allArticles;
    }
    notifyListeners();
  }

  // **New Method:** Loads more articles when the user reaches the end.
  Future<void> loadMoreArticles() async {
    if (_isLoadingMore || !_hasMore) return; // Prevent duplicate requests

    _isLoadingMore = true;
    notifyListeners();

    try {
      // **Fetch additional articles from the API**
      List<Article> fetchedArticles = await ApiService.fetchExploreItems();

      if (fetchedArticles.isNotEmpty) {
        _allArticles.addAll(fetchedArticles); // Append new articles
        applyFilter(_currentFilter); // Re-apply the current filter
      } else {
        _hasMore = false; // No more articles to load
      }
    } catch (e) {
      _errorMessage = 'Failed to load more articles.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
