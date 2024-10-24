// lib/providers/favorites_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/article.dart';

class FavoritesProvider extends ChangeNotifier {
  late Box<Article> _favoritesBox;
  List<Article> _favoriteArticles = [];
  bool _isLoading = true; // Added isLoading flag

  List<Article> get favoriteArticles => _favoriteArticles;
  bool get isLoading => _isLoading; // Getter for isLoading

  FavoritesProvider() {
    _initializeFavorites();
  }

  /// Initializes the Hive box and loads existing favorites.
  void _initializeFavorites() {
    try {
      _favoritesBox = Hive.box<Article>('favoritesBox');
      _favoriteArticles = _favoritesBox.values.toList();
      print('FavoritesProvider initialized with ${_favoriteArticles.length} articles.');
    } catch (e) {
      // Handle any errors during initialization
      print('Error initializing favorites: $e');
      _favoriteArticles = [];
    } finally {
      _isLoading = false; // Set isLoading to false after loading
      notifyListeners();
    }
  }

  /// Adds an article to favorites and saves it to Hive.
  Future<void> addArticle(Article article) async {
    await _favoritesBox.put(article.id, article);
    _favoriteArticles = _favoritesBox.values.toList();
    notifyListeners();
  }

  /// Removes an article from favorites and updates Hive.
  Future<void> removeArticle(Article article) async {
    await _favoritesBox.delete(article.id);
    _favoriteArticles = _favoritesBox.values.toList();
    notifyListeners();
  }

  /// Checks if an article is already in favorites.
  bool isFavorite(Article article) {
    return _favoritesBox.containsKey(article.id);
  }

  /// Clears all favorites from Hive and the local list.
  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
    _favoriteArticles = [];
    notifyListeners();
  }
}
