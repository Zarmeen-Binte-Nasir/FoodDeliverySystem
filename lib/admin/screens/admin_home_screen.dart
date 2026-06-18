import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../screens/login_screen.dart';
import '../../widgets/admin_widgets.dart';
import 'dashboard.dart';
import 'restaurants.dart';
import 'orders.dart';
import 'analytics.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────
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

// ═════════════════════════════════════════════════════════════════════════════
// ADMIN HOME SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  final List<({IconData icon, String label})> _navItems = const [
    (icon: Icons.grid_view_rounded,       label: 'Dashboard'),
    (icon: Icons.storefront_outlined,     label: 'Restaurants'),
    (icon: Icons.shopping_bag_outlined,   label: 'Orders'),
    (icon: Icons.bar_chart_rounded,       label: 'Analytics'),
  ];

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: _buildBody(),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return DashboardTab(onLogout: _confirmLogout);
      case 1: return RestaurantsTab();
      case 2: return OrdersTab();
      case 3: return AnalyticsTab();
      default: return SizedBox();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: _navItems.asMap().entries.map((e) {
              final isActive = _selectedIndex == e.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? kPrimary.withOpacity(0.10)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          e.value.icon,
                          color: isActive ? kPrimary : kTextHint,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.value.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive ? kPrimary : kTextHint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _LogoutDialog(
        onConfirm: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOGOUT DIALOG
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: kRed.withOpacity(0.08), shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded, color: kRed, size: 26),
            ),
            const SizedBox(height: 16),
            const Text('Sign Out',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kText,
                    letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('You will be logged out of the admin panel.',
                style: TextStyle(
                    fontSize: 13, color: kTextSub, height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kBorder, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kTextSub)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Sign Out',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}