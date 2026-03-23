import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_card.dart';
import 'roadmaps_screen.dart'; // مسار الشاشة اللي هيروح لها

class AiGeneratorScreen extends StatefulWidget {
  const AiGeneratorScreen({super.key});

  @override
  State<AiGeneratorScreen> createState() => _AiGeneratorScreenState();
}

class _AiGeneratorScreenState extends State<AiGeneratorScreen> {
  String _selectedLevel = 'Beginner';
  String _targetGoal = '';
  bool _isLoading = false;

  final List<String> _levelsEn = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _levelsAr = ['مبتدئ', 'متوسط', 'متقدم'];

  void _generateRoadmap(bool isArabic) {
    if (_targetGoal.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'أدخل هدفك أولاً!' : 'Please enter your goal!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate AI generation time
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // التوجيه الفعلي للـ Roadmap بدل الـ SnackBar بس
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoadmapsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final levels = isArabic ? _levelsAr : _levelsEn;

    return Scaffold(
      // Transparent so AppBackground's radial gradient renders fully,
      // consistent with all other pro_mode screens.
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
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _generateRoadmap(isArabic),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  isArabic ? 'توليد المسار بالذكاء الاصطناعي 🚀' : 'Generate AI Roadmap 🚀',
                                  style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }
}