import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/game_engine.dart';
import 'kids_game_state.dart';
import '../../../pro_mode/presentation/cubit/gamification_cubit.dart';

class KidsGameCubit extends Cubit<KidsGameState> {
  final GameEngine engine;
  final GamificationCubit gamificationCubit;
  final int level;
  
  final List<Direction> _commands = [];
  final List<String> _commandNames = []; // For UI display

  KidsGameCubit({
    required this.engine,
    required this.gamificationCubit,
    required this.level,
  }) : super(GameInitial(engine.playerPosition));

  void addCommand(Direction dir, String name) {
    if (state is GameRunning) return;
    if (_commands.length < 12) {
      _commands.add(dir);
      _commandNames.add(name);
      emit(GameInitial(engine.playerPosition, commands: List.from(_commandNames)));
    }
  }

  void removeLastCommand() {
    if (state is GameRunning) return;
    if (_commands.isNotEmpty) {
      _commands.removeLast();
      _commandNames.removeLast();
      emit(GameInitial(engine.playerPosition, commands: List.from(_commandNames)));
    }
  }

  void reset() {
    engine.playerPosition = const Point(0, 0); // Reset Engine
    _commands.clear();
    _commandNames.clear();
    emit(GameInitial(engine.playerPosition));
  }

  Future<void> runGame() async {
    if (_commands.isEmpty) return;

    for (int i = 0; i < _commands.length; i++) {
      if (isClosed) return;
      
      // 1. Update State to Running (UI updates player pos)
      engine.movePlayer(_commands[i]);
      emit(GameRunning(engine.playerPosition, i));
      
      // 2. Check Win/Loss
      if (engine.checkCollision()) {
        emit(const GameLost('Hit an obstacle!'));
        return;
      }
      
      if (engine.checkWin()) {
        // Unlock next level logic
        gamificationCubit.unlockKidsLevel(level + 1);
        gamificationCubit.addPoints(100); // Reward
        emit(const GameWon(100));
        return;
      }

      // 3. Delay for animation
      await Future.delayed(const Duration(milliseconds: 600));
    }
    
    // If commands finished and didn't win
    if (!engine.checkWin() && !engine.checkCollision()) {
      emit(const GameLost('Did not reach the goal. Try again!'));
    }
  }
}