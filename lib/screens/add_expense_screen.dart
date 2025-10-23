import 'package:flutter/material.dart' hide DateUtils;
import '../models/category.dart';
import '../services/expense_service.dart';
import '../utils/date_utils.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseService expenseService;

  const AddExpenseScreen({super.key, required this.expenseService});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // UBAH: Hapus _titleController, kita akan pakai _selectedProduct
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;
  
  // BARU: Tambahkan variabel untuk katalog produk
  late List<Map<String, dynamic>> _catalog;
  Map<String, dynamic>? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _catalog = widget.expenseService.catalogProducts;
    
    // Atur nilai default saat halaman dibuka
    if (_catalog.isNotEmpty) {
      _updateSelectedProduct(_catalog.first);
    }
  }

  // BARU: Helper untuk update field saat produk diganti
  void _updateSelectedProduct(Map<String, dynamic>? product) {
    if (product == null) return;
    setState(() {
      _selectedProduct = product;
      _amountController.text = product['price'].toStringAsFixed(0);
      _selectedCategory = product['category'];
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
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

  Future<void> _submitExpenseData() async {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // UBAH: Validasi _selectedProduct
    if (_formKey.currentState!.validate() && !amountIsInvalid && _selectedProduct != null) {
      await widget.expenseService.addExpense(
        // UBAH: Ambil title dari produk yang dipilih
        title: _selectedProduct!['name'],
        description: _descriptionController.text,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory!, // Kategori sudah otomatis terisi
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_catalog.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tambah Jajan')),
        body: const Center(
          child: Text('Katalog produk tidak ditemukan.'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jajan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // UBAH: Ganti TextFormField menjadi Dropdown
              DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedProduct,
                items: _catalog.map((product) => DropdownMenuItem(
                      value: product,
                      child: Text(product['name']),
                    )).toList(),
                onChanged: (value) {
                  _updateSelectedProduct(value);
                },
                decoration: const InputDecoration(labelText: 'Nama Jajan'),
                validator: (value) => value == null ? 'Pilih jajan' : null,
              ),
              
              TextFormField(
                controller: _amountController,
                // BARU: Buat field ini tidak bisa diedit manual
                readOnly: true, 
                decoration: const InputDecoration(labelText: 'Harga', prefixText: 'Rp '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'Harga tidak valid';
                  return null;
                },
              ),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi (Opsional)'),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    // UBAH: Tampilkan kategori sebagai teks (atau Dropdown non-aktif)
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: InputBorder.none,
                      ),
                      child: Text(
                        _selectedCategory?.name ?? 'Pilih produk...',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(DateUtils.format(_selectedDate)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}