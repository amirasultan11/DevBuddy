import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// ─────────────────────────────────────────────────────────────────────────────
// API key is injected at build time via:
//   flutter run --dart-define=GEMINI_API_KEY=your_key_here
// Never hardcode the real key here — this file is public on GitHub.
// ─────────────────────────────────────────────────────────────────────────────
const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '', // Empty → shows user-friendly error, never crashes
);

/// AIRoadmapScreen — the core value proposition of DevBuddy.
///
/// Takes a topic + skill level from the user, sends a structured prompt to
/// the Gemini Flash model, and renders a 5-step learning roadmap from the
/// JSON response.
class AIRoadmapScreen extends StatefulWidget {
  const AIRoadmapScreen({super.key});

  @override
  State<AIRoadmapScreen> createState() => _AIRoadmapScreenState();
}

class _AIRoadmapScreenState extends State<AIRoadmapScreen> {
  // ── State ──────────────────────────────────────────────────────────────────

  final TextEditingController _topicController = TextEditingController();
  String _selectedLevel = 'Beginner';
  bool _isLoading = false;
  List<Map<String, String>>? _generatedRoadmap;

  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];

  // ── Gemini Model ───────────────────────────────────────────────────────────

  /// Lazy-initialise the model once; avoids creating a new instance per call.
  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      // Keep response deterministic and concise
      temperature: 0.7,
      maxOutputTokens: 1024,
    ),
  );

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  // ── Core Logic ─────────────────────────────────────────────────────────────

  /// Builds the prompt instructing Gemini to return ONLY a raw JSON array.
  String _buildPrompt(String topic, String level) {
    return '''
You are an expert tech mentor and curriculum designer.
The user wants to learn "$topic" at a "$level" level.

Generate a concise 5-step learning roadmap.

STRICT RULES — you MUST follow all of them:
1. Respond with ONLY a valid JSON array. No markdown code fences, no ```json tags, no explanations, no extra text.
2. The array must contain exactly 5 objects.
3. Each object must have exactly two string keys:
   - "title": a short, clear step title (max 8 words)
   - "action": a specific, actionable instruction for this step (1-2 sentences)

Example of the ONLY acceptable format:
[{"title":"Learn the Basics","action":"Read the official documentation and follow the getting-started tutorial."},{"title":"...","action":"..."}]
''';
  }

  /// Strips any markdown code-fence wrappers that LLMs sometimes add despite
  /// being instructed not to. Handles both ```json ... ``` and ``` ... ```.
  String _stripMarkdownFences(String raw) {
    // Remove opening fence: ```json or ```
    var cleaned = raw.replaceAll(RegExp(r'^```(?:json)?\s*', multiLine: true), '');
    // Remove closing fence
    cleaned = cleaned.replaceAll(RegExp(r'```\s*$', multiLine: true), '');
    return cleaned.trim();
  }

  /// Parses the JSON array from the model response into the typed list.
  ///
  /// Returns null and shows a SnackBar if parsing fails.
  List<Map<String, String>>? _parseResponse(String rawText) {
    final cleaned = _stripMarkdownFences(rawText);

    final decoded = jsonDecode(cleaned);

    if (decoded is! List) {
      throw const FormatException('Expected a JSON array at the root level.');
    }

    return decoded.map<Map<String, String>>((item) {
      if (item is! Map) {
        throw const FormatException('Each roadmap item must be a JSON object.');
      }
      final title = item['title'];
      final action = item['action'];
      if (title == null || action == null) {
        throw const FormatException(
            'Each roadmap object must have "title" and "action" keys.');
      }
      return {
        'title': title.toString(),
        'action': action.toString(),
      };
    }).toList();
  }

  /// Main generation method — replaces the fake `Future.delayed` mock.
  Future<void> _generateRoadmap() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      _showError('Please enter a topic first.');
      return;
    }

    // Guard: don't allow concurrent requests
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _generatedRoadmap = null; // Clear previous results
    });

    try {
      // ── 1. Build the prompt ────────────────────────────────────────────────
      final prompt = _buildPrompt(topic, _selectedLevel);

      // ── 2. Call Gemini Flash ───────────────────────────────────────────────
      final response = await _model.generateContent([Content.text(prompt)]);

      final rawText = response.text;

      if (rawText == null || rawText.isEmpty) {
        throw Exception('The AI returned an empty response. Please try again.');
      }

      // ── 3. Parse the JSON array ────────────────────────────────────────────
      final roadmap = _parseResponse(rawText);

      if (roadmap == null || roadmap.isEmpty) {
        throw Exception('Could not parse the AI response. Please try again.');
      }

      // ── 4. Update UI ───────────────────────────────────────────────────────
      if (mounted) {
        setState(() {
          _generatedRoadmap = roadmap;
          _isLoading = false;
        });
      }
    } on GenerativeAIException catch (e) {
      // Firebase / API-level errors (invalid key, quota exceeded, etc.)
      _handleError('AI service error: ${e.message}');
    } on FormatException catch (e) {
      // JSON parsing errors
      _handleError('Could not parse the AI response: ${e.message}');
    } catch (e) {
      // Network errors, unexpected exceptions
      _handleError('Something went wrong. Please check your connection and try again.');
    }
  }

  /// Resets loading state and shows a user-friendly error SnackBar.
  /// Using a single method guarantees the spinner never gets stuck.
  void _handleError(String message) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showError(message);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Learning Path ✨',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputSection(),
                const SizedBox(height: 24),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isLoading
                        ? _buildLoadingState()
                        : _generatedRoadmap == null
                            ? _buildEmptyState()
                            : _buildRoadmapList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Input Section ──────────────────────────────────────────────────────────

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
            // Disable input while loading to prevent duplicate requests
            enabled: !_isLoading,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _generateRoadmap(),
            decoration: InputDecoration(
              hintText: 'e.g. Flutter, Python, System Design',
              hintStyle: GoogleFonts.cairo(color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.indigoAccent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // ── Level Dropdown ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Level',
                      style:
                          GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLevel,
                          dropdownColor: const Color(0xFF1E293B),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                          style: GoogleFonts.cairo(color: Colors.white),
                          items: _levels.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: _isLoading
                              ? null // Lock dropdown during loading
                              : (newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      _selectedLevel = newValue;
                                    }
                                  });
                                },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // ── Generate Button ────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: ElevatedButton.icon(
                    // null disables and shows disabled styling automatically
                    onPressed: _isLoading ? null : _generateRoadmap,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.auto_awesome, size: 16),
                    label: Text(
                      _isLoading ? 'Thinking...' : 'Generate',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      disabledBackgroundColor:
                          Colors.indigoAccent.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  // ── State Widgets ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'Your personalised roadmap\nwill appear here',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white30,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by Gemini ✨',
            style: GoogleFonts.cairo(
              color: Colors.indigoAccent.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing AI glow indicator
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.6, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigoAccent.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: Colors.indigoAccent,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Consulting Gemini...',
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Building your personalised roadmap',
            style: GoogleFonts.cairo(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Roadmap List ───────────────────────────────────────────────────────────

  Widget _buildRoadmapList() {
    return Column(
      key: const ValueKey('results'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Results Header ─────────────────────────────────────────────────
        Row(
          children: [
            const Icon(Icons.route_rounded,
                color: Colors.indigoAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Your $_selectedLevel Roadmap for "${_topicController.text.trim()}"',
              style: GoogleFonts.cairo(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Step Cards ─────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _generatedRoadmap!.length,
            itemBuilder: (context, index) =>
                _buildStepCard(_generatedRoadmap![index], index),
          ),
        ),

        // ── Regenerate Button ──────────────────────────────────────────────
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: _generateRoadmap,
            icon: const Icon(Icons.refresh_rounded,
                color: Colors.white38, size: 16),
            label: Text(
              'Regenerate',
              style: GoogleFonts.cairo(color: Colors.white38, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(Map<String, String> step, int index) {
    return Container(
      key: ValueKey('step_$index'),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Subtle gradient that gets slightly more visible per step
        color: Colors.white.withValues(alpha: 0.05 + (index * 0.005)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.indigoAccent.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigoAccent.withValues(alpha: 0.4),
                  Colors.blueAccent.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.indigoAccent.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step['action'] ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
