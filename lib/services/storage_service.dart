import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/expense.dart';

class StorageService {
  static const _expensesKey = 'expenses';
  static const _categoriesKey = 'categories';

  // --- Operasi Expense ---
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Expense.encode(expenses);
    await prefs.setString(_expensesKey, encodedData);
  }

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesString = prefs.getString(_expensesKey);
    if (expensesString != null) {
      return Expense.decode(expensesString);
    }
    return []; // Kembalikan list kosong jika tidak ada data
  }

  // --- Operasi Kategori ---
  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Category.encode(categories);
    await prefs.setString(_categoriesKey, encodedData);
  }

  Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesString = prefs.getString(_categoriesKey);
    if (categoriesString != null) {
      return Category.decode(categoriesString);
    }
    return []; // Kembalikan list kosong
  }
}