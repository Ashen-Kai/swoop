import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../app.dart';
import '../models/listing.dart';
import '../data/categories.dart';

/// Sell screen — form for listing surplus materials.
class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedSellerType;
  String _selectedUnit = 'piece';
  bool _showSuccess = false;

  final List<String> _unitOptions = [
    'piece', 'kg', 'bundle', 'set', 'lot', 'sheet', 'kit', 'metre',
  ];

  void _submitListing() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null || _selectedCondition == null || _selectedSellerType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required dropdowns.')),
      );
      return;
    }

    final appState = AppStateProvider.of(context);
    final listing = Listing(
      id: appState.generateId(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      unit: _selectedUnit,
      category: _selectedCategory!,
      condition: _selectedCondition!,
      quantity: int.parse(_quantityController.text.trim()),
      sellerName: 'You (Demo)',
      sellerType: _selectedSellerType!,
      location: _locationController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=600&h=400&fit=crop',
      createdAt: DateTime.now(),
    );

    appState.addListing(listing);
    setState(() => _showSuccess = true);

    // Reset form after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showSuccess = false);
        _formKey.currentState?.reset();
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _locationController.clear();
        _imageUrlController.clear();
        _selectedCategory = null;
        _selectedCondition = null;
        _selectedSellerType = null;
        _selectedUnit = 'piece';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _showSuccess ? _SuccessView() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return CustomScrollView(
      slivers: [
        // ─── Header ───
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SwoopTheme.softLime.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 26,
                    color: SwoopTheme.forestGreen,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Got extras? Give them\na new home.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: SwoopTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'List your unused materials in a few simple steps.',
                  style: TextStyle(
                    fontSize: 14,
                    color: SwoopTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── Form ───
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name
                  _buildLabel('Item name'),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Cotton fabric offcuts',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Item name is required' : null,
                  ),
                  const SizedBox(height: 18),

                  // Category
                  _buildLabel('Category'),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(hintText: 'Select a category'),
                    items: categories.map((c) {
                      return DropdownMenuItem(value: c.id, child: Text(c.label));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) => v == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 18),

                  // Description
                  _buildLabel('Short description'),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Describe the material, size, and suitability',
                    ),
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 18),

                  // Price & Unit row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Price (₹)'),
                            TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 120',
                                prefixText: '₹ ',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Price required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Unit'),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedUnit,
                              decoration: const InputDecoration(),
                              items: _unitOptions.map((u) {
                                return DropdownMenuItem(value: u, child: Text(u));
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _selectedUnit = v);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Quantity
                  _buildLabel('Quantity available'),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(hintText: 'e.g. 5'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Quantity required' : null,
                  ),
                  const SizedBox(height: 18),

                  // Condition
                  _buildLabel('Condition'),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCondition,
                    decoration: const InputDecoration(hintText: 'Select condition'),
                    items: conditionOptions.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCondition = v),
                    validator: (v) => v == null ? 'Please select condition' : null,
                  ),
                  const SizedBox(height: 18),

                  // Seller type
                  _buildLabel('Seller type'),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSellerType,
                    decoration: const InputDecoration(hintText: 'What describes you best?'),
                    items: sellerTypeOptions.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedSellerType = v),
                    validator: (v) => v == null ? 'Please select seller type' : null,
                  ),
                  const SizedBox(height: 18),

                  // Location
                  _buildLabel('Location'),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Koramangala, Bangalore',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Location is required' : null,
                  ),
                  const SizedBox(height: 18),

                  // Image URL (optional)
                  _buildLabel('Image URL (optional)'),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      hintText: 'Paste an image URL for your listing',
                    ),
                    keyboardType: TextInputType.url,
                  ),

                  // Image preview
                  if (_imageUrlController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(SwoopTheme.radiusMedium),
                      child: Image.network(
                        _imageUrlController.text.trim(),
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 80,
                          color: SwoopTheme.surfaceGrey,
                          child: const Center(
                            child: Text('Could not load image preview',
                                style: TextStyle(color: SwoopTheme.textTertiary, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitListing,
                      icon: const Icon(Icons.publish_rounded, size: 20),
                      label: const Text('List this material'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'This is a demo. Your listing won\'t be published to a real marketplace.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: SwoopTheme.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: SwoopTheme.textPrimary,
        ),
      ),
    );
  }
}

/// Success view shown after listing submission.
class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SwoopTheme.softLime.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 44,
                color: SwoopTheme.forestGreen,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Listed successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your material is now visible in Home and Explore. This is a demo listing — it will not persist after the app restarts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: SwoopTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
