import 'dart:ui';
import 'package:dev_buddy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dev_buddy/features/auth/presentation/cubit/auth_state.dart';
import 'package:dev_buddy/features/pro_mode/presentation/screens/pre_programming_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/animated_fade_slide.dart';
import '../../../../shared/widgets/glass_bottom_nav.dart';
import '../cubit/gamification_cubit.dart';
import '../cubit/gamification_state.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import '../../data/models/track_model.dart';
import 'resources_screen.dart';
import 'roadmap_screen.dart' as track_roadmap;
import 'roadmaps_screen.dart';
import 'profile_screen.dart';
import 'ai_generator_screen.dart';

class ProHomeScreen extends StatefulWidget {
  const ProHomeScreen({super.key});

  @override
  State<ProHomeScreen> createState() => _ProHomeScreenState();
}

class _ProHomeScreenState extends State<ProHomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // تحميل الداتا أول ما الشاشة تفتح
    context.read<GamificationCubit>().initialize();
    context.read<RoadmapCubit>().loadTracks();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1E293B), Color(0xFF020617)],
          ),
        ),
        child: Stack(
          children: [
            IndexedStack(
              index: _currentNavIndex,
              children: [
                // 0: Home Dashboard
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          String name = 'Developer';
                          String personality = 'Dev';
                          if (state is Authenticated) {
                            name = state.user.name.isNotEmpty
                                ? state.user.name
                                : 'Developer';
                            personality = state.user.personalityType ?? 'Dev';
                          }
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.indigoAccent,
                                child: Text(
                                  name[0].toUpperCase(),
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic ? 'مرحباً بك،' : 'Welcome back,',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.cairo(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purpleAccent.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.purpleAccent
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Text(
                                          personality,
                                          style: GoogleFonts.cairo(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purpleAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 120,
                          left: 24,
                          right: 24,
                          top: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'نظرة عامة' : 'Overview',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // كارت الإحصائيات (مربوط بالـ Gamification)
                            AnimatedFadeSlide(
                              delay: 0,
                              child:
                                  BlocBuilder<
                                    GamificationCubit,
                                    GamificationState
                                  >(
                                    builder: (context, state) {
                                      return _buildOverviewCard(
                                        isArabic,
                                        state,
                                      );
                                    },
                                  ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              isArabic ? 'إجراءات سريعة' : 'Quick Actions',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedFadeSlide(
                              delay: 1,
                              child: _buildQuickActions(context, isArabic),
                            ),
                            const SizedBox(height: 32),
                            AnimatedFadeSlide(
                              delay: 2,
                              child: BlocBuilder<RoadmapCubit, RoadmapState>(
                                builder: (context, state) {
                                  if (state is TracksLoaded) {
                                    return _buildRecommendedTracks(
                                      isArabic,
                                      state.tracks,
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // 1: Roadmaps Screen
                const RoadmapsScreen(),
                // 2: Profile Screen
                const ProfileScreen(),
              ],
            ),
            GlassBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(bool isArabic, GamificationState state) {
    int points = 0;
    int level = 1;
    int streak = 0;

    if (state is GamificationLoaded) {
      points = state.user.totalPoints;
      level = state.user.level;
      streak = state.user.currentStreak;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Bumped from 0.05 → 0.09 for visible separation on the dark background.
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatColumn(
            Icons.stars_rounded,
            Colors.amberAccent,
            '$points',
            isArabic ? 'نقطة' : 'Points',
          ),
          _buildStatColumn(
            Icons.trending_up_rounded,
            Colors.greenAccent,
            'Lvl $level',
            isArabic ? 'المستوى' : 'Level',
          ),
          _buildStatColumn(
            Icons.local_fire_department_rounded,
            Colors.orangeAccent,
            '$streak',
            isArabic ? 'أيام متتالية' : 'Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 12, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildActionChip(
            isArabic ? 'مستشارك الذكي' : 'AI Consultant',
            Icons.memory_rounded,
            Colors.deepPurpleAccent,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiGeneratorScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
          _buildActionChip(
            isArabic ? 'تأسيس برمجي' : 'Pre-Programming',
            Icons.calculate_rounded,
            Colors.orangeAccent,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MathLogicScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
          _buildActionChip(
            isArabic ? 'الموارد' : 'Resources',
            Icons.library_books_rounded,
            Colors.cyanAccent,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResourcesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    // ConstrainedBox enforces the Material 48dp minimum interactive touch target.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fixed: typed List<TrackModel> instead of dynamic List.
  Widget _buildRecommendedTracks(bool isArabic, List<TrackModel> tracks) {
    if (tracks.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المسارات المتاحة' : 'Available Tracks',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return _buildTrackCard(
                trackId: track.id,
                title: track.title,
                // Dynamic per-track visual identity derived from track ID.
                icon: _trackIcon(track.id),
                color: _trackColor(track.id),
                // Progress is loaded on-demand when the user enters a track.
                // Defaults to 0.0 on the home screen; updates after returning.
                progress: 0.0,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackCard({
    required String trackId,
    required String title,
    required IconData icon,
    required Color color,
    double progress = 0.0,
  }) {
    final progressPercent = (progress * 100).toInt();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => track_roadmap.RoadmapScreen(
              trackId: trackId,
              trackTitle: title,
            ),
          ),
        ).then((_) => context.read<RoadmapCubit>().loadTracks());
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          // Border uses the track's accent color for visual variety.
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Progress bar — shows 0% until user enters and returns from the track.
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$progressPercent%',
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: progressPercent > 0 ? color : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Track Theme Helpers ─────────────────────────────────────────────────────

  /// Returns a contextually relevant icon for a track based on its ID keywords.
  /// Falls back to [Icons.code_rounded] for unrecognised IDs.
  IconData _trackIcon(String trackId) {
    final id = trackId.toLowerCase();
    if (id.contains('flutter') || id.contains('mobile')) return Icons.phone_android_rounded;
    if (id.contains('web') || id.contains('front')) return Icons.web_rounded;
    if (id.contains('backend') || id.contains('server') || id.contains('api')) return Icons.dns_rounded;
    if (id.contains('data') || id.contains('sql') || id.contains('db')) return Icons.bar_chart_rounded;
    if (id.contains('ai') || id.contains('ml')) return Icons.psychology_rounded;
    if (id.contains('devops') || id.contains('cloud')) return Icons.cloud_rounded;
    if (id.contains('security') || id.contains('cyber')) return Icons.security_rounded;
    if (id.contains('game')) return Icons.sports_esports_rounded;
    return Icons.code_rounded;
  }

  /// Returns a deterministic accent color for a track derived from its ID hash.
  /// This ensures each track always renders the same color across rebuilds.
  Color _trackColor(String trackId) {
    const palette = [
      Colors.indigoAccent,
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
    ];
    return palette[trackId.hashCode.abs() % palette.length];
  }
}
