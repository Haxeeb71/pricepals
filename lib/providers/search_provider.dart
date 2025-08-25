import 'package:flutter/material.dart';

class SearchHistoryItem {
  final String query;
  final DateTime searchedAt;
  final int resultCount;

  SearchHistoryItem({
    required this.query,
    required this.searchedAt,
    required this.resultCount,
  });
}

class SearchProvider extends ChangeNotifier {
  final List<SearchHistoryItem> _searchHistory = [];
  String _currentQuery = '';
  bool _isSearching = false;

  List<SearchHistoryItem> get searchHistory => List.unmodifiable(_searchHistory);
  String get currentQuery => _currentQuery;
  bool get isSearching => _isSearching;

  void addToHistory(String query, int resultCount) {
    // Remove existing entry if it exists
    _searchHistory.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());
    
    // Add new entry at the beginning
    _searchHistory.insert(0, SearchHistoryItem(
      query: query,
      searchedAt: DateTime.now(),
      resultCount: resultCount,
    ));

    // Keep only last 20 searches
    if (_searchHistory.length > 20) {
      _searchHistory.removeRange(20, _searchHistory.length);
    }

    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void removeFromHistory(String query) {
    _searchHistory.removeWhere((item) => item.query == query);
    notifyListeners();
  }

  void setCurrentQuery(String query) {
    _currentQuery = query;
    notifyListeners();
  }

  void setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  List<SearchHistoryItem> getFilteredHistory(String filter) {
    if (filter.isEmpty) return _searchHistory;
    
    return _searchHistory.where((item) => 
      item.query.toLowerCase().contains(filter.toLowerCase())
    ).toList();
  }
}
