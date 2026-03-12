import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/dummy_data_source.dart';
import '../../data/models/track_model.dart';
import '../../data/models/roadmap_step_model.dart';
import 'roadmap_state.dart';

/// Cubit for managing Tracks and Roadmap Steps with local Hive persistence.
///
/// Every mutation ([toggleStepCompletion], [unlockNextStep], [updateStepProgress])
/// immediately serialises the updated step list to Hive under the [trackId] key,
/// so progress survives app restarts without any network round-trip.
///
/// Storage format inside 'roadmaps_box':
///   key   → trackId (String)
///   value → List&lt;Map&lt;String, dynamic&gt;&gt;  (each element is a RoadmapStepModel.toJson())
class RoadmapCubit extends Cubit<RoadmapState> {
  /// The dedicated Hive box for roadmap persistence.
  /// Opened once in main.dart and injected here for testability.
  final Box _box;

  RoadmapCubit({required Box box})
      : _box = box,
        super(const RoadmapInitial());

  // ── Private Helpers ────────────────────────────────────────────────────────

  /// Serialise the current step list to Hive.
  ///
  /// Called after every mutation. Failures are caught and logged to prevent
  /// a Hive error from crashing the UI — the in-memory state is still valid.
  void _saveToHive(String trackId, List<RoadmapStepModel> steps) {
    try {
      // Convert each step to a plain Map so Hive can store it without
      // needing a registered TypeAdapter.
      final encoded = steps.map((s) => s.toJson()).toList();
      _box.put(trackId, encoded);
    } catch (e) {
      // Non-fatal: in-memory state is already correct; only persistence failed.
      // In a production app this would be sent to a crash reporter.
      assert(false, '[RoadmapCubit] Failed to persist to Hive: $e');
    }
  }

  /// Read and deserialise a saved step list from Hive for [trackId].
  /// Returns null if no saved data exists yet.
  List<RoadmapStepModel>? _loadFromHive(String trackId) {
    try {
      final raw = _box.get(trackId);
      if (raw == null) return null;

      // Hive stores the list as a List<dynamic> where each element is a
      // Map<dynamic, dynamic>. We need to cast each entry to
      // Map<String, dynamic> before calling fromJson.
      final list = (raw as List)
          .map((e) => RoadmapStepModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      return list;
    } catch (e) {
      // Corrupted or incompatible data — fall back to fresh data from source.
      assert(false, '[RoadmapCubit] Failed to read from Hive, using fallback: $e');
      return null;
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Load all available tracks from the data source.
  Future<void> loadTracks() async {
    try {
      emit(const RoadmapLoading());

      // Simulate a brief network delay for realistic UX
      await Future.delayed(const Duration(milliseconds: 800));

      final tracks = DummyDataSource.getTracks();

      if (tracks.isEmpty) {
        emit(const RoadmapError('No tracks available'));
        return;
      }

      emit(TracksLoaded(tracks));
    } catch (e) {
      emit(RoadmapError('Failed to load tracks: ${e.toString()}'));
    }
  }

  /// Load roadmap steps for [trackId].
  ///
  /// Strategy:
  /// 1. Check Hive for previously saved progress.
  /// 2. If found → emit the saved steps (progress is preserved! ✅).
  /// 3. If not found → fetch fresh data from [DummyDataSource], save it to
  ///    Hive as the initial baseline, then emit.
  Future<void> loadRoadmap(String trackId) async {
    try {
      emit(const RoadmapLoading());

      // ── Step 1: Try reading saved progress from Hive ──────────────────────
      final savedSteps = _loadFromHive(trackId);

      if (savedSteps != null && savedSteps.isNotEmpty) {
        // Saved data found — restore progress directly from Hive.
        emit(RoadmapLoaded(trackId: trackId, steps: savedSteps));
        return;
      }

      // ── Step 2: No saved data — load fresh data from DummyDataSource ─────
      // Brief delay to simulate a data fetch
      await Future.delayed(const Duration(milliseconds: 600));

      final freshSteps = DummyDataSource.getRoadmapByTrackId(trackId);

      if (freshSteps.isEmpty) {
        emit(const RoadmapError('No roadmap steps available for this track'));
        return;
      }

      // ── Step 3: Persist the initial state to Hive ─────────────────────────
      // This seeds the Hive box so future restarts restore from here.
      _saveToHive(trackId, freshSteps);

      emit(RoadmapLoaded(trackId: trackId, steps: freshSteps));
    } catch (e) {
      emit(RoadmapError('Failed to load roadmap: ${e.toString()}'));
    }
  }

  /// Toggle the completion status of a step.
  ///
  /// After updating the in-memory state, the new step list is persisted to
  /// Hive so progress is not lost on app restart.
  void toggleStepCompletion(String stepId) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) {
      emit(const RoadmapError(
          'Cannot toggle step completion: Roadmap not loaded'));
      return;
    }

    try {
      final stepIndex =
          currentState.steps.indexWhere((s) => s.id == stepId);

      if (stepIndex == -1) {
        emit(const RoadmapError('Step not found'));
        return;
      }

      final step = currentState.steps[stepIndex];

      if (step.isLocked) {
        emit(const RoadmapError('Cannot complete a locked step'));
        return;
      }

      final updatedStep = step.copyWith(
        isCompleted: !step.isCompleted,
        completionPercentage: !step.isCompleted ? 100 : 0,
      );

      final updatedSteps =
          List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[stepIndex] = updatedStep;

      // ── Emit updated state ─────────────────────────────────────────────────
      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));

      // ── Persist to Hive ────────────────────────────────────────────────────
      _saveToHive(currentState.trackId, updatedSteps);

      // If the step was just marked complete, unlock the next one.
      if (updatedStep.isCompleted) {
        unlockNextStep(stepId);
      }
    } catch (e) {
      emit(RoadmapError('Failed to toggle step completion: ${e.toString()}'));
    }
  }

  /// Unlock the next step after the current one is completed.
  ///
  /// Reads the CURRENT state (which was already updated by [toggleStepCompletion]
  /// or [updateStepProgress]). Persists after unlocking.
  void unlockNextStep(String currentStepId) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) return;

    try {
      final currentStepIndex = currentState.steps
          .indexWhere((s) => s.id == currentStepId);

      if (currentStepIndex == -1) return;

      final currentStep = currentState.steps[currentStepIndex];

      if (!currentStep.isCompleted) return;

      // Find the step with the next sequential order number
      final nextStepIndex = currentState.steps.indexWhere(
        (s) => s.order == currentStep.order + 1,
      );

      if (nextStepIndex == -1) return; // User completed the final step

      final nextStep = currentState.steps[nextStepIndex];

      if (!nextStep.isLocked) return; // Already unlocked — nothing to do

      final unlockedNextStep = nextStep.copyWith(isLocked: false);
      final updatedSteps =
          List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[nextStepIndex] = unlockedNextStep;

      // ── Emit updated state ─────────────────────────────────────────────────
      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));

      // ── Persist to Hive ────────────────────────────────────────────────────
      // This ensures the newly unlocked step survives an app restart.
      _saveToHive(currentState.trackId, updatedSteps);
    } catch (e) {
      emit(RoadmapError('Failed to unlock next step: ${e.toString()}'));
    }
  }

  /// Mark a step as in-progress by updating its completion percentage.
  ///
  /// [percentage] is clamped to [0, 100]. If it reaches 100, the step is
  /// marked complete and the next step is unlocked. Progress is persisted.
  void updateStepProgress(String stepId, int percentage) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) return;

    try {
      final stepIndex =
          currentState.steps.indexWhere((s) => s.id == stepId);

      if (stepIndex == -1) return;

      final step = currentState.steps[stepIndex];

      if (step.isLocked) return;

      final clampedPercentage = percentage.clamp(0, 100);

      final updatedStep = step.copyWith(
        completionPercentage: clampedPercentage,
        isCompleted: clampedPercentage == 100,
      );

      final updatedSteps =
          List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[stepIndex] = updatedStep;

      // ── Emit updated state ─────────────────────────────────────────────────
      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));

      // ── Persist to Hive ────────────────────────────────────────────────────
      _saveToHive(currentState.trackId, updatedSteps);

      if (clampedPercentage == 100) {
        unlockNextStep(stepId);
      }
    } catch (e) {
      emit(
          RoadmapError('Failed to update step progress: ${e.toString()}'));
    }
  }

  // ── Read-Only Helpers ──────────────────────────────────────────────────────

  /// Get a specific track by ID (from the in-memory TracksLoaded state).
  TrackModel? getTrackById(String trackId) {
    final currentState = state;
    if (currentState is TracksLoaded) {
      try {
        return currentState.tracks.firstWhere((t) => t.id == trackId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Get completion statistics for the currently loaded roadmap.
  Map<String, dynamic> getRoadmapStats() {
    final currentState = state;

    if (currentState is! RoadmapLoaded) {
      return {
        'totalSteps': 0,
        'completedSteps': 0,
        'unlockedSteps': 0,
        'completionPercentage': 0.0,
      };
    }

    final totalSteps = currentState.steps.length;
    final completedSteps =
        currentState.steps.where((s) => s.isCompleted).length;
    final unlockedSteps =
        currentState.steps.where((s) => !s.isLocked).length;
    final completionPercentage =
        totalSteps > 0 ? (completedSteps / totalSteps * 100).toDouble() : 0.0;

    return {
      'totalSteps': totalSteps,
      'completedSteps': completedSteps,
      'unlockedSteps': unlockedSteps,
      'completionPercentage': completionPercentage,
    };
  }

  /// Clear saved roadmap progress for [trackId] (e.g. on logout or reset).
  Future<void> clearProgress(String trackId) async {
    try {
      await _box.delete(trackId);
    } catch (e) {
      assert(false, '[RoadmapCubit] Failed to clear Hive data: $e');
    }
  }
}
