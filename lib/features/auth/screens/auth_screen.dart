import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_mode_provider.dart';
import '../../../core/theme/locale_provider.dart';
import '../../kids_mode/screens/kids_home_screen.dart';
import '../../pro_mode/screens/pro_home_screen.dart';

/// AuthScreen - Glassmorphism authentication screen with mode-aware UI
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _heroNameController = TextEditingController();
  final FocusNode _heroNameFocusNode = FocusNode();
  bool _isLockUnlocked = false;
  String _selectedAvatar = '🤖';

  @override
  void initState() {
    super.initState();

    // Animation controller for sequential animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.forward();

    // Listen to text changes for lock animation
    _emailController.addListener(() {
      setState(() {
        _isLockUnlocked = _emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _heroNameController.dispose();
    _heroNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<AppModeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final isKidsMode = modeProvider.isKidsMode;

    // Theme colors based on mode
    final primaryColor = isKidsMode ? Colors.orangeAccent : Colors.indigoAccent;
    final glowColor = isKidsMode ? Colors.amber : Colors.blueAccent;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1E293B), // Lighter Navy Center
              Color(0xFF020617), // Darkest Navy Edges
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

                  // Main Glass Card
                  _buildAnimatedCard(
                    delay: 0,
                    child: _buildAuthCard(
                      isArabic: isArabic,
                      isKidsMode: isKidsMode,
                      primaryColor: primaryColor,
                      glowColor: glowColor,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (delay * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  Widget _buildAuthCard({
    required bool isArabic,
    required bool isKidsMode,
    required Color primaryColor,
    required Color glowColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
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
              // Animated Lock Icon
              _buildAnimatedLockIcon(glowColor),

              const SizedBox(height: 24),

              // Title
              _buildAnimatedElement(
                delay: 1,
                child: Text(
                  isKidsMode
                      ? (isArabic ? 'هيا بنا!' : 'Let\'s Go!')
                      : (isArabic ? 'مرحباً بعودتك' : 'Welcome Back'),
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
              _buildAnimatedElement(
                delay: 2,
                child: Text(
                  isArabic
                      ? 'سجل دخولك لحفظ تقدمك'
                      : 'Login to save your progress',
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Conditional content based on mode
              if (!isKidsMode) ...[
                // Email Input for Pro Mode
                _buildAnimatedElement(
                  delay: 3,
                  child: GlassTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    hintText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    primaryColor: primaryColor,
                    glowColor: glowColor,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                const SizedBox(height: 24),

                // Send Magic Code Button
                _buildAnimatedElement(
                  delay: 4,
                  child: _buildPrimaryButton(
                    text: isArabic ? 'إرسال رمز التحقق' : 'Send Magic Code',
                    primaryColor: primaryColor,
                    onTap: () {
                      // Validate email
                      if (_emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? 'من فضلك أدخل بريدك الإلكتروني!'
                                  : 'Please enter your email!',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: Colors.indigo,
                          ),
                        );
                        return;
                      }

                      // Navigate to Professional Dashboard (no back to auth)
                      // TODO: Implement actual OTP logic
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProHomeScreen(),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Social Login Buttons
                _buildAnimatedElement(
                  delay: 5,
                  child: Column(
                    children: [
                      Text(
                        isArabic ? 'أو سجل دخولك عبر' : 'Or continue with',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Google',
                            glowColor: glowColor,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'تسجيل الدخول عبر جوجل (قريباً)'
                                        : 'Google Login (Coming Soon)',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildSocialButton(
                            icon: Icons.code_rounded,
                            label: 'GitHub',
                            glowColor: glowColor,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'تسجيل الدخول عبر GitHub (قريباً)'
                                        : 'GitHub Login (Coming Soon)',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Kids Mode: Avatar Selection Grid
                _buildAnimatedElement(
                  delay: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'اختر شخصيتك' : 'Choose Your Avatar',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAvatarGrid(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Hero Name Input
                _buildAnimatedElement(
                  delay: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic
                            ? 'ما هو اسم بطلك؟'
                            : 'What is your hero name?',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildHeroNameField(
                        hintText: isArabic ? 'اسم البطل' : 'Hero Name',
                        primaryColor: primaryColor,
                        glowColor: glowColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Start Adventure Button
                _buildAnimatedElement(
                  delay: 5,
                  child: _buildGuestButton(
                    text: isArabic ? 'ابدأ المغامرة!' : 'Start Adventure',
                    primaryColor: primaryColor,
                    glowColor: glowColor,
                    icon: Icons.rocket_launch_rounded,
                    onTap: () {
                      // Validate hero name
                      if (_heroNameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? 'من فضلك أدخل اسم بطلك!'
                                  : 'Please enter your hero name!',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      // Navigate to Kids Adventure Map (no back to auth)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KidsHomeScreen(
                            heroName: _heroNameController.text.trim(),
                            selectedAvatar: _selectedAvatar,
                          ),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Parent Gate Link
                _buildAnimatedElement(
                  delay: 6,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Show parent login dialog
                      _showParentLoginDialog(context, isArabic);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      isArabic
                          ? 'لديك حساب بالفعل؟ تسجيل دخول (للآباء)'
                          : 'Already have an account? Login (Parents)',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLockIcon(Color glowColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Container(
                key: ValueKey(_isLockUnlocked),
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
                child: Icon(
                  _isLockUnlocked
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedElement({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (delay * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
        child: Text(
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

  Widget _buildGuestButton({
    required String text,
    required Color primaryColor,
    required Color glowColor,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.4),
              primaryColor.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.play_circle_filled_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    final avatars = ['🤖', '🦁', '👩🚀', '🦸‍♂️', '🐉', '🦄', '🐱', '🐶'];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = _selectedAvatar == avatar;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatar = avatar;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          Colors.orangeAccent.withValues(alpha: 0.4),
                          Colors.amber.withValues(alpha: 0.3),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
                border: Border.all(
                  color: isSelected
                      ? Colors.orangeAccent.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.2),
                  width: isSelected ? 2.5 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(avatar, style: const TextStyle(fontSize: 32)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroNameField({
    required String hintText,
    required Color primaryColor,
    required Color glowColor,
  }) {
    return GlassTextField(
      controller: _heroNameController,
      focusNode: _heroNameFocusNode,
      hintText: hintText,
      primaryColor: primaryColor,
      glowColor: glowColor,
      keyboardType: TextInputType.name,
    );
  }

  void _showParentLoginDialog(BuildContext context, bool isArabic) {
    final primaryColor = Colors.indigoAccent;
    final glowColor = Colors.blueAccent;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.08),
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
                  // Title
                  Text(
                    isArabic ? 'تسجيل دخول الآباء' : 'Parent Login',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'أدخل بريدك الإلكتروني للمتابعة'
                        : 'Enter your email to continue',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Input
                  GlassTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    hintText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    primaryColor: primaryColor,
                    glowColor: glowColor,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            isArabic ? 'إلغاء' : 'Cancel',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_emailController.text.isNotEmpty) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'تم تسجيل الدخول بنجاح! (تجريبي)'
                                        : 'Logged in successfully! (Demo)',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Navigate to Pro Home as Parent
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProHomeScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'يرجى إدخال البريد الإلكتروني'
                                        : 'Please enter email',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                            ),
                            child: Text(
                              isArabic ? 'تسجيل الدخول' : 'Login',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// GlassTextField - Custom text field with glassmorphism and neon glow
class GlassTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color primaryColor;
  final Color glowColor;
  final TextInputType keyboardType;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.primaryColor,
    required this.glowColor,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused
              ? widget.primaryColor.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.2),
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.cairo(
                  color: Colors.white60,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
