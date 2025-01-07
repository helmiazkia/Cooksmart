import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import '../services/db_service.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  String _day = 'Senin';
  String _mealType = 'Sarapan';
  String _recipeTitle = '';
  int _calories = 0;

  late Future<List<MealPlan>> _mealPlans;

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  void _loadMealPlans() {
    setState(() {
      _mealPlans = DatabaseHelper.instance.getMealPlans();
    });
  }

  void _addMealPlan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final mealPlan = MealPlan(
        day: _day,
        mealType: _mealType,
        recipeTitle: _recipeTitle,
        calories: _calories,
      );
      await DatabaseHelper.instance.addMealPlan(mealPlan);
      _loadMealPlans();
      Navigator.pop(context); // Tutup dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 83, 227, 88),
              Color.fromARGB(255, 34, 139, 34),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<MealPlan>>(
          future: _mealPlans,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final mealPlans = snapshot.data!;
            return ListView.builder(
              itemCount: mealPlans.length,
              itemBuilder: (context, index) {
                final mealPlan = mealPlans[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      '${mealPlan.day} - ${mealPlan.mealType} - ${mealPlan.recipeTitle}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text('Kalori: ${mealPlan.calories}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .deleteMealPlan(mealPlan.id!);
                        _loadMealPlans();
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealPlanDialog(context);
        },
        backgroundColor:
            const Color.fromARGB(255, 83, 227, 88), // Warna hijau untuk FAB
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMealPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Tambah Rencana Makan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _day,
                    items: [
                      'Senin',
                      'Selasa',
                      'Rabu',
                      'Kamis',
                      'Jumat',
                      'Sabtu',
                      'Minggu'
                    ]
                        .map((day) =>
                            DropdownMenuItem(value: day, child: Text(day)))
                        .toList(),
                    onChanged: (value) => _day = value!,
                    decoration: const InputDecoration(
                      labelText: 'Hari',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, // Boldkan label
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 245, 245, 245),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _mealType,
                    items: ['Sarapan', 'Makan Siang', 'Makan Malam']
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => _mealType = value!,
                    decoration: const InputDecoration(
                      labelText: 'Tipe Makanan',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, // Boldkan label
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 245, 245, 245),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Judul Resep',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, // Boldkan label
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 245, 245, 245),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onSaved: (value) => _recipeTitle = value!,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Kalori',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, // Boldkan label
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 245, 245, 245),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _calories = int.parse(value!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _addMealPlan,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
