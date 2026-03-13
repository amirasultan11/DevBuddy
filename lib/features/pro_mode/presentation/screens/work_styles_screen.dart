import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/animated_fade_slide.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/datasources/dummy_data_source.dart';
import '../../data/models/work_style_model.dart';

/// Work Styles Hub - Career Path Guidance Screen
/// Displays detailed information about Freelance, Startup, and Corporate work styles
class WorkStylesScreen extends StatelessWidget {
  const WorkStylesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final workStyles = DummyDataSource.getWorkStyles();

    return Scaffold(
      body: AppBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  isArabic ? Icons.arrow_forward : Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  isArabic ? 'المسارات المهنية' : 'Career Paths',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),

            // Subtitle
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Text(
                  isArabic
                      ? 'اكتشف أسلوب العمل المناسب لشخصيتك وأهدافك المهنية'
                      : 'Discover the work style that matches your personality and career goals',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Work Style Cards
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildAnimatedCard(
                  delay: index,
                  child: _buildWorkStyleCard(workStyles[index], isArabic),
                );
              }, childCount: workStyles.length),
            ),

            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return AnimatedFadeSlide(delay: delay, child: child);
  }

  /// Performance fix: BackdropFilter removed from list cards.
  /// Replaced with a flat semi-transparent Container — visually near-identical
  /// but renders without per-frame compositing overhead.
  Widget _buildWorkStyleCard(WorkStyleModel workStyle, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GlassCard(
        hasBlur: false, // Performance fix for list cards
        radius: 24,
        padding: const EdgeInsets.all(24),
        borderColor: Colors.white.withValues(alpha: 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Description
            Text(
              workStyle.title,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              workStyle.description,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white70,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),
            _buildSalarySection(workStyle, isArabic),

            const SizedBox(height: 24),
            _buildPersonalitySection(workStyle, isArabic),

            const SizedBox(height: 24),
            _buildProsConsSection(workStyle, isArabic),

            const SizedBox(height: 24),
            _buildSkillsSection(workStyle, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildSalarySection(WorkStyleModel workStyle, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.attach_money_rounded,
              color: Colors.greenAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'نطاق الراتب' : 'Salary Range',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.greenAccent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🇪🇬', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'مصر' : 'Egypt',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${workStyle.avgSalaryRange['minEGP']!.toInt()}K - ${workStyle.avgSalaryRange['maxEGP']!.toInt()}K EGP/mo',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🌍', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'عالمي' : 'Global',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${workStyle.avgSalaryRange['minUSD']!.toInt()}K - \$${workStyle.avgSalaryRange['maxUSD']!.toInt()}K/yr',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalitySection(WorkStyleModel workStyle, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.psychology_rounded,
              color: Colors.purpleAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'مناسب لـ' : 'Best for',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workStyle.suitablePersonalityTypes.map((type) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withValues(alpha: 0.3),
                    Colors.purpleAccent.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.purpleAccent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Text(
                type,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProsConsSection(WorkStyleModel workStyle, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المميزات والعيوب' : 'Pros & Cons',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pros Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'المميزات' : 'Pros',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...workStyle.pros.map(
                    (pro) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pro,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Cons Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'العيوب' : 'Cons',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...workStyle.cons.map(
                    (con) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              con,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsSection(WorkStyleModel workStyle, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amberAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'المهارات المطلوبة' : 'Required Skills',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workStyle.requiredSoftSkills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amberAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amberAccent.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                skill,
                style: GoogleFonts.cairo(fontSize: 11, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
