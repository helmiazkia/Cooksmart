import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'meal_plan_screen.dart';
import 'search_recipe_screen.dart';
import 'shopping_list_screen.dart';
import 'nutritional_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SearchRecipeScreen(),
    const MealPlanScreen(),
    const ShoppingListScreen(),
    const FavoritesScreen(),
    const NutritionalInfoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Warna latar belakang AppBar
        elevation: 0, // Menghilangkan bayangan
        centerTitle: true, // Teks di tengah
        title: const Text(
          'CookSmart',
          style: TextStyle(
            color: Colors.white, // Warna teks putih
            fontSize: 24, // Ukuran font
            fontWeight: FontWeight.bold, // Bold teks
            fontFamily: 'DancingScript', // Font bergaya
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF6F9F6), // Warna background layar
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Warna ikon aktif
        unselectedItemColor: Colors.grey, // Warna ikon non-aktif
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rencana Makan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Daftar Belanja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}
