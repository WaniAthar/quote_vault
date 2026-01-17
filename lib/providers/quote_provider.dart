import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../models/collection.dart';
import '../services/quote_service.dart';
import '../services/widget_service.dart';

class QuoteProvider with ChangeNotifier {
  final QuoteService _quoteService = QuoteService();
  final WidgetService _widgetService = WidgetService();

  final List<Quote> _quotes = [];
  List<Quote> _favorites = []; // Add local favorites list
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String? _currentCategory;
  String? _searchQuery;
  Quote? _quoteOfTheDay;
  List<String> _categories = [];
  List<Collection> _collections = [];

  String? _lastError;

  List<Quote> get quotes => _quotes;
  List<Quote> get favorites => _favorites; // Getter for favorites
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  Quote? get quoteOfTheDay => _quoteOfTheDay;
  List<String> get categories => _categories;
  List<Collection> get collections => _collections;
  String? get currentCategory => _currentCategory;
  String? get searchQuery => _searchQuery;
  String? get lastError => _lastError;

  // Load initial quotes
  Future<void> loadQuotes({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _quotes.clear();
      _hasMore = true;
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final newQuotes = await _quoteService.fetchQuotes(
        offset: _currentPage * 20,
        category: _currentCategory,
        searchQuery: _searchQuery,
      );

      if (newQuotes.length < 20) {
        _hasMore = false;
      }

      _quotes.addAll(newQuotes);
      _currentPage++;

      // Mark favorites
      await _markFavoritesInQuotes();
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Seed initial data if empty
  Future<void> seedDatabase() async {
    debugPrint('QuoteProvider: Starting seedDatabase...');
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      debugPrint('QuoteProvider: Calling _quoteService.seedInitialQuotes()...');
      await _quoteService.seedInitialQuotes();
      debugPrint('QuoteProvider: Seeding successful, refreshing quotes...');
      await loadQuotes(refresh: true);
      debugPrint('QuoteProvider: Quotes refreshed, loading categories...');
      await loadCategories();
      debugPrint(
        'QuoteProvider: Categories loaded, loading quote of the day...',
      );
      await loadQuoteOfTheDay();
      debugPrint('QuoteProvider: seedDatabase complete!');
    } catch (error) {
      debugPrint('QuoteProvider: Error in seedDatabase: $error');
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by category
  Future<void> filterByCategory(String? category) async {
    _currentCategory = category;
    _searchQuery = null;
    await loadQuotes(refresh: true);
  }

  // Search quotes
  Future<void> searchQuotes(String query) async {
    _searchQuery = query;
    _currentCategory = null;
    await loadQuotes(refresh: true);
  }

  // Clear search
  Future<void> clearSearch() async {
    _searchQuery = null;
    await loadQuotes(refresh: true);
  }

  // Load quote of the day
  Future<void> loadQuoteOfTheDay() async {
    try {
      _quoteOfTheDay = await _quoteService.getQuoteOfTheDay();

      // Update widget with new quote
      if (_quoteOfTheDay != null) {
        _widgetService.updateWidget(_quoteOfTheDay!);
      }

      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _quoteService.getCategories();
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(Quote quote) async {
    try {
      final newFavoriteStatus = !quote.isFavorite;
      await _quoteService.toggleFavorite(quote.id, newFavoriteStatus);

      // Update main quotes list
      final index = _quotes.indexWhere((q) => q.id == quote.id);
      if (index != -1) {
        _quotes[index] = quote.copyWith(isFavorite: newFavoriteStatus);
      }

      // Update favorites list
      if (newFavoriteStatus) {
        _favorites.add(quote.copyWith(isFavorite: true));
      } else {
        _favorites.removeWhere((q) => q.id == quote.id);
      }

      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  // Mark which quotes are favorites
  Future<void> _markFavoritesInQuotes() async {
    try {
      final favoriteIds = await _quoteService.getFavoritedQuoteIds();

      for (var i = 0; i < _quotes.length; i++) {
        _quotes[i] = _quotes[i].copyWith(
          isFavorite: favoriteIds.contains(_quotes[i].id),
        );
      }
    } catch (error) {
      // Handle error
    }
  }

  // Load user's favorites
  Future<void> loadFavorites() async {
    try {
      _favorites = await _quoteService.getUserFavorites();
      notifyListeners();
    } catch (error) {
      _favorites = [];
      notifyListeners();
    }
  }

  // Helper method for backward compatibility if needed, but UI should use property
  Future<List<Quote>> getUserFavorites() async {
    await loadFavorites();
    return _favorites;
  }

  Future<void> clearAllFavorites() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _quoteService.deleteAllFavorites();

      // Update local state
      _favorites.clear();

      // Update main quotes list status
      for (var i = 0; i < _quotes.length; i++) {
        if (_quotes[i].isFavorite) {
          _quotes[i] = _quotes[i].copyWith(isFavorite: false);
        }
      }

      notifyListeners();
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Collections methods
  Future<void> loadCollections() async {
    try {
      debugPrint('QuoteProvider: Loading collections...');
      _collections = await _quoteService.getUserCollections();
      debugPrint('QuoteProvider: Loaded ${_collections.length} collections');
      notifyListeners();
    } catch (error) {
      debugPrint('QuoteProvider: Error loading collections: $error');
      // Handle error
    }
  }

  Future<void> createCollection(String name, String? description) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _quoteService.createCollection(name, description);
      await loadCollections(); // Refresh collections
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addQuoteToCollection(String collectionId, String quoteId) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _quoteService.addQuoteToCollection(collectionId, quoteId);
      await loadCollections(); // Refresh counts
    } catch (error) {
      debugPrint('QuoteProvider: Error adding quote to collection: $error');
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeQuoteFromCollection(
    String collectionId,
    String quoteId,
  ) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _quoteService.removeQuoteFromCollection(collectionId, quoteId);
      await loadCollections(); // Refresh counts
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _quoteService.deleteCollection(collectionId);
      await loadCollections(); // Refresh collections
    } catch (error) {
      _lastError = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getCollectionQuoteCount(String collectionId) async {
    return _quoteService.getCollectionQuoteCount(collectionId);
  }

  Future<List<Quote>> getCollectionQuotes(String collectionId) async {
    try {
      return await _quoteService.getCollectionQuotes(collectionId);
    } catch (error) {
      return [];
    }
  }
}
