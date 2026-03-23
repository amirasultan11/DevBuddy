import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // هنا بنكتشف إحنا في الدارك مود ولا اللايت مود
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: isDark
              ? const [
                  Color(0xFF1E293B), // Lighter navy center
                  Color(0xFF020617), // Deep dark navy edges
                ]
              : const [
                  Color(0xFFF8FAFC), // Light Slate 50
                  Color(0xFFE2E8F0), // Light Slate 200
                ],
        ),
      ),
      child: child,
    );
  }
}