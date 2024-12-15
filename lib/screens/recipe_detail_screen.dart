import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/favorite_recipe.dart';
import '../models/shopping_item.dart';
import '../services/db_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final String recipeTitle;

  const RecipeDetailScreen({
    Key? key,
    required this.recipeId,
    required this.recipeTitle,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? recipeDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    try {
      final details = await _apiService.fetchRecipeDetails(widget.recipeId);
      setState(() {
        recipeDetails = details;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching recipe details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToFavorites() async {
    if (recipeDetails == null) return;

    final recipe = FavoriteRecipe(
      id: widget.recipeId,
      title: widget.recipeTitle,
      imageUrl: recipeDetails!['image'],
    );

    // Menggunakan toJson untuk mengonversi FavoriteRecipe menjadi Map
    await DatabaseHelper.instance.addFavorite(recipe.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resep ditambahkan ke favorit!')),
    );
  }

  // Fungsi untuk menambahkan bahan ke daftar belanja

  Future<void> addToShoppingList(List<dynamic> ingredients) async {
    // Loop melalui semua bahan dan tambahkan ke daftar belanja
    for (var ingredient in ingredients) {
      final item = ShoppingItem(
        name: ingredient['original'],
        quantity:
            1, // Anda bisa menyesuaikan jumlahnya sesuai dengan data resep jika diperlukan
        unit: ingredient['unit'] ??
            'pcs', // Jika unit tidak ada, set default ke 'pcs'
      );
      await DatabaseHelper.instance.addShoppingItem(item);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Bahan-bahan ditambahkan ke daftar belanja!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.red,
            onPressed: addToFavorites,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipeDetails == null
              ? const Center(child: Text('Gagal memuat detail resep.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Image.network(
                        recipeDetails!['image'],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recipeDetails!['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bahan-Bahan: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...recipeDetails!['extendedIngredients']
                          .map<Widget>((ingredient) {
                        return ListTile(
                          title: Text(ingredient['original']),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Menambahkan bahan ke daftar belanja
                              addToShoppingList([ingredient]);
                            },
                            child: const Text('Tambah'),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      const Text(
                        'Langkah Memasak:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      recipeDetails!['analyzedInstructions'].isEmpty
                          ? const Text('Tidak ada langkah memasak.')
                          : Column(
                              children: recipeDetails!['analyzedInstructions']
                                      [0]['steps']
                                  .map<Widget>((step) => ListTile(
                                        leading: CircleAvatar(
                                          child: Text('${step['number']}'),
                                        ),
                                        title: Text(step['step']),
                                      ))
                                  .toList(),
                            ),
                      const SizedBox(height: 16),
                      const Text(
                        'Informasi Nutrisi:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kalori: ${recipeDetails!['nutrition']['nutrients'][0]['amount']} kkal',
                      ),
                    ],
                  ),
                ),
    );
  }
}
