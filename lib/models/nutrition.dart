// models/nutrition.dart
class Nutrition {
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });

  // Factory constructor untuk membuat objek Nutrition dari map (biasanya JSON)
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      fat: json['fat']?.toDouble() ?? 0.0,
      carbohydrates: json['carbohydrates']?.toDouble() ?? 0.0,
    );
  }

  // Mengonversi objek Nutrition ke map
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
    };
  }
}
