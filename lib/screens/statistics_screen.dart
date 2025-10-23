import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../utils/currency_utils.dart';

class StatisticsScreen extends StatelessWidget {
  final ExpenseService expenseService;

  const StatisticsScreen({super.key, required this.expenseService});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = expenseService.getCategoryTotals();
    final totalExpense = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
    
    // Buat daftar PieChartSectionData
    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final categoryName = entry.key;
      final amount = entry.value;
      final percentage = (amount / totalExpense) * 100;
      
      // Cari warna kategori
      final category = expenseService.categories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => throw Exception('Kategori tidak ditemukan'),
      );

      return PieChartSectionData(
        color: category.color,
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Jajan'),
      ),
      body: categoryTotals.isEmpty
          ? const Center(child: Text('Belum ada data untuk ditampilkan.'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Pengeluaran: ${CurrencyUtils.format(totalExpense)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Rincian per Kategori:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...categoryTotals.entries.map((entry) {
                      final category = expenseService.categories.firstWhere((c) => c.name == entry.key);
                      return ListTile(
                        leading: Icon(category.icon, color: category.color),
                        title: Text(entry.key),
                        trailing: Text(CurrencyUtils.format(entry.value)),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}