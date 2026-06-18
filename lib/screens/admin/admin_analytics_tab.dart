// lib/screens/admin/tabs/admin_analytics_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_system/theme/app_theme.dart';
import 'package:food_delivery_system/widgets/admin_widgets.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, restSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('menu_items')
              .snapshots(),
          builder: (context, menuSnap) {
            if (restSnap.connectionState == ConnectionState.waiting ||
                menuSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final restaurantsList = restSnap.data?.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList() ??
                [];
            final menuItemsList = menuSnap.data?.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList() ??
                [];

            final totalRestaurants = restaurantsList.length;
            final totalMenuItems = menuItemsList.length;

            double avgRating = 0;
            if (restaurantsList.isNotEmpty) {
              final sum = restaurantsList.fold<double>(
                  0,
                      (s, r) =>
                  s + ((r['rating'] ?? 0.0) as num).toDouble());
              avgRating = sum / restaurantsList.length;
            }

            final catMap = <String, int>{};
            for (final r in restaurantsList) {
              final cat = (r['category'] ?? 'Other') as String;
              catMap[cat] = (catMap[cat] ?? 0) + 1;
            }
            final sorted = catMap.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final maxVal = sorted.isEmpty ? 1 : sorted.first.value;

            final colors = [
              kPrimary, kBlue, kAmber, kRed, kGreen, kPurple,
              const Color(0xFF06B6D4), const Color(0xFFF97316),
            ];

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AdminPageHeader(
                      title: 'Analytics',
                      subtitle: 'Platform breakdown'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Row(
                      children: [
                        _MiniStatCard('$totalRestaurants',
                            'Restaurants', kPrimary),
                        const SizedBox(width: 10),
                        _MiniStatCard(
                            '$totalMenuItems', 'Menu Items', kBlue),
                        const SizedBox(width: 10),
                        _MiniStatCard(avgRating.toStringAsFixed(1),
                            'Avg Rating', kAmber),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                    child: Text('By Category', style: h2),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final entry = sorted[i];
                      final color = colors[i % colors.length];
                      final pct = entry.value / maxVal;
                      return Padding(
                        padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: kBorder),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle)),
                                      const SizedBox(width: 8),
                                      Text(entry.key, style: h3),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                      color.withValues(alpha: 0.1),
                                      borderRadius:
                                      BorderRadius.circular(8),
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
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: sorted.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        );
      },
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStatCard(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(label, style: caption),
          ],
        ),
      ),
    );
  }
}