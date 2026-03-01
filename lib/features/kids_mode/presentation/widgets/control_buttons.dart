import 'package:flutter/material.dart';
import '../../logic/game_engine.dart'; // Import Direction enum

class ControlButtons extends StatelessWidget {
  final bool isRunning;
  final Function(Direction, String) onCommand;
  final VoidCallback onRun;
  final VoidCallback onReset;
  final VoidCallback onBackspace;

  const ControlButtons({
    super.key,
    required this.isRunning,
    required this.onCommand,
    required this.onRun,
    required this.onReset,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Direction Arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBtn(
              Icons.arrow_back_rounded,
              Colors.red,
              Direction.left,
              'LEFT',
            ),
            Column(
              children: [
                _buildBtn(
                  Icons.arrow_upward_rounded,
                  Colors.orange,
                  Direction.up,
                  'UP',
                ),
                const SizedBox(height: 10),
                _buildBtn(
                  Icons.arrow_downward_rounded,
                  Colors.blue,
                  Direction.down,
                  'DOWN',
                ),
              ],
            ),
            _buildBtn(
              Icons.arrow_forward_rounded,
              Colors.green,
              Direction.right,
              'RIGHT',
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: isRunning ? null : onReset,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: isRunning ? null : onRun,
              icon: const Icon(Icons.play_arrow),
              label: const Text('RUN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: isRunning ? null : onBackspace,
              icon: const Icon(
                Icons.backspace,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBtn(IconData icon, Color color, Direction dir, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: isRunning ? null : () => onCommand(dir, name),
        child: Opacity(
          opacity: isRunning ? 0.5 : 1.0,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
        ),
      ),
    );
  }
}
