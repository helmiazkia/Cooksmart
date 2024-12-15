import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';

class SearchRecipeScreen extends StatefulWidget {
  const SearchRecipeScreen({Key? key}) : super(key: key);

  @override
  _SearchRecipeScreenState createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final apiService = ApiService();
      final recipes = await apiService.fetchRecipesByIngredients(
        _ingredientsController.text,
      );
      setState(() {
        _recipes = recipes.map((recipe) => Recipe.fromJson(recipe)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mencari resep';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Resep'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Masukkan bahan-bahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchRecipes,
              child: const Text('Cari Resep'),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty) Text(_errorMessage),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: _recipes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
