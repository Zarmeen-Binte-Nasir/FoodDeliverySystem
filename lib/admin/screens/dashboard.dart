import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/admin_widgets.dart';

// ═════════════════════════════════════════════════════════════════════════════
// DASHBOARD TAB
// ═════════════════════════════════════════════════════════════════════════════

class DashboardTab extends StatelessWidget {
  final VoidCallback? onLogout;

  const DashboardTab({super.key, this.onLogout});

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
                if (restSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final restaurantsList = restSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ??
                    [];
                final ordersList = orderSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ??
                    [];
                final menuItemsList = menuSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ??
                    [];

                final totalRestaurants = restaurantsList.length;
                final totalOrders = ordersList.length;
                final totalMenuItems = menuItemsList.length;

                double avgRating = 0;
                if (restaurantsList.isNotEmpty) {
                  final sum = restaurantsList.fold<double>(
                      0,
                          (s, r) =>
                      s + ((r['rating'] ?? 0.0) as num).toDouble());
                  avgRating = sum / restaurantsList.length;
                }

                final popularCount =
                    menuItemsList.where((i) => i['isPopular'] == true).length;

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
                      child: PageHeader(
                        title: 'Dashboard',
                        subtitle: 'Welcome back, Admin 👋',
                        onLogout: onLogout,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: _buildHeroStats(totalRestaurants, totalOrders,
                            avgRating, popularCount)),
                    SliverToBoxAdapter(
                        child: _buildHighlightRow(totalMenuItems, ordersList)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Text('Category Breakdown', style: h2Style),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: _buildCategoryBreakdown(
                            topCategories.take(5).toList())),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Restaurants', style: h2Style),
                            Text('$totalRestaurants total',
                                style: captionStyle.copyWith(color: kPrimary)),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: RestaurantCard(r: restaurantsList[i]),
                        ),
                        childCount: restaurantsList.take(5).length,
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

  Widget _buildHeroStats(int totalRestaurants, int totalOrders,
      double avgRating, int popularCount) {
    final stats = [
      StatData(
        icon: Icons.soup_kitchen_outlined,
        value: '$totalRestaurants',
        label: 'Restaurants',
        color: kPrimary,
        trend: 'Live',
      ),
      StatData(
        icon: Icons.shopping_bag_outlined,
        value: '$totalOrders',
        label: 'Total Orders',
        color: kBlue,
        trend: 'Realtime',
      ),
      StatData(
        icon: Icons.grade_outlined,
        value: avgRating.toStringAsFixed(1),
        label: 'Avg Rating',
        color: kAmber,
        trend: 'Community',
      ),
      StatData(
        icon: Icons.thumb_up_outlined,
        value: '$popularCount',
        label: 'Popular Items',
        color: kRed,
        trend: 'Trending',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
        children: stats.map((s) => BigStatCard(data: s)).toList(),
      ),
    );
  }

  Widget _buildHighlightRow(int totalMenuItems, List<Map<String, dynamic>> ordersList) {
    final revenue = ordersList
        .where((o) => o['status'] == 'Delivered')
        .fold<double>(0, (sum, o) => sum + ((o['total'] ?? 0) as num).toDouble());

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(child: RevenueCard(revenue: revenue)),  // pass real value
          const SizedBox(width: 10),
          Expanded(child: ActivityCard(totalMenuItems: totalMenuItems)),
        ],
      ),
    );
  }

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
                    decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(entry.value.key,
                        style: h3Style.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis),
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
                  Text('${entry.value.value}',
                      style: captionStyle.copyWith(
                          color: color, fontWeight: FontWeight.w800)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}