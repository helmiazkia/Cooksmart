import 'package:flutter/material.dart';
import 'package:cooksmart/screens/recipe_detail_screen.dart'; // Import layar detail resep
import '../services/api_service.dart';

class SearchRecipeScreen extends StatefulWidget {
  const SearchRecipeScreen({Key? key}) : super(key: key);

  @override
  _SearchRecipeScreenState createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _recipes = [];
  bool isLoading = false;
  String selectedDiet = ''; // Variabel untuk menyimpan pilihan diet

  // Daftar pilihan diet yang tersedia
  List<String> dietOptions = [
    'Semua Diet',
    'Keto',
    'Vegan',
    'Vegetarian',
    'Gluten Free',
    'Dairy Free',
    'Paleo',
    'Low Carb',
    'Low Fat',
    'High Protein',
    'Whole 30',
  ];

  void _fetchRecipes(String ingredients) async {
    setState(() {
      isLoading = true;
    });

    try {
      final recipes = await _apiService.fetchRecipesByIngredients(ingredients,
          diet: selectedDiet);
      setState(() {
        _recipes = recipes;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pencarian Resep')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown untuk memilih preferensi diet
            DropdownButton<String>(
              value: selectedDiet.isEmpty ? null : selectedDiet,
              hint: const Text('Pilih Diet'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDiet = newValue ?? '';
                });
              },
              items: dietOptions.map((String diet) {
                return DropdownMenuItem<String>(
                  value: diet,
                  child: Text(diet),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // TextField untuk memasukkan bahan
            TextField(
              decoration: const InputDecoration(
                labelText: 'Masukkan bahan (misalnya: tomat, ayam)',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                // Update ketika bahan diubah
              },
            ),
            const SizedBox(height: 16),
            // Tombol untuk mencari resep
            ElevatedButton(
              onPressed: () {
                String ingredients =
                    'tomato, chicken'; // Gantilah ini dengan input bahan dari pengguna
                _fetchRecipes(ingredients);
              },
              child: const Text('Cari Resep'),
            ),
            const SizedBox(height: 16),
            // Menampilkan indikator loading atau resep
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _recipes[index];
                        return ListTile(
                          title: Text(recipe['title']),
                          leading: Image.network(
                            recipe['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            // Navigasi ke layar detail resep
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipeId: recipe['id'],
                                  recipeTitle: recipe['title'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
