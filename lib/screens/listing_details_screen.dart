import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app.dart';
import '../models/listing.dart';
import '../data/categories.dart';

/// Product detail screen — full listing information with actions.
class ListingDetailsScreen extends StatelessWidget {
  final String listingId;

  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final listing = appState.getListingById(listingId);

    if (listing == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Listing not found')),
      );
    }

    final isSaved = appState.isSaved(listing.id);
    final categoryLabel = categories
        .where((c) => c.id == listing.category)
        .map((c) => c.label)
        .firstOrNull ?? listing.category;

    return Scaffold(
      backgroundColor: SwoopTheme.cream,
      body: CustomScrollView(
        slivers: [
          // ─── Image header with back + save ───
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: SwoopTheme.cream,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  color: SwoopTheme.textPrimary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: isSaved ? SwoopTheme.heartRed : SwoopTheme.textSecondary,
                    ),
                    onPressed: () => appState.toggleSave(listing.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _DetailImage(url: listing.imageUrl),
            ),
          ),

          // ─── Content ───
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: SwoopTheme.forestGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(SwoopTheme.radiusPill),
                      ),
                      child: Text(
                        categoryLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: SwoopTheme.forestGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text(
                      listing.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: SwoopTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Text(
                      listing.priceWithUnit,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: SwoopTheme.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info rows
                    _InfoRow(icon: Icons.inventory_2_outlined, label: 'Quantity', value: '${listing.quantity} ${listing.unit}(s)'),
                    _InfoRow(icon: Icons.verified_outlined, label: 'Condition', value: listing.condition),
                    _InfoRow(icon: Icons.storefront_outlined, label: 'Seller', value: '${listing.sellerName} · ${listing.sellerType}'),
                    _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: listing.location),
                    _InfoRow(icon: Icons.category_outlined, label: 'Category', value: categoryLabel),

                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: SwoopTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: SwoopTheme.textSecondary,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ─── Interest button ───
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price summary
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontSize: 12, color: SwoopTheme.textTertiary),
                    ),
                    Text(
                      listing.priceWithUnit,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: SwoopTheme.forestGreen,
                      ),
                    ),
                  ],
                ),
              ),
              // CTA button
              ElevatedButton.icon(
                onPressed: () => _showInterestDialog(context, listing),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text("I'm interested"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInterestDialog(BuildContext context, Listing listing) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: SwoopTheme.softLime.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 36,
                  color: SwoopTheme.forestGreen,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Interest Recorded!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SwoopTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your interest in "${listing.name}" has been recorded for this demo. No seller has been contacted.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: SwoopTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/// Product detail image with loading and error handling.
class _DetailImage extends StatelessWidget {
  final String url;

  const _DetailImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: SwoopTheme.surfaceGrey,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: SwoopTheme.forestGreen,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: SwoopTheme.surfaceGrey,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_not_supported_outlined, size: 48, color: SwoopTheme.textTertiary),
                SizedBox(height: 8),
                Text('Image unavailable', style: TextStyle(color: SwoopTheme.textTertiary)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Info row in product details.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: SwoopTheme.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: SwoopTheme.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: SwoopTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
