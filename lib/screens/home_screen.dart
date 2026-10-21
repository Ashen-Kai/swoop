import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app.dart';
import '../data/categories.dart';
import '../widgets/search_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/listing_card.dart';
import 'main_shell.dart';
import 'listing_details_screen.dart';

/// Home screen — the first screen users see.
/// 
/// Features Swoop branding, search, hero card, categories,
/// "Useful finds near you", and "Picked for your next project".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final listings = appState.allListings;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ─── Top bar ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Swoop wordmark
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Logo symbol
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [SwoopTheme.forestGreen, SwoopTheme.mutedTeal],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'swoop',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: SwoopTheme.deepGreen,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Location label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: SwoopTheme.cardWhite,
                      borderRadius: BorderRadius.circular(SwoopTheme.radiusPill),
                      border: Border.all(color: SwoopTheme.borderLight),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: SwoopTheme.forestGreen),
                        SizedBox(width: 4),
                        Text(
                          'Bangalore',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: SwoopTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Profile avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: SwoopTheme.forestGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: SwoopTheme.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Search bar ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SearchField(
                readOnly: true,
                onTap: () {
                  MainShell.of(context)?.navigateToExplore();
                },
              ),
            ),
          ),

          // ─── Hero card ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _HeroCard(
                onExplore: () {
                  MainShell.of(context)?.navigateToExplore();
                },
                onSell: () {
                  MainShell.of(context)?.switchToTab(2);
                },
              ),
            ),
          ),

          // ─── Impact banner ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _ImpactBanner(),
            ),
          ),

          // ─── Categories ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Browse categories',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: SwoopTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 86,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return CategoryTile(
                          category: cat,
                          onTap: () {
                            MainShell.of(context)?.navigateToExplore(category: cat.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Useful finds near you ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Useful finds near you',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: SwoopTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      MainShell.of(context)?.navigateToExplore();
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SwoopTheme.forestGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listings.length > 6 ? 6 : listings.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return SizedBox(
                    width: 180,
                    child: ListingCard(
                      listing: listing,
                      onTap: () => _openDetails(context, listing.id),
                    ),
                  );
                },
              ),
            ),
          ),

          // ─── Picked for your next project ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Picked for your next project',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: SwoopTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      MainShell.of(context)?.navigateToExplore();
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SwoopTheme.forestGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid of remaining items
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final offset = 6;
                  if (offset + index >= listings.length) return null;
                  final listing = listings[offset + index];
                  return ListingCard(
                    listing: listing,
                    onTap: () => _openDetails(context, listing.id),
                  );
                },
                childCount: (listings.length - 6).clamp(0, listings.length),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, String listingId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ListingDetailsScreen(listingId: listingId),
      ),
    );
  }
}

/// Hero card with gradient background and CTAs.
class _HeroCard extends StatelessWidget {
  final VoidCallback onExplore;
  final VoidCallback onSell;

  const _HeroCard({required this.onExplore, required this.onSell});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SwoopTheme.forestGreen,
            SwoopTheme.mutedTeal,
            SwoopTheme.forestGreen.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SwoopTheme.radiusXL),
        boxShadow: [
          BoxShadow(
            color: SwoopTheme.forestGreen.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.recycling_rounded,
              color: SwoopTheme.softLime,
              size: 22,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Good materials deserve\na second round.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find affordable leftover materials\nfor your next project.',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              ElevatedButton(
                onPressed: onExplore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SwoopTheme.softLime,
                  foregroundColor: SwoopTheme.deepGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                ),
                child: const Text('Explore materials', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onSell,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Sell your extras'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Environmental impact banner.
class _ImpactBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SwoopTheme.softLime.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(SwoopTheme.radiusLarge),
        border: Border.all(color: SwoopTheme.softLime.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco_rounded, size: 18, color: SwoopTheme.forestGreen),
              const SizedBox(width: 6),
              const Text(
                'Why it matters',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SwoopTheme.forestGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '70.73 lakh tonnes of textile waste is generated in India annually. Cutting waste alone accounts for 10–25% of fabric in garment production.',
            style: TextStyle(
              fontSize: 12.5,
              color: SwoopTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Figures are provisional estimates, not independently verified Swoop results.',
            style: TextStyle(
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              color: SwoopTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Less waste. Better finds. More possibilities.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SwoopTheme.forestGreen,
            ),
          ),
        ],
      ),
    );
  }
}
