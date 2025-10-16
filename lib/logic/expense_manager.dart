import '../models/expense.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      title: 'Nasi Goreng Spesial', 
      description: '-', 
      amount: 30000, 
      date: DateTime(2025, 10, 15), 
      category: 'Makanan Berat'
    ),
    Expense(
      title: 'Sate Ayam', 
      description: 'makan malem', 
      amount: 25000, 
      date: DateTime(2025, 10, 14), 
      category: 'Makanan Berat'
    ),
    Expense(
      title: 'Jus Alpukat', 
      description: 'makan malem', 
      amount: 15000, 
      date: DateTime(2025, 10, 14), 
      category: 'Minuman'
    ),
    Expense(
      title: 'Es Teh Manis', 
      description: 'haus', 
      amount: 5000, 
      date: DateTime(2025, 10, 15), 
      category: 'Minuman'
    ),
    Expense(
      title: 'Mie Ayam', 
      description: 'makan siang', 
      amount: 20000, 
      date: DateTime(2025, 10, 13), 
      category: 'Makanan Berat'
    ),
  ];

  // Fungsi untuk mencari pengeluaran berdasarkan kata kunci
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    if (keyword.isEmpty) {
      return expenses;
    }
    String lowerKeyword = keyword.toLowerCase();
    return expenses.where((expense) =>
      expense.title.toLowerCase().contains(lowerKeyword) ||
      expense.description.toLowerCase().contains(lowerKeyword) ||
      expense.category.toLowerCase().contains(lowerKeyword)
    ).toList();
  }

}