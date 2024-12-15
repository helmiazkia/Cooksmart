import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '27aec1d7480f4b78818f2b1126c561cb';
  final String baseUrl = 'https://api.spoonacular.com';

  // Fetch recipes by ingredients
  Future<List<dynamic>> fetchRecipesByIngredients(String ingredients) async {
    final url =
        '$baseUrl/recipes/findByIngredients?ingredients=$ingredients&number=10&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch recipe details
  Future<Map<String, dynamic>> fetchRecipeDetails(int id) async {
    final url =
        '$baseUrl/recipes/$id/information?includeNutrition=true&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  // Tambahkan fetchRecipeDetailsFromUrl jika diperlukan
  Future<Map<String, dynamic>> fetchRecipeDetailsFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
