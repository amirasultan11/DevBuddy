import 'dart:math';

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class GameLevel {
  final Point startPos;
  final Point goalPos;
  final List<Point> obstacles;

  const GameLevel({
    required this.startPos,
    required this.goalPos,
    required this.obstacles,
  });

  /// Get level configuration based on level number
  static GameLevel getLevel(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return const GameLevel(
          startPos: Point(0, 0),
          goalPos: Point(3, 3),
          obstacles: [Point(1, 1)],
        );
      case 2:
        // Maze level!
        return const GameLevel(
          startPos: Point(0, 0),
          goalPos: Point(0, 3),
          obstacles: [Point(1, 1), Point(2, 1), Point(2, 2)],
        );
      default:
        // Level 3+: Generate random obstacles
        return _generateRandomLevel(levelNumber);
    }
  }

  /// Generate a random level with simple obstacles
  static GameLevel _generateRandomLevel(int levelNumber) {
    final random = Random(levelNumber); // Use level as seed for consistency
    final obstacles = <Point>[];

    // Generate 2-5 random obstacles based on level
    final obstacleCount = 2 + (levelNumber % 4);

    while (obstacles.length < obstacleCount) {
      final x = random.nextInt(4);
      final y = random.nextInt(4);
      final point = Point(x, y);

      // Don't place obstacles at start or goal positions
      if (point != const Point(0, 0) &&
          point != const Point(3, 3) &&
          !obstacles.contains(point)) {
        obstacles.add(point);
      }
    }

    return GameLevel(
      startPos: const Point(0, 0),
      goalPos: const Point(3, 3),
      obstacles: obstacles,
    );
  }
}
