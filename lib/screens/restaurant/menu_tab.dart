import 'package:flutter/material.dart';
import 'package:food_delivery_system/data/dummy_data.dart';
import 'package:food_delivery_system/theme/app_theme.dart';

class MenuTab extends StatelessWidget {
  final int restaurantId;
  final List<Map<String, dynamic>> items;
  final VoidCallback onUpdate;

  const MenuTab({
    super.key,
    required this.restaurantId,
    required this.items,
    required this.onUpdate,
  });

  void _showAddEditItem(BuildContext context, [Map<String, dynamic>? item]) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?['name'] ?? '');
    final priceController = TextEditingController(text: item?['price']?.toString() ?? '');
    final descController = TextEditingController(text: item?['description'] ?? '');
    final imageController = TextEditingController(text: item?['image'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEditing ? 'Edit Item' : 'Add New Item', style: h1),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price (Rs)'), keyboardType: TextInputType.number),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (isEditing) {
                    item['name'] = nameController.text;
                    item['price'] = double.tryParse(priceController.text) ?? 0.0;
                    item['description'] = descController.text;
                    item['image'] = imageController.text;
                  } else {
                    menuItems.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'restaurantId': restaurantId,
                      'name': nameController.text,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'description': descController.text,
                      'image': imageController.text,
                      'category': 'Custom',
                    });
                  }
                  Navigator.pop(context);
                  onUpdate();
                },
                child: Text(isEditing ? 'Update Item' : 'Add Item', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Menu', style: h1),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Item'),
                onPressed: () => _showAddEditItem(context),
                style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item['image'], width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(item['name'], style: h2),
                  subtitle: Text('Rs ${item['price']}', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: kBlue), onPressed: () => _showAddEditItem(context, item)),
                      IconButton(icon: const Icon(Icons.delete, color: kRed), onPressed: () {
                        menuItems.remove(item);
                        onUpdate();
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
