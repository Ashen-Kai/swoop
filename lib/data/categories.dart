import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Category model with icon, label, and colour.
class Category {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// All marketplace categories.
final List<Category> categories = [
  Category(
    id: 'fabric',
    label: 'Fabric & Textiles',
    icon: Icons.checkroom_rounded,
    color: const Color(0xFFE8887D),
  ),
  Category(
    id: 'art',
    label: 'Art & Craft',
    icon: Icons.palette_rounded,
    color: const Color(0xFF9B8FE8),
  ),
  Category(
    id: 'acrylic',
    label: 'Acrylic & Boards',
    icon: Icons.crop_square_rounded,
    color: const Color(0xFF5DB8D4),
  ),
  Category(
    id: 'electronics',
    label: 'Electronics',
    icon: Icons.memory_rounded,
    color: const Color(0xFF4ECDC4),
  ),
  Category(
    id: 'mechanical',
    label: 'Mechanical Parts',
    icon: Icons.settings_rounded,
    color: const Color(0xFFE89B3F),
  ),
  Category(
    id: 'other',
    label: 'Other Supplies',
    icon: Icons.category_rounded,
    color: SwoopTheme.mutedTeal,
  ),
];

/// Condition options for listings.
const List<String> conditionOptions = [
  'New – unused surplus',
  'Like new – barely used',
  'Good – minor wear',
  'Fair – usable with imperfections',
  'As-is – sold without warranty',
];

/// Seller type options.
const List<String> sellerTypeOptions = [
  'Student',
  'Tailor / Clothing Business',
  'Electronics Shop',
  'Mechanic / Repair Shop',
  'School / University',
  'Manufacturer',
  'Other',
];

/// Sort options for explore screen.
enum SortOption {
  recentlyAdded('Recently Added'),
  priceLow('Lowest Price'),
  priceHigh('Highest Price');

  final String label;
  const SortOption(this.label);
}
