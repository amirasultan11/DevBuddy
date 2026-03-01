import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_mode_provider.dart';
import '../../../core/theme/locale_provider.dart';
import '../../auth/screens/auth_screen.dart';

// 1. The Content Model
class OnboardingContent {
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final IconData icon;

  OnboardingContent({
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // 2. The Data Source - Mode-aware getter
  List<OnboardingContent> _getContents(bool isKidsMode) {
    if (isKidsMode) {
      // Kids Mode: Playful, Fun, Gamified
      return [
        OnboardingContent(
          titleEn: 'Welcome Hero!',
          titleAr: 'أهلاً يا بطل!',
          descEn: 'Ready to build your own games and apps?',
          descAr: 'جاهز تصمم ألعابك وبرامجك بنفسك؟',
          icon: Icons.videogame_asset_rounded,
        ),
        OnboardingContent(
          titleEn: 'Learn by Playing',
          titleAr: 'تعلم باللعب',
          descEn: 'No boring lessons! Solve puzzles to code.',
          descAr: 'مفيش دروس مملة! حل الألغاز عشان تبرمج.',
          icon: Icons.extension_rounded,
        ),
        OnboardingContent(
          titleEn: 'Win Badges',
          titleAr: 'جمع الجوائز',
          descEn: 'Collect stars and trophies as you go!',
          descAr: 'جمع النجوم والكؤوس في رحلتك!',
          icon: Icons.emoji_events_rounded,
        ),
      ];
    } else {
      // Professional Mode: Career-focused
      return [
        OnboardingContent(
          titleEn: 'Start Your Career',
          titleAr: 'ابدأ مسيرتك المهنية',
          descEn:
              'Choose from curated programming tracks designed for career growth and job opportunities.',
          descAr:
              'اختر مسارك من بين مناهج مدروسة بعناية للنمو المهني وفرص العمل.',
          icon: Icons.rocket_launch_rounded,
        ),
        OnboardingContent(
          titleEn: 'Personality Analysis',
          titleAr: 'تحليل الشخصية',
          descEn:
              'Take the personality test to find the right tech path that matches your strengths.',
          descAr:
              'قم بإجراء اختبار الشخصية لمعرفة المسار التقني الأنسب لنقاط قوتك.',
          icon: Icons.psychology_rounded,
        ),
        OnboardingContent(
          titleEn: 'Achieve Mastery',
          titleAr: 'حقق التميز',
          descEn:
              'Stay motivated with daily streaks, achievements, and community support.',
          descAr: 'حافظ على حماسك مع التحديات اليومية والإنجازات ودعم المجتمع.',
          icon: Icons.trending_up_rounded,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<AppModeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    // Get mode-specific content
    final contents = _getContents(modeProvider.isKidsMode);

    // Theme Colors based on Mode
    final primaryColor = modeProvider.isKidsMode
        ? Colors.orangeAccent
        : Colors.indigoAccent;
    final glowColor = modeProvider.isKidsMode
        ? Colors.amber
        : Colors.blueAccent;

    return Scaffold(
      body: Stack(
        children: [
          // 3. Background (Consistent Radial Gradient)
          Container(
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
          ),

          // 4. PageView Slider
          PageView.builder(
            controller: _pageController,
            itemCount: contents.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPageItem(
                contents[index],
                isArabic,
                primaryColor,
                glowColor,
              );
            },
          ),

          // 5. Bottom Controls (Indicators + Buttons)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicators
                Row(
                  children: List.generate(
                    contents.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? primaryColor
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Next / Get Started Button
                _buildGlassButton(
                  text: _currentIndex == contents.length - 1
                      ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                      : (isArabic ? 'التالي' : 'Next'),
                  color: primaryColor,
                  onTap: () {
                    if (_currentIndex == contents.length - 1) {
                      // Navigate to Auth Screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Skip Button (Top Right/Left based on Lang)
          Positioned(
            top: 50,
            right: isArabic ? null : 24,
            left: isArabic ? 24 : null,
            child: TextButton(
              onPressed: () {
                // Skip to Auth Screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: Text(
                isArabic ? 'تخطي' : 'Skip',
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(
    OnboardingContent content,
    bool isArabic,
    Color primary,
    Color glow,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Glass Card
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Neon Icon
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: glow.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          content.icon,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Title
                      Text(
                        isArabic ? content.titleAr : content.titleEn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        isArabic ? content.descAr : content.descEn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
