import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../screens/recipe_detail_screen.dart';

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

  void _openRecipeDetails(int recipeId, String recipeTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          recipeId: recipeId,
          recipeTitle: recipeTitle,
        ),
      ),
    );
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
              return GestureDetector(
                onTap: () {
                  _openRecipeDetails(item['id'], item['title']);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: Image.network(item['image'],
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item['title']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFavorite(item['id']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
