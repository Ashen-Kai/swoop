/// Data model for a surplus material listing.
class Listing {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String condition;
  final int quantity;
  final String sellerName;
  final String sellerType;
  final String location;
  final String imageUrl;
  final DateTime createdAt;

  const Listing({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.condition,
    required this.quantity,
    required this.sellerName,
    required this.sellerType,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
  });

  /// Formatted price string in Indian Rupees.
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  /// Full price with unit.
  String get priceWithUnit => '₹${price.toStringAsFixed(0)}/$unit';

  /// Checks if name or description matches a query.
  bool matchesQuery(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q);
  }
}
