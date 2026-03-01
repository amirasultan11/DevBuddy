import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_profile_model.dart';

/// Base state for Gamification feature
abstract class GamificationState extends Equatable {
  const GamificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before gamification data is loaded
class GamificationInitial extends GamificationState {
  const GamificationInitial();
}

/// Loading state when fetching or updating gamification data
class GamificationLoading extends GamificationState {
  const GamificationLoading();
}

/// State when gamification data is successfully loaded or updated
class GamificationLoaded extends GamificationState {
  final UserProfileModel user;

  const GamificationLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when points are being added (for animation purposes)
class PointsAdding extends GamificationState {
  final int pointsToAdd;
  final UserProfileModel currentUser;

  const PointsAdding({required this.pointsToAdd, required this.currentUser});

  @override
  List<Object?> get props => [pointsToAdd, currentUser];
}

/// State when user levels up
class LeveledUp extends GamificationState {
  final int newLevel;
  final int totalPoints;
  final UserProfileModel user;

  const LeveledUp({
    required this.newLevel,
    required this.totalPoints,
    required this.user,
  });

  @override
  List<Object?> get props => [newLevel, totalPoints, user];
}

/// State when streak is updated
class StreakUpdated extends GamificationState {
  final int currentStreak;
  final int longestStreak;
  final bool isNewRecord;
  final UserProfileModel user;

  const StreakUpdated({
    required this.currentStreak,
    required this.longestStreak,
    required this.isNewRecord,
    required this.user,
  });

  @override
  List<Object?> get props => [currentStreak, longestStreak, isNewRecord, user];
}

/// State when a new badge is earned
class BadgeEarned extends GamificationState {
  final Badge badge;
  final UserProfileModel user;

  const BadgeEarned({required this.badge, required this.user});

  @override
  List<Object?> get props => [badge, user];
}

/// State when an error occurs
class GamificationError extends GamificationState {
  final String message;

  const GamificationError(this.message);

  @override
  List<Object?> get props => [message];
}
