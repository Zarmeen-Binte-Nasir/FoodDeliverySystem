import 'package:flutter/material.dart';
import 'package:food_delivery_system/theme/app_theme.dart';

class DashboardTab extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final int menuCount;
  final int orderCount;

  const DashboardTab({
    super.key,
    required this.restaurant,
    required this.menuCount,
    required this.orderCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Performance Overview', style: h1),
        const SizedBox(height: 20),
        Row(
          children: [
            _StatCard(label: 'Total Orders', value: '$orderCount', icon: Icons.receipt_long, color: kBlue),
            const SizedBox(width: 15),
            _StatCard(label: 'Rating', value: '${restaurant['rating']}', icon: Icons.star, color: kAmber),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _StatCard(label: 'Menu Items', value: '$menuCount', icon: Icons.menu_book, color: kGreen),
            const SizedBox(width: 15),
            _StatCard(label: 'Revenue', value: 'Rs 12.5k', icon: Icons.payments, color: kPurple),
          ],
        ),
        const SizedBox(height: 30),
        Text('Restaurant Details', style: h2),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            children: [
              _InfoRow(Icons.category, 'Category', restaurant['category']),
              const Divider(),
              _InfoRow(Icons.timer, 'Delivery Time', restaurant['deliveryTime']),
              const Divider(),
              _InfoRow(Icons.local_shipping, 'Fee', restaurant['deliveryFee']),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(value, style: displayXL.copyWith(color: color, fontSize: 28)),
            Text(label, style: caption),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final String value;
  const _InfoRow(this.icon, this.labelText, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kTextSub),
          const SizedBox(width: 10),
          Text(labelText, style: bodyStyle),
          const Spacer(),
          Text(value, style: h3),
        ],
      ),
    );
  }
}
