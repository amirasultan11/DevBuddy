import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import 'personality_result_screen.dart';

class PersonalityTestScreen extends StatefulWidget {
  const PersonalityTestScreen({super.key});

  @override
  State<PersonalityTestScreen> createState() => _PersonalityTestScreenState();
}

class _PersonalityTestScreenState extends State<PersonalityTestScreen> {
  int _currentQuestionIndex = 0;
  int _eScore = 0, _sScore = 0, _tScore = 0, _jScore = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'questionEn': 'In a team setting, you prefer to...',
      'questionAr': 'في بيئة العمل، تفضل أن...',
      'option1En': 'Collaborate and brainstorm together (E)',
      'option1Ar': 'أتعاون ونعصف ذهنياً معاً',
      'option2En': 'Work independently on complex tasks (I)',
      'option2Ar': 'أعمل باستقلالية على المهام المعقدة',
      'type': 'E/I'
    },
    {
      'questionEn': 'When learning a new tool, you...',
      'questionAr': 'عند تعلم تقنية جديدة، أنت...',
      'option1En': 'Read the official documentation step-by-step (S)',
      'option1Ar': 'أقرأ التوثيق الرسمي خطوة بخطوة',
      'option2En': 'Watch tutorials and experiment intuitively (N)',
      'option2Ar': 'أجرب وأستكشف الصورة الكبيرة بحدسي',
      'type': 'S/N'
    },
    {
      'questionEn': 'How do you usually solve bugs?',
      'questionAr': 'كيف تحل المشاكل البرمجية (Bugs)؟',
      'option1En': 'Analyze logically using strict data (T)',
      'option1Ar': 'أحللها منطقياً بصرامة وبناءً على الداتا',
      'option2En': 'Focus on how it affects the user experience (F)',
      'option2Ar': 'أركز على تأثيرها على تجربة المستخدم',
      'type': 'T/F'
    },
    {
      'questionEn': 'When starting a new project, you...',
      'questionAr': 'عند بدء مشروع جديد، أنت...',
      'option1En': 'Plan the architecture and follow it strictly (J)',
      'option1Ar': 'أخطط للهيكلة وألتزم بالخطة بصرامة',
      'option2En': 'Dive right in and adapt as things change (P)',
      'option2Ar': 'أبدأ فوراً وأتكيف مع التغييرات بمرونة',
      'type': 'J/P'
    },
  ];

  void _answerQuestion(int optionIndex) {
    final type = _questions[_currentQuestionIndex]['type'];
    if (type == 'E/I') optionIndex == 1 ? _eScore++ : _eScore--;
    if (type == 'S/N') optionIndex == 1 ? _sScore++ : _sScore--;
    if (type == 'T/F') optionIndex == 1 ? _tScore++ : _tScore--;
    if (type == 'J/P') optionIndex == 1 ? _jScore++ : _jScore--;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      String result = '';
      result += _eScore >= 0 ? 'E' : 'I';
      result += _sScore >= 0 ? 'S' : 'N';
      result += _tScore >= 0 ? 'T' : 'F';
      result += _jScore >= 0 ? 'J' : 'P';

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PersonalityResultScreen(personalityType: result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';
    final currentQ = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purpleAccent.withValues(alpha: 0.2),
                      child: const Icon(Icons.psychology_rounded, color: Colors.purpleAccent),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        isArabic ? 'اكتشف شخصيتك البرمجية' : 'Discover Your Dev Persona',
                        style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  isArabic ? currentQ['questionAr'] : currentQ['questionEn'],
                  style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildChoiceButton(
                      isArabic ? currentQ['option1Ar'] : currentQ['option1En'],
                      Icons.analytics_rounded,
                      Colors.blueAccent,
                      () => _answerQuestion(1),
                    ),
                    const SizedBox(height: 16),
                    _buildChoiceButton(
                      isArabic ? currentQ['option2Ar'] : currentQ['option2En'],
                      Icons.lightbulb_rounded,
                      Colors.orangeAccent,
                      () => _answerQuestion(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}