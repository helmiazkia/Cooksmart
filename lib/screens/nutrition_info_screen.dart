import 'package:flutter/material.dart';

class NutritionInfoScreen extends StatelessWidget {
  final Map<String, dynamic> nutritionDetails;

  const NutritionInfoScreen({Key? key, required this.nutritionDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Nutrisi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Kalori'),
              trailing: Text('${nutritionDetails['calories']} kkal'),
            ),
            ListTile(
              title: const Text('Protein'),
              trailing: Text('${nutritionDetails['protein']} g'),
            ),
            ListTile(
              title: const Text('Karbohidrat'),
              trailing: Text('${nutritionDetails['carbs']} g'),
            ),
            ListTile(
              title: const Text('Lemak'),
              trailing: Text('${nutritionDetails['fat']} g'),
            ),
            ListTile(
              title: const Text('Serat'),
              trailing: Text('${nutritionDetails['fiber']} g'),
            ),
          ],
        ),
      ),
    );
  }
}
