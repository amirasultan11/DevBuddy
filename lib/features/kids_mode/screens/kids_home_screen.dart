import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/locale_provider.dart';
import 'game_level_screen.dart';

class KidsHomeScreen extends StatefulWidget {
  final String heroName;
  final String selectedAvatar;

  const KidsHomeScreen({
    super.key,
    required this.heroName,
    required this.selectedAvatar,
  });

  @override
  State<KidsHomeScreen> createState() => _KidsHomeScreenState();
}

class _KidsHomeScreenState extends State<KidsHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late AnimationController _starsController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  int unlockedLevel = 1; // Current unlocked level (dynamic)
  final int totalLevels = 6;

  @override
  void initState() {
    super.initState();

    // Pulse animation for active level
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Bounce animation for avatar
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Stars twinkling animation
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            // Starry Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _starsController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: StarryBackgroundPainter(
                      animationValue: _starsController.value,
                    ),
                  );
                },
              ),
            ),

            // Scrollable Map Content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: screenHeight * 1.5, // 1.5x screen height for scrolling
                width: screenWidth,
                child: Stack(
                  children: [
                    // The Winding Path
                    Positioned.fill(
                      child: CustomPaint(
                        painter: MapPathPainter(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight * 1.5,
                        ),
                      ),
                    ),

                    // Level Nodes
                    ..._buildLevelNodes(
                      screenWidth,
                      screenHeight * 1.5,
                      isArabic,
                    ),

                    // Floating Avatar above Level 1
                    _buildFloatingAvatar(screenWidth, screenHeight * 1.5),
                  ],
                ),
              ),
            ),

            // Header with Hero Name
            _buildHeader(isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hero Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic ? 'مرحباً' : 'Hello',
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  widget.heroName,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Avatar Display
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.orangeAccent.withValues(alpha: 0.4),
                    Colors.amber.withValues(alpha: 0.3),
                  ],
                ),
                border: Border.all(
                  color: Colors.orangeAccent.withValues(alpha: 0.8),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.selectedAvatar,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLevelNodes(double width, double height, bool isArabic) {
    final nodes = <Widget>[];

    // Define level positions as percentages (responsive!)
    final levelPositions = [
      {'x': 0.5, 'y': 0.85}, // Level 1 - Bottom (Active)
      {'x': 0.3, 'y': 0.70}, // Level 2 - Left
      {'x': 0.7, 'y': 0.55}, // Level 3 - Right
      {'x': 0.4, 'y': 0.40}, // Level 4 - Left-Center
      {'x': 0.6, 'y': 0.25}, // Level 5 - Right-Center
      {'x': 0.5, 'y': 0.10}, // Level 6 - Top Center
    ];

    for (int i = 0; i < totalLevels; i++) {
      final level = i + 1;
      final isActive = level <= unlockedLevel;
      final position = levelPositions[i];

      nodes.add(
        Positioned(
          left: width * position['x']! - 40, // Center the 80px node
          top: height * position['y']! - 40,
          child: LevelNode(
            level: level,
            isActive: isActive,
            pulseAnimation: isActive ? _pulseAnimation : null,
            onTap: () => _handleLevelTap(level, isActive),
            isArabic: isArabic,
          ),
        ),
      );
    }

    return nodes;
  }

  Widget _buildFloatingAvatar(double width, double height) {
    // Position above Level 1 (85% down the screen)
    return Positioned(
      left: width * 0.5 - 35, // Center the 70px avatar
      top: height * 0.85 - 120, // 80px above Level 1
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.orangeAccent.withValues(alpha: 0.6),
                    Colors.amber.withValues(alpha: 0.4),
                  ],
                ),
                border: Border.all(color: Colors.orangeAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.selectedAvatar,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLevelTap(int level, bool isActive) {
    if (isActive) {
      // Launch animation and navigate
      _launchLevel(level);
    } else {
      // Shake animation for locked levels
      _shakeLocked();
    }
  }

  void _launchLevel(int level) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameLevelScreen(level: level)),
    );

    // Refresh state after returning from level
    if (result == true && mounted) {
      setState(() {
        // State will be updated by BlocBuilder
      });
    }
  }

  void _shakeLocked() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Complete previous levels first! 🔒',
          style: GoogleFonts.cairo(),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

/// LevelNode - Individual level circle widget
class LevelNode extends StatefulWidget {
  final int level;
  final bool isActive;
  final Animation<double>? pulseAnimation;
  final VoidCallback onTap;
  final bool isArabic;

  const LevelNode({
    super.key,
    required this.level,
    required this.isActive,
    this.pulseAnimation,
    required this.onTap,
    required this.isArabic,
  });

  @override
  State<LevelNode> createState() => _LevelNodeState();
}

class _LevelNodeState extends State<LevelNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final nodeSize = widget.isActive ? 80.0 : 60.0;

    return GestureDetector(
      onTap: () {
        if (!widget.isActive) {
          _triggerShake();
        }
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(math.sin(_shakeAnimation.value) * 5, 0),
            child: SizedBox(
              width: nodeSize,
              height: nodeSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse/Ripple effect for active level
                  if (widget.isActive && widget.pulseAnimation != null)
                    AnimatedBuilder(
                      animation: widget.pulseAnimation!,
                      builder: (context, child) {
                        return Container(
                          width: nodeSize * widget.pulseAnimation!.value,
                          height: nodeSize * widget.pulseAnimation!.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.cyan.withValues(
                                alpha: 1.0 - widget.pulseAnimation!.value + 1.0,
                              ),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),

                  // Main Node Circle
                  Container(
                    width: nodeSize,
                    height: nodeSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isActive
                            ? [
                                Colors.cyan.withValues(alpha: 0.6),
                                Colors.purple.withValues(alpha: 0.5),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.15),
                                Colors.white.withValues(alpha: 0.08),
                              ],
                      ),
                      border: Border.all(
                        color: widget.isActive
                            ? Colors.cyan
                            : Colors.white.withValues(alpha: 0.3),
                        width: widget.isActive ? 3 : 2,
                      ),
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: Colors.cyan.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        widget.isActive
                            ? Icons.play_arrow_rounded
                            : Icons.lock_rounded,
                        color: Colors.white,
                        size: widget.isActive ? 40 : 30,
                      ),
                    ),
                  ),

                  // Level Number Badge
                  Positioned(
                    bottom: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? Colors.cyan
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.level}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// MapPathPainter - Draws the winding Bezier curve path
class MapPathPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;

  MapPathPainter({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = Colors.purple.withValues(alpha: 0.2)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Create winding path using percentage-based coordinates
    final path = Path();

    // Start at Level 1 position (50%, 85%)
    path.moveTo(screenWidth * 0.5, screenHeight * 0.85);

    // Curve to Level 2 (30%, 70%)
    path.quadraticBezierTo(
      screenWidth * 0.2,
      screenHeight * 0.78,
      screenWidth * 0.3,
      screenHeight * 0.70,
    );

    // Curve to Level 3 (70%, 55%)
    path.quadraticBezierTo(
      screenWidth * 0.8,
      screenHeight * 0.62,
      screenWidth * 0.7,
      screenHeight * 0.55,
    );

    // Curve to Level 4 (40%, 40%)
    path.quadraticBezierTo(
      screenWidth * 0.2,
      screenHeight * 0.47,
      screenWidth * 0.4,
      screenHeight * 0.40,
    );

    // Curve to Level 5 (60%, 25%)
    path.quadraticBezierTo(
      screenWidth * 0.8,
      screenHeight * 0.32,
      screenWidth * 0.6,
      screenHeight * 0.25,
    );

    // Curve to Level 6 (50%, 10%)
    path.quadraticBezierTo(
      screenWidth * 0.3,
      screenHeight * 0.17,
      screenWidth * 0.5,
      screenHeight * 0.10,
    );

    // Draw glow effect first
    canvas.drawPath(path, glowPaint);

    // Draw dashed path
    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 15.0;
    const dashSpace = 10.0;

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          nextDistance > metric.length ? metric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// StarryBackgroundPainter - Draws twinkling stars
class StarryBackgroundPainter extends CustomPainter {
  final double animationValue;

  StarryBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent positions

    // Draw 40 stars
    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 1;

      // Twinkling effect using animation value
      final twinkle = (math.sin((animationValue * 2 * math.pi) + i) + 1) / 2;
      final opacity = 0.3 + (twinkle * 0.5);

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarryBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
