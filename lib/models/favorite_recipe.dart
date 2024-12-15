// models/favorite_recipe.dart
class FavoriteRecipe {
  final int id;
  final String title;
  final String imageUrl;

  FavoriteRecipe({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  // Menambahkan metode toJson untuk mengonversi objek menjadi Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
    };
  }

  // Mengonversi Map ke objek FavoriteRecipe (dari database)
  factory FavoriteRecipe.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipe(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
    );
  }
}
