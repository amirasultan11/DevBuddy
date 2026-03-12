import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Implementation of AuthRepository using Firebase
/// Handles authentication operations with error handling
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileModel> signIn(String email, String password) async {
    try {
      return await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      // Re-throw the exception to be handled by the cubit
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      return await remoteDataSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      // Re-throw the exception to be handled by the cubit
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> signInAnonymously() async {
    try {
      return await remoteDataSource.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }
}
