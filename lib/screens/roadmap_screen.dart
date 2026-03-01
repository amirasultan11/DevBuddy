import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIRoadmapScreen extends StatefulWidget {
  const AIRoadmapScreen({super.key});

  @override
  State<AIRoadmapScreen> createState() => _AIRoadmapScreenState();
}

class _AIRoadmapScreenState extends State<AIRoadmapScreen> {
  final TextEditingController _topicController = TextEditingController();
  String _selectedLevel = 'Beginner';
  bool _isLoading = false;
  List<Map<String, String>>? _generatedRoadmap;

  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];

  Future<void> _generateRoadmap() async {
    if (_topicController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Mock API Delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock Data Response
    final topic = _topicController.text;
    setState(() {
      _generatedRoadmap = [
        {
          'title': 'Understand the Basics of $topic',
          'action':
              'Ask ChatGPT to explain the core concepts of $topic and why it is used.',
        },
        {
          'title': 'Setup Environment',
          'action':
              'Ask Gemini for the best installation guide for $topic on Windows/Mac.',
        },
        {
          'title': 'Build a Hello World',
          'action':
              'Prompt AI: "Write a simple Hello World program in $topic".',
        },
        {
          'title': 'Core Syntax & Logic',
          'action':
              'Use ChatGPT to generate exercises for loops, variables, and functions in $topic.',
        },
        {
          'title': 'Mini Project: To-Do App',
          'action':
              'Ask Gemini to guide you through building a CLI To-Do app with $topic.',
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Learning Path',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1E293B), Color(0xFF020617)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputSection(),
                const SizedBox(height: 24),
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState()
                      : _generatedRoadmap == null
                      ? _buildEmptyState()
                      : _buildRoadmapList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you want to learn?',
            style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _topicController,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Flutter, Python, React',
              hintStyle: GoogleFonts.cairo(color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Level',
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLevel,
                          dropdownColor: const Color(0xFF1E293B),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: GoogleFonts.cairo(color: Colors.white),
                          items: _levels.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != null) _selectedLevel = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: ElevatedButton(
                    onPressed: _generateRoadmap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Generate',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 60,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Unlock your potential with various AI tools',
            style: GoogleFonts.cairo(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.indigoAccent),
          const SizedBox(height: 16),
          Text(
            'Consulting AI Models...',
            style: GoogleFonts.cairo(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _generatedRoadmap!.length,
      itemBuilder: (context, index) {
        final step = _generatedRoadmap![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.cairo(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title']!,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['action']!,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
