import 'package:intl/intl.dart';

class DateUtils {
  static final _formatter = DateFormat('d MMM yyyy', 'id_ID');
  static final _csvFormatter = DateFormat('yyyy-MM-dd');

  static String format(DateTime date) {
    return _formatter.format(date);
  }

  static String formatForCsv(DateTime date) {
    return _csvFormatter.format(date);
  }
}