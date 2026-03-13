import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import '../cubit/gamification_cubit.dart';
import '../../data/models/roadmap_step_model.dart';

/// Roadmap Details Screen - Learning Path for a Specific Track
/// Displays steps with status, progress tracking, and interactive completion
class RoadmapScreen extends StatefulWidget {
  final String trackId;
  final String trackTitle;

  const RoadmapScreen({
    super.key,
    required this.trackId,
    required this.trackTitle,
  });

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  Set<String> expandedSteps = {};

  @override
  void initState() {
    super.initState();
    // Load roadmap steps for this track
    context.read<RoadmapCubit>().loadRoadmap(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(isArabic),

              // Content
              Expanded(
                child: BlocBuilder<RoadmapCubit, RoadmapState>(
                  builder: (context, state) {
                    if (state is RoadmapLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigoAccent,
                        ),
                      );
                    } else if (state is RoadmapLoaded) {
                      return _buildRoadmapContent(state, isArabic);
                    } else if (state is RoadmapError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.cairo(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.trackTitle,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapContent(RoadmapLoaded state, bool isArabic) {
    final stats = _calculateStats(state.steps);

    return Column(
      children: [
        // Progress Overview
        _buildProgressOverview(stats, isArabic),

        const SizedBox(height: 16),

        // Steps List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: state.steps.length,
            itemBuilder: (context, index) {
              final step = state.steps[index];
              final isExpanded = expandedSteps.contains(step.id);
              return _buildStepCard(step, isExpanded, isArabic);
            },
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateStats(List<RoadmapStepModel> steps) {
    final completed = steps.where((s) => s.isCompleted).length;
    final total = steps.length;
    final progress = total > 0 ? (completed / total) : 0.0;

    // Calculate estimated time remaining
    final remainingSteps = steps.where((s) => !s.isCompleted).toList();
    final totalHours = remainingSteps.fold<double>(
      0.0,
      (sum, step) => sum + step.estimatedHours,
    );
    final hours = totalHours.floor();
    final minutes = ((totalHours - hours) * 60).round();

    return {
      'completed': completed,
      'total': total,
      'progress': progress,
      'hours': hours,
      'minutes': minutes,
    };
  }

  Widget _buildProgressOverview(Map<String, dynamic> stats, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'التقدم' : 'Progress',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${stats['completed']}/${stats['total']} ${isArabic ? 'خطوات' : 'steps'}',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: stats['progress'],
                    minHeight: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.indigoAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic
                          ? 'الوقت المتبقي: ${stats['hours']}س ${stats['minutes']}د'
                          : 'Time remaining: ${stats['hours']}h ${stats['minutes']}m',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(RoadmapStepModel step, bool isExpanded, bool isArabic) {
    final status = _getStepStatus(step);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: status == 'locked'
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Main Card Content
                InkWell(
                  onTap: status != 'locked'
                      ? () {
                          setState(() {
                            if (isExpanded) {
                              expandedSteps.remove(step.id);
                            } else {
                              expandedSteps.add(step.id);
                            }
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Status Icon
                            _buildStatusIcon(status),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step.title,
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: status == 'locked'
                                          ? Colors.white38
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(step.estimatedHours * 60).round()} ${isArabic ? 'دقيقة' : 'min'}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: status == 'locked'
                                          ? Colors.white24
                                          : Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (status != 'locked')
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white70,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step.description,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: status == 'locked'
                                ? Colors.white24
                                : Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded Content
                if (isExpanded && status != 'locked')
                  _buildExpandedContent(step, status, isArabic),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStepStatus(RoadmapStepModel step) {
    if (step.isCompleted) return 'completed';
    if (step.isLocked) return 'locked';
    return 'open';
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent.withValues(alpha: 0.4),
                Colors.greenAccent.withValues(alpha: 0.2),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 30,
          ),
        );
      case 'open':
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withValues(alpha: 0.4),
                Colors.blueAccent.withValues(alpha: 0.2),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.play_circle_outline,
            color: Colors.blueAccent,
            size: 30,
          ),
        );
      case 'locked':
      default:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.withValues(alpha: 0.3),
                Colors.grey.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock, color: Colors.white38, size: 30),
        );
    }
  }

  Widget _buildExpandedContent(
    RoadmapStepModel step,
    String status,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          // Resources
          if (step.resources.isNotEmpty) ...[
            _buildSectionHeader(
              Icons.link,
              isArabic ? 'الموارد' : 'Resources',
              Colors.cyanAccent,
            ),
            const SizedBox(height: 12),
            ...step.resources.map(
              (resource) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.open_in_new,
                      color: Colors.cyanAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${resource.title} (${resource.type})',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.cyanAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Common Mistakes
          if (step.commonMistakes.isNotEmpty) ...[
            _buildSectionHeader(
              Icons.warning_rounded,
              isArabic ? 'أخطاء شائعة' : 'Common Mistakes',
              Colors.orangeAccent,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orangeAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: step.commonMistakes
                    .map(
                      (mistake) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                mistake,
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
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Tips
          if (step.practicalTips != null && step.practicalTips!.isNotEmpty) ...[
            _buildSectionHeader(
              Icons.lightbulb_rounded,
              isArabic ? 'نصائح' : 'Tips',
              Colors.amberAccent,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amberAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amberAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: step.practicalTips!
                    .map(
                      (tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                tip,
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
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Mark Complete Button
          if (status == 'open')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _markStepComplete(step),
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: Text(
                  isArabic ? 'وضع علامة مكتمل' : 'Mark Complete',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.greenAccent.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _markStepComplete(RoadmapStepModel step) {
    // Toggle step completion
    context.read<RoadmapCubit>().toggleStepCompletion(step.id);

    // Add points to gamification
    context.read<GamificationCubit>().addPoints(50); // 50 points per step

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Step completed! +50 XP', style: GoogleFonts.cairo()),
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Collapse the step after marking complete
    setState(() {
      expandedSteps.remove(step.id);
    });
  }
}
