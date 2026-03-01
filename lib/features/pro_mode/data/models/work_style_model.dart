import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_style_model.g.dart';

/// Represents different career paths and work styles in the tech industry
/// Used to help users understand which work environment suits them best
@JsonSerializable(explicitToJson: true)
class WorkStyleModel extends Equatable {
  /// Unique identifier for the work style
  final String id;

  /// Display title (e.g., "Freelance", "Startup", "Corporate")
  final String title;

  /// Detailed description of this work style
  final String description;

  /// List of personality types that typically thrive in this work style
  /// e.g., ["INTJ", "ENTP", "ISTP"]
  final List<String> suitablePersonalityTypes;

  /// List of advantages/benefits of this work style
  final List<String> pros;

  /// List of disadvantages/challenges of this work style
  final List<String> cons;

  /// Average salary range in different currencies
  /// Keys: "minEGP", "maxEGP", "minUSD", "maxUSD"
  final Map<String, double> avgSalaryRange;

  /// Required soft skills for success in this work style
  final List<String> requiredSoftSkills;

  const WorkStyleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.suitablePersonalityTypes,
    required this.pros,
    required this.cons,
    required this.avgSalaryRange,
    required this.requiredSoftSkills,
  });

  /// Creates a WorkStyleModel from JSON
  factory WorkStyleModel.fromJson(Map<String, dynamic> json) =>
      _$WorkStyleModelFromJson(json);

  /// Converts this WorkStyleModel to JSON
  Map<String, dynamic> toJson() => _$WorkStyleModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    suitablePersonalityTypes,
    pros,
    cons,
    avgSalaryRange,
    requiredSoftSkills,
  ];

  /// Creates a copy of this WorkStyleModel with optional field updates
  WorkStyleModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? suitablePersonalityTypes,
    List<String>? pros,
    List<String>? cons,
    Map<String, double>? avgSalaryRange,
    List<String>? requiredSoftSkills,
  }) {
    return WorkStyleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      suitablePersonalityTypes:
          suitablePersonalityTypes ?? this.suitablePersonalityTypes,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      avgSalaryRange: avgSalaryRange ?? this.avgSalaryRange,
      requiredSoftSkills: requiredSoftSkills ?? this.requiredSoftSkills,
    );
  }
}
