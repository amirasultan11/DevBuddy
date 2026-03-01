import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class KidsGameState extends Equatable {
  const KidsGameState();
  @override
  List<Object> get props => [];
}

class GameInitial extends KidsGameState {
  final Point<int> playerPosition;
  final List<String> commands;

  const GameInitial(this.playerPosition, {this.commands = const []});

  @override
  List<Object> get props => [playerPosition, commands];
}

class GameRunning extends KidsGameState {
  final Point<int> playerPosition;
  final int activeCommandIndex;

  const GameRunning(this.playerPosition, this.activeCommandIndex);

  @override
  List<Object> get props => [playerPosition, activeCommandIndex];
}

class GameWon extends KidsGameState {
  final int xpEarned;
  const GameWon(this.xpEarned);
}

class GameLost extends KidsGameState {
  final String reason;
  const GameLost(this.reason);
}
