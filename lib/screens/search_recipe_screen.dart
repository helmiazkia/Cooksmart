import 'package:flutter/material.dart';
import 'package:cooksmart/screens/recipe_detail_screen.dart';
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
  String selectedDiet = '';
  String ingredients = '';

  final List<String> dietOptions = [
    'All Diets',
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

  void _fetchRecipes() async {
    if (ingredients.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter ingredients before searching for recipes!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final recipes = await _apiService.fetchRecipesByIngredients(
        ingredients,
        diet: selectedDiet == 'All Diets' ? '' : selectedDiet,
      );
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: DropdownButtonFormField<String>(
                value: selectedDiet.isEmpty ? null : selectedDiet,
                decoration: InputDecoration(
                  labelText: 'Select Diet Preference',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
            ),
            const SizedBox(height: 16),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter ingredients (e.g., tomato, chicken)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (text) {
                  ingredients = text;
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _fetchRecipes,
                child: const Text(
                  'Search Recipes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recipes.isEmpty
                      ? const Center(
                          child: Text(
                            'No recipes found',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _recipes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  recipe['title'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: recipe['image'] != null
                                      ? Image.network(
                                          recipe['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
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
                              ),
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
