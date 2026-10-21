import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/listing.dart';
import '../app.dart';

/// Product card for marketplace grid / list.
/// 
/// Shows image, name, price, seller, location, and save toggle.
class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isSaved = appState.isSaved(listing.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: SwoopTheme.cardWhite,
          borderRadius: BorderRadius.circular(SwoopTheme.radiusLarge),
          border: Border.all(color: SwoopTheme.borderLight.withValues(alpha: 0.6)),
          boxShadow: SwoopTheme.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Product image
                  _ProductImage(url: listing.imageUrl),
                  // Save button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _SaveButton(
                      isSaved: isSaved,
                      onTap: () => appState.toggleSave(listing.id),
                    ),
                  ),
                  // Condition badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(SwoopTheme.radiusSmall),
                      ),
                      child: Text(
                        listing.condition.split(' – ').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SwoopTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.priceWithUnit,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SwoopTheme.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        size: 13,
                        color: SwoopTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.sellerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: SwoopTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: SwoopTheme.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.location.split(',').first,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: SwoopTheme.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Network image with loading placeholder and error fallback.
class _ProductImage extends StatelessWidget {
  final String url;

  const _ProductImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: SwoopTheme.surfaceGrey,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: SwoopTheme.forestGreen.withValues(alpha: 0.4),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
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
                Icon(Icons.inventory_2_outlined, size: 32, color: SwoopTheme.textTertiary),
                SizedBox(height: 4),
                Text(
                  'Image unavailable',
                  style: TextStyle(fontSize: 11, color: SwoopTheme.textTertiary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Circular save/unsave button with heart icon.
class _SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _SaveButton({required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 17,
          color: isSaved ? SwoopTheme.heartRed : SwoopTheme.textSecondary,
        ),
      ),
    );
  }
}
