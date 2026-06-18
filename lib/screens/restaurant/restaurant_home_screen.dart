import 'package:flutter/material.dart';
import 'package:food_delivery_system/data/dummy_data.dart';
import 'package:food_delivery_system/screens/auth/login_screen.dart';
import 'package:food_delivery_system/screens/restaurant/dashboard_tab.dart';
import 'package:food_delivery_system/screens/restaurant/menu_tab.dart';
import 'package:food_delivery_system/screens/restaurant/orders_tab.dart';
import 'package:food_delivery_system/theme/app_theme.dart';

class RestaurantHomeScreen extends StatefulWidget {
  final int restaurantId;
  const RestaurantHomeScreen({super.key, this.restaurantId = 1});

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  int _selectedIndex = 0;

  Map<String, dynamic> get restaurant =>
      restaurants.firstWhere((r) => r['id'] == widget.restaurantId);
  List<Map<String, dynamic>> get myMenuItems =>
      menuItems.where((m) => m['restaurantId'] == widget.restaurantId).toList();
  List<Map<String, dynamic>> get myOrders =>
      orders.where((o) => o['restaurantId'] == widget.restaurantId).toList();

  final List<({IconData icon, String label})> _navItems = const [
    (icon: Icons.dashboard_rounded, label: 'Stats'),
    (icon: Icons.restaurant_menu_rounded, label: 'Menu'),
    (icon: Icons.receipt_long_rounded, label: 'Orders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(restaurant['image']),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant['name'], style: h2),
                Text('Restaurant Panel', style: caption.copyWith(color: kPrimary)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: kRed),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardTab(
          restaurant: restaurant,
          menuCount: myMenuItems.length,
          orderCount: myOrders.length,
        );
      case 1:
        return MenuTab(
          restaurantId: widget.restaurantId,
          items: myMenuItems,
          onUpdate: () => setState(() {}),
        );
      case 2:
        return OrdersTab(
          orders: myOrders,
          onUpdate: () => setState(() {}),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: _navItems.asMap().entries.map((e) {
              final isActive = _selectedIndex == e.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = e.key),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.value.icon, color: isActive ? kPrimary : kTextHint),
                      Text(
                        e.value.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
}
