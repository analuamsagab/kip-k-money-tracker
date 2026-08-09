import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../extensions/number_format.dart';
import '../widgets/app_bottom_sheets.dart';
import '../widgets/money_field.dart';

class TransferSheet extends ConsumerStatefulWidget {
  const TransferSheet({super.key});

  @override
  ConsumerState<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<TransferSheet> {
  late final AppDatabase _db;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _from = 'cash';
  DateTime _date = DateTime.now();

  double _cashBalance = 0;
  double _ewalletBalance = 0;

  String get _to => _from == 'cash' ? 'ewallet' : 'cash';

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _loadBalances();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadBalances() async {
    final cash = await _db.getBalanceByMethod('cash');
    final ewallet = await _db.getBalanceByMethod('ewallet');
    if (!mounted) return;
    setState(() {
      _cashBalance = cash;
      _ewalletBalance = ewallet;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  double get _amount {
    final parsed = tryParseRupiahInput(_amountController.text);
    return parsed ?? 0;
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nominal yang valid')),
      );
      return;
    }
    final now = DateTime.now();
    await _db.insertTransfer(WalletTransfersCompanion.insert(
      fromMethod: _from,
      toMethod: _to,
      amount: _amount,
      date: _date,
      note: _noteController.text.trim().isEmpty
          ? const Value(null)
          : Value(_noteController.text.trim()),
      createdAt: now,
    ));
    if (mounted) Navigator.pop(context, true);
  }

  double _afterTransfer(String method) {
    if (method == 'cash') {
      return _cashBalance + (_from == 'cash' ? -_amount : _amount);
    }
    return _ewalletBalance + (_from == 'ewallet' ? -_amount : _amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SheetHeader(
          title: 'Pindah Uang',
          subtitle: 'Pindahkan saldo antara cash dan e-wallet.',
          trailing: Icon(Icons.swap_horiz, color: Color(0xFF283593)),
        ),
        const SizedBox(height: 16),
        _methodSelector(),
          const SizedBox(height: 16),
          _toRow(),
          const SizedBox(height: 16),
          MoneyField(
            controller: _amountController,
            label: 'Nominal',
            helperText: 'Jumlah uang yang ingin dipindahkan.',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(16),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Tanggal',
                prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
                prefixIconColor: Colors.grey[500],
                filled: true,
                fillColor: Colors.grey[50],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color(0xFF283593), width: 1.6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: Text(DateFormat('dd MMMM yyyy').format(_date), style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Catatan (opsional)',
              prefixIcon: const Icon(Icons.sticky_note_2_outlined, size: 20),
              prefixIconColor: Colors.grey[500],
              filled: true,
              fillColor: Colors.grey[50],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(color: Color(0xFF283593), width: 1.6),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          _balancePreview(),
          const SizedBox(height: 20),
          SheetActions(
            onCancel: () => Navigator.pop(context),
            onConfirm: _save,
            confirmLabel: 'Pindahkan',
            confirmIcon: Icons.swap_horiz,
          ),
        ],
    );
  }

  Widget _methodSelector() {
    return Row(
      children: [
        _methodChip('cash', 'Cash', Icons.payments),
        const SizedBox(width: 12),
        _methodChip('ewallet', 'E-Wallet', Icons.account_balance_wallet),
      ],
    );
  }

  Widget _methodChip(String method, String label, IconData icon) {
    final selected = _from == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _from = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF283593).withValues(alpha: 0.08)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF283593).withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? const Color(0xFF283593) : Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? const Color(0xFF283593) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toRow() {
    final toLabel = _to == 'cash' ? 'Cash' : 'E-Wallet';
    final toIcon = _to == 'cash' ? Icons.payments : Icons.account_balance_wallet;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(toIcon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text('Ke: $toLabel', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _balancePreview() {
    final cashAfter = _afterTransfer('cash');
    final ewalletAfter = _afterTransfer('ewallet');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF283593).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _balanceRow('Cash', 'cash', cashAfter),
          const SizedBox(height: 6),
          _balanceRow('E-Wallet', 'ewallet', ewalletAfter),
        ],
      ),
    );
  }

  Widget _balanceRow(String label, String method, double after) {
    final before = method == 'cash' ? _cashBalance : _ewalletBalance;
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const Spacer(),
        Text(formatRupiah(before),
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough)),
        const SizedBox(width: 8),
        Icon(
          after >= before ? Icons.arrow_upward : Icons.arrow_downward,
          size: 12,
          color: after >= before ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          formatRupiah(after),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: after >= before ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}