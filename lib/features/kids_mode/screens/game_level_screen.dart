import 'dart:math';
import 'package:dev_buddy/features/kids_mode/logic/game_engine.dart';
import 'package:dev_buddy/features/kids_mode/presentation/cubit/kids_game_cubit.dart';
import 'package:dev_buddy/features/kids_mode/presentation/cubit/kids_game_state.dart';
import 'package:dev_buddy/features/kids_mode/presentation/widgets/control_buttons.dart';
import 'package:dev_buddy/features/pro_mode/presentation/cubit/gamification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

class GameLevelScreen extends StatefulWidget {
  final int level;
  const GameLevelScreen({super.key, required this.level});

  @override
  State<GameLevelScreen> createState() => _GameLevelScreenState();
}

class _GameLevelScreenState extends State<GameLevelScreen> {
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String name) async {
    await _audioPlayer.play(AssetSource('sounds/$name.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KidsGameCubit(
        engine: GameEngine.fromLevel(widget.level),
        gamificationCubit: context.read<GamificationCubit>(),
        level: widget.level,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: BlocConsumer<KidsGameCubit, KidsGameState>(
          listener: (context, state) {
            if (state is GameRunning) {
              _playSound('move');
            } else if (state is GameWon) {
              _playSound('win');
              _confettiController.play();
              _showDialog(context, 'You Win! 🎉', 'Next Level', true);
            } else if (state is GameLost) {
              _playSound('fail');
              _showDialog(context, 'Try Again 😅', 'Retry', false);
            }
          },
          builder: (context, state) {
            final cubit = context.read<KidsGameCubit>();
            Point<int> playerPos = const Point(0, 0);
            List<String> commands = [];

            if (state is GameInitial) {
              playerPos = state.playerPosition;
              commands = state.commands;
            } else if (state is GameRunning) {
              playerPos = state.playerPosition;
            }

            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                ),
                Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Level ${widget.level}',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Command Bar
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: commands
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Chip(label: Text(c)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // Game Grid - Force LTR for game logic consistency
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final cellSize = constraints.maxWidth / 4;
                                  final engine = cubit.engine;
                                  return Stack(
                                    children: [
                                      // Goal
                                      Positioned(
                                        left: engine.goalPosition.x * cellSize,
                                        top: engine.goalPosition.y * cellSize,
                                        width: cellSize,
                                        height: cellSize,
                                        child: const Center(
                                          child: Text(
                                            '⭐',
                                            style: TextStyle(fontSize: 40),
                                          ),
                                        ),
                                      ),
                                      // Obstacles
                                      ...engine.obstacles.map(
                                        (obs) => Positioned(
                                          left: obs.x * cellSize,
                                          top: obs.y * cellSize,
                                          width: cellSize,
                                          height: cellSize,
                                          child: const Center(
                                            child: Text(
                                              '🪨',
                                              style: TextStyle(fontSize: 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Player (Animated)
                                      AnimatedPositioned(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        left: playerPos.x * cellSize,
                                        top: playerPos.y * cellSize,
                                        width: cellSize,
                                        height: cellSize,
                                        child: const Center(
                                          child: Text(
                                            '🦸‍♂️',
                                            style: TextStyle(fontSize: 40),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Controls - Force LTR for directional consistency
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: ControlButtons(
                        isRunning: state is GameRunning,
                        onCommand: cubit.addCommand,
                        onRun: cubit.runGame,
                        onReset: cubit.reset,
                        onBackspace: cubit.removeLastCommand,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDialog(
    BuildContext context,
    String title,
    String btnText,
    bool isWin,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              if (isWin) {
                Navigator.pop(context); // Go back to map
              } else {
                context.read<KidsGameCubit>().reset();
              }
            },
            child: Text(
              btnText,
              style: const TextStyle(color: Colors.cyan, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
