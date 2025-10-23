import 'dart:convert';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  
  // Kita simpan kode ikon & warna agar bisa disimpan di JSON
  final int iconCodePoint;
  final int colorValue;

  Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  });

  // Getter untuk mengubah data mentah menjadi objek Flutter
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  // Fungsi untuk konversi ke/dari JSON (untuk penyimpanan data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
    };
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconCodePoint: map['iconCodePoint'],
      colorValue: map['colorValue'],
    );
  }

  // Helper untuk mem-parsing dari String JSON
  static String encode(List<Category> categories) => json.encode(
        categories.map<Map<String, dynamic>>((c) => c.toJson()).toList(),
      );

  static List<Category> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<Category>((item) => Category.fromJson(item))
          .toList();
}