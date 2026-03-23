import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/onboarding/screens/language_selection_screen.dart';
import '../../../../shared/widgets/app_background.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    // تحديد الألوان بناءً على الثيم (فاتح أو غامق)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final glassBg = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03);
    final glassBorder = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final user = (state is Authenticated) ? state.user : null;
          final String name = user?.name ?? (isArabic ? 'مطور' : 'Developer');
          final String email = user?.email ?? 'dev@example.com';
          final String initials = name.isNotEmpty ? name[0].toUpperCase() : 'D';

          return AppBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 100),
                child: Column(
                  children: [
                    _buildProfileHeader(name, email, initials, textColor),
                    const SizedBox(height: 32),
                    
                    // --- إعدادات التطبيق ---
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(isArabic ? 'إعدادات التطبيق' : 'App Settings', style: GoogleFonts.cairo(color: textColor.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    _buildLanguageToggle(context, isArabic, textColor, glassBg, glassBorder),
                    const SizedBox(height: 12),
                    _buildThemeToggle(context, isArabic, textColor, glassBg, glassBorder),
                    const SizedBox(height: 24),

                    // --- الحساب ---
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(isArabic ? 'الحساب' : 'Account', style: GoogleFonts.cairo(color: textColor.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsTile(
                      title: isArabic ? 'تعديل البيانات' : 'Edit Profile',
                      icon: Icons.edit_rounded,
                      textColor: textColor,
                      glassBg: glassBg,
                      glassBorder: glassBorder,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      title: isArabic ? 'تغيير كلمة المرور' : 'Change Password',
                      icon: Icons.lock_outline_rounded,
                      textColor: textColor,
                      glassBg: glassBg,
                      glassBorder: glassBorder,
                      isComingSoon: true,
                      onTap: () => _showComingSoon(context, isArabic, textColor),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      title: isArabic ? 'الإشعارات' : 'Notifications',
                      icon: Icons.notifications_none_rounded,
                      textColor: textColor,
                      glassBg: glassBg,
                      glassBorder: glassBorder,
                      isComingSoon: true,
                      onTap: () => _showComingSoon(context, isArabic, textColor),
                    ),
                    const SizedBox(height: 24),

                    // --- الدعم والتواصل ---
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(isArabic ? 'الدعم والتواصل' : 'Support & Contact', style: GoogleFonts.cairo(color: textColor.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsTile(
                      title: isArabic ? 'تواصل معنا' : 'Contact Us',
                      icon: Icons.email_outlined,
                      textColor: textColor,
                      glassBg: glassBg,
                      glassBorder: glassBorder,
                      onTap: () => _showContactDialog(context, isArabic, textColor),
                    ),
                    const SizedBox(height: 32),

                    // --- تسجيل الخروج ---
                    _buildSettingsTile(
                      title: isArabic ? 'تسجيل الخروج' : 'Logout',
                      icon: Icons.logout_rounded,
                      textColor: Colors.redAccent, // ثابت أحمر
                      glassBg: glassBg,
                      glassBorder: glassBorder,
                      onTap: () => _showLogoutConfirmation(context, isArabic, textColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Header UI
  Widget _buildProfileHeader(String name, String email, String initials, Color textColor) {
    return Column(
      children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Colors.indigoAccent, Colors.purpleAccent]),
            boxShadow: [BoxShadow(color: Colors.indigoAccent.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 5)],
          ),
          child: Center(child: Text(initials, style: GoogleFonts.cairo(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        const SizedBox(height: 16),
        Text(name, style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        Text(email, style: GoogleFonts.cairo(fontSize: 14, color: textColor.withValues(alpha: 0.6))),
      ],
    );
  }

  // مفتاح اللغات (Dropdown)
  Widget _buildLanguageToggle(BuildContext context, bool isArabic, Color textColor, Color glassBg, Color glassBorder) {
    return _buildGlassContainer(
      bg: glassBg,
      border: glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.cyan.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.language_rounded, color: Colors.cyan, size: 20),
              ),
              const SizedBox(width: 16),
              Text(isArabic ? 'اللغة' : 'Language', style: GoogleFonts.cairo(fontSize: 16, color: textColor)),
            ],
          ),
          DropdownButton<String>(
            value: isArabic ? 'ar' : 'en',
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: textColor.withValues(alpha: 0.7)),
            style: GoogleFonts.cairo(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
            onChanged: (String? newVal) {
              if (newVal != null) {
                context.read<LocaleProvider>().setLocale(Locale(newVal));
              }
            },
            items: [
              DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: textColor))),
              DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(color: textColor))),
            ],
          ),
        ],
      ),
    );
  }

  // مفتاح الثيم
  Widget _buildThemeToggle(BuildContext context, bool isArabic, Color textColor, Color glassBg, Color glassBorder) {
    final themeProvider = context.watch<ThemeProvider>();
    return _buildGlassContainer(
      bg: glassBg,
      border: glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.dark_mode_rounded, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 16),
              Text(isArabic ? 'المظهر' : 'Theme', style: GoogleFonts.cairo(fontSize: 16, color: textColor)),
            ],
          ),
          DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: textColor.withValues(alpha: 0.7)),
            style: GoogleFonts.cairo(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
            onChanged: (ThemeMode? newMode) {
              if (newMode != null) themeProvider.setTheme(newMode);
            },
            items: [
              DropdownMenuItem(value: ThemeMode.system, child: Text(isArabic ? 'النظام' : 'System', style: TextStyle(color: textColor))),
              DropdownMenuItem(value: ThemeMode.dark, child: Text(isArabic ? 'داكن' : 'Dark', style: TextStyle(color: textColor))),
              DropdownMenuItem(value: ThemeMode.light, child: Text(isArabic ? 'فاتح' : 'Light', style: TextStyle(color: textColor))),
            ],
          ),
        ],
      ),
    );
  }

  // أزرار الإعدادات العادية
  Widget _buildSettingsTile({
    required String title, required IconData icon, required VoidCallback onTap, 
    required Color textColor, required Color glassBg, required Color glassBorder, 
    bool isComingSoon = false
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: _buildGlassContainer(
        bg: glassBg,
        border: glassBorder,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: textColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: textColor, size: 20),
            ),
            const SizedBox(width: 16),
            Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
            const Spacer(),
            if (isComingSoon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: textColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('قريباً', style: GoogleFonts.cairo(fontSize: 10, color: textColor.withValues(alpha: 0.7))),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded, color: textColor.withValues(alpha: 0.3), size: 16),
          ],
        ),
      ),
    );
  }

  // كونتينر الـ Glass المشترك
  Widget _buildGlassContainer({required Widget child, required Color bg, required Color border}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }

  // رسالة قريباً
  void _showComingSoon(BuildContext context, bool isArabic, Color textColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isArabic ? 'هذه الميزة ستتوفر قريباً 🚀' : 'This feature is coming soon 🚀', style: GoogleFonts.cairo(color: Colors.white)),
        backgroundColor: Colors.indigoAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // نافذة تواصل معنا (بديل آمن لفتح تطبيق الإيميل)
  void _showContactDialog(BuildContext context, bool isArabic, Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            const Icon(Icons.email, color: Colors.indigoAccent),
            const SizedBox(width: 8),
            Text(isArabic ? 'تواصل معنا' : 'Contact Us', style: GoogleFonts.cairo(color: textColor, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          isArabic 
              ? 'يسعدنا تواصلك معنا! يمكنك مراسلتنا عبر البريد الإلكتروني الخاص بالدعم:\n\nsupport@devbuddy.com' 
              : 'We would love to hear from you! Please email our support team at:\n\nsupport@devbuddy.com',
          style: GoogleFonts.cairo(color: textColor, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'حسناً' : 'OK', style: GoogleFonts.cairo(color: Colors.indigoAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // تسجيل الخروج
  void _showLogoutConfirmation(BuildContext context, bool isArabic, Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout', style: GoogleFonts.cairo(color: textColor, fontWeight: FontWeight.bold)),
        content: Text(isArabic ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟' : 'Are you sure you want to logout?', style: GoogleFonts.cairo(color: textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isArabic ? 'إلغاء' : 'Cancel', style: GoogleFonts.cairo(color: textColor.withValues(alpha: 0.6)))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            child: Text(isArabic ? 'خروج' : 'Logout', style: GoogleFonts.cairo(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}