import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../services/db_service.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late Future<List<ShoppingItem>> shoppingList;

  @override
  void initState() {
    super.initState();
    shoppingList = DatabaseHelper.instance.getShoppingList();
  }

  void _addItemToShoppingList(String name, int quantity, String unit) async {
    final newItem = ShoppingItem(name: name, quantity: quantity, unit: unit);
    await DatabaseHelper.instance.addShoppingItem(newItem);
    setState(() {
      shoppingList = DatabaseHelper.instance.getShoppingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: FutureBuilder<List<ShoppingItem>>(
        future: shoppingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Daftar belanja kosong'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Jumlah: ${item.quantity} ${item.unit}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance
                          .deleteShoppingItem(item.id!);
                      setState(() {
                        shoppingList =
                            DatabaseHelper.instance.getShoppingList();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Menambahkan bahan ke daftar belanja
          _showAddItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Bahan ke Daftar Belanja'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Bahan'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah'),
              ),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final unit = unitController.text;

                if (name.isNotEmpty && unit.isNotEmpty) {
                  _addItemToShoppingList(name, quantity, unit);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
