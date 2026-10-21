import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app.dart';
import '../widgets/listing_card.dart';
import '../widgets/empty_state.dart';
import 'main_shell.dart';
import 'listing_details_screen.dart';

/// Saved items screen — shows bookmarked listings.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final savedListings = appState.savedListings;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: SwoopTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                if (savedListings.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: SwoopTheme.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(SwoopTheme.radiusPill),
                    ),
                    child: Text(
                      '${savedListings.length} item${savedListings.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: SwoopTheme.forestGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: savedListings.isEmpty
                ? EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: 'No saved materials yet',
                    subtitle:
                        'Tap the heart icon on any listing to save it here for later.',
                    actionLabel: 'Explore materials',
                    onAction: () {
                      MainShell.of(context)?.navigateToExplore();
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: savedListings.length,
                    itemBuilder: (context, index) {
                      final listing = savedListings[index];
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
