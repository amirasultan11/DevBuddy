import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/theme/locale_provider.dart';
import 'ai_generator_screen.dart';

/// StageTasksScreen — The core learning area
/// Displays different types of challenges fetched from Firestore.
class StageTasksScreen extends StatefulWidget {
  const StageTasksScreen({super.key});

  @override
  State<StageTasksScreen> createState() => _StageTasksScreenState();
}

class _StageTasksScreenState extends State<StageTasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // CRITICAL: Prevent screenshots for this secure content screen
    ScreenProtector.preventScreenshotOn();
  }

  @override
  void dispose() {
    // Re-enable screenshots when leaving
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      // Transparent so the global professionalTheme background shows through.
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              // RTL-aware back arrow.
              icon: Icon(
                isArabic ? Icons.arrow_forward : Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isArabic ? 'مهام المرحلة' : 'Stage Missions',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getStageTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Error loading tasks.',
                        style: GoogleFonts.cairo(color: Colors.redAccent),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.indigoAccent),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No missions available yet.',
                        style: GoogleFonts.cairo(color: Colors.white70),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final doc = docs[index];
                      // CRITICAL: Safe Parsing to avoid type cast errors
                      final data = Map<String, dynamic>.from(doc.data() as Map);

                      final taskType = data['task_type'] ?? 'classic';

                      // Pass the inner builder context so card methods can read providers.
                      switch (taskType) {
                        case 'ai_boosted':
                          return _buildAIBoostedCard(context, data);
                        case 'ai_review':
                          return _buildAIReviewCard(context, data);
                        case 'classic':
                        default:
                          return _buildClassicCard(context, data);
                      }
                    },
                    childCount: docs.length,
                  ),
                );
              },
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ─── Task Card Builders ──────────────────────────────────────────────────

  /// 1. Classic Challenge Card
  Widget _buildClassicCard(BuildContext context, Map<String, dynamic> data) {
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';
    final String title = data['title'] ?? 'Classic Challenge';
    final String description = data['description'] ?? 'Solve this problem manually to build your core logic skills.';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Darker slate
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Strict Badge: AI Disabled
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.block, size: 12, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(
                      'AI Disabled',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? 'بيئة البرمجة قادمة قريباً 🚀' : 'Coding Workspace coming soon! 🚀',
                      style: GoogleFonts.cairo(color: Colors.white),
                    ),
                    backgroundColor: Colors.indigoAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Start Coding',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. AI Boosted (Productivity) Card
  Widget _buildAIBoostedCard(BuildContext context, Map<String, dynamic> data) {
    final String title = data['title'] ?? 'Productivity Sprint';
    final String description = data['description'] ?? 'Use AI tools to complete this objective faster.';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // Glowing / gradient border effect wrapper
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)], // Purple to Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2), // Acts as border width
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Inner background matching scaffold
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // AI Co-pilot Allowed Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, size: 14, color: Colors.amberAccent),
                      const SizedBox(width: 4),
                      Text(
                        'AI Co-pilot Allowed',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Gradient Button for AI Task
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Purple to Indigo
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiGeneratorScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Solve with AI',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Code Review Terminal Card
  Widget _buildAIReviewCard(BuildContext context, Map<String, dynamic> data) {
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';
    // The user explicitly asked for "Find the AI Bugs" title.
    final String title = data['title'] ?? 'Find the AI Bugs';
    final String description = data['description'] ?? 'Review this autogenerated snippet and spot the logical flaws.';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617), // Extremely dark, terminal-like background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mac-style Terminal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                _buildMacDot(Colors.redAccent),
                const SizedBox(width: 6),
                _buildMacDot(Colors.amber),
                const SizedBox(width: 6),
                _buildMacDot(Colors.green),
                const SizedBox(width: 12),
                Text(
                  'bash — code_review.sh',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 11,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          
          // Terminal Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // tealAccent has better contrast than greenAccent on near-black backgrounds.
                    color: Colors.tealAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '> $description',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic ? 'نظام المراجعة بالذكاء الاصطناعي قيد الإنشاء.' : 'AI Review system is under construction.',
                            style: GoogleFonts.cairo(color: Colors.white),
                          ),
                          backgroundColor: Colors.teal,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      // Border updated to match the new tealAccent title color.
                      side: const BorderSide(color: Colors.tealAccent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isArabic ? 'إرسال المراجعة' : 'Submit Review',
                      style: GoogleFonts.sourceCodePro(
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
