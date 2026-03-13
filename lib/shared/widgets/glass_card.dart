import 'dart:ui';
import 'package:flutter/material.dart';

/// GlassCard
///
/// Standard glassmorphism card — ClipRRect + BackdropFilter + frosted Container.
/// Use ONLY for STATIC (non-scrollable-list) cards where BackdropFilter is safe,
/// OR set `hasBlur: false` when using inside ListView/SliverList.
///
/// Usage:
/// ```dart
/// GlassCard(
///   hasBlur: false, // For list items
///   radius: 20,
///   padding: EdgeInsets.all(20),
///   child: MyContent(),
/// )
/// ```
class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final double borderWidth;
  final double blurSigma;
  final bool hasBlur;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = const EdgeInsets.all(20),
    this.borderColor = const Color(0x33FFFFFF), // white 20%
    this.borderWidth = 1.5,
    this.blurSigma = 10,
    this.hasBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: hasBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: container,
            )
          : container,
    );
  }
}
