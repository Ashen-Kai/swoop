import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../data/mock_listings.dart';

/// Central app state using ChangeNotifier.
/// 
/// Manages listings, saved items, and user-created listings.
/// Designed for demo — state is in-memory only.
class AppState extends ChangeNotifier {
  late List<Listing> _allListings;
  final Set<String> _savedIds = {};
  int _listingCounter = 100;

  AppState() {
    _allListings = getMockListings();
  }

  /// All available listings (mock + user-created).
  List<Listing> get allListings => List.unmodifiable(_allListings);

  /// IDs of saved listings.
  Set<String> get savedIds => Set.unmodifiable(_savedIds);

  /// Listings the user has saved.
  List<Listing> get savedListings =>
      _allListings.where((l) => _savedIds.contains(l.id)).toList();

  /// Check if a listing is saved.
  bool isSaved(String id) => _savedIds.contains(id);

  /// Toggle save state for a listing.
  void toggleSave(String id) {
    if (_savedIds.contains(id)) {
      _savedIds.remove(id);
    } else {
      _savedIds.add(id);
    }
    notifyListeners();
  }

  /// Add a new listing (from the Sell screen).
  void addListing(Listing listing) {
    _allListings.insert(0, listing);
    notifyListeners();
  }

  /// Generate a unique ID for new listings.
  String generateId() {
    _listingCounter++;
    return 'user_$_listingCounter';
  }

  /// Filter listings by category.
  List<Listing> listingsByCategory(String categoryId) =>
      _allListings.where((l) => l.category == categoryId).toList();

  /// Search listings by query.
  List<Listing> searchListings(String query) =>
      _allListings.where((l) => l.matchesQuery(query)).toList();

  /// Get a listing by ID.
  Listing? getListingById(String id) {
    try {
      return _allListings.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Total number of listings.
  int get totalListings => _allListings.length;

  /// Number of unique categories with listings.
  int get activeCategoryCount =>
      _allListings.map((l) => l.category).toSet().length;

  /// Number of saved items.
  int get savedCount => _savedIds.length;
}
