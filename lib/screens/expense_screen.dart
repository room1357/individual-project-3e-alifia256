// lib/screens/expense_screen.dart

import 'package:flutter/material.dart' hide DateUtils;
import 'package:pemrograman_mobile/main.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart'; // Anda bisa hapus import ini jika tidak terpakai lagi
import 'category_screen.dart';
import 'edit_expense_screen.dart';
import 'statistics_screen.dart';
import '../utils/currency_utils.dart';
import '../utils/date_utils.dart';

class ExpenseScreen extends StatefulWidget {
  // ... (sisa kode StatefulWidget tetap sama)
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  // ... (semua kode state tetap sama)
  final _expenseService = expenseService;
  late List<Expense> _displayedExpenses;

  @override
  void initState() {
    super.initState();
    _displayedExpenses = _expenseService.expenses;
  }

  void _refreshExpenses() {
    setState(() {
      _displayedExpenses = _expenseService.expenses;
    });
  }

  // --- Navigasi ---
  void _navigateAndRefresh(Widget page) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (ctx) => page),
    );
    if (result == true) {
      _refreshExpenses();
    }
  }
  
  // HAPUS FUNGSI _navigateToAddExpense (ATAU BIARKAN JIKA MASIH DIPERLUKAN UNTUK DEBUG)
  
  void _navigateToEditExpense(Expense expense) => _navigateAndRefresh(
    EditExpenseScreen(expenseService: _expenseService, expenseToEdit: expense)
  );
  
  void _navigateToCategories() => _navigateAndRefresh(
    CategoryScreen(expenseService: _expenseService)
  );
  
  void _navigateToStats() => Navigator.push(
    context,
    MaterialPageRoute(builder: (ctx) => StatisticsScreen(expenseService: _expenseService))
  );

  // --- Aksi ---
  void _deleteExpense(String id) async {
    // ... (fungsi delete tetap sama)
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Apakah Anda yakin ingin menghapus jajan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await _expenseService.deleteExpense(id);
      _refreshExpenses();
    }
  }
  
  void _exportData() async {
    // ... (fungsi export tetap sama)
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final result = await _expenseService.exportToCsv();
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(result ?? 'Ekspor dibatalkan.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... (AppBar tetap sama)
        automaticallyImplyLeading: false, 
        title: const Text('Jurnal Jajan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _navigateToStats,
            tooltip: 'Statistik',
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _navigateToCategories,
            tooltip: 'Kelola Kategori',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
            tooltip: 'Ekspor ke CSV',
          ),
        ],
      ),
      body: _displayedExpenses.isEmpty
          ? const Center(child: Text('Belum ada jajan.'))
          : ListView.builder(
              // ... (ListView.builder tetap sama)
              itemCount: _displayedExpenses.length,
              itemBuilder: (context, index) {
                final expense = _displayedExpenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: expense.category.color,
                      child: Icon(expense.category.icon, color: Colors.white),
                    ),
                    title: Text(expense.title),
                    subtitle: Text(DateUtils.format(expense.date)),
                    trailing: Text(
                      CurrencyUtils.format(expense.amount),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    onTap: () => _navigateToEditExpense(expense),
                    onLongPress: () => _deleteExpense(expense.id),
                  ),
                );
              },
            ),

    );
  }
}