// lib/screens/expense_screen.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../logic/expense_manager.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  // Ambil data asli sekali saja
  final List<Expense> _allExpenses = ExpenseManager.expenses;
  
  // State untuk data yang akan ditampilkan
  List<Expense> _filteredExpenses = [];
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Awalnya, tampilkan semua data
    _filteredExpenses = _allExpenses;
  }

  // Fungsi utama untuk memfilter data berdasarkan pencarian dan kategori
  void _filterExpenses() {
    final keyword = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredExpenses = _allExpenses.where((expense) {
        final matchesSearch = keyword.isEmpty ||
            expense.title.toLowerCase().contains(keyword) ||
            expense.description.toLowerCase().contains(keyword);
        
        final matchesCategory = _selectedCategory == 'Semua' ||
            expense.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar kategori disesuaikan dengan studi kasus
    final categories = ['Semua', 'Makanan Berat', 'Minuman', 'Cemilan'];

    return Column(
      children: [
        // 1. Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _filterExpenses(),
            decoration: const InputDecoration(
              hintText: 'Cari riwayat jajan...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // 2. Filter Kategori
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                    _filterExpenses();
                  });
                },
              ),
            )).toList(),
          ),
        ),

        // 3. Ringkasan Statistik
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total', _calculateTotal(_filteredExpenses)),
              _buildStatCard('Jumlah', '${_filteredExpenses.length} item'),
              _buildStatCard('Rata-rata', _calculateAverage(_filteredExpenses)),
            ],
          ),
        ),

        // 4. Daftar Pengeluaran
        Expanded(
          child: _filteredExpenses.isEmpty
              ? const Center(child: Text('Tidak ada pengeluaran ditemukan.'))
              : ListView.builder(
                  itemCount: _filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = _filteredExpenses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getCategoryColor(expense.category),
                          child: Icon(_getCategoryIcon(expense.category), color: Colors.white),
                        ),
                        title: Text(expense.title),
                        subtitle: Text('${expense.category} • ${expense.formattedDate}'),
                        trailing: Text(
                          expense.formattedAmount,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onTap: () => _showExpenseDetails(context, expense),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- WIDGET & METHOD HELPER ---

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  String _calculateTotal(List<Expense> expenses) {
    final total = expenses.fold<double>(0, (sum, item) => sum + item.amount);
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total);
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    final total = expenses.fold<double>(0, (sum, item) => sum + item.amount);
    final average = total / expenses.length;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(average);
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(expense.formattedAmount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 16),
            Text('Kategori: ${expense.category}'),
            Text('Tanggal: ${expense.formattedDate}'),
            const SizedBox(height: 8),
            const Divider(),
            Text(expense.description),
          ],
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan Berat': return Icons.ramen_dining;
      case 'Minuman': return Icons.local_cafe;
      case 'Cemilan': return Icons.icecream;
      default: return Icons.fastfood;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan Berat': return Colors.orange;
      case 'Minuman': return Colors.lightBlue;
      case 'Cemilan': return Colors.pink;
      default: return Colors.grey;
    }
  }
}