// lib/providers/favorites_provider.dart

import 'package:flutter/material.dart';
import '../models/article.dart';

class FavoritesProvider with ChangeNotifier {
  // Internal list to store favorite articles
  final List<Article> _favoriteArticles = [];

  // Getter to access favorite articles
  List<Article> get favoriteArticles => List.unmodifiable(_favoriteArticles);

  // Method to add an article to favorites
  void addArticle(Article article) {
    if (!_favoriteArticles.contains(article)) {
      _favoriteArticles.add(article);
      notifyListeners();
    }
  }

  // Method to remove an article from favorites
  void removeArticle(Article article) {
    if (_favoriteArticles.contains(article)) {
      _favoriteArticles.remove(article);
      notifyListeners();
    }
  }

  // Method to check if an article is already in favorites
  bool isFavorite(Article article) {
    return _favoriteArticles.contains(article);
  }
}
