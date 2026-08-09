import 'package:flutter/material.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    constraints: BoxConstraints(
      maxWidth: 560,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: child,
      ),
    ),
  );
}

class SheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SheetHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: sheetDragHandle()),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.2),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ],
    );
  }
}

Widget sheetDragHandle() {
  return Container(
    width: 40,
    height: 4,
    margin: const EdgeInsets.only(top: 12, bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class SheetActions extends StatelessWidget {
  final VoidCallback onConfirm;
  final String confirmLabel;
  final IconData? confirmIcon;
  final VoidCallback? onCancel;
  final String? cancelLabel;
  final bool isDanger;

  const SheetActions({
    super.key,
    required this.onConfirm,
    required this.confirmLabel,
    this.confirmIcon,
    this.onCancel,
    this.cancelLabel = 'Batal',
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          if (onCancel != null) ...[
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onCancel,
                child: Text(cancelLabel!),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDanger ? Colors.red : null,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onConfirm,
              child: confirmIcon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(confirmIcon, size: 18),
                        const SizedBox(width: 8),
                        Text(confirmLabel),
                      ],
                    )
                  : Text(confirmLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final bool isDanger;
  final IconData icon;

  const ConfirmationSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.isDanger = false,
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDanger ? Colors.red : Colors.orange[700];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: sheetDragHandle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor!.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
        ),
        const SizedBox(height: 20),
        _actions(context),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: isDanger ? Colors.red : null,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}