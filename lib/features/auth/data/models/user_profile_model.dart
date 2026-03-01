import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// Represents a user's achievement badge
@JsonSerializable()
class Badge extends Equatable {
  /// Badge ID
  final String id;

  /// Badge title
  final String title;

  /// Badge icon/emoji
  final String icon;

  /// Date earned
  final DateTime earnedAt;

  const Badge({
    required this.id,
    required this.title,
    required this.icon,
    required this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  @override
  List<Object?> get props => [id, title, icon, earnedAt];
}

/// Represents a user's learning statistics
@JsonSerializable()
class LearningStats extends Equatable {
  /// Total learning hours
  final double totalHours;

  /// Number of completed lessons
  final int completedLessons;

  /// Number of completed quizzes
  final int completedQuizzes;

  /// Number of completed projects
  final int completedProjects;

  /// Average quiz score (0-100)
  final double avgQuizScore;

  const LearningStats({
    required this.totalHours,
    required this.completedLessons,
    required this.completedQuizzes,
    required this.completedProjects,
    required this.avgQuizScore,
  });

  factory LearningStats.fromJson(Map<String, dynamic> json) =>
      _$LearningStatsFromJson(json);

  Map<String, dynamic> toJson() => _$LearningStatsToJson(this);

  @override
  List<Object?> get props => [
    totalHours,
    completedLessons,
    completedQuizzes,
    completedProjects,
    avgQuizScore,
  ];
}

/// Comprehensive user profile model for the EdTech platform
/// Tracks user progress, preferences, and achievements
@JsonSerializable(explicitToJson: true)
class UserProfileModel extends Equatable {
  /// Unique user identifier
  final String uid;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// Optional phone number
  final String? phoneNumber;

  /// User's personality type (e.g., "INTJ", "ENFP")
  /// Based on Myers-Briggs Type Indicator
  final String personalityType;

  /// Current learning streak in days
  final int currentStreak;

  /// Longest learning streak achieved
  final int longestStreak;

  /// Total gamification points earned
  final int totalPoints;

  /// Current level based on points (calculated: points / 1000)
  final int level;

  /// List of completed track IDs
  final List<String> completedTracks;

  /// List of currently enrolled track IDs
  final List<String> enrolledTracks;

  /// Preferred work style ID (Freelance, Startup, Corporate)
  final String? preferredWorkStyle;

  /// User's avatar URL or emoji
  final String avatar;

  /// Account creation date
  final DateTime createdAt;

  /// Last login date
  final DateTime lastLoginAt;

  /// Whether user is in Kids Mode or Pro Mode
  final bool isKidsMode;

  /// User's preferred language code (e.g., "en", "ar")
  final String preferredLanguage;

  /// List of earned badges
  final List<Badge> badges;

  /// Learning statistics
  final LearningStats learningStats;

  /// Optional: User's bio/description
  final String? bio;

  /// Optional: User's current goal
  final String? currentGoal;

  /// Unlocked Kids Mode level (default: 1)
  final int unlockedKidsLevel;

  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.personalityType,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalPoints,
    required this.level,
    required this.completedTracks,
    required this.enrolledTracks,
    this.preferredWorkStyle,
    required this.avatar,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isKidsMode,
    required this.preferredLanguage,
    required this.badges,
    required this.learningStats,
    this.bio,
    this.currentGoal,
    this.unlockedKidsLevel = 1,
  });

  /// Creates a UserProfileModel from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts this UserProfileModel to JSON
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phoneNumber,
    personalityType,
    currentStreak,
    longestStreak,
    totalPoints,
    level,
    completedTracks,
    enrolledTracks,
    preferredWorkStyle,
    avatar,
    createdAt,
    lastLoginAt,
    isKidsMode,
    preferredLanguage,
    badges,
    learningStats,
    bio,
    currentGoal,
    unlockedKidsLevel,
  ];

  /// Creates a copy of this UserProfileModel with optional field updates
  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? personalityType,
    int? currentStreak,
    int? longestStreak,
    int? totalPoints,
    int? level,
    List<String>? completedTracks,
    List<String>? enrolledTracks,
    String? preferredWorkStyle,
    String? avatar,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isKidsMode,
    String? preferredLanguage,
    List<Badge>? badges,
    LearningStats? learningStats,
    String? bio,
    String? currentGoal,
    int? unlockedKidsLevel,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      personalityType: personalityType ?? this.personalityType,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      completedTracks: completedTracks ?? this.completedTracks,
      enrolledTracks: enrolledTracks ?? this.enrolledTracks,
      preferredWorkStyle: preferredWorkStyle ?? this.preferredWorkStyle,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isKidsMode: isKidsMode ?? this.isKidsMode,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      badges: badges ?? this.badges,
      learningStats: learningStats ?? this.learningStats,
      bio: bio ?? this.bio,
      currentGoal: currentGoal ?? this.currentGoal,
      unlockedKidsLevel: unlockedKidsLevel ?? this.unlockedKidsLevel,
    );
  }
}
