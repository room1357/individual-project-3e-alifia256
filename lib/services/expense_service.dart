import 'dart:io'; 
import 'package:csv/csv.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../models/expense.dart';
import './storage_service.dart';
import '../utils/date_utils.dart';

const uuid = Uuid();

class ExpenseService {
  final StorageService _storageService;

  ExpenseService(this._storageService);

  List<Expense> _expenses = [];
  List<Category> _categories = [];

  List<Map<String, dynamic>> _catalogProducts = [];

  final List<Category> _defaultCategories = [
    Category(id: 'c1', name: 'Makanan Berat', iconCodePoint: Icons.ramen_dining.codePoint, colorValue: Colors.orange.value),
    Category(id: 'c2', name: 'Minuman', iconCodePoint: Icons.local_cafe.codePoint, colorValue: Colors.lightBlue.value),
    Category(id: 'c3', name: 'Cemilan', iconCodePoint: Icons.icecream.codePoint, colorValue: Colors.pink.value),
  ];

  List<Map<String, dynamic>> get catalogProducts => _catalogProducts;

  Category _findCategoryByName(String name, Category fallback) {
    try {
      return _categories.firstWhere((c) => c.name == name);
    } catch (e) {
      return fallback;
    }
  }

  Future<void> init() async {
    _expenses = await _storageService.loadExpenses();
    _categories = await _storageService.loadCategories();

    if (_categories.isEmpty) {
      _categories = _defaultCategories;
      await _storageService.saveCategories(_categories);
    }

    final makananBerat = _findCategoryByName('Makanan Berat', _categories[0]);
    final minuman = _findCategoryByName('Minuman', _categories[1]);
    final cemilan = _findCategoryByName('Cemilan', _categories[2]);

    _catalogProducts = [
      {
        "name": "Sate Ayam",
        "price": 25000.0,
        "image": "assets/Sate.jpeg",
        "category": makananBerat
      },
      {
        "name": "Nasi Goreng Spesial",
        "price": 30000.0,
        "image": "assets/NasiGorengSpesial.jpeg",
        "category": makananBerat
      },
      {
        "name": "Es Teh Manis",
        "price": 5000.0,
        "image": "assets/EsTeh.jpeg",
        "category": minuman
      },
      {
        "name": "Mie Ayam",
        "price": 20000.0,
        "image": "assets/MieAyam.jpeg",
        "category": makananBerat
      },
      {
        "name": "Jus Alpukat",
        "price": 15000.0,
        "image": "assets/JusAlpukat.jpeg",
        "category": minuman
      },
      {
        "name": "Kentang Goreng",
        "price": 18000.0,
        "image": "assets/kentang.jpg",
        "category": cemilan
      },
    ];
  }

  // --- Getter untuk UI ---
  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;

  // --- CRUD Expense ---
  Future<void> addExpense({
    required String title,
    required String description,
    required double amount,
    required DateTime date,
    required Category category,
  }) async {
    final newExpense = Expense(
      id: uuid.v4(),
      title: title,
      description: description,
      amount: amount,
      date: date,
      category: category,
    );
    _expenses.insert(0, newExpense);
    await _storageService.saveExpenses(_expenses);
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      await _storageService.saveExpenses(_expenses);
    }
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
    await _storageService.saveExpenses(_expenses);
  }

  // --- CRUD Category ---
  Future<void> addCategory({
    required String name,
    required IconData icon,
    required Color color,
  }) async {
    final newCategory = Category(
      id: uuid.v4(),
      name: name,
      iconCodePoint: icon.codePoint,
      colorValue: color.value,
    );
    _categories.add(newCategory);
    await _storageService.saveCategories(_categories);
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    _expenses.removeWhere((e) => e.category.id == id);
    await _storageService.saveCategories(_categories);
    await _storageService.saveExpenses(_expenses);
  }

  // --- Fitur Statistik ---
  Map<String, double> getCategoryTotals() {
    Map<String, double> totals = {};
    for (var category in _categories) {
      totals[category.name] = 0.0;
    }
    for (var expense in _expenses) {
      totals.update(
        expense.category.name,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    totals.removeWhere((key, value) => value == 0);
    return totals;
  }

  // --- Fitur Ekspor ---
  Future<String?> exportToCsv() async {
    if (_expenses.isEmpty) {
      return 'Tidak ada data untuk diekspor.';
    }

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        return 'Izin penyimpanan ditolak.';
      }
    }
    
    List<List<dynamic>> rows = [];
    rows.add(['ID', 'Judul', 'Deskripsi', 'Jumlah', 'Tanggal', 'Kategori']);
    for (var expense in _expenses) {
      rows.add([
        expense.id,
        expense.title,
        expense.description,
        expense.amount,
        DateUtils.formatForCsv(expense.date),
        expense.category.name,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) return 'Tidak dapat menemukan direktori.';
      
      final path = '${directory.path}/cityfood_expenses.csv';
      final file = File(path);
      
      await file.writeAsString(csv);
      
      return 'Data berhasil diekspor ke $path';
    } catch (e) {
      return 'Terjadi error saat ekspor: $e';
    }
  }
}