import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/admin_widgets.dart';

// ═════════════════════════════════════════════════════════════════════════════
// ANALYTICS TAB
// ═════════════════════════════════════════════════════════════════════════════

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, restSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
          builder: (context, menuSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, orderSnap) {
                if (restSnap.connectionState == ConnectionState.waiting ||
                    menuSnap.connectionState == ConnectionState.waiting ||
                    orderSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final restaurantsList = restSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ?? [];
                final menuItemsList = menuSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ?? [];
                final ordersList = orderSnap.data?.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList() ?? [];

                // ── Stats ──────────────────────────────────────────────────
                final totalRestaurants = restaurantsList.length;
                final totalMenuItems = menuItemsList.length;
                final totalOrders = ordersList.length;

                // Real revenue from delivered orders
                final totalRevenue = ordersList
                    .where((o) => o['status'] == 'Delivered')
                    .fold<double>(
                    0, (sum, o) => sum + ((o['total'] ?? 0) as num).toDouble());

                // Average rating
                double avgRating = 0;
                if (restaurantsList.isNotEmpty) {
                  final sum = restaurantsList.fold<double>(
                      0, (s, r) => s + ((r['rating'] ?? 0.0) as num).toDouble());
                  avgRating = sum / restaurantsList.length;
                }

                // Order status breakdown
                final statusMap = <String, int>{};
                for (final o in ordersList) {
                  final s = (o['status'] ?? 'Unknown') as String;
                  statusMap[s] = (statusMap[s] ?? 0) + 1;
                }

                // Category breakdown
                final catMap = <String, int>{};
                for (final r in restaurantsList) {
                  final cat = (r['category'] ?? 'Other') as String;
                  catMap[cat] = (catMap[cat] ?? 0) + 1;
                }
                final sortedCats = catMap.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                final maxCatVal = sortedCats.isEmpty ? 1 : sortedCats.first.value;

                // Order status sort
                final statusOrder = [
                  'Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled'
                ];
                final sortedStatuses = statusMap.entries.toList()
                  ..sort((a, b) => statusOrder.indexOf(a.key)
                      .compareTo(statusOrder.indexOf(b.key)));
                final maxStatusVal = sortedStatuses.isEmpty
                    ? 1
                    : sortedStatuses.map((e) => e.value).reduce((a, b) => a > b ? a : b);

                final catColors = [
                  kPrimary, kBlue, kAmber, kRed, kGreen, kPurple,
                  const Color(0xFF06B6D4), const Color(0xFFF97316),
                ];
                final statusColors = {
                  'Pending': kPrimary,
                  'Preparing': kBlue,
                  'Out for Delivery': kPurple,
                  'Delivered': kGreen,
                  'Cancelled': kRed,
                };

                return CustomScrollView(
                  slivers: [
                    // ── Header ───────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: PageHeader(
                        title: 'Analytics',
                        subtitle: 'Platform breakdown',
                      ),
                    ),

                    // ── Top stat cards ───────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: Row(
                          children: [
                            MiniStatCard('$totalRestaurants', 'Restaurants', kPrimary),
                            const SizedBox(width: 10),
                            MiniStatCard('$totalMenuItems', 'Menu Items', kBlue),
                            const SizedBox(width: 10),
                            MiniStatCard(
                                avgRating.toStringAsFixed(1), 'Avg Rating', kAmber),
                          ],
                        ),
                      ),
                    ),

                    // ── Revenue + Orders row ─────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatBanner(
                                label: 'Total Revenue',
                                value: '\$${totalRevenue.toStringAsFixed(2)}',
                                icon: Icons.trending_up_rounded,
                                color: kGreen,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatBanner(
                                label: 'Total Orders',
                                value: '$totalOrders',
                                icon: Icons.shopping_bag_outlined,
                                color: kBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Order Status Breakdown ───────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Text('Order Status Breakdown', style: h2Style),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kBorder),
                          ),
                          child: sortedStatuses.isEmpty
                              ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text('No orders yet', style: bodyStyle),
                            ),
                          )
                              : Column(
                            children: sortedStatuses.map((entry) {
                              final color = statusColors[entry.key] ?? kTextHint;
                              final pct = entry.value / maxStatusVal;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: color, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 110,
                                      child: Text(entry.key,
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
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(color),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text('${entry.value}',
                                        style: captionStyle.copyWith(
                                            color: color,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    // ── Category Breakdown ───────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                        child: Text('By Category', style: h2Style),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) {
                          final entry = sortedCats[i];
                          final color = catColors[i % catColors.length];
                          final pct = entry.value / maxCatVal;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: kSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: color, shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(entry.key, style: h3Style),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${entry.value} restaurant${entry.value > 1 ? 's' : ''}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: color,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 8,
                                      backgroundColor: kBg,
                                      valueColor: AlwaysStoppedAnimation<Color>(color),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: sortedCats.length,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _StatBanner extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBanner({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: color,
                        letterSpacing: -0.5)),
                Text(label, style: captionStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}