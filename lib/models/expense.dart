import 'dart:convert';
import './category.dart';

class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Fungsi untuk konversi ke/dari JSON (untuk penyimpanan data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(), // Simpan tanggal sebagai string
      'category': category.toJson(), // Simpan objek kategori
    };
  }

  factory Expense.fromJson(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']), // Ubah string kembali ke DateTime
      category: Category.fromJson(map['category']), // Ubah map kembali ke Category
    );
  }

  // Helper untuk mem-parsing dari String JSON
  static String encode(List<Expense> expenses) => json.encode(
        expenses.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
      );

  static List<Expense> decode(String expenses) =>
      (json.decode(expenses) as List<dynamic>)
          .map<Expense>((item) => Expense.fromJson(item))
          .toList();
}