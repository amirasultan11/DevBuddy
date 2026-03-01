// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) => TrackModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      marketDemand: $enumDecode(_$MarketDemandEnumMap, json['marketDemand']),
      avgSalaryEgypt: (json['avgSalaryEgypt'] as num).toDouble(),
      avgSalaryGlobal: (json['avgSalaryGlobal'] as num).toDouble(),
      readinessScore:
          $enumDecode(_$ReadinessScoreEnumMap, json['readinessScore']),
      prerequisites: (json['prerequisites'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      toolsRequired: (json['toolsRequired'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      estimatedHours: (json['estimatedHours'] as num).toInt(),
      difficultyLevel: (json['difficultyLevel'] as num).toInt(),
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
    );

Map<String, dynamic> _$TrackModelToJson(TrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'marketDemand': _$MarketDemandEnumMap[instance.marketDemand]!,
      'avgSalaryEgypt': instance.avgSalaryEgypt,
      'avgSalaryGlobal': instance.avgSalaryGlobal,
      'readinessScore': _$ReadinessScoreEnumMap[instance.readinessScore]!,
      'prerequisites': instance.prerequisites,
      'toolsRequired': instance.toolsRequired,
      'estimatedHours': instance.estimatedHours,
      'difficultyLevel': instance.difficultyLevel,
      'icon': instance.icon,
      'colorHex': instance.colorHex,
    };

const _$MarketDemandEnumMap = {
  MarketDemand.high: 'high',
  MarketDemand.medium: 'medium',
  MarketDemand.low: 'low',
};

const _$ReadinessScoreEnumMap = {
  ReadinessScore.ready: 'ready',
  ReadinessScore.almost: 'almost',
  ReadinessScore.notReady: 'not_ready',
};
