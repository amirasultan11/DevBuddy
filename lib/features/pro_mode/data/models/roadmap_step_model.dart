import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roadmap_step_model.g.dart';

/// Enum for step types
enum StepType {
  @JsonValue('lesson')
  lesson,
  @JsonValue('quiz')
  quiz,
  @JsonValue('project')
  project,
  @JsonValue('reading')
  reading,
  @JsonValue('video')
  video,
}

/// Represents a learning resource (book, article, video, etc.)
@JsonSerializable()
class LearningResource extends Equatable {
  /// Type of resource (e.g., "book", "video", "article", "documentation")
  final String type;

  /// Title of the resource
  final String title;

  /// URL or identifier for the resource
  final String url;

  /// Whether this is a free resource
  final bool isFree;

  /// Optional author/creator name
  final String? author;

  const LearningResource({
    required this.type,
    required this.title,
    required this.url,
    required this.isFree,
    this.author,
  });

  factory LearningResource.fromJson(Map<String, dynamic> json) =>
      _$LearningResourceFromJson(json);

  Map<String, dynamic> toJson() => _$LearningResourceToJson(this);

  @override
  List<Object?> get props => [type, title, url, isFree, author];
}

/// Represents a single step in a learning roadmap
/// Each step is a milestone in the user's learning journey
@JsonSerializable(explicitToJson: true)
class RoadmapStepModel extends Equatable {
  /// Unique identifier for this step
  final String id;

  /// Parent track ID this step belongs to
  final String trackId;

  /// Display title of the step
  final String title;

  /// Detailed description of what this step covers
  final String description;

  /// Order/sequence number in the roadmap (1-indexed)
  final int order;

  /// Whether this step is locked (user hasn't reached it yet)
  final bool isLocked;

  /// Whether this step has been completed by the user
  final bool isCompleted;

  /// Type of step (lesson, quiz, project, etc.)
  final StepType type;

  /// List of learning resources (books, videos, articles)
  final List<LearningResource> resources;

  /// Common mistakes learners make in this step
  final List<String> commonMistakes;

  /// Estimated time to complete in hours
  final double estimatedHours;

  /// Points awarded upon completion
  final int pointsReward;

  /// Optional: Skills learned in this step
  final List<String> skillsLearned;

  /// Optional: Practical tips for completing this step
  final List<String>? practicalTips;

  /// Completion percentage (0-100) for in-progress steps
  final int completionPercentage;

  const RoadmapStepModel({
    required this.id,
    required this.trackId,
    required this.title,
    required this.description,
    required this.order,
    required this.isLocked,
    required this.isCompleted,
    required this.type,
    required this.resources,
    required this.commonMistakes,
    required this.estimatedHours,
    required this.pointsReward,
    required this.skillsLearned,
    this.practicalTips,
    this.completionPercentage = 0,
  });

  /// Creates a RoadmapStepModel from JSON
  factory RoadmapStepModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapStepModelFromJson(json);

  /// Converts this RoadmapStepModel to JSON
  Map<String, dynamic> toJson() => _$RoadmapStepModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    trackId,
    title,
    description,
    order,
    isLocked,
    isCompleted,
    type,
    resources,
    commonMistakes,
    estimatedHours,
    pointsReward,
    skillsLearned,
    practicalTips,
    completionPercentage,
  ];

  /// Creates a copy of this RoadmapStepModel with optional field updates
  RoadmapStepModel copyWith({
    String? id,
    String? trackId,
    String? title,
    String? description,
    int? order,
    bool? isLocked,
    bool? isCompleted,
    StepType? type,
    List<LearningResource>? resources,
    List<String>? commonMistakes,
    double? estimatedHours,
    int? pointsReward,
    List<String>? skillsLearned,
    List<String>? practicalTips,
    int? completionPercentage,
  }) {
    return RoadmapStepModel(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      resources: resources ?? this.resources,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      pointsReward: pointsReward ?? this.pointsReward,
      skillsLearned: skillsLearned ?? this.skillsLearned,
      practicalTips: practicalTips ?? this.practicalTips,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}
