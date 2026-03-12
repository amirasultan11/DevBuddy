import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/locale_provider.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        // BackdropFilter is safe here — this card is NOT inside a scrollable list.
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
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
                child: _buildGlassButton(
                  text: isArabic
                      ? 'تسجيل الدخول / إنشاء حساب'
                      : 'Login / Sign Up',
                  primaryColor: primaryColor,
                  isLoading: false,
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
                child: _buildGlassButton(
                  text: isArabic ? 'المتابعة كضيف' : 'Continue as Guest',
                  primaryColor: Colors.grey,
                  isLoading: isLoading,
                  onTap: () {
                    context.read<AuthCubit>().signInAnonymously();
                  },
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildGlassButton({
    required String text,
    required Color primaryColor,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.3),
              primaryColor.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

}
