import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'meal_plan_screen.dart';
import 'search_recipe_screen.dart';
import 'shopping_list_screen.dart';

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
  ];

  final List<String> _titles = [
    'Search Recipes',
    'Meal Plan',
    'Shopping List',
    'Favorites',
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
        backgroundColor:
            const Color.fromARGB(255, 3, 152, 8), // Warna hijau lembut
        elevation: 4, // Tambahkan sedikit bayangan
        centerTitle: true, // Teks di tengah
        title: Text(
          _titles[_selectedIndex], // Judul berubah sesuai tab aktif
          style: const TextStyle(
            color: Colors.white, // Warna teks putih
            fontSize: 24, // Ukuran font
            fontWeight: FontWeight.bold, // Bold teks
            fontFamily: 'DancingScript', // Font bergaya
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9), // Hijau muda lembut
              Color(0xFFFFF8E1), // Kuning lembut
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 34, 139, 34), // Hijau tua
        unselectedItemColor: Colors.grey.shade600, // Warna ikon non-aktif
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold), // Bold label aktif
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal), // Label non-aktif
        backgroundColor: Colors.white, // Latar belakang putih
        type: BottomNavigationBarType.fixed,
        elevation: 12, // Tambahkan bayangan
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
