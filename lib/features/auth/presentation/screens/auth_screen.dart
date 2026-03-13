import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../pro_mode/presentation/screens/pro_home_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';

/// AuthScreen — the gateway between onboarding and the app.
///
/// Scope freeze: Kids Mode removed. Only Pro Mode is active for MVP.
///
/// Navigation rule: authentication-triggered navigation to [ProHomeScreen]
/// ONLY happens inside the BlocConsumer listener, NEVER inside button onTap.
/// [Navigator.pushAndRemoveUntil] is enforced to clear the back-stack.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    // Scope freeze: always Pro Mode colors. AppModeProvider not needed.
    const Color primaryColor = Colors.indigoAccent;
    const Color glowColor = Colors.blueAccent;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // STRICT NAVIGATION: Clear the full back-stack so the user
            // cannot swipe back to Splash, Onboarding, or AuthScreen.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ProHomeScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.cairo()),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return AppBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildFadeIn(
                        delay: 0,
                        child: _buildAuthCard(
                          isArabic: isArabic,
                          primaryColor: primaryColor,
                          glowColor: glowColor,
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildFadeIn({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (delay * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Transform.translate(
        offset: Offset(0, 30 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
    );
  }

  Widget _buildAuthCard({
    required bool isArabic,
    required Color primaryColor,
    required Color glowColor,
    required bool isLoading,
  }) {
    return GlassCard(
      radius: 30,
      blurSigma: 20,
      padding: const EdgeInsets.all(32),
      borderColor: Colors.white.withValues(alpha: 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
              // Animated lock icon with neon glow
              _buildGlowIcon(glowColor),
              const SizedBox(height: 24),

              // Title — always Pro Mode
              _buildFadeIn(
                delay: 1,
                child: Text(
                  isArabic ? 'مرحباً بعودتك' : 'Welcome Back',
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              _buildFadeIn(
                delay: 2,
                child: Text(
                  isArabic
                      ? 'سجل دخولك لحفظ تقدمك'
                      : 'Login to save your progress',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // ── Pro Mode: Two CTA Buttons (Kids Mode removed for MVP) ────
              _buildFadeIn(
                delay: 3,
                child: GradientButton(
                  label: isArabic
                      ? 'تسجيل الدخول / إنشاء حساب'
                      : 'Login / Sign Up',
                  colors: [primaryColor.withValues(alpha: 0.8), primaryColor],
                  isLoading: false, // hand off to next screen
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildFadeIn(
                delay: 4,
                child: GradientButton(
                  label: isArabic ? 'المتابعة كضيف' : 'Continue as Guest',
                  colors: [Colors.grey.withValues(alpha: 0.6), Colors.grey.withValues(alpha: 0.4)],
                  isLoading: isLoading,
                  onTap: () {
                    context.read<AuthCubit>().signInAnonymously();
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildGlowIcon(Color glowColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Opacity(
        opacity: value,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }



}
