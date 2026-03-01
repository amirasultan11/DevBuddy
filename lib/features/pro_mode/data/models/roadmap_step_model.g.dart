// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningResource _$LearningResourceFromJson(Map<String, dynamic> json) =>
    LearningResource(
      type: json['type'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      isFree: json['isFree'] as bool,
      author: json['author'] as String?,
    );

Map<String, dynamic> _$LearningResourceToJson(LearningResource instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'url': instance.url,
      'isFree': instance.isFree,
      'author': instance.author,
    };

RoadmapStepModel _$RoadmapStepModelFromJson(Map<String, dynamic> json) =>
    RoadmapStepModel(
      id: json['id'] as String,
      trackId: json['trackId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: (json['order'] as num).toInt(),
      isLocked: json['isLocked'] as bool,
      isCompleted: json['isCompleted'] as bool,
      type: $enumDecode(_$StepTypeEnumMap, json['type']),
      resources: (json['resources'] as List<dynamic>)
          .map((e) => LearningResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      commonMistakes: (json['commonMistakes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      estimatedHours: (json['estimatedHours'] as num).toDouble(),
      pointsReward: (json['pointsReward'] as num).toInt(),
      skillsLearned: (json['skillsLearned'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      practicalTips: (json['practicalTips'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      completionPercentage:
          (json['completionPercentage'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RoadmapStepModelToJson(RoadmapStepModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackId': instance.trackId,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'isLocked': instance.isLocked,
      'isCompleted': instance.isCompleted,
      'type': _$StepTypeEnumMap[instance.type]!,
      'resources': instance.resources.map((e) => e.toJson()).toList(),
      'commonMistakes': instance.commonMistakes,
      'estimatedHours': instance.estimatedHours,
      'pointsReward': instance.pointsReward,
      'skillsLearned': instance.skillsLearned,
      'practicalTips': instance.practicalTips,
      'completionPercentage': instance.completionPercentage,
    };

const _$StepTypeEnumMap = {
  StepType.lesson: 'lesson',
  StepType.quiz: 'quiz',
  StepType.project: 'project',
  StepType.reading: 'reading',
  StepType.video: 'video',
};
