import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';

class MoneyField extends StatefulWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
    this.hintText,
    this.prefixIcon = Icons.payments_outlined,
    this.autofocus = false,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? helperText;
  final String? hintText;
  final IconData prefixIcon;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onChanged);
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _valid = parseAmount(_controller.text) > 0;
  }

  void _onChanged() {
    final valid = parseAmount(_controller.text) > 0;
    if (valid != _valid) setState(() => _valid = valid);
    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }

  static double parseAmount(String text) {
    return double.tryParse(text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Color(AppConfig.primaryColor);
    final focused = _focusNode.hasFocus;
    final filled = _controller.text.isNotEmpty;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [RupiahInputFormatter()],
      style: TextStyle(
        fontSize: 16,
        color: filled ? Colors.grey[900] : Colors.grey[400],
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: focused ? primary : Colors.grey[500],
          fontWeight: focused ? FontWeight.w600 : FontWeight.w400,
        ),
        helperText: widget.helperText,
        helperStyle: TextStyle(fontSize: 11, color: Colors.grey[500]),
        hintText: '0',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        prefixIcon: Icon(widget.prefixIcon, size: 20),
        prefixIconColor: focused ? primary : Colors.grey[400],
        prefixText: 'Rp ',
        prefixStyle: TextStyle(
          color: focused ? primary : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: filled
            ? Icon(
                _valid ? Icons.check_circle : Icons.error,
                size: 18,
                color: _valid ? Colors.green : Colors.red,
              )
            : null,
        errorMaxLines: 2,
        filled: true,
        fillColor: widget.enabled ? Colors.grey[50] : Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final grouped = _groupDigits(digits);
    return TextEditingValue(
      text: grouped,
      selection: TextSelection.collapsed(offset: grouped.length),
    );
  }

  static String _groupDigits(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

String groupedAmount(num value) {
  final digits = value.round().abs().toString();
  return RupiahInputFormatter._groupDigits(digits);
}