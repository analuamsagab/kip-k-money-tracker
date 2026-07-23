import 'package:intl/intl.dart';

class MonthYear {
  final int month;
  final int year;

  const MonthYear(this.month, this.year);

  MonthYear.now() : month = DateTime.now().month, year = DateTime.now().year;

  MonthYear previous() {
    if (month == 1) return MonthYear(12, year - 1);
    return MonthYear(month - 1, year);
  }

  MonthYear next() {
    if (month == 12) return MonthYear(1, year + 1);
    return MonthYear(month + 1, year);
  }

  String get displayName => '${DateFormat('MMMM').format(DateTime(year, month))} $year';

  bool get isCurrentMonth => month == DateTime.now().month && year == DateTime.now().year;
}
