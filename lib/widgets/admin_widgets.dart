// lib/screens/admin/widgets/admin_shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_system/theme/app_theme.dart';

// ── Orange Badge Icon ─────────────────────────────────────────────────────────
class AdminOrangeBadgeIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const AdminOrangeBadgeIcon({super.key, required this.icon, this.size = 44});

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
              color: kPrimary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.48),
    );
  }
}

// ── Page Header ───────────────────────────────────────────────────────────────
class AdminPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onLogout;

  const AdminPageHeader(
      {super.key, required this.title, required this.subtitle, this.trailing, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 20),
      color: kSurface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: h1),
                const SizedBox(height: 3),
                Text(subtitle, style: bodyStyle),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (isNarrow && onLogout != null) ...[
            const SizedBox(width: 10),
            _MobileLogoutButton(onTap: onLogout!),
          ],
        ],
      ),
    );
  }
}

class _MobileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kRed.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout_rounded, color: kRed, size: 15),
            const SizedBox(width: 5),
            Text('Logout',
                style: caption.copyWith(
                    color: kRed, fontWeight: FontWeight.w800, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────
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
                  Text(r['name'], style: h3),
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
                        color: kRed.withValues(alpha: 0.08),
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

// ── Form Field ────────────────────────────────────────────────────────────────
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
                  color: kText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
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