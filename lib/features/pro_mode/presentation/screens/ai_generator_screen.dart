import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import 'roadmap_screen.dart' as ai_roadmap;

class AiGeneratorScreen extends StatefulWidget {
  const AiGeneratorScreen({super.key});

  @override
  State<AiGeneratorScreen> createState() => _AiGeneratorScreenState();
}

class _AiGeneratorScreenState extends State<AiGeneratorScreen> {
  String _selectedLevel = 'Beginner';
  String _targetGoal = '';

  final List<String> _levelsEn = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _levelsAr = ['مبتدئ', 'متوسط', 'متقدم'];

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final levels = isArabic ? _levelsAr : _levelsEn;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? 'مستشارك الذكي' : 'AI Consultant',
                      style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stairs_rounded, color: Colors.cyanAccent, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            isArabic ? 'مستواك الحالي' : 'Current Level',
                            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: levels.map((level) {
                          final isSelected = _selectedLevel == level || _levelsEn.indexOf(_selectedLevel) == levels.indexOf(level);
                          return ChoiceChip(
                            label: Text(level, style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                            selected: isSelected,
                            selectedColor: Colors.indigoAccent.withValues(alpha: 0.8),
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                            side: BorderSide(color: isSelected ? Colors.indigoAccent : Colors.white24),
                            onSelected: (s) { if (s) setState(() => _selectedLevel = level); },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const Icon(Icons.flag_rounded, color: Colors.cyanAccent, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            isArabic ? 'هدفك إيه؟' : 'What is your goal?',
                            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GlassCard(
                        blurSigma: 10,
                        radius: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        borderColor: Colors.white24,
                        child: TextField(
                          style: GoogleFonts.cairo(color: Colors.white),
                          maxLines: 3,
                          onChanged: (val) => _targetGoal = val,
                          decoration: InputDecoration(
                            hintText: isArabic ? 'مثال: عايز أبقى مطور فلاتر شاطر وأعمل تطبيقات...' : 'e.g. I want to be a solid Flutter dev...',
                            hintStyle: GoogleFonts.cairo(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // ── Generate Button: driven by RoadmapCubit state ──────
                      BlocConsumer<RoadmapCubit, RoadmapState>(
                        listener: (context, state) {
                          if (state is RoadmapError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message, style: GoogleFonts.cairo(color: Colors.white)),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (state is RoadmapLoaded && state.trackId == 'ai_generated') {
                            // Navigate to the generated roadmap.
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => ai_roadmap.RoadmapScreen(
                                  trackId: state.trackId,
                                  trackTitle: isArabic ? 'مسارك المُولَّد بالذكاء الاصطناعي' : 'Your AI-Generated Roadmap',
                                ),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isGenerating = state is RoadmapLoading;
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              // Disabled while the cubit is loading.
                              onPressed: isGenerating ? null : () {
                                if (_targetGoal.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isArabic ? 'أدخل هدفك أولاً!' : 'Please enter your goal!',
                                        style: GoogleFonts.cairo(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                context.read<RoadmapCubit>().generateAiRoadmap(
                                  goal: _targetGoal.trim(),
                                  level: _selectedLevel,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                                disabledBackgroundColor: Colors.indigoAccent.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: isGenerating
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      isArabic ? 'توليد المسار بالذكاء الاصطناعي 🚀' : 'Generate AI Roadmap 🚀',
                                      style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}