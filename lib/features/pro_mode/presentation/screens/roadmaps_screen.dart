import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../cubit/roadmap_cubit.dart';
import '../cubit/roadmap_state.dart';
import 'roadmap_screen.dart';

class RoadmapsScreen extends StatefulWidget {
  const RoadmapsScreen({super.key});

  @override
  State<RoadmapsScreen> createState() => _RoadmapsScreenState();
}

class _RoadmapsScreenState extends State<RoadmapsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoadmapCubit>().loadTracks();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.transparent, // بيعتمد على الخلفية اللي وراه في الـ Stack
      appBar: AppBar(
        title: Text(
          isArabic ? 'المسارات التعليمية' : 'Learning Roadmaps',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<RoadmapCubit, RoadmapState>(
        builder: (context, state) {
          if (state is RoadmapLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.indigoAccent));
          }

          if (state is TracksLoaded) {
            final tracks = state.tracks;
            if (tracks.isEmpty) {
              return Center(
                child: Text(
                  isArabic ? 'لا توجد مسارات حالياً' : 'No roadmaps available.',
                  style: GoogleFonts.cairo(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
              physics: const BouncingScrollPhysics(),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoadmapScreen(trackId: track.id, trackTitle: track.title),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white.withValues(alpha: 0.05),
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.indigoAccent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.route_rounded, color: Colors.indigoAccent),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  track.title,
                                  style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            track.description,
                            style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70, height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
    );
  }
}