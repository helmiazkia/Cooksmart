import 'package:flutter/material.dart';

class NutritionalInfoScreen extends StatelessWidget {
  const NutritionalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Nutrisi'),
      ),
      body: Center(
        child: Column(
          children: const <Widget>[
            Text('Tampilkan informasi nutrisi dari resep yang dipilih.'),
            // Di sini bisa ditambahkan fitur informasi nutrisi resep.
          ],
        ),
      ),
    );
  }
}
