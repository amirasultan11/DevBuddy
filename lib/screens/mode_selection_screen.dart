import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_mode_provider.dart';
import '../core/theme/locale_provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';

/// ModeSelectionScreen - Premium mode selection with glassmorphism
/// Allows users to choose between Professional and Kids modes
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return Scaffold(
      body: Stack(
        children: [
          // Radial Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF1E293B), // Center
                  Color(0xFF020617), // Outer
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Glass Circle Back Button
                  Align(
                    alignment: isArabic
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Icon(
                              isArabic
                                  ? Icons.arrow_forward_rounded
                                  : Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Header
                  Text(
                    isArabic ? 'اختر مسارك' : 'Choose Your Destiny',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic
                        ? 'حدد تجربتك المثالية للتعلم'
                        : 'Select your ideal learning experience',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Professional Card
                  SelectionCard(
                    title: isArabic ? 'احترافي' : 'Professional',
                    description: isArabic
                        ? 'خرائط طريق متقدمة وأدوات مهنية'
                        : 'Advanced Roadmaps & Career Tools',
                    icon: Icons.code_rounded,
                    glowColor: const Color(0xFF6366F1), // Indigo
                    onTap: () {
                      final modeProvider = Provider.of<AppModeProvider>(
                        context,
                        listen: false,
                      );
                      modeProvider.toggleMode(false);
                      _navigateToOnboarding(context);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Kids Card
                  SelectionCard(
                    title: isArabic ? 'أطفال' : 'Kids',
                    description: isArabic
                        ? 'تعلم البرمجة من خلال مهام ممتعة'
                        : 'Learn Coding Through Fun Missions',
                    icon: Icons.rocket_launch,
                    glowColor: const Color(0xFFF59E0B), // Orange
                    onTap: () {
                      final modeProvider = Provider.of<AppModeProvider>(
                        context,
                        listen: false,
                      );
                      modeProvider.toggleMode(true);
                      _navigateToOnboarding(context);
                    },
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to onboarding screen
  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
          );
          final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
          );
          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

/// SelectionCard - Custom glassmorphic card for mode selection
class SelectionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color glowColor;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side: Title and Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.65),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Right side: Neon Glow Icon
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: widget.glowColor.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 48,
                          color: widget.glowColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
