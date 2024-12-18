import 'package:cooksmart/screens/nutrition_info_screen.dart';
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
  bool isFavorite = false; // Menambahkan status favorit

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
    checkIfFavorite();
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

  // Fungsi untuk memeriksa status favorit
  Future<void> checkIfFavorite() async {
    final isFav = await DatabaseHelper.instance.isFavorite(widget.recipeId);
    setState(() {
      isFavorite = isFav;
    });
  }

  Future<void> addToFavorites() async {
    if (recipeDetails == null) return;

    final recipe = FavoriteRecipe(
      id: widget.recipeId,
      title: widget.recipeTitle,
      imageUrl: recipeDetails!['image'],
    );

    await DatabaseHelper.instance.addFavorite(recipe.toJson());
    setState(() {
      isFavorite = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resep ditambahkan ke favorit!')),
    );
  }

  Future<void> removeFromFavorites() async {
    if (recipeDetails == null) return;

    await DatabaseHelper.instance.deleteFavorite(widget.recipeId);
    setState(() {
      isFavorite = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resep dihapus dari favorit!')),
    );
  }

  Future<void> addToShoppingList(List<dynamic> ingredients) async {
    for (var ingredient in ingredients) {
      final item = ShoppingItem(
        name: ingredient['original'],
        quantity: 1, // Bisa disesuaikan
        unit: ingredient['unit'] ?? 'pcs',
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
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: isFavorite ? removeFromFavorites : addToFavorites,
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
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(ingredient['original']),
                                      ),
                                      // Menambahkan jumlah bahan
                                      Text(
                                        '${ingredient['amount']} ${ingredient['unit'] ?? ''}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      addToShoppingList([ingredient]);
                                    },
                                    child: const Text('Tambah'),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Langkah Memasak: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              recipeDetails!['analyzedInstructions'].isEmpty
                                  ? const Text('Tidak ada langkah memasak.')
                                  : Column(
                                      children:
                                          recipeDetails!['analyzedInstructions']
                                                  [0]['steps']
                                              .map<Widget>((step) => ListTile(
                                                    leading: CircleAvatar(
                                                      child: Text(
                                                          '${step['number']}'),
                                                    ),
                                                    title: Text(step['step']),
                                                  ))
                                              .toList(),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Informasi Nutrisi: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Kalori: ${recipeDetails!['nutrition']['nutrients'][0]['amount']} kkal',
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (recipeDetails != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NutritionInfoScreen(
                                          nutritionDetails: {
                                            'calories':
                                                recipeDetails!['nutrition']
                                                    ['nutrients'][0]['amount'],
                                            'protein':
                                                recipeDetails!['nutrition']
                                                    ['nutrients'][1]['amount'],
                                            'carbs': recipeDetails!['nutrition']
                                                ['nutrients'][2]['amount'],
                                            'fat': recipeDetails!['nutrition']
                                                ['nutrients'][3]['amount'],
                                            'fiber': recipeDetails!['nutrition']
                                                ['nutrients'][4]['amount'],
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Lihat Informasi Nutrisi'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
