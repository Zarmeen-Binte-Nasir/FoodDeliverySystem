<<<<<<< HEAD
// lib/screens/admin/widgets/admin_shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_system/theme/app_theme.dart';

// ── Orange Badge Icon ─────────────────────────────────────────────────────────
class AdminOrangeBadgeIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const AdminOrangeBadgeIcon({super.key, required this.icon, this.size = 44});
=======
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Color Constants ───────────────────────────────────────────────────────────
const kPrimary      = Color(0xFFFF6B35);
const kPrimaryLight = Color(0xFFFFF3EE);
const kPrimaryDark  = Color(0xFFCC4F1F);
const kBg           = Color(0xFFF5F4F2);
const kSurface      = Colors.white;
const kText         = Color(0xFF111111);
const kTextSub      = Color(0xFF666666);
const kTextHint     = Color(0xFFBBBBBB);
const kBorder       = Color(0xFFEDEBE8);
const kGreen        = Color(0xFF16A34A);
const kBlue         = Color(0xFF2563EB);
const kAmber        = Color(0xFFD97706);
const kRed          = Color(0xFFDC2626);
const kPurple       = Color(0xFF7C3AED);
// ── Text Styles (shared) ──────────────────────────────────────────────────────

TextStyle get displayXLStyle => const TextStyle(
    fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF111111), letterSpacing: -1.2, height: 1.0);

TextStyle get h1Style => const TextStyle(
    fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF111111), letterSpacing: -0.8, height: 1.1);

TextStyle get h2Style => const TextStyle(
    fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111111), letterSpacing: -0.4);

TextStyle get h3Style => const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111111), letterSpacing: -0.2);

TextStyle get bodyStyle => const TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF666666), height: 1.5);

TextStyle get captionStyle => const TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFBBBBBB), letterSpacing: 0.3);

TextStyle get labelStyle => const TextStyle(
    fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFBBBBBB), letterSpacing: 1.2);

// ═════════════════════════════════════════════════════════════════════════════
// ORANGE BADGE ICON
// ═════════════════════════════════════════════════════════════════════════════

class OrangeBadgeIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const OrangeBadgeIcon({super.key, required this.icon, this.size = 44});
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimary, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
<<<<<<< HEAD
              color: kPrimary.withValues(alpha: 0.35),
=======
              color: kPrimary.withOpacity(0.35),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.48),
    );
  }
}

<<<<<<< HEAD
// ── Page Header ───────────────────────────────────────────────────────────────
class AdminPageHeader extends StatelessWidget {
=======
// ═════════════════════════════════════════════════════════════════════════════
// PAGE HEADER
// ═════════════════════════════════════════════════════════════════════════════

class PageHeader extends StatelessWidget {
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onLogout;

<<<<<<< HEAD
  const AdminPageHeader(
      {super.key, required this.title, required this.subtitle, this.trailing, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 20),
      color: kSurface,
=======
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      color: kBg,
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(title, style: h1),
                const SizedBox(height: 3),
=======
                Text(title, style: h1Style),
                const SizedBox(height: 2),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
                Text(subtitle, style: bodyStyle),
              ],
            ),
          ),
          if (trailing != null) trailing!,
<<<<<<< HEAD
          if (isNarrow && onLogout != null) ...[
            const SizedBox(width: 10),
            _MobileLogoutButton(onTap: onLogout!),
=======
          if (onLogout != null) ...[
            const SizedBox(width: 10),
            MobileLogoutButton(onTap: onLogout!),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
          ],
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _MobileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileLogoutButton({super.key, required this.onTap});
=======
// ═════════════════════════════════════════════════════════════════════════════
// MOBILE LOGOUT BUTTON
// ═════════════════════════════════════════════════════════════════════════════

class MobileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const MobileLogoutButton({super.key, required this.onTap});
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: kRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kRed.withValues(alpha: 0.2)),
=======
          color: kRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kRed.withOpacity(0.2)),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout_rounded, color: kRed, size: 15),
            const SizedBox(width: 5),
            Text('Logout',
<<<<<<< HEAD
                style: caption.copyWith(
=======
                style: captionStyle.copyWith(
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
                    color: kRed, fontWeight: FontWeight.w800, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
// ── Search Bar ────────────────────────────────────────────────────────────────
class AdminSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const AdminSearchBar({super.key, required this.hint, required this.onChanged});
=======
// ═════════════════════════════════════════════════════════════════════════════
// STAT DATA MODEL
// ═════════════════════════════════════════════════════════════════════════════

class StatData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String trend;
  const StatData({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.trend,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
// BIG STAT CARD
// ═════════════════════════════════════════════════════════════════════════════

class BigStatCard extends StatelessWidget {
  final StatData data;
  const BigStatCard({super.key, required this.data});
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
      height: 48,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: bodyStyle,
          prefixIcon:
          const Icon(Icons.search_rounded, color: kPrimary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
=======
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
              Icon(data.icon, color: data.color, size: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(data.trend,
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: data.color)),
              ),
            ],
          ),
          const Spacer(),
          Text(data.value,
              style: displayXLStyle.copyWith(color: data.color, fontSize: 28)),
          const SizedBox(height: 2),
          Text(data.label, style: captionStyle),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// REVENUE CARD
// ═════════════════════════════════════════════════════════════════════════════

class RevenueCard extends StatelessWidget {
  final double revenue;          
  const RevenueCard({super.key, required this.revenue});

  @override
  Widget build(BuildContext context) {
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
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.trending_up_rounded,
                  color: Colors.white70, size: 18),
              const Spacer(),
              Text('\$8,240',
                  style: displayXLStyle.copyWith(
                      color: Colors.white, fontSize: 26)),
              const SizedBox(height: 2),
              Text('Revenue', style: captionStyle.copyWith(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ACTIVITY CARD
// ═════════════════════════════════════════════════════════════════════════════

class ActivityCard extends StatelessWidget {
  final int totalMenuItems;
  const ActivityCard({super.key, required this.totalMenuItems});

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
          Text('$totalMenuItems',
              style:
              displayXLStyle.copyWith(color: Colors.white, fontSize: 26)),
          const SizedBox(height: 2),
          Text('Menu Items',
              style: captionStyle.copyWith(color: Colors.white38)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// MINI STAT CARD
// ═════════════════════════════════════════════════════════════════════════════

class MiniStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const MiniStatCard(this.value, this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
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
            Text(label, style: captionStyle),
          ],
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
        ),
      ),
    );
  }
}

<<<<<<< HEAD
// ── Empty State ───────────────────────────────────────────────────────────────
class AdminEmptyState extends StatelessWidget {
  final String message;
  const AdminEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                color: kBg,
                shape: BoxShape.circle,
                border: Border.all(color: kBorder)),
            child: const Icon(Icons.inbox_rounded, color: kTextHint, size: 32),
          ),
          const SizedBox(height: 16),
          Text(message, style: h3.copyWith(color: kTextSub)),
          const SizedBox(height: 6),
          Text('Nothing to show here', style: bodyStyle),
        ],
      ),
    );
  }
}

// ── Status Chip ───────────────────────────────────────────────────────────────
class AdminStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const AdminStatusChip(
      {super.key, required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Restaurant Card ───────────────────────────────────────────────────────────
class AdminRestaurantCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final VoidCallback? onDelete;
  const AdminRestaurantCard({super.key, required this.r, this.onDelete});
=======
// ═════════════════════════════════════════════════════════════════════════════
// RESTAURANT CARD
// ═════════════════════════════════════════════════════════════════════════════

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final VoidCallback? onDelete;
  const RestaurantCard({super.key, required this.r, this.onDelete});
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646

  @override
  Widget build(BuildContext context) {
    final rating = ((r['rating'] ?? 0.0) as num).toDouble();
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                r['image'] ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: kBg,
                  child:
                  const Icon(Icons.restaurant, color: kTextHint, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  Text(r['name'], style: h3),
=======
                  Text(r['name'], style: h3Style),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
                  const SizedBox(height: 2),
                  Text(r['category'], style: bodyStyle),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: kAmber, size: 13),
                      const SizedBox(width: 3),
                      Text(rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kAmber)),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time_rounded,
                          color: kTextHint, size: 13),
                      const SizedBox(width: 3),
                      Text(r['deliveryTime'] ?? '', style: bodyStyle),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kPrimaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(r['deliveryFee'] ?? '',
                      style: const TextStyle(
                          fontSize: 12,
                          color: kPrimary,
                          fontWeight: FontWeight.w700)),
                ),
                if (onDelete != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
<<<<<<< HEAD
                        color: kRed.withValues(alpha: 0.08),
=======
                        color: kRed.withOpacity(0.08),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: kRed, size: 16),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
// ── Form Field ────────────────────────────────────────────────────────────────
=======
// ═════════════════════════════════════════════════════════════════════════════
// ORDER CARD
// ═════════════════════════════════════════════════════════════════════════════

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Color Function(String) statusColor;
  final IconData Function(String) statusIcon;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.statusColor,
    required this.statusIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = statusColor(order['status']);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      order['restaurantImage'],
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 52,
                        height: 52,
                        color: kBg,
                        child: const Icon(Icons.restaurant,
                            color: kTextHint, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['id'], style: captionStyle),
                            StatusChip(
                                label: order['status'],
                                color: color,
                                icon: statusIcon(order['status'])),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(order['restaurantName'], style: h3Style),
                        Text(order['customerName'], style: bodyStyle),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: kBorder),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: kTextHint),
                      const SizedBox(width: 4),
                      Text(order['time'], style: bodyStyle),
                    ],
                  ),
                  Text('\$${(order['total'] as num).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: kPrimary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STATUS CHIP
// ═════════════════════════════════════════════════════════════════════════════

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const StatusChip(
      {super.key, required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ORDER DETAIL SHEET
// ═════════════════════════════════════════════════════════════════════════════

class OrderDetailSheet extends StatefulWidget {
  final Map<String, dynamic> order;
  final Color Function(String) statusColor;
  final IconData Function(String) statusIcon;
  final Function(String) onStatusChanged;

  const OrderDetailSheet({
    super.key,
    required this.order,
    required this.statusColor,
    required this.statusIcon,
    required this.onStatusChanged,
  });

  @override
  State<OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends State<OrderDetailSheet> {
  late String _currentStatus;
  final List<String> _allStatuses = [
    'Pending',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status'];
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.statusColor(_currentStatus);
    final items = List<String>.from(widget.order['items']);

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: kBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order['id'],
                              style: h2Style.copyWith(fontSize: 20)),
                          Text(widget.order['time'], style: bodyStyle),
                        ],
                      ),
                      StatusChip(
                          label: _currentStatus,
                          color: color,
                          icon: widget.statusIcon(_currentStatus)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: kBg, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.order['restaurantImage'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                width: 48,
                                height: 48,
                                color: kBorder,
                                child: const Icon(Icons.restaurant,
                                    color: kTextHint)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.order['restaurantName'], style: h3Style),
                            Text('Restaurant', style: bodyStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SectionDivider(label: 'Customer Details'),
                  const SizedBox(height: 12),
                  DetailRow(Icons.person_rounded, widget.order['customerName']),
                  const SizedBox(height: 8),
                  DetailRow(Icons.phone_rounded, widget.order['customerPhone']),
                  const SizedBox(height: 8),
                  DetailRow(Icons.location_on_rounded, widget.order['address']),
                  const SizedBox(height: 20),
                  SectionDivider(label: 'Order Items'),
                  const SizedBox(height: 12),
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: kPrimary, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Text(item,
                            style: bodyStyle.copyWith(color: kText)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: kPrimaryLight,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: h3Style.copyWith(color: kPrimary)),
                        Text(
                            '\$${(widget.order['total'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: kPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SectionDivider(label: 'Update Status'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allStatuses.map((s) {
                      final isActive = _currentStatus == s;
                      final sColor = widget.statusColor(s);
                      return GestureDetector(
                        onTap: () {
                          setState(() => _currentStatus = s);
                          widget.onStatusChanged(s);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: isActive
                                ? sColor
                                : sColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: isActive
                                    ? sColor
                                    : sColor.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.statusIcon(s),
                                  color:
                                  isActive ? Colors.white : sColor,
                                  size: 13),
                              const SizedBox(width: 5),
                              Text(s,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isActive
                                          ? Colors.white
                                          : sColor)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION DIVIDER
// ═════════════════════════════════════════════════════════════════════════════

class SectionDivider extends StatelessWidget {
  final String label;
  const SectionDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: captionStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: kTextSub,
                letterSpacing: 0.5)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: kBorder)),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// DETAIL ROW
// ═════════════════════════════════════════════════════════════════════════════

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const DetailRow(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: kPrimaryLight, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 15, color: kPrimary),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: bodyStyle.copyWith(color: kText))),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SEARCH BAR
// ═════════════════════════════════════════════════════════════════════════════

class AdminSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const AdminSearchBar({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: bodyStyle,
          prefixIcon:
          const Icon(Icons.search_rounded, color: kPrimary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═════════════════════════════════════════════════════════════════════════════

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                color: kBg,
                shape: BoxShape.circle,
                border: Border.all(color: kBorder)),
            child: const Icon(Icons.inbox_rounded, color: kTextHint, size: 32),
          ),
          const SizedBox(height: 16),
          Text(message, style: h3Style.copyWith(color: kTextSub)),
          const SizedBox(height: 6),
          Text('Nothing to show here', style: bodyStyle),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ADD RESTAURANT SHEET
// ═════════════════════════════════════════════════════════════════════════════

class AddRestaurantSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  const AddRestaurantSheet({super.key, required this.onAdd});

  @override
  State<AddRestaurantSheet> createState() => _AddRestaurantSheetState();
}

class _AddRestaurantSheetState extends State<AddRestaurantSheet> {
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: kBorder, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Restaurant', style: h2Style),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          color: kBg, borderRadius: BorderRadius.circular(10)),
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
                        hint: 'e.g. \$2.99 or Free',
                        icon: Icons.delivery_dining_rounded,
                        validator: (v) =>
                        v!.isEmpty ? 'Delivery fee is required' : null),
                    AdminFormField(
                        controller: _priceRangeController,
                        label: 'Price Range',
                        hint: 'e.g. \$\$ or \$10–\$30',
                        icon: Icons.payments_outlined),
                    AdminFormField(
                        controller: _freeAboveController,
                        label: 'Free Delivery Above (optional)',
                        hint: 'e.g. \$20',
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
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Add Restaurant',
                            style: h3Style.copyWith(
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

// ═════════════════════════════════════════════════════════════════════════════
// ADMIN FORM FIELD
// ═════════════════════════════════════════════════════════════════════════════

>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
class AdminFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AdminFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: bodyStyle.copyWith(
<<<<<<< HEAD
                  color: kText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
=======
                  color: kText, fontWeight: FontWeight.w600, fontSize: 13)),
>>>>>>> 8d61d677478ac338835568e82a6be84b75d9a646
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: bodyStyle.copyWith(color: kText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: bodyStyle,
              prefixIcon: Icon(icon, color: kPrimary, size: 18),
              filled: true,
              fillColor: kBg,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kRed, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kRed, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}