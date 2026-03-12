import 'package:flutter/material.dart';

/// AnimatedFadeSlide
///
/// Wraps a child with a combined fade + upward-slide entrance animation.
/// Used throughout the app wherever cards or sections need a staggered
/// entrance. Eliminates the repeated TweenAnimationBuilder boilerplate.
///
/// [delay] is a multiplier added to the base 600ms duration, so each
/// successive card in a list enters slightly later than the previous one.
///
/// Usage:
/// ```dart
/// AnimatedFadeSlide(delay: 0, child: MyCard())
/// AnimatedFadeSlide(delay: 1, child: MyCard())  // enters 100ms later
/// ```
class AnimatedFadeSlide extends StatelessWidget {
  final int delay;
  final Widget child;
  final double slideOffset;

  const AnimatedFadeSlide({
    super.key,
    required this.delay,
    required this.child,
    this.slideOffset = 30,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (delay * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, slideOffset * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }
}
