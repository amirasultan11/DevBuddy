
import 'dart:math';
import 'package:flutter/material.dart';


/// SplashScreen - Premium Cyber-Tech animated splash screen
/// Features pulsing neon glow, metallic logo, and fluid transitions
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with RadialGradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF1E293B), // Slightly lighter navy (center)
                  Color(0xFF020617), // Almost black (edges)
                ],
              ),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Glow Logo
                    _AnimatedGlowLogo(),

                    const SizedBox(height: 40),

                    // App Name
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF06B6D4), // Cyan
                          Colors.white,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'DEV BUDDY',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated Glow Logo with pulsing neon effect
class _AnimatedGlowLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOutQuart,
      builder: (context, value, child) {
        // Pulsing effect using sine wave
        final pulseValue = 0.5 + (0.5 * (1 + sin(value * 6.28318)) / 2);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              // Pulsing neon glow effect
              BoxShadow(
                color: const Color(
                  0xFF06B6D4,
                ).withValues(alpha: 0.6 * pulseValue),
                blurRadius: 50 + (30 * pulseValue),
                spreadRadius: 10 + (10 * pulseValue),
              ),
              BoxShadow(
                color: const Color(
                  0xFF8B5CF6,
                ).withValues(alpha: 0.4 * pulseValue),
                blurRadius: 70 + (30 * pulseValue),
                spreadRadius: 5 + (5 * pulseValue),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF06B6D4), // Cyan
                  Colors.white,
                ],
              ).createShader(bounds),
              child: const Icon(
                Icons.code_rounded,
                size: 100,
                color: Colors.white, // Will be replaced by gradient
              ),
            ),
          ),
        );
      },
    );
  }
}
