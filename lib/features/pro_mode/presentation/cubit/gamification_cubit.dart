import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../auth/data/models/user_profile_model.dart';
import '../../data/datasources/dummy_data_source.dart';
import 'gamification_state.dart';

/// Cubit for managing user gamification (XP, Streaks, Levels, Badges)
/// Uses Hive for local persistence of user progress
class GamificationCubit extends Cubit<GamificationState> {
  static const String _boxName = 'gamification';
  static const String _userKey = 'user_profile';
  static const String _lastLoginKey = 'last_login';

  Box<dynamic>? _box;

  GamificationCubit() : super(const GamificationInitial());

  /// Initialize Hive and load user data
  Future<void> initialize() async {
    try {
      emit(const GamificationLoading());

      // Open Hive box
      _box = await Hive.openBox(_boxName);

      // Load user from Hive or create new user
      await _loadOrCreateUser();
    } catch (e) {
      emit(GamificationError('Failed to initialize: ${e.toString()}'));
    }
  }

  /// Load user from Hive or create a new user profile
  Future<void> _loadOrCreateUser() async {
    try {
      // Try to load user from Hive
      final userJson = _box?.get(_userKey) as Map<dynamic, dynamic>?;

      UserProfileModel user;

      if (userJson != null) {
        // Convert dynamic map to Map<String, dynamic>
        final convertedJson = Map<String, dynamic>.from(userJson);
        user = UserProfileModel.fromJson(convertedJson);
      } else {
        // Create new user from DummyDataSource
        user = DummyDataSource.getSampleUserProfile();
        await _saveUser(user);
      }

      emit(GamificationLoaded(user));
    } catch (e) {
      emit(GamificationError('Failed to load user: ${e.toString()}'));
    }
  }

  /// Save user to Hive
  Future<void> _saveUser(UserProfileModel user) async {
    try {
      await _box?.put(_userKey, user.toJson());
    } catch (e) {
      emit(GamificationError('Failed to save user: ${e.toString()}'));
    }
  }

  /// Check and update daily streak
  /// Compares last login date with current date
  /// - If consecutive days: increment streak
  /// - If missed days: reset to 1
  /// - If same day: no change
  Future<void> checkDailyStreak() async {
    final currentState = state;

    if (currentState is! GamificationLoaded) {
      return;
    }

    try {
      final now = DateTime.now();
      final lastLogin = _box?.get(_lastLoginKey) as String?;

      UserProfileModel updatedUser = currentState.user;

      if (lastLogin != null) {
        final lastLoginDate = DateTime.parse(lastLogin);
        final difference = _daysBetween(lastLoginDate, now);

        if (difference == 0) {
          // Same day - no change
          return;
        } else if (difference == 1) {
          // Consecutive day - increment streak
          final newStreak = currentState.user.currentStreak + 1;
          final newLongestStreak = newStreak > currentState.user.longestStreak
              ? newStreak
              : currentState.user.longestStreak;

          updatedUser = currentState.user.copyWith(
            currentStreak: newStreak,
            longestStreak: newLongestStreak,
            lastLoginAt: now,
          );

          await _saveUser(updatedUser);
          await _box?.put(_lastLoginKey, now.toIso8601String());

          // Check if user earned a streak badge
          await _checkStreakBadges(updatedUser);

          emit(
            StreakUpdated(
              currentStreak: newStreak,
              longestStreak: newLongestStreak,
              isNewRecord: newStreak == newLongestStreak,
              user: updatedUser,
            ),
          );
        } else {
          // Missed days - reset streak to 1
          updatedUser = currentState.user.copyWith(
            currentStreak: 1,
            lastLoginAt: now,
          );

          await _saveUser(updatedUser);
          await _box?.put(_lastLoginKey, now.toIso8601String());

          emit(
            StreakUpdated(
              currentStreak: 1,
              longestStreak: currentState.user.longestStreak,
              isNewRecord: false,
              user: updatedUser,
            ),
          );
        }
      } else {
        // First login - set streak to 1
        updatedUser = currentState.user.copyWith(
          currentStreak: 1,
          lastLoginAt: now,
        );

        await _saveUser(updatedUser);
        await _box?.put(_lastLoginKey, now.toIso8601String());

        emit(GamificationLoaded(updatedUser));
      }
    } catch (e) {
      emit(GamificationError('Failed to check streak: ${e.toString()}'));
    }
  }

  /// Calculate days between two dates (ignoring time)
  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  /// Add points to user and check for level up
  /// [points] - Number of points to add
  /// [reason] - Optional reason for adding points (for badge logic)
  Future<void> addPoints(int points, {String? reason}) async {
    final currentState = state;

    if (currentState is! GamificationLoaded) {
      emit(const GamificationError('User not loaded'));
      return;
    }

    try {
      // Show points adding animation state
      emit(PointsAdding(pointsToAdd: points, currentUser: currentState.user));

      // Simulate animation delay
      await Future.delayed(const Duration(milliseconds: 500));

      final oldPoints = currentState.user.totalPoints;
      final newPoints = oldPoints + points;
      final oldLevel = currentState.user.level;
      final newLevel = _calculateLevel(newPoints);

      final updatedUser = currentState.user.copyWith(
        totalPoints: newPoints,
        level: newLevel,
      );

      await _saveUser(updatedUser);

      // Check if user leveled up
      if (newLevel > oldLevel) {
        // Check for level-based badges
        await _checkLevelBadges(updatedUser);

        emit(
          LeveledUp(
            newLevel: newLevel,
            totalPoints: newPoints,
            user: updatedUser,
          ),
        );

        // After showing level up, return to loaded state
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(GamificationLoaded(updatedUser));
      } else {
        emit(GamificationLoaded(updatedUser));
      }

      // Check for point-based badges
      await _checkPointBadges(updatedUser);
    } catch (e) {
      emit(GamificationError('Failed to add points: ${e.toString()}'));
    }
  }

  /// Calculate level based on total points
  /// Formula: level = points / 1000
  int _calculateLevel(int points) {
    return (points / 1000).floor();
  }

  /// Check and award streak-based badges
  Future<void> _checkStreakBadges(UserProfileModel user) async {
    final streakMilestones = [7, 14, 30, 60, 100];

    for (final milestone in streakMilestones) {
      if (user.currentStreak == milestone) {
        final badgeId = 'badge_streak_$milestone';

        // Check if user already has this badge
        final hasBadge = user.badges.any((b) => b.id == badgeId);

        if (!hasBadge) {
          final badge = Badge(
            id: badgeId,
            title: '$milestone-Day Streak',
            icon: _getStreakIcon(milestone),
            earnedAt: DateTime.now(),
          );

          final updatedUser = user.copyWith(badges: [...user.badges, badge]);

          await _saveUser(updatedUser);

          emit(BadgeEarned(badge: badge, user: updatedUser));

          // Return to loaded state after showing badge
          await Future.delayed(const Duration(milliseconds: 2000));
          emit(GamificationLoaded(updatedUser));
        }
      }
    }
  }

  /// Check and award level-based badges
  Future<void> _checkLevelBadges(UserProfileModel user) async {
    final levelMilestones = [1, 5, 10, 20, 50];

    for (final milestone in levelMilestones) {
      if (user.level == milestone) {
        final badgeId = 'badge_level_$milestone';

        final hasBadge = user.badges.any((b) => b.id == badgeId);

        if (!hasBadge) {
          final badge = Badge(
            id: badgeId,
            title: 'Level $milestone Achieved',
            icon: _getLevelIcon(milestone),
            earnedAt: DateTime.now(),
          );

          final updatedUser = user.copyWith(badges: [...user.badges, badge]);

          await _saveUser(updatedUser);

          emit(BadgeEarned(badge: badge, user: updatedUser));

          await Future.delayed(const Duration(milliseconds: 2000));
          emit(GamificationLoaded(updatedUser));
        }
      }
    }
  }

  /// Check and award point-based badges
  Future<void> _checkPointBadges(UserProfileModel user) async {
    final pointMilestones = [1000, 5000, 10000, 25000, 50000];

    for (final milestone in pointMilestones) {
      if (user.totalPoints >= milestone) {
        final badgeId = 'badge_points_$milestone';

        final hasBadge = user.badges.any((b) => b.id == badgeId);

        if (!hasBadge) {
          final badge = Badge(
            id: badgeId,
            title: '$milestone Points Earned',
            icon: '💎',
            earnedAt: DateTime.now(),
          );

          final updatedUser = user.copyWith(badges: [...user.badges, badge]);

          await _saveUser(updatedUser);

          emit(BadgeEarned(badge: badge, user: updatedUser));

          await Future.delayed(const Duration(milliseconds: 2000));
          emit(GamificationLoaded(updatedUser));
        }
      }
    }
  }

  /// Get appropriate icon for streak milestone
  String _getStreakIcon(int days) {
    if (days >= 100) return '🏆';
    if (days >= 60) return '💪';
    if (days >= 30) return '🔥';
    if (days >= 14) return '⚡';
    return '🎯';
  }

  /// Get appropriate icon for level milestone
  String _getLevelIcon(int level) {
    if (level >= 50) return '👑';
    if (level >= 20) return '🌟';
    if (level >= 10) return '⭐';
    if (level >= 5) return '✨';
    return '🎖️';
  }

  /// Update user profile
  Future<void> updateProfile(UserProfileModel user) async {
    try {
      await _saveUser(user);
      emit(GamificationLoaded(user));
    } catch (e) {
      emit(GamificationError('Failed to update profile: ${e.toString()}'));
    }
  }

  /// Reset user data (for testing purposes)
  Future<void> resetUserData() async {
    try {
      await _box?.clear();
      await _loadOrCreateUser();
    } catch (e) {
      emit(GamificationError('Failed to reset data: ${e.toString()}'));
    }
  }

  /// Unlock a Kids Mode level
  /// Only unlocks if the new level is higher than the current unlocked level
  Future<void> unlockKidsLevel(int level) async {
    final currentState = state;

    if (currentState is! GamificationLoaded) {
      return;
    }

    try {
      final currentMaxLevel = currentState.user.unlockedKidsLevel;

      // Only unlock if new level is higher
      if (level > currentMaxLevel) {
        final updatedUser = currentState.user.copyWith(
          unlockedKidsLevel: level,
        );

        await _saveUser(updatedUser);
        emit(GamificationLoaded(updatedUser));
      }
    } catch (e) {
      emit(GamificationError('Failed to unlock level: ${e.toString()}'));
    }
  }

  /// Get current user
  UserProfileModel? getCurrentUser() {
    final currentState = state;
    if (currentState is GamificationLoaded) {
      return currentState.user;
    }
    return null;
  }

  @override
  Future<void> close() {
    _box?.close();
    return super.close();
  }
}
