import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_bottom_sheets.dart';

Future<DateTime?> showMonthPickerSheet(
  BuildContext context, {
  required int initialYear,
  required int initialMonth,
}) {
  return showAppBottomSheet<DateTime>(
    context,
    child: _MonthPickerSheet(
      initialYear: initialYear,
      initialMonth: initialMonth,
    ),
  );
}

class _MonthPickerSheet extends StatefulWidget {
  final int initialYear;
  final int initialMonth;

  const _MonthPickerSheet({
    required this.initialYear,
    required this.initialMonth,
  });

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int _year = widget.initialYear;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = const [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetHeader(
          title: 'Pilih Bulan',
          subtitle: 'Filter pengeluaran per kategori berdasarkan bulan.',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() => _year--),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '$_year',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() => _year++),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.3,
          children: List.generate(12, (i) {
            final selected = i + 1 == widget.initialMonth && _year == widget.initialYear;
            return FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    selected ? const Color(0xFF283593) : Colors.grey[100],
                foregroundColor:
                    selected ? Colors.white : const Color(0xFF283593),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(
                context,
                DateTime(_year, i + 1),
              ),
              child: Text(months[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            );
          }),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pop(context, DateTime(now.year, now.month)),
            icon: const Icon(Icons.today, size: 18),
            label: Text('Ke Bulan Ini (${DateFormat('MMMM yyyy').format(now)})'),
          ),
        ),
      ],
    );
  }
}