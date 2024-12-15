class MealPlan {
  final int? id;
  final String day; // Hari rencana makan
  final String mealType; // Jenis makan (sarapan, makan siang, makan malam)
  final String recipeTitle; // Judul resep
  final int calories; // Jumlah kalori

  MealPlan({
    this.id,
    required this.day,
    required this.mealType,
    required this.recipeTitle,
    required this.calories,
  });

  // Convert MealPlan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'mealType': mealType,
      'recipeTitle': recipeTitle,
      'calories': calories,
    };
  }

  // Create MealPlan object from JSON
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as int?,
      day: json['day'] as String,
      mealType: json['mealType'] as String,
      recipeTitle: json['recipeTitle'] as String,
      calories: json['calories'] as int,
    );
  }
}
