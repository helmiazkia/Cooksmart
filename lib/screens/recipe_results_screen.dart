import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecipeResultsScreen extends StatelessWidget {
  final String ingredient;

  const RecipeResultsScreen({Key? key, required this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes with "$ingredient"'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().fetchRecipesByIngredients(ingredient),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load recipes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No recipes found for the ingredient.',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(recipe['title']),
                    leading: recipe['image'] != null
                        ? Image.network(
                            recipe['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.food_bank),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
