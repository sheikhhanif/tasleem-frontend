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
}
