import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app.dart';
import '../models/listing.dart';
import '../data/categories.dart';
import '../widgets/search_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/listing_card.dart';
import '../widgets/empty_state.dart';
import 'listing_details_screen.dart';

/// Explore screen — search, filter, sort, and browse all listings.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  SortOption _sortOption = SortOption.recentlyAdded;
  String _searchQuery = '';

  /// Set category filter programmatically (from Home).
  void setCategory(String? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
  }

  List<Listing> _getFilteredListings(List<Listing> all) {
    var results = all.toList();

    // Search filter
    if (_searchQuery.isNotEmpty) {
      results = results.where((l) => l.matchesQuery(_searchQuery)).toList();
    }

    // Category filter
    if (_selectedCategory != null) {
      results = results.where((l) => l.category == _selectedCategory).toList();
    }

    // Sort
    switch (_sortOption) {
      case SortOption.priceLow:
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHigh:
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.recentlyAdded:
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return results;
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = null;
      _sortOption = SortOption.recentlyAdded;
    });
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedCategory != null || _sortOption != SortOption.recentlyAdded;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final filtered = _getFilteredListings(appState.allListings);

    return SafeArea(
      child: Column(
        children: [
          // ─── Header ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: SwoopTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_hasActiveFilters)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.clear_all_rounded, size: 18),
                    label: const Text('Reset'),
                    style: TextButton.styleFrom(
                      foregroundColor: SwoopTheme.errorRed,
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ),

          // ─── Search ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: SearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // ─── Category chips ───
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return CategoryChip(
                    category: cat,
                    isSelected: _selectedCategory == cat.id,
                    onTap: () {
                      setState(() {
                        _selectedCategory =
                            _selectedCategory == cat.id ? null : cat.id;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // ─── Sort bar ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(
              children: [
                Text(
                  '${filtered.length} item${filtered.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SwoopTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                _SortDropdown(
                  value: _sortOption,
                  onChanged: (option) {
                    setState(() {
                      _sortOption = option;
                    });
                  },
                ),
              ],
            ),
          ),

          // ─── Listings grid ───
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No materials found',
                    subtitle: _hasActiveFilters
                        ? 'Try adjusting your search or filters.'
                        : 'Check back soon for new listings.',
                    actionLabel: _hasActiveFilters ? 'Reset filters' : null,
                    onAction: _hasActiveFilters ? _resetFilters : null,
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final listing = filtered[index];
                      return ListingCard(
                        listing: listing,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ListingDetailsScreen(listingId: listing.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Sort dropdown styled as a pill.
class _SortDropdown extends StatelessWidget {
  final SortOption value;
  final ValueChanged<SortOption> onChanged;

  const _SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: SwoopTheme.cardWhite,
        borderRadius: BorderRadius.circular(SwoopTheme.radiusPill),
        border: Border.all(color: SwoopTheme.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOption>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: SwoopTheme.textPrimary,
            fontFamily: 'Roboto',
          ),
          items: SortOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (option) {
            if (option != null) onChanged(option);
          },
        ),
      ),
    );
  }
}
