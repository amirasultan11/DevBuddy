import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/locale_provider.dart';
import 'mode_selection_screen.dart';

/// LanguageSelectionScreen - Premium language selection with glassmorphism
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Welcome Header - English
                Text(
                  'Welcome to DevBuddy',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Welcome Header - Arabic
                Text(
                  'أهلاً بك في ديف بادي',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Subtitle
                Column(
                  children: [
                    Text(
                      'Choose Your Language',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اختر لغتك',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Arabic Language Card
                LanguageGlassCard(
                  icon: Icons.translate,
                  text: 'العربية',
                  onTap: () {
                    final localeProvider = Provider.of<LocaleProvider>(
                      context,
                      listen: false,
                    );
                    localeProvider.setLocale(const Locale('ar'));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ModeSelectionScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // English Language Card
                LanguageGlassCard(
                  icon: Icons.language,
                  text: 'English',
                  onTap: () {
                    final localeProvider = Provider.of<LocaleProvider>(
                      context,
                      listen: false,
                    );
                    localeProvider.setLocale(const Locale('en'));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ModeSelectionScreen(),
                      ),
                    );
                  },
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// LanguageGlassCard - Custom glassmorphic card for language selection
class LanguageGlassCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const LanguageGlassCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<LanguageGlassCard> createState() => _LanguageGlassCardState();
}

class _LanguageGlassCardState extends State<LanguageGlassCard> {
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
          constraints: const BoxConstraints(maxWidth: 450),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
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
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glowing Icon
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 28),
                      ),

                      const SizedBox(width: 16),

                      // Language Text
                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
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
