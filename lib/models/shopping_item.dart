class ShoppingItem {
  final int? id;
  final String name;
  final int quantity;
  final String unit;

  ShoppingItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  // Mengubah objek menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  // Mengubah format JSON menjadi objek
  static ShoppingItem fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }
}
