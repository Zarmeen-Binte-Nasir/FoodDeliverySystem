// lib/screens/admin/tabs/admin_restaurants_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_system/theme/app_theme.dart';
import 'package:food_delivery_system/widgets/admin_widgets.dart';

class AdminRestaurantsTab extends StatefulWidget {
  const AdminRestaurantsTab({super.key});

  @override
  State<AdminRestaurantsTab> createState() => _AdminRestaurantsTabState();
}

class _AdminRestaurantsTabState extends State<AdminRestaurantsTab> {
  String _search = '';

  void _deleteRestaurant(Map<String, dynamic> r, String docId) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: kRed.withValues(alpha: 0.08),
                    shape: BoxShape.circle),
                child:
                const Icon(Icons.delete_rounded, color: kRed, size: 28),
              ),
              const SizedBox(height: 16),
              Text('Delete Restaurant', style: h2),
              const SizedBox(height: 8),
              Text('Remove "${r['name']}" from the platform?',
                  style: bodyStyle, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel',
                          style: h3.copyWith(color: kTextSub)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('restaurants')
                            .doc(docId)
                            .delete();
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                            content: Text('${r['name']} removed'),
                            backgroundColor: kRed,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kRed,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Delete',
                          style: h3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRestaurantSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddRestaurantSheet(
        onAdd: (newRestaurant) async {
          await FirebaseFirestore.instance
              .collection('restaurants')
              .add(newRestaurant);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${newRestaurant['name']} added!'),
              backgroundColor: kGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .snapshots(),
        builder: (context, snapshot) {
          final restaurantsList = snapshot.data?.docs ?? [];
          final filtered = restaurantsList.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString();
            final category = (data['category'] ?? '').toString();

            return name.toLowerCase().contains(_search.toLowerCase()) ||
                category.toLowerCase().contains(_search.toLowerCase());
          }).toList();

          return Column(
            children: [
              AdminPageHeader(
                  title: 'Restaurants',
                  subtitle:
                  '${restaurantsList.length} listed on platform'),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: AdminSearchBar(
                  hint: 'Search by name or category…',
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                    ? const AdminEmptyState(
                    message: 'No restaurants found')
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final doc = filtered[i];
                    final r =
                    doc.data() as Map<String, dynamic>;
                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 10),
                      child: AdminRestaurantCard(
                        r: r,
                        onDelete: () =>
                            _deleteRestaurant(r, doc.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRestaurantSheet,
        backgroundColor: kPrimary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Restaurant',
            style: h3.copyWith(color: Colors.white, fontSize: 13)),
      ),
    );
  }
}

// ── Add Restaurant Sheet ──────────────────────────────────────────────────────
class _AddRestaurantSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  const _AddRestaurantSheet({required this.onAdd});

  @override
  State<_AddRestaurantSheet> createState() => _AddRestaurantSheetState();
}

class _AddRestaurantSheetState extends State<_AddRestaurantSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ratingController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _deliveryFeeController = TextEditingController();
  final _priceRangeController = TextEditingController();
  final _freeAboveController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    _deliveryTimeController.dispose();
    _deliveryFeeController.dispose();
    _priceRangeController.dispose();
    _freeAboveController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'image': _imageController.text.trim(),
        'category': _categoryController.text.trim(),
        'rating': double.tryParse(_ratingController.text.trim()) ?? 4.0,
        'deliveryTime': _deliveryTimeController.text.trim(),
        'deliveryFee': _deliveryFeeController.text.trim(),
        'priceRange': _priceRangeController.text.trim(),
        'freeAbove': _freeAboveController.text.trim(),
        'color': 0xFFFF6B35,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: kSurface,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: kBorder,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Restaurant', style: h2),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          color: kBg,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.close_rounded,
                          size: 18, color: kTextSub),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                height: 1,
                color: kBorder),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  children: [
                    AdminFormField(
                        controller: _nameController,
                        label: 'Restaurant Name',
                        hint: 'e.g. Pizza Palace',
                        icon: Icons.storefront_rounded,
                        validator: (v) =>
                        v!.isEmpty ? 'Name is required' : null),
                    AdminFormField(
                        controller: _descController,
                        label: 'Description',
                        hint: 'e.g. Best pizza in town',
                        icon: Icons.notes_rounded,
                        validator: (v) =>
                        v!.isEmpty ? 'Description is required' : null),
                    AdminFormField(
                        controller: _imageController,
                        label: 'Image URL',
                        hint: 'https://...',
                        icon: Icons.image_outlined,
                        validator: (v) =>
                        v!.isEmpty ? 'Image URL is required' : null),
                    AdminFormField(
                        controller: _categoryController,
                        label: 'Category',
                        hint: 'e.g. Pizza, Burger, Sushi',
                        icon: Icons.category_outlined,
                        validator: (v) =>
                        v!.isEmpty ? 'Category is required' : null),
                    AdminFormField(
                      controller: _ratingController,
                      label: 'Rating',
                      hint: 'e.g. 4.5',
                      icon: Icons.star_outline_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final d = double.tryParse(v ?? '');
                        if (d == null || d < 1 || d > 5) {
                          return 'Enter a rating between 1.0 and 5.0';
                        }
                        return null;
                      },
                    ),
                    AdminFormField(
                        controller: _deliveryTimeController,
                        label: 'Delivery Time',
                        hint: 'e.g. 20-30 min',
                        icon: Icons.access_time_rounded,
                        validator: (v) =>
                        v!.isEmpty ? 'Delivery time is required' : null),
                    AdminFormField(
                        controller: _deliveryFeeController,
                        label: 'Delivery Fee',
                        hint: 'e.g. PKR 200 or Free',
                        icon: Icons.delivery_dining_rounded,
                        validator: (v) =>
                        v!.isEmpty ? 'Delivery fee is required' : null),
                    AdminFormField(
                        controller: _priceRangeController,
                        label: 'Price Range',
                        hint: 'e.g. PKR or PKR10–PKR30',
                        icon: Icons.payments_outlined),
                    AdminFormField(
                        controller: _freeAboveController,
                        label: 'Free Delivery Above (optional)',
                        hint: 'e.g. PKR20',
                        icon: Icons.local_offer_outlined),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14)),
                        ),
                        child: Text('Add Restaurant',
                            style: h3.copyWith(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}