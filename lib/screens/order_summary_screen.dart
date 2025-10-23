// lib/screens/order_summary_screen.dart

import 'package:flutter/material.dart' hide DateUtils;
import 'package:pemrograman_mobile/main.dart'; // Impor service global
import '../models/category.dart';
import '../utils/currency_utils.dart';
import '../utils/date_utils.dart';

class OrderSummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const OrderSummaryScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  late List<Category> _categories;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Ambil kategori dari service
    _categories = expenseService.categories;
    // Coba atur kategori default berdasarkan item pertama, atau ambil yg pertama
    if (widget.cartItems.isNotEmpty) {
      _selectedCategory = widget.cartItems.first['category'];
    } else if (_categories.isNotEmpty) {
      _selectedCategory = _categories.first;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate ?? _selectedDate;
    });
  }

  // Fungsi untuk membuat judul pesanan otomatis
  String _generateOrderTitle() {
    if (widget.cartItems.isEmpty) return 'Pesanan Kosong';
    
    String title = 'Pesanan: ${widget.cartItems.first['name']}';
    if (widget.cartItems.length > 1) {
      title += ' & ${widget.cartItems.length - 1} lainnya';
    }
    return title;
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      
      final title = _generateOrderTitle();

      await expenseService.addExpense(
        title: title,
        description: _descriptionController.text,
        amount: widget.total,
        date: _selectedDate,
        category: _selectedCategory!,
      );
      
      if (mounted) {
        // Kirim sinyal 'true' kembali ke HomeScreen untuk membersihkan keranjang
        Navigator.pop(context, true); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text('Detail Pesanan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Tampilkan daftar item yang dipilih
                  ...widget.cartItems.map((item) {
                    return ListTile(
                      title: Text(item['name']),
                      trailing: Text(CurrencyUtils.format(item['price'])),
                      dense: true,
                    );
                  }).toList(),
                  const Divider(),
                  // Total Pesanan
                  ListTile(
                    title: const Text('Total Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: Text(
                      CurrencyUtils.format(widget.total),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Form input
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                      hintText: 'Cth: Makan siang bareng teman',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    value: _selectedCategory,
                    items: _categories.map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                    validator: (value) => value == null ? 'Pilih kategori' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tanggal Pesan:', style: TextStyle(fontSize: 16)),
                      TextButton.icon(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(DateUtils.format(_selectedDate)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          // Bagian Tombol Bayar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('BAYAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}