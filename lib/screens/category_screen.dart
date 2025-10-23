import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/expense_service.dart';

class CategoryScreen extends StatefulWidget {
  final ExpenseService expenseService;

  const CategoryScreen({super.key, required this.expenseService});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.expenseService.categories;
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    // Anda bisa tambahkan IconPicker dan ColorPicker di sini
    // Untuk sederhana, kita gunakan default
    IconData selectedIcon = Icons.label;
    Color selectedColor = Colors.grey;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kategori Baru'),
        content: TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              await widget.expenseService.addCategory(
                name: nameController.text,
                icon: selectedIcon,
                color: selectedColor,
              );
              setState(() {
                _categories = widget.expenseService.categories;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String id) async {
    // Tampilkan konfirmasi
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: const Text('Menghapus kategori juga akan menghapus semua jajan di dalamnya. Yakin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await widget.expenseService.deleteCategory(id);
              setState(() {
                _categories = widget.expenseService.categories;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              child: Icon(category.icon, color: Colors.white),
            ),
            title: Text(category.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteCategory(category.id),
            ),
          );
        },
      ),
    );
  }
}