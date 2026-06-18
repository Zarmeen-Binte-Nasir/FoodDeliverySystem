// lib/screens/admin/tabs/admin_orders_tab.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_system/theme/app_theme.dart';
import 'package:food_delivery_system/widgets/admin_widgets.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> {
  String _selectedStatus = 'All';

  final List<String> _statuses = [
    'All',
    'Pending',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Cancelled'
  ];

  Color statusColor(String status) {
    switch (status) {
      case 'Pending': return kPrimary;
      case 'Preparing': return kBlue;
      case 'Out for Delivery': return kPurple;
      case 'Delivered': return kGreen;
      case 'Cancelled': return kRed;
      default: return kTextHint;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'Pending': return Icons.access_time_rounded;
      case 'Preparing': return Icons.restaurant_rounded;
      case 'Out for Delivery': return Icons.delivery_dining_rounded;
      case 'Delivered': return Icons.check_circle_rounded;
      case 'Cancelled': return Icons.cancel_rounded;
      default: return Icons.help_outline;
    }
  }

  void _showOrderDetail(Map<String, dynamic> order, String docId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminOrderDetailSheet(
        order: order,
        statusColor: statusColor,
        statusIcon: statusIcon,
        onStatusChanged: (newStatus) async {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(docId)
              .update({'status': newStatus});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        final allOrders = snapshot.data?.docs ?? [];
        final filtered = _selectedStatus == 'All'
            ? allOrders
            : allOrders
            .where((doc) =>
        (doc.data() as Map<String, dynamic>)['status'] ==
            _selectedStatus)
            .toList();

        final pendingCount = allOrders
            .where((doc) =>
        (doc.data() as Map<String, dynamic>)['status'] ==
            'Pending')
            .length;

        return Column(
          children: [
            AdminPageHeader(
              title: 'Orders',
              subtitle:
              '${allOrders.length} total · $pendingCount pending',
            ),
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                itemCount: _statuses.length,
                itemBuilder: (_, i) {
                  final s = _statuses[i];
                  final isActive = _selectedStatus == s;
                  final color =
                  s == 'All' ? kText : statusColor(s);
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedStatus = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? color : kSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isActive ? color : kBorder),
                      ),
                      child: Text(s,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? Colors.white
                                  : kTextSub)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${filtered.length} order${filtered.length != 1 ? 's' : ''}',
                    style: caption),
              ),
            ),
            Expanded(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                  ? AdminEmptyState(
                  message: 'No $_selectedStatus orders')
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 0),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final doc = filtered[i];
                  final order =
                  doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: 10),
                    child: AdminOrderCard(
                      order: order,
                      statusColor: statusColor,
                      statusIcon: statusIcon,
                      onTap: () =>
                          _showOrderDetail(order, doc.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────
class AdminOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Color Function(String) statusColor;
  final IconData Function(String) statusIcon;
  final VoidCallback onTap;

  const AdminOrderCard({
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['id'], style: caption),
                            AdminStatusChip(
                                label: order['status'],
                                color: color,
                                icon: statusIcon(order['status'])),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(order['restaurantName'], style: h3),
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
                  Text(
                      '\$${(order['total'] as num).toStringAsFixed(2)}',
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

// ── Order Detail Sheet ────────────────────────────────────────────────────────
class AdminOrderDetailSheet extends StatefulWidget {
  final Map<String, dynamic> order;
  final Color Function(String) statusColor;
  final IconData Function(String) statusIcon;
  final Function(String) onStatusChanged;

  const AdminOrderDetailSheet({
    super.key,
    required this.order,
    required this.statusColor,
    required this.statusIcon,
    required this.onStatusChanged,
  });

  @override
  State<AdminOrderDetailSheet> createState() =>
      _AdminOrderDetailSheetState();
}

class _AdminOrderDetailSheetState
    extends State<AdminOrderDetailSheet> {
  late String _currentStatus;
  final List<String> _allStatuses = [
    'Pending',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status'];
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.statusColor(_currentStatus);
    final items = (widget.order['items'] as List?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: kSurface,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(28)),
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
                    color: kBorder,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(widget.order['id'],
                              style: h2.copyWith(fontSize: 20)),
                          Text(widget.order['time'],
                              style: bodyStyle),
                        ],
                      ),
                      AdminStatusChip(
                          label: _currentStatus,
                          color: color,
                          icon: widget.statusIcon(_currentStatus)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: kBg,
                        borderRadius: BorderRadius.circular(14)),
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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(widget.order['restaurantName'],
                                style: h3),
                            Text('Restaurant', style: bodyStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionDivider(label: 'Customer Details'),
                  const SizedBox(height: 12),
                  _DetailRow(Icons.person_rounded,
                      widget.order['customerName']),
                  const SizedBox(height: 8),
                  _DetailRow(Icons.phone_rounded,
                      widget.order['customerPhone']),
                  const SizedBox(height: 8),
                  _DetailRow(Icons.location_on_rounded,
                      widget.order['address']),
                  const SizedBox(height: 20),
                  _SectionDivider(label: 'Order Items'),
                  const SizedBox(height: 12),
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Text(item,
                            style: bodyStyle.copyWith(
                                color: kText)),
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: h3.copyWith(color: kPrimary)),
                        Text(
                            'PKR${(widget.order['total'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: kPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionDivider(label: 'Update Status'),
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
                          duration:
                          const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: isActive
                                ? sColor
                                : sColor.withValues(alpha: 0.06),
                            borderRadius:
                            BorderRadius.circular(10),
                            border: Border.all(
                                color: isActive
                                    ? sColor
                                    : sColor.withValues(
                                    alpha: 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.statusIcon(s),
                                  color: isActive
                                      ? Colors.white
                                      : sColor,
                                  size: 13),
                              const SizedBox(width: 5),
                              Text(s,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w700,
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

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: caption.copyWith(
                fontWeight: FontWeight.w800,
                color: kTextSub,
                letterSpacing: 0.5)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: kBorder)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 15, color: kPrimary),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text, style: bodyStyle.copyWith(color: kText))),
      ],
    );
  }
}