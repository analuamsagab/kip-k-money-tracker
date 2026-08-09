import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

String formatRupiah(num amount) => _currencyFormat.format(amount);

double parseRupiahInput(String raw) {
  return double.parse(raw.replaceAll('.', '').replaceAll(',', ''));
}

double? tryParseRupiahInput(String raw) {
  return double.tryParse(raw.replaceAll('.', '').replaceAll(',', ''));
}

