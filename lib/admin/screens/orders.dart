import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/admin_widgets.dart';

// ═════════════════════════════════════════════════════════════════════════════
// ORDERS TAB
// ═════════════════════════════════════════════════════════════════════════════

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  String _selectedStatus = 'All';

  final List<String> _statuses = [
    'All',
    'Pending',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':       return kPrimary;
      case 'Preparing':     return kBlue;
      case 'Out for Delivery': return kPurple;
      case 'Delivered':     return kGreen;
      case 'Cancelled':     return kRed;
      default:              return kTextHint;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Pending':           return Icons.access_time_rounded;
      case 'Preparing':         return Icons.restaurant_rounded;
      case 'Out for Delivery':  return Icons.delivery_dining_rounded;
      case 'Delivered':         return Icons.check_circle_rounded;
      case 'Cancelled':         return Icons.cancel_rounded;
      default:                  return Icons.help_outline;
    }
  }

  void _showOrderDetail(Map<String, dynamic> order, String docId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderDetailSheet(
        order: order,
        statusColor: _statusColor,
        statusIcon: _statusIcon,
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
        (doc.data() as Map<String, dynamic>)['status'] == 'Pending')
            .length;

        return Column(
          children: [
            PageHeader(
              title: 'Orders',
              subtitle:
              '${allOrders.length} total · $pendingCount pending',
            ),
            // Status filter chips
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: _statuses.length,
                itemBuilder: (_, i) {
                  final s = _statuses[i];
                  final isActive = _selectedStatus == s;
                  final color =
                  s == 'All' ? kText : _statusColor(s);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStatus = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14),
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
                    style: captionStyle),
              ),
            ),
            Expanded(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                  ? EmptyState(
                  message: 'No $_selectedStatus orders')
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final doc = filtered[i];
                  final order =
                  doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OrderCard(
                      order: order,
                      statusColor: _statusColor,
                      statusIcon: _statusIcon,
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