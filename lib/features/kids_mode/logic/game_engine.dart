import 'dart:math';

enum Direction { up, down, left, right }

class GameEngine {
  final int gridSize;
  Point<int> playerPosition;
  final Point<int> goalPosition;
  final List<Point<int>> obstacles;

  GameEngine({
    this.gridSize = 4,
    required this.playerPosition,
    required this.goalPosition,
    required this.obstacles,
  });

  // Factory to create levels configuration
  factory GameEngine.fromLevel(int level) {
    switch (level) {
      case 1:
        return GameEngine(
          playerPosition: const Point(0, 0),
          goalPosition: const Point(3, 3),
          obstacles: [const Point(1, 1)],
        );
      case 2:
        return GameEngine(
          playerPosition: const Point(0, 0),
          goalPosition: const Point(0, 3),
          obstacles: [const Point(1, 1), const Point(2, 1), const Point(2, 2)],
        );
      default:
        // Random generator for higher levels
        return _generateRandomLevel(level);
    }
  }

  static GameEngine _generateRandomLevel(int level) {
    final random = Random(level);
    final obstacles = <Point<int>>[];
    final count = 2 + (level % 4);
    
    while (obstacles.length < count) {
      final p = Point(random.nextInt(4), random.nextInt(4));
      if (p != const Point(0, 0) && p != const Point(3, 3) && !obstacles.contains(p)) {
        obstacles.add(p);
      }
    }
    return GameEngine(
      playerPosition: const Point(0, 0),
      goalPosition: const Point(3, 3),
      obstacles: obstacles,
    );
  }

  // Returns true if move is valid (inside bounds and not obstacle)
  bool isValidMove(Point<int> nextPos) {
    if (nextPos.x < 0 || nextPos.x >= gridSize || nextPos.y < 0 || nextPos.y >= gridSize) {
      return false; // Out of bounds
    }
    if (obstacles.contains(nextPos)) {
      return false; // Hit obstacle
    }
    return true;
  }

  // Moves player and returns true if hit obstacle (Game Over condition check)
  bool movePlayer(Direction direction) {
    int dx = 0;
    int dy = 0;
    switch (direction) {
      case Direction.up: dy = -1; break;
      case Direction.down: dy = 1; break;
      case Direction.left: dx = -1; break;
      case Direction.right: dx = 1; break;
    }

    final nextPos = Point(playerPosition.x + dx, playerPosition.y + dy);
    
    // Logic: We allow the move, but check result in Cubit
    // If out of bounds -> Stay in place
    if (nextPos.x < 0 || nextPos.x >= gridSize || nextPos.y < 0 || nextPos.y >= gridSize) {
      return false; 
    }
    
    // Update position
    playerPosition = nextPos;
    return true; 
  }

  bool checkWin() => playerPosition == goalPosition;
  bool checkCollision() => obstacles.contains(playerPosition);
}