import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// GradientButton
///
/// The standard full-width CTA button with an indigo→purple gradient,
/// rounded corners, and a loading state built in.
///
/// Usage:
/// ```dart
/// GradientButton(
///   label: 'Login',
///   isLoading: _isLoading,
///   onTap: _onLogin,
/// )
/// GradientButton(
///   label: 'Skip',
///   colors: [Colors.white24, Colors.white12],
///   onTap: _onSkip,
/// )
/// ```
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final List<Color> colors;
  final double height;
  final double radius;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.colors = const [Color(0xFF6366F1), Color(0xFF8B5CF6)], // indigo→purple
    this.height = 56,
    this.radius = 16,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? colors.map((c) => c.withValues(alpha: 0.5)).toList()
                : colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: GoogleFonts.cairo(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
