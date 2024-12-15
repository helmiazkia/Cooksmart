import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  // Fetch recipes by ingredients
  Future<void> fetchRecipes(String ingredients) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchRecipesByIngredients(ingredients);
      _recipes = response.map<Recipe>((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
