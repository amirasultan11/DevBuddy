import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_model.g.dart';

/// Enum for market demand levels
enum MarketDemand {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
}

/// Enum for readiness score
enum ReadinessScore {
  @JsonValue('ready')
  ready,
  @JsonValue('almost')
  almost,
  @JsonValue('not_ready')
  notReady,
}

/// Represents a learning track (e.g., Flutter Development, AI/ML, Backend)
/// Contains all information needed to help users choose and understand a career path
@JsonSerializable(explicitToJson: true)
class TrackModel extends Equatable {
  /// Unique identifier for the track
  final String id;

  /// Display title (e.g., "Flutter Development", "AI & Machine Learning")
  final String title;

  /// Brief description of what this track covers
  final String description;

  /// Current market demand for this skill
  final MarketDemand marketDemand;

  /// Average salary in Egypt (EGP per month)
  final double avgSalaryEgypt;

  /// Average salary globally (USD per year)
  final double avgSalaryGlobal;

  /// User's readiness level for this track based on their profile
  final ReadinessScore readinessScore;

  /// List of prerequisite skills/knowledge required
  final List<String> prerequisites;

  /// List of tools and technologies used in this track
  final List<String> toolsRequired;

  /// Estimated time to complete in hours
  final int estimatedHours;

  /// Difficulty level (1-5, where 5 is most difficult)
  final int difficultyLevel;

  /// Icon name or emoji representing this track
  final String icon;

  /// Color hex code for UI representation
  final String colorHex;

  const TrackModel({
    required this.id,
    required this.title,
    required this.description,
    required this.marketDemand,
    required this.avgSalaryEgypt,
    required this.avgSalaryGlobal,
    required this.readinessScore,
    required this.prerequisites,
    required this.toolsRequired,
    required this.estimatedHours,
    required this.difficultyLevel,
    required this.icon,
    required this.colorHex,
  });

  /// Creates a TrackModel from JSON
  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  /// Converts this TrackModel to JSON
  Map<String, dynamic> toJson() => _$TrackModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    marketDemand,
    avgSalaryEgypt,
    avgSalaryGlobal,
    readinessScore,
    prerequisites,
    toolsRequired,
    estimatedHours,
    difficultyLevel,
    icon,
    colorHex,
  ];

  /// Creates a copy of this TrackModel with optional field updates
  TrackModel copyWith({
    String? id,
    String? title,
    String? description,
    MarketDemand? marketDemand,
    double? avgSalaryEgypt,
    double? avgSalaryGlobal,
    ReadinessScore? readinessScore,
    List<String>? prerequisites,
    List<String>? toolsRequired,
    int? estimatedHours,
    int? difficultyLevel,
    String? icon,
    String? colorHex,
  }) {
    return TrackModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      marketDemand: marketDemand ?? this.marketDemand,
      avgSalaryEgypt: avgSalaryEgypt ?? this.avgSalaryEgypt,
      avgSalaryGlobal: avgSalaryGlobal ?? this.avgSalaryGlobal,
      readinessScore: readinessScore ?? this.readinessScore,
      prerequisites: prerequisites ?? this.prerequisites,
      toolsRequired: toolsRequired ?? this.toolsRequired,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
