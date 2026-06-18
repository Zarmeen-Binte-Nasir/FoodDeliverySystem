// lib/screens/admin/tabs/admin_dashboard_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_system/theme/app_theme.dart';
import 'package:food_delivery_system/widgets/admin_widgets.dart';

class AdminDashboardTab extends StatelessWidget {
  final VoidCallback? onLogout;
  const AdminDashboardTab({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, restSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, orderSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
              builder: (context, menuSnap) {
                if (restSnap.connectionState == ConnectionState.waiting ||
                    orderSnap.connectionState == ConnectionState.waiting ||
                    menuSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final restaurantDocs = restSnap.data?.docs ?? [];
                final restaurantsList = restaurantDocs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                final ordersList = orderSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ?? [];
                final menuItemsList = menuSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ?? [];

                final totalRestaurants = restaurantsList.length;
                final totalOrders = ordersList.length;
                final totalMenuItems = menuItemsList.length;

                double avgRating = 0;
                if (restaurantsList.isNotEmpty) {
                  final sum = restaurantsList.fold<double>(
                      0, (s, r) => s + ((r['rating'] ?? 0.0) as num).toDouble());
                  avgRating = sum / restaurantsList.length;
                }

                final popularCount = menuItemsList
                    .where((i) => i['isPopular'] == true)
                    .length;

                final catMap = <String, int>{};
                for (final r in restaurantsList) {
                  final cat = (r['category'] ?? 'Other') as String;
                  catMap[cat] = (catMap[cat] ?? 0) + 1;
                }
                final topCategories = catMap.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: AdminPageHeader(
                        title: 'Dashboard',
                        subtitle: 'Welcome back, Admin 👋',
                        onLogout: onLogout,
                        trailing: const AdminOrangeBadgeIcon(
                          icon: Icons.local_fire_department_rounded,
                          size: 42,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: _buildHeroStats(totalRestaurants, totalOrders, avgRating, popularCount)),
                    SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: Row(
                            children: [
                              Expanded(child: _RevenueCard(orders: orderSnap.data?.docs ?? [])),
                              const SizedBox(width: 10),
                              Expanded(child: _ActivityCard(totalMenuItems: totalMenuItems)),
                            ],
                          ),
                        )),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Text('Category Breakdown', style: h2),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: _buildCategoryBreakdown(topCategories.take(5).toList())),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Restaurants', style: h2),
                            Text('$totalRestaurants total', style: caption.copyWith(color: kPrimary)),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) {
                          final docId = restaurantDocs[i].id;
                          final rData = restaurantDocs[i].data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: AdminRestaurantCard(
                              r: rData,
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Restaurant'),
                                    content: Text('Are you sure you want to delete ${rData['name']}?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: kRed))),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await FirebaseFirestore.instance.collection('restaurants').doc(docId).delete();
                                }
                              },
                            ),
                          );
                        },
                        childCount: restaurantDocs.take(5).length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Missing Method 1: Build Hero Stats ─────────────────────────────────────
  Widget _buildHeroStats(int totalRestaurants, int totalOrders, double avgRating, int popularCount) {
    final stats = [
      _StatData(
          icon: Icons.storefront_rounded,
          value: '$totalRestaurants',
          label: 'Restaurants',
          color: kPrimary,
          trend: 'Live'),
      _StatData(
          icon: Icons.receipt_long_rounded,
          value: '$totalOrders',
          label: 'Total Orders',
          color: kBlue,
          trend: 'Realtime'),
      _StatData(
          icon: Icons.star_rounded,
          value: avgRating.toStringAsFixed(1),
          label: 'Avg Rating',
          color: kAmber,
          trend: 'Community'),
      _StatData(
          icon: Icons.local_fire_department_rounded,
          value: '$popularCount',
          label: 'Popular Items',
          color: kRed,
          trend: 'Trending'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
        children: stats.map((s) => _BigStatCard(data: s)).toList(),
      ),
    );
  }

  // ── Missing Method 2: Build Category Breakdown ──────────────────────────────
  Widget _buildCategoryBreakdown(List<MapEntry<String, int>> topCategories) {
    final maxVal = topCategories.isEmpty ? 1 : topCategories.first.value;
    final barColors = [kPrimary, kBlue, kAmber, kGreen, kPurple];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          children: topCategories.asMap().entries.map((entry) {
            final pct = entry.value.value / maxVal;
            final color = barColors[entry.key % barColors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(entry.value.key, style: h3.copyWith(fontSize: 12), overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 7,
                        backgroundColor: kBg,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${entry.value.value}', style: caption.copyWith(color: color, fontWeight: FontWeight.w800)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Local Stat Data Models & Supporting UI Widgets ───────────────────────────
class _StatData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String trend;
  const _StatData({required this.icon, required this.value, required this.label, required this.color, required this.trend});
}

class _BigStatCard extends StatelessWidget {
  final _StatData data;
  const _BigStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(data.icon, color: data.color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(data.trend, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: data.color)),
              ),
            ],
          ),
          const Spacer(),
          Text(data.value, style: displayXL.copyWith(color: data.color, fontSize: 28)),
          const SizedBox(height: 2),
          Text(data.label, style: caption),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final List<DocumentSnapshot> orders;
  const _RevenueCard({required this.orders});

  @override
  Widget build(BuildContext context) {
    final double totalRevenue = orders.fold(0.0, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final String status = data['status'] ?? '';
      if (status != 'Cancelled') {
        final price = data['total'] ?? 0.0;
        return sum + (price is num ? price.toDouble() : 0.0);
      }
      return sum;
    });

    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimary, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.trending_up_rounded, color: Colors.white70, size: 18),
          const Spacer(),
          Text(
            'Rs ${totalRevenue.toStringAsFixed(0)}',
            style: displayXL.copyWith(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 2),
          Text('Revenue', style: caption.copyWith(color: Colors.white60)),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final int totalMenuItems;
  const _ActivityCard({required this.totalMenuItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kText,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white54, size: 18),
          const Spacer(),
          Text('$totalMenuItems', style: displayXL.copyWith(color: Colors.white, fontSize: 26)),
          const SizedBox(height: 2),
          Text('Menu Items', style: caption.copyWith(color: Colors.white38)),
        ],
      ),
    );
  }
}