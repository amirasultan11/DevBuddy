import '../../data/models/user_profile_model.dart';

/// Abstract repository for authentication operations
/// Defines the contract for authentication data operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserProfileModel> signIn(String email, String password);

  /// Sign up with email, password, and name
  Future<UserProfileModel> signUp(String name, String email, String password);

  /// Sign in anonymously as a Guest.
  /// Creates a Firebase anonymous session and a local guest profile.
  Future<UserProfileModel> signInAnonymously();

  /// Sign out the current user
  Future<void> logout();

  /// Get the current authenticated user
  Future<UserProfileModel?> getCurrentUser();
}

