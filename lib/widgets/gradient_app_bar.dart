import 'package:flutter/material.dart';
import '../config/app_config.dart';

final _gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color(AppConfig.primaryColor),
    const Color(AppConfig.primaryColor).withValues(alpha: 0.85),
  ],
);

PreferredSizeWidget gradientAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
  PreferredSizeWidget? bottom,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    title: Text(title),
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
    bottom: bottom,
    flexibleSpace: Container(decoration: BoxDecoration(gradient: _gradient)),
  );
}
