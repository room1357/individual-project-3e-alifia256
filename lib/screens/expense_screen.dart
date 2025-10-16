// lib/screens/expense_screen.dart

import 'package:flutter/material.dart';
import '../logic/expense_manager.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late List<Expense> _filteredExpenses;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredExpenses = ExpenseManager.expenses;
  }

  void _runSearch(String keyword) {
    final results = ExpenseManager.searchExpenses(ExpenseManager.expenses, keyword);
    setState(() {
      _filteredExpenses = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _runSearch,
            decoration: const InputDecoration(
              // UBAH: Sesuaikan placeholder text
              labelText: 'Cari riwayat jajan (cth: sate, jus)',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _filteredExpenses.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = _filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(child: Icon(_getIconForCategory(expense.category))),
                          title: Text(expense.title),
                          subtitle: Text('${expense.category} - ${expense.description}'),
                          trailing: Text(
                            'Rp ${expense.amount.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Tidak ada data yang cocok.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // UBAH: Sesuaikan ikon untuk kategori baru
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Makanan Berat':
        return Icons.ramen_dining; // Ikon untuk makanan berat
      case 'Minuman':
        return Icons.local_cafe; // Ikon untuk minuman
      default:
        return Icons.fastfood; // Ikon default
    }
  }
}