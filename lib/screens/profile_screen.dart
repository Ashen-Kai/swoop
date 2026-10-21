import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app.dart';

/// Profile screen — lightweight demo profile with Swoop summary.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Profile card ───
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: SwoopTheme.cardWhite,
                borderRadius: BorderRadius.circular(SwoopTheme.radiusXL),
                border: Border.all(color: SwoopTheme.borderLight.withValues(alpha: 0.5)),
                boxShadow: SwoopTheme.cardShadow,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [SwoopTheme.forestGreen, SwoopTheme.mutedTeal],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Swoop User',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: SwoopTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Demo account · Bangalore',
                          style: TextStyle(
                            fontSize: 13,
                            color: SwoopTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Stats row ───
            Row(
              children: [
                _StatCard(
                  icon: Icons.inventory_2_outlined,
                  value: '${appState.totalListings}',
                  label: 'Listings',
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.favorite_border_rounded,
                  value: '${appState.savedCount}',
                  label: 'Saved',
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.category_outlined,
                  value: '${appState.activeCategoryCount}',
                  label: 'Categories',
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ─── About Swoop ───
            const Text(
              'About Swoop',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: SwoopTheme.cardWhite,
                borderRadius: BorderRadius.circular(SwoopTheme.radiusLarge),
                border: Border.all(color: SwoopTheme.borderLight.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [SwoopTheme.forestGreen, SwoopTheme.mutedTeal],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'swoop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: SwoopTheme.deepGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Swoop is a marketplace where people and businesses can buy and sell surplus materials that still have useful value.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: SwoopTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Find what you need. Spend less. Waste less.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SwoopTheme.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Demo note ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SwoopTheme.warmYellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(SwoopTheme.radiusMedium),
                border: Border.all(color: SwoopTheme.warmYellow.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 18, color: SwoopTheme.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Frontend Demo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: SwoopTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is a fully interactive prototype built for a designathon. All data is local. No real transactions, accounts, or sellers are involved.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: SwoopTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─── Feature summary ───
            const Text(
              'Working features',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._features.map((f) => _FeatureRow(icon: f.$1, label: f.$2)),
          ],
        ),
      ),
    );
  }
}

const _features = [
  (Icons.home_rounded, 'Browse marketplace Home with product discovery'),
  (Icons.search_rounded, 'Search, filter, and sort listings'),
  (Icons.open_in_new_rounded, 'View detailed product information'),
  (Icons.favorite_rounded, 'Save and unsave favourite materials'),
  (Icons.add_circle_rounded, 'List surplus materials for sale'),
  (Icons.category_rounded, 'Filter by material category'),
  (Icons.sort_rounded, 'Sort by price or recency'),
  (Icons.eco_rounded, 'Environmental impact awareness'),
];

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: SwoopTheme.cardWhite,
          borderRadius: BorderRadius.circular(SwoopTheme.radiusMedium),
          border: Border.all(color: SwoopTheme.borderLight.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: SwoopTheme.forestGreen),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: SwoopTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: SwoopTheme.forestGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: SwoopTheme.forestGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: SwoopTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
