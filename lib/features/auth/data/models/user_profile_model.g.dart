// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'earnedAt': instance.earnedAt.toIso8601String(),
    };

LearningStats _$LearningStatsFromJson(Map<String, dynamic> json) =>
    LearningStats(
      totalHours: (json['totalHours'] as num).toDouble(),
      completedLessons: (json['completedLessons'] as num).toInt(),
      completedQuizzes: (json['completedQuizzes'] as num).toInt(),
      completedProjects: (json['completedProjects'] as num).toInt(),
      avgQuizScore: (json['avgQuizScore'] as num).toDouble(),
    );

Map<String, dynamic> _$LearningStatsToJson(LearningStats instance) =>
    <String, dynamic>{
      'totalHours': instance.totalHours,
      'completedLessons': instance.completedLessons,
      'completedQuizzes': instance.completedQuizzes,
      'completedProjects': instance.completedProjects,
      'avgQuizScore': instance.avgQuizScore,
    };

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      personalityType: json['personalityType'] as String?,
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      totalPoints: (json['totalPoints'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      completedTracks: (json['completedTracks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      enrolledTracks: (json['enrolledTracks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      preferredWorkStyle: json['preferredWorkStyle'] as String?,
      avatar: json['avatar'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      isKidsMode: json['isKidsMode'] as bool,
      preferredLanguage: json['preferredLanguage'] as String,
      badges: (json['badges'] as List<dynamic>)
          .map((e) => Badge.fromJson(e as Map<String, dynamic>))
          .toList(),
      learningStats:
          LearningStats.fromJson(json['learningStats'] as Map<String, dynamic>),
      bio: json['bio'] as String?,
      currentGoal: json['currentGoal'] as String?,
      unlockedKidsLevel: (json['unlockedKidsLevel'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'personalityType': instance.personalityType,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'totalPoints': instance.totalPoints,
      'level': instance.level,
      'completedTracks': instance.completedTracks,
      'enrolledTracks': instance.enrolledTracks,
      'preferredWorkStyle': instance.preferredWorkStyle,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
      'isKidsMode': instance.isKidsMode,
      'preferredLanguage': instance.preferredLanguage,
      'badges': instance.badges.map((e) => e.toJson()).toList(),
      'learningStats': instance.learningStats.toJson(),
      'bio': instance.bio,
      'currentGoal': instance.currentGoal,
      'unlockedKidsLevel': instance.unlockedKidsLevel,
    };
