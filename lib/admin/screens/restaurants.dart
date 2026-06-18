import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/admin_widgets.dart';

// ═════════════════════════════════════════════════════════════════════════════
// RESTAURANTS TAB
// ═════════════════════════════════════════════════════════════════════════════

class RestaurantsTab extends StatefulWidget {
  const RestaurantsTab({super.key});

  @override
  State<RestaurantsTab> createState() => _RestaurantsTabState();
}

class _RestaurantsTabState extends State<RestaurantsTab> {
  String _search = '';

  void _deleteRestaurant(Map<String, dynamic> r, String docId) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: kRed.withOpacity(0.08), shape: BoxShape.circle),
                child: const Icon(Icons.delete_rounded, color: kRed, size: 28),
              ),
              const SizedBox(height: 16),
              Text('Delete Restaurant', style: h2Style),
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
                          style: h3Style.copyWith(color: kTextSub)),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                          style: h3Style.copyWith(
                              color: kText,
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
      builder: (_) => AddRestaurantSheet(
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
        stream:
        FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (context, snapshot) {
          final restaurantsList = snapshot.data?.docs ?? [];
          final filtered = restaurantsList.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['name'] as String)
                .toLowerCase()
                .contains(_search.toLowerCase()) ||
                (data['category'] as String)
                    .toLowerCase()
                    .contains(_search.toLowerCase());
          }).toList();

          return Column(
            children: [
              PageHeader(
                  title: 'Restaurants',
                  subtitle: '${restaurantsList.length} listed on platform'),
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
                    ? const EmptyState(message: 'No restaurants found')
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final doc = filtered[i];
                    final r = doc.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RestaurantCard(
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
            style: h3Style.copyWith(color: Colors.white, fontSize: 13)),
      ),
    );
  }
}