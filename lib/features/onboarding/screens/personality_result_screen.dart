import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/pro_mode/presentation/screens/pro_home_screen.dart';

class PersonalityResultScreen extends StatefulWidget {
  final String personalityType;
  const PersonalityResultScreen({super.key, required this.personalityType});

  @override
  State<PersonalityResultScreen> createState() => _PersonalityResultScreenState();
}

class _PersonalityResultScreenState extends State<PersonalityResultScreen> {
  bool _isLoading = false;

  Map<String, String> _getRecommendations(String type, bool isArabic) {
    if (type.contains('E') && type.contains('P')) {
      return {
        'track': isArabic ? 'تطوير الموبايل (Flutter)' : 'Mobile Dev (Flutter)',
        'workStyle': isArabic ? 'بيئة الشركات الناشئة (Startup)' : 'Startup Environment',
      };
    } else if (type.contains('I') && type.contains('T')) {
      return {
        'track': isArabic ? 'الذكاء الاصطناعي أو Backend' : 'AI/ML or Backend',
        'workStyle': isArabic ? 'العمل الحر (Freelance)' : 'Freelance / Remote',
      };
    } else {
      return {
        'track': isArabic ? 'تطوير واجهات المستخدم (UI/UX)' : 'UI/UX Design',
        'workStyle': isArabic ? 'الشركات الكبرى (Corporate)' : 'Corporate Environment',
      };
    }
  }

  void _finishAndSave() async {
    setState(() => _isLoading = true);
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.getCurrentUser();

    if (currentUser != null) {
      await authCubit.updateUserProfile(
        currentUser.copyWith(personalityType: widget.personalityType),
      );
    }
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ProHomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final recs = _getRecommendations(widget.personalityType, isArabic);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  isArabic ? 'اكتمل التحليل!' : 'Analysis Complete!',
                  style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 40),
                GlassCard(
                  radius: 24,
                  padding: const EdgeInsets.all(24),
                  borderColor: Colors.purpleAccent.withValues(alpha: 0.3),
                  child: Column(
                    children: [
                      Text(
                        widget.personalityType,
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 48, fontWeight: FontWeight.bold, color: Colors.purpleAccent, letterSpacing: 4,
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 40),
                      _buildRecRow(isArabic ? 'المسار المرشح:' : 'Recommended Track:', recs['track']!, Icons.route_rounded, Colors.blueAccent),
                      const SizedBox(height: 20),
                      _buildRecRow(isArabic ? 'بيئة العمل:' : 'Best Environment:', recs['workStyle']!, Icons.business_center_rounded, Colors.greenAccent),
                    ],
                  ),
                ),
                const Spacer(),
                GradientButton(
                  label: isArabic ? 'ابدأ رحلتك الآن 🚀' : 'Start My Journey 🚀',
                  isLoading: _isLoading,
                  onTap: _finishAndSave,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.cairo(fontSize: 12, color: Colors.white60)),
              Text(value, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}