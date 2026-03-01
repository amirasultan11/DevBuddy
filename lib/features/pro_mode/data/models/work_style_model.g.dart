// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_style_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkStyleModel _$WorkStyleModelFromJson(Map<String, dynamic> json) =>
    WorkStyleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      suitablePersonalityTypes:
          (json['suitablePersonalityTypes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      pros: (json['pros'] as List<dynamic>).map((e) => e as String).toList(),
      cons: (json['cons'] as List<dynamic>).map((e) => e as String).toList(),
      avgSalaryRange: (json['avgSalaryRange'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      requiredSoftSkills: (json['requiredSoftSkills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkStyleModelToJson(WorkStyleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'suitablePersonalityTypes': instance.suitablePersonalityTypes,
      'pros': instance.pros,
      'cons': instance.cons,
      'avgSalaryRange': instance.avgSalaryRange,
      'requiredSoftSkills': instance.requiredSoftSkills,
    };
