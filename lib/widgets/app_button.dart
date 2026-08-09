import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primary = const Color(AppConfig.primaryColor);
    final enabled = widget.onPressed != null && !widget.loading;

    Widget button = FilledButton(
      onPressed: enabled ? widget.onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        disabledBackgroundColor: Colors.grey[300],
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.grey[600],
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        shadowColor: primary.withValues(alpha: 0.35),
      ),
      child: widget.loading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(Colors.grey[700]),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                ),
              ],
            ),
    );

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}