import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Halaman Kategori',
            style: TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}