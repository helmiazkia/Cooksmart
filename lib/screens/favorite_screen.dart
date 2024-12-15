import 'package:flutter/material.dart';

import '../services/db_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Map<String, dynamic>>> _favorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favorites = DatabaseHelper.instance.getFavorites();
    });
  }

  void _deleteFavorite(int id) async {
    await DatabaseHelper.instance.deleteFavorite(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resep Favorit')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada resep favorit.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(item['image'],
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(item['title']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteFavorite(item['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
