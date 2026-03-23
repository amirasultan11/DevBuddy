import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';

class MathLogicScreen extends StatelessWidget {
  const MathLogicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isArabic),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text(
                      isArabic ? 'تأسيس التفكير البرمجي' : 'Computational Thinking',
                      style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic 
                          ? 'البرمجة مش مجرد كتابة كود، هي طريقة تفكير لحل المشاكل. ابدأ من هنا.' 
                          : 'Coding is not just typing; it is problem solving. Start here.',
                      style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    
                    _buildModuleCard(
                      title: isArabic ? 'الخوارزميات في حياتنا' : 'Algorithms in Daily Life',
                      description: isArabic ? 'إزاي بتعمل كوباية شاي؟ دي خوارزمية! اتعلم تحول أفكارك لخطوات منطقية.' : 'How do you make tea? That is an algorithm! Learn step-by-step logic.',
                      icon: Icons.account_tree_rounded,
                      color: Colors.amberAccent,
                      progress: 1.0, // Completed
                    ),
                    const SizedBox(height: 16),
                    _buildModuleCard(
                      title: isArabic ? 'تفكيك المشاكل المعقدة' : 'Problem Decomposition',
                      description: isArabic ? 'إزاي تاخد مشكلة كبيرة وتقسمها لمشاكل صغيرة سهلة الحل.' : 'Break down large, scary problems into small, manageable tasks.',
                      icon: Icons.dashboard_customize_rounded,
                      color: Colors.purpleAccent,
                      progress: 0.3, // In progress
                    ),
                    const SizedBox(height: 16),
                    _buildModuleCard(
                      title: isArabic ? 'مهارة البحث (Googling)' : 'Googling like a Pro',
                      description: isArabic ? 'أهم مهارة للمبرمج. إزاي تسأل جوجل صح وتلاقي حل للـ Bugs.' : 'The most important dev skill. How to search effectively for bug fixes.',
                      icon: Icons.search_rounded,
                      color: Colors.cyanAccent,
                      progress: 0.0, // Locked
                      isLocked: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            isArabic ? 'ما قبل البرمجة' : 'Pre-Programming',
            style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required double progress,
    bool isLocked = false,
  }) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: GlassCard(
        blurSigma: 10,
        radius: 20,
        padding: const EdgeInsets.all(20),
        borderColor: isLocked ? Colors.white12 : color.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(isLocked ? Icons.lock_rounded : icon, color: isLocked ? Colors.white54 : color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (!isLocked)
                  Icon(progress == 1.0 ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded, 
                       color: progress == 1.0 ? Colors.greenAccent : color, size: 32),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70, height: 1.4),
            ),
            if (!isLocked) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0 ? Colors.greenAccent : color),
                borderRadius: BorderRadius.circular(4),
              ),
            ]
          ],
        ),
      ),
    );
  }
}