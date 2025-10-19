// lib/logic/expense_manager.dart

import '../models/expense.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(title: 'Nasi Goreng Spesial', description: 'Makan malam setelah kerja', amount: 30000, date: DateTime(2025, 10, 15), category: 'Makanan Berat'),
    Expense(title: 'Sate Ayam', description: 'Traktir teman di akhir pekan', amount: 25000, date: DateTime(2025, 10, 14), category: 'Makanan Berat'),
    Expense(title: 'Jus Alpukat', description: 'Minum siang hari yang panas', amount: 15000, date: DateTime(2025, 10, 14), category: 'Minuman'),
    Expense(title: 'Kentang Goreng', description: 'Ngemil sore sambil nonton', amount: 18000, date: DateTime(2025, 10, 13), category: 'Cemilan'),
    Expense(title: 'Es Teh Manis', description: 'Teman makan nasi goreng', amount: 5000, date: DateTime(2025, 10, 15), category: 'Minuman'),
    Expense(title: 'Mie Ayam', description: 'Sarapan sebelum ke kampus', amount: 20000, date: DateTime(2025, 10, 13), category: 'Makanan Berat'),
    Expense(title: 'Kopi Susu Gula Aren', description: 'Biar semangat pagi', amount: 22000, date: DateTime(2025, 10, 12), category: 'Minuman'),
  ];

  // Fungsi search tetap sama
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    if (keyword.isEmpty) return expenses;
    String lowerKeyword = keyword.toLowerCase();
    return expenses.where((expense) =>
      expense.title.toLowerCase().contains(lowerKeyword) ||
      expense.description.toLowerCase().contains(lowerKeyword) ||
      expense.category.toLowerCase().contains(lowerKeyword)
    ).toList();
  }
}