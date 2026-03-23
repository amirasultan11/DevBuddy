import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import '../cubit/gamification_cubit.dart';

class RoadmapScreen extends StatefulWidget {
  final String trackId;
  final String trackTitle;

  const RoadmapScreen({super.key, required this.trackId, required this.trackTitle});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  @override
  void initState() {
    super.initState();
    // بنطلب من الـ Cubit يحمل خطوات التراك ده تحديداً
    context.read<RoadmapCubit>().loadRoadmap(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
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
                    Expanded(
                      child: Text(
                        widget.trackTitle,
                        style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<RoadmapCubit, RoadmapState>(
                  builder: (context, state) {
                    if (state is RoadmapLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.indigoAccent));
                    }

                    if (state is RoadmapLoaded) {
                      final steps = state.steps;
                      
                      if (steps.isEmpty) {
                         return Center(
                           child: Text(
                             isArabic ? 'سيتم إضافة مهام قريباً' : 'Tasks coming soon',
                             style: GoogleFonts.cairo(color: Colors.white70),
                           ),
                         );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          final isLocked = step.isLocked;
                          final isCompleted = step.isCompleted;

                          return Opacity(
                            opacity: isLocked ? 0.5 : 1.0,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCompleted ? Colors.greenAccent : (isLocked ? Colors.white12 : Colors.indigoAccent),
                                  width: 1.5,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: isCompleted 
                                      ? Colors.greenAccent.withValues(alpha: 0.2) 
                                      : (isLocked ? Colors.white12 : Colors.indigoAccent.withValues(alpha: 0.2)),
                                  child: Icon(
                                    isCompleted ? Icons.check_rounded : (isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded),
                                    color: isCompleted ? Colors.greenAccent : (isLocked ? Colors.white54 : Colors.indigoAccent),
                                  ),
                                ),
                                title: Text(
                                  step.title,
                                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    step.description,
                                    style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70),
                                  ),
                                ),
                                trailing: isLocked 
                                  ? null 
                                  : ElevatedButton(
                                      onPressed: () {
                                        // تحديث حالة التاسك في الـ Roadmap
                                        context.read<RoadmapCubit>().toggleStepCompletion(step.id);
                                        // إضافة نقاط لليوزر في الـ Gamification
                                        if (!isCompleted) {
                                          context.read<GamificationCubit>().addPoints(step.pointsReward);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCompleted ? Colors.transparent : Colors.indigoAccent,
                                        elevation: isCompleted ? 0 : 2,
                                        side: isCompleted ? const BorderSide(color: Colors.greenAccent) : null,
                                      ),
                                      child: Text(
                                        isCompleted ? (isArabic ? 'مكتمل' : 'Done') : (isArabic ? 'إكمال' : 'Complete'),
                                        style: GoogleFonts.cairo(
                                          color: isCompleted ? Colors.greenAccent : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          );
                        },
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
}