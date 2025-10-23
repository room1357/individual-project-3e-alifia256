import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }
}