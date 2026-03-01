import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/dummy_data_source.dart';
import '../../data/models/track_model.dart';
import '../../data/models/roadmap_step_model.dart';
import 'roadmap_state.dart';

/// Cubit for managing Tracks and Roadmap Steps
/// Handles loading tracks, loading roadmap steps, and managing step completion
class RoadmapCubit extends Cubit<RoadmapState> {
  RoadmapCubit() : super(const RoadmapInitial());

  /// Load all available tracks from the data source
  Future<void> loadTracks() async {
    try {
      emit(const RoadmapLoading());

      // Simulate network delay for realistic UX
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

  /// Load roadmap steps for a specific track
  /// [trackId] - The ID of the track to load steps for
  Future<void> loadRoadmap(String trackId) async {
    try {
      emit(const RoadmapLoading());

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));

      // Get roadmap steps for the track from DummyDataSource
      final steps = DummyDataSource.getRoadmapByTrackId(trackId);

      if (steps.isEmpty) {
        emit(const RoadmapError('No roadmap steps available for this track'));
        return;
      }

      emit(RoadmapLoaded(trackId: trackId, steps: steps));
    } catch (e) {
      emit(RoadmapError('Failed to load roadmap: ${e.toString()}'));
    }
  }

  /// Toggle the completion status of a step
  /// [stepId] - The ID of the step to toggle
  void toggleStepCompletion(String stepId) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) {
      emit(
        const RoadmapError('Cannot toggle step completion: Roadmap not loaded'),
      );
      return;
    }

    try {
      // Find the step to toggle
      final stepIndex = currentState.steps.indexWhere((s) => s.id == stepId);

      if (stepIndex == -1) {
        emit(const RoadmapError('Step not found'));
        return;
      }

      final step = currentState.steps[stepIndex];

      // Check if step is locked
      if (step.isLocked) {
        emit(const RoadmapError('Cannot complete a locked step'));
        return;
      }

      // Create updated step with toggled completion
      final updatedStep = step.copyWith(
        isCompleted: !step.isCompleted,
        completionPercentage: !step.isCompleted ? 100 : 0,
      );

      // Create updated steps list
      final updatedSteps = List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[stepIndex] = updatedStep;

      // Emit updated state
      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));

      // If step was just completed, try to unlock next step
      if (updatedStep.isCompleted) {
        unlockNextStep(stepId);
      }
    } catch (e) {
      emit(RoadmapError('Failed to toggle step completion: ${e.toString()}'));
    }
  }

  /// Unlock the next step after completing the current one
  /// [currentStepId] - The ID of the step that was just completed
  void unlockNextStep(String currentStepId) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) {
      return;
    }

    try {
      // Find the current step
      final currentStepIndex = currentState.steps.indexWhere(
        (s) => s.id == currentStepId,
      );

      if (currentStepIndex == -1) {
        return;
      }

      final currentStep = currentState.steps[currentStepIndex];

      // Check if current step is completed
      if (!currentStep.isCompleted) {
        return;
      }

      // Find the next step (by order)
      final nextStepIndex = currentState.steps.indexWhere(
        (s) => s.order == currentStep.order + 1,
      );

      if (nextStepIndex == -1) {
        // No next step found (user completed the last step)
        return;
      }

      final nextStep = currentState.steps[nextStepIndex];

      // If next step is already unlocked, do nothing
      if (!nextStep.isLocked) {
        return;
      }

      // Unlock the next step
      final unlockedNextStep = nextStep.copyWith(isLocked: false);

      // Create updated steps list
      final updatedSteps = List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[nextStepIndex] = unlockedNextStep;

      // Emit updated state
      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));
    } catch (e) {
      emit(RoadmapError('Failed to unlock next step: ${e.toString()}'));
    }
  }

  /// Mark a step as in-progress by updating its completion percentage
  /// [stepId] - The ID of the step
  /// [percentage] - Completion percentage (0-100)
  void updateStepProgress(String stepId, int percentage) {
    final currentState = state;

    if (currentState is! RoadmapLoaded) {
      return;
    }

    try {
      final stepIndex = currentState.steps.indexWhere((s) => s.id == stepId);

      if (stepIndex == -1) {
        return;
      }

      final step = currentState.steps[stepIndex];

      if (step.isLocked) {
        return;
      }

      // Clamp percentage between 0 and 100
      final clampedPercentage = percentage.clamp(0, 100);

      final updatedStep = step.copyWith(
        completionPercentage: clampedPercentage,
        isCompleted: clampedPercentage == 100,
      );

      final updatedSteps = List<RoadmapStepModel>.from(currentState.steps);
      updatedSteps[stepIndex] = updatedStep;

      emit(RoadmapLoaded(trackId: currentState.trackId, steps: updatedSteps));

      // If step reached 100%, unlock next step
      if (clampedPercentage == 100) {
        unlockNextStep(stepId);
      }
    } catch (e) {
      emit(RoadmapError('Failed to update step progress: ${e.toString()}'));
    }
  }

  /// Get a specific track by ID
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

  /// Get completion statistics for the current roadmap
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
    final completedSteps = currentState.steps
        .where((s) => s.isCompleted)
        .length;
    final unlockedSteps = currentState.steps.where((s) => !s.isLocked).length;
    final completionPercentage = totalSteps > 0
        ? (completedSteps / totalSteps * 100).toDouble()
        : 0.0;

    return {
      'totalSteps': totalSteps,
      'completedSteps': completedSteps,
      'unlockedSteps': unlockedSteps,
      'completionPercentage': completionPercentage,
    };
  }
}
