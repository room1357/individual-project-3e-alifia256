import 'package:flutter/material.dart' hide DateUtils;
import '../models/category.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../utils/date_utils.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseService expenseService;
  final Expense expenseToEdit;

  const EditExpenseScreen({
    super.key,
    required this.expenseService,
    required this.expenseToEdit,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  late DateTime _selectedDate;
  Category? _selectedCategory;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.expenseService.categories;
    
    final e = widget.expenseToEdit;
    _titleController = TextEditingController(text: e.title);
    _amountController = TextEditingController(text: e.amount.toStringAsFixed(0));
    _descriptionController = TextEditingController(text: e.description);
    _selectedDate = e.date;
    
    try {
    _selectedCategory = _categories.firstWhere((c) => c.id == e.category.id);
  } catch (e) {
    _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
  }
}

  @override
  void dispose() {
    _titleController.dispose();
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

    if (_formKey.currentState!.validate() && !amountIsInvalid && _selectedCategory != null) {
      final updatedExpense = Expense(
        id: widget.expenseToEdit.id, // Gunakan ID yang sama
        title: _titleController.text,
        description: _descriptionController.text,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory!,
      );
      
      await widget.expenseService.updateExpense(updatedExpense);
      
      if (mounted) {
        Navigator.pop(context, true); // Kirim sinyal 'true' bahwa ada data baru
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jajan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Jajan'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Harga', prefixText: 'Rp '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'Masukkan harga yang valid';
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
                    child: DropdownButtonFormField<Category>(
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
                      decoration: const InputDecoration(labelText: 'Kategori'),
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
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}