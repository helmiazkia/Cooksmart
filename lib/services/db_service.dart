import 'package:cooksmart/models/shopping_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal_plan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cooksmart.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 2, // Ganti versi jika ada perubahan
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel untuk rencana makan
    await db.execute('''
      CREATE TABLE meal_plan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day TEXT,
        mealType TEXT,
        recipeTitle TEXT,
        calories INTEGER
      );
    ''');

    // Tabel untuk daftar belanja
    await db.execute('''
      CREATE TABLE shopping_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        quantity INTEGER,
        unit TEXT
      );
    ''');

    // Tabel untuk favorit
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        title TEXT,
        image TEXT
      );
    ''');
  }

  // Fungsi untuk menangani pembaruan database (migrasi)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Jika versi sebelumnya lebih rendah dari 2, buat tabel baru
      await db.execute('''
        CREATE TABLE shopping_list (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          quantity INTEGER,
          unit TEXT
        );
      ''');
    }
  }

  // Fungsi untuk menambahkan rencana makan
  Future<void> addMealPlan(MealPlan mealPlan) async {
    final db = await instance.database;
    await db.insert('meal_plan', mealPlan.toJson());
  }

  // Ambil semua rencana makan
  Future<List<MealPlan>> getMealPlans() async {
    final db = await instance.database;
    final result = await db.query('meal_plan');
    return result.map((json) => MealPlan.fromJson(json)).toList();
  }

  // Hapus rencana makan berdasarkan ID
  Future<void> deleteMealPlan(int id) async {
    final db = await instance.database;
    await db.delete('meal_plan', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk menambahkan item ke daftar belanja
  Future<void> addShoppingItem(ShoppingItem item) async {
    final db = await instance.database;
    await db.insert('shopping_list', item.toJson());
  }

  // Ambil semua item dari daftar belanja
  Future<List<ShoppingItem>> getShoppingList() async {
    final db = await instance.database;
    final result = await db.query('shopping_list');
    return result.map((json) => ShoppingItem.fromJson(json)).toList();
  }

  // Hapus item dari daftar belanja berdasarkan ID
  Future<void> deleteShoppingItem(int id) async {
    final db = await instance.database;
    await db.delete('shopping_list', where: 'id = ?', whereArgs: [id]);
  }

  // Tambahkan resep favorit ke database
  Future<void> addFavorite(Map<String, dynamic> recipe) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      recipe,
      conflictAlgorithm: ConflictAlgorithm.replace, // Hindari duplikat
    );
  }

  // Ambil semua resep favorit
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  // Hapus resep favorit berdasarkan ID
  Future<void> deleteFavorite(int id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
