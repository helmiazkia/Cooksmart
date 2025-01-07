import 'package:flutter/material.dart';

class NutritionInfoScreen extends StatelessWidget {
  final Map<String, dynamic> nutritionDetails;

  const NutritionInfoScreen({Key? key, required this.nutritionDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Nutrisi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 83, 227, 88), // Light green
              Color.fromARGB(255, 34, 139, 34), // Dark green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Kalori',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${nutritionDetails['calories']} kkal',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Protein',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${nutritionDetails['protein']} g',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Karbohidrat',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${nutritionDetails['carbs']} g',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Lemak',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${nutritionDetails['fat']} g',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Serat',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${nutritionDetails['fiber']} g',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
