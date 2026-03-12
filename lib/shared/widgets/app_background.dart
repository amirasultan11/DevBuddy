import 'package:flutter/material.dart';

/// AppBackground
///
/// The standard dark navy RadialGradient background used on every screen.
/// Wrap any screen's body with this instead of repeating the Container +
/// BoxDecoration + RadialGradient boilerplate in every file.
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: AppBackground(
///     child: SafeArea(child: ...),
///   ),
/// )
/// ```
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1E293B), // Lighter navy centre
            Color(0xFF020617), // Deep dark navy edges
          ],
        ),
      ),
      child: child,
    );
  }
}
