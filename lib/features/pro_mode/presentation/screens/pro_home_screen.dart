import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/animated_fade_slide.dart';
import '../../../../shared/widgets/glass_bottom_nav.dart';
import '../../../../shared/widgets/home_action_card.dart';
import '../cubit/gamification_cubit.dart';
import '../cubit/gamification_state.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import '../../data/datasources/dummy_data_source.dart';
import 'work_styles_screen.dart';
import 'resources_screen.dart';
import 'roadmap_screen.dart' as track_roadmap;
import 'mentorship_screen.dart';
import 'ai_roadmap_screen.dart';
import 'profile_screen.dart';

/// ProHomeScreen - Smart Dashboard with Cubit Integration
/// Displays personalized user data from GamificationCubit and RoadmapCubit
class ProHomeScreen extends StatefulWidget {
  const ProHomeScreen({super.key});

  @override
  State<ProHomeScreen> createState() => _ProHomeScreenState();
}

class _ProHomeScreenState extends State<ProHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();

    // Progress ring animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    // Load data from Cubits
    context.read<GamificationCubit>().initialize();
    context.read<RoadmapCubit>().loadTracks();

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getGreetingArabic() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء الخير';
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return Scaffold(
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
        child: Stack(
          children: [
            // Main Content
            IndexedStack(
              index: _currentNavIndex,
              children: [
                // 0: Home Dashboard
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Collapsible Header with User Data
                    SliverAppBar(
                      expandedHeight: 280,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background:
                            BlocBuilder<GamificationCubit, GamificationState>(
                              builder: (context, state) {
                                if (state is GamificationLoaded) {
                                  return _buildHeroSection(
                                    isArabic,
                                    state.user.name,
                                    state.user.level,
                                    state.user.totalPoints,
                                  );
                                }
                                return _buildHeroSection(
                                  isArabic,
                                  'Guest',
                                  0,
                                  0,
                                );
                              },
                            ),
                      ),
                    ),

                    // Content Body
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),

                            // Amira's Picks Section
                            _buildAnimatedCard(
                              delay: 0,
                              child: _buildAmirasPicks(isArabic),
                            ),

                            const SizedBox(height: 32),

                            // AI Roadmap Quick Action (New)
                            _buildAnimatedCard(
                              delay: 0,
                              child: _buildAIPathButton(context, isArabic),
                            ),

                            const SizedBox(height: 32),

                            // Career Paths Quick Action
                            _buildAnimatedCard(
                              delay: 1,
                              child: _buildCareerPathsButton(context, isArabic),
                            ),

                            const SizedBox(height: 32),

                            // Resources Hub Quick Action
                            _buildAnimatedCard(
                              delay: 2,
                              child: _buildResourcesButton(context, isArabic),
                            ),

                            const SizedBox(height: 32),

                            // Mentors Quick Action
                            _buildAnimatedCard(
                              delay: 3,
                              child: _buildMentorsButton(context, isArabic),
                            ),

                            const SizedBox(height: 32),

                            // Continue Learning Card
                            _buildAnimatedCard(
                              delay: 1,
                              child: _buildContinueLearning(isArabic),
                            ),

                            const SizedBox(height: 32),

                            // Recommended Tracks (Dynamic from Cubit)
                            _buildAnimatedCard(
                              delay: 2,
                              child: BlocBuilder<RoadmapCubit, RoadmapState>(
                                builder: (context, state) {
                                  if (state is TracksLoaded) {
                                    return _buildRecommendedTracks(
                                      isArabic,
                                      state.tracks,
                                    );
                                  } else if (state is RoadmapLoading) {
                                    return _buildLoadingTracks(isArabic);
                                  }
                                  return _buildRecommendedTracks(isArabic, []);
                                },
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 1: AI Roadmap Screen
                const AIRoadmapScreen(),

                // 2: Community (Placeholder)
                Center(
                  child: Text(
                    isArabic ? 'المجتمع قريباً' : 'Community Coming Soon',
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 18),
                  ),
                ),

                // 3: User Profile
                const ProfileScreen(),
              ],
            ),

            // Floating Bottom Navigation
            GlassBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    bool isArabic,
    String userName,
    int level,
    int totalPoints,
  ) {
    // Calculate completion percentage based on current level progress
    final currentLevelPoints = totalPoints % 1000;
    final completionPercentage = currentLevelPoints / 1000;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Greeting
            Text(
              isArabic ? _getGreetingArabic() : _getGreeting(),
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              userName,
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Progress Ring with Real Data
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return _buildProgressRing(
                  completionPercentage * _progressAnimation.value,
                  isArabic,
                  level,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing(double progress, bool isArabic, int level) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Ring
          CustomPaint(
            size: const Size(160, 160),
            painter: CircularProgressPainter(progress: progress),
          ),

          // Center Content with Real Level
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Level $level',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.cairo(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
              Text(
                isArabic ? 'مكتمل' : 'Complete',
                style: GoogleFonts.cairo(fontSize: 12, color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return AnimatedFadeSlide(delay: delay, child: child);
  }

  Widget _buildAIPathButton(BuildContext context, bool isArabic) {
    return HomeActionCard(
      title: isArabic ? 'خارطة طريق ذكية AI' : 'AI Smart Roadmap',
      subtitle: isArabic
          ? 'أنشئ خطة تعلمك مع Gemini'
          : 'Generate your plan with Gemini',
      icon: Icons.auto_awesome,
      iconColors: const [Colors.purpleAccent, Colors.blueAccent],
      isArabic: isArabic,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AIRoadmapScreen()),
      ),
    );
  }

  /// Amira's Picks - Community Tips Section
  Widget _buildAmirasPicks(bool isArabic) {
    final tips = DummyDataSource.getTips();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                isArabic ? 'اختيارات أميرة' : 'Amira\'s Picks',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text('✨', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return _buildTipCard(tip.title, tip.content, tip.category ?? '');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(String title, String content, String category) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Text(
                  content,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareerPathsButton(BuildContext context, bool isArabic) {
    return HomeActionCard(
      title: isArabic ? 'المسارات المهنية' : 'Career Paths',
      subtitle: isArabic
          ? 'اكتشف أسلوب العمل المناسب لك'
          : 'Discover your ideal work style',
      icon: Icons.work_rounded,
      iconColors: [Colors.purpleAccent.withValues(alpha: 0.8), Colors.indigoAccent],
      isArabic: isArabic,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WorkStylesScreen()),
      ),
    );
  }

  Widget _buildResourcesButton(BuildContext context, bool isArabic) {
    return HomeActionCard(
      title: isArabic ? 'مركز الموارد' : 'Resources Hub',
      subtitle: isArabic
          ? 'منصات، كتب، أدوات ومسابقات'
          : 'Platforms, books, tools & contests',
      icon: Icons.library_books_rounded,
      iconColors: [Colors.cyanAccent.withValues(alpha: 0.8), Colors.blueAccent],
      isArabic: isArabic,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResourcesScreen()),
      ),
    );
  }

  Widget _buildMentorsButton(BuildContext context, bool isArabic) {
    return HomeActionCard(
      title: isArabic ? 'مركز الإرشاد' : 'Mentorship Hub',
      subtitle: isArabic
          ? 'احجز جلسة مع خبراء الصناعة'
          : 'Book sessions with experts',
      icon: Icons.people_rounded,
      iconColors: [Colors.purpleAccent.withValues(alpha: 0.8), Colors.pinkAccent],
      isArabic: isArabic,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MentorshipScreen()),
      ),
    );
  }

  Widget _buildContinueLearning(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'تابع التعلم' : 'Continue Learning',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigoAccent.withValues(alpha: 0.4),
                                Colors.blueAccent.withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.flutter_dash,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flutter State Management',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Master Flutter',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? 'التقدم' : 'Progress',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              '65%',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigoAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.65,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.indigoAccent,
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
        ],
      ),
    );
  }

  Widget _buildRecommendedTracks(bool isArabic, List tracks) {
    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            isArabic ? 'المسارات الموصى بها' : 'Recommended Tracks',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return _buildTrackCard(
                trackId: track.id,
                trackTitle: track.title,
                title: track.title,
                icon: _getIconForTrack(track.icon),
                color: _getColorFromHex(track.colorHex),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingTracks(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'المسارات الموصى بها' : 'Recommended Tracks',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: CircularProgressIndicator(color: Colors.indigoAccent),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTrack(String emoji) {
    // Map emoji to IconData
    switch (emoji) {
      case '📱':
        return Icons.flutter_dash;
      case '🤖':
        return Icons.psychology_rounded;
      case '⚙️':
        return Icons.cloud_rounded;
      case '🎨':
        return Icons.palette_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Widget _buildTrackCard({
    required String trackId,
    required String trackTitle,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => track_roadmap.RoadmapScreen(
              trackId: trackId,
              trackTitle: trackTitle,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.4),
                          color.withValues(alpha: 0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CircularProgressPainter - Custom painter for gradient progress ring
class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
      colors: [Colors.indigoAccent, Colors.blueAccent, Colors.purpleAccent],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
