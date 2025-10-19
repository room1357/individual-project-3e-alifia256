import 'package:intl/intl.dart'; // Impor library intl

class Expense {
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  //Getter buat memformat jumlah uang
  String get formattedAmount {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(amount);
  }

  //Getter buat memformat tanggal
  String get formattedDate {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }
}