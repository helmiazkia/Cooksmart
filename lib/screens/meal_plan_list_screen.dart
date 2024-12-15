import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import '../services/db_service.dart';

class MealPlanListScreen extends StatefulWidget {
  const MealPlanListScreen({Key? key}) : super(key: key);

  @override
  _MealPlanListScreenState createState() => _MealPlanListScreenState();
}

class _MealPlanListScreenState extends State<MealPlanListScreen> {
  late Future<List<MealPlan>> mealPlans;

  @override
  void initState() {
    super.initState();
    mealPlans = DatabaseHelper.instance.getMealPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Rencana Makan'),
      ),
      body: FutureBuilder<List<MealPlan>>(
        future: mealPlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada rencana makan'));
          } else {
            final mealPlansList = snapshot.data!;
            return ListView.builder(
              itemCount: mealPlansList.length,
              itemBuilder: (context, index) {
                final mealPlan = mealPlansList[index];
                return ListTile(
                  title: Text('${mealPlan.day} - ${mealPlan.mealType}'),
                  subtitle: Text(
                      'Resep: ${mealPlan.recipeTitle}, Kalori: ${mealPlan.calories}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
