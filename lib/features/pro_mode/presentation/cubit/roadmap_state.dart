import 'package:equatable/equatable.dart';
import '../../data/models/track_model.dart';
import '../../data/models/roadmap_step_model.dart';

/// Base state for Roadmap feature
abstract class RoadmapState extends Equatable {
  const RoadmapState();

  @override
  List<Object?> get props => [];
}

class RoadmapInitial extends RoadmapState {
  const RoadmapInitial();
}

class RoadmapLoading extends RoadmapState {
  const RoadmapLoading();
}

class TracksLoaded extends RoadmapState {
  final List<TrackModel> tracks;

  const TracksLoaded(this.tracks);

  @override
  List<Object?> get props => [tracks];
}

/// State when roadmap steps for a specific track are loaded
class RoadmapLoaded extends RoadmapState {
  final String trackId;
  final List<RoadmapStepModel> steps;

  const RoadmapLoaded({required this.trackId, required this.steps});

  @override
  List<Object?> get props => [trackId, steps];

  /// Create a copy with updated steps
  RoadmapLoaded copyWith({String? trackId, List<RoadmapStepModel>? steps}) {
    return RoadmapLoaded(
      trackId: trackId ?? this.trackId,
      steps: steps ?? this.steps,
    );
  }
}

/// State when an error occurs
class RoadmapError extends RoadmapState {
  final String message;

  const RoadmapError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a step completion is being processed
class StepCompletionUpdating extends RoadmapState {
  final String stepId;

  const StepCompletionUpdating(this.stepId);

  @override
  List<Object?> get props => [stepId];
}

/// State when a step is successfully completed and next step is unlocked
class StepCompletedAndUnlocked extends RoadmapState {
  final String completedStepId;
  final String? unlockedStepId;
  final List<RoadmapStepModel> updatedSteps;

  const StepCompletedAndUnlocked({
    required this.completedStepId,
    this.unlockedStepId,
    required this.updatedSteps,
  });

  @override
  List<Object?> get props => [completedStepId, unlockedStepId, updatedSteps];
}
