import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_profile_model.dart';
import 'auth_state.dart';

/// Cubit for managing Firebase authentication flow
/// Handles sign-in, sign-up, and logout with Firebase
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthInitial());

  /// Initialize and check for existing authentication
  Future<void> initialize() async {
    try {
      emit(const AuthLoading());

      // Check if user is already authenticated
      final user = await _repository.getCurrentUser();

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      emit(const AuthLoading());

      final user = await _repository.signIn(email, password);

      emit(Authenticated(user));
    } on Exception catch (e) {
      // Extract error message from exception
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  /// Sign up with name, email, and password
  Future<void> signUp(String name, String email, String password) async {
    try {
      emit(const AuthLoading());

      final user = await _repository.signUp(name, email, password);

      emit(Authenticated(user));
    } on Exception catch (e) {
      // Extract error message from exception
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      emit(const AuthLoading());

      await _repository.logout();

      emit(const Unauthenticated());
    } catch (e) {
      emit(const AuthError('Failed to logout'));
    }
  }

  /// Update user profile
  /// This method updates the local state and should be called after
  /// updating user data in Firestore from other cubits (e.g., GamificationCubit)
  void updateUserProfile(UserProfileModel user) {
    emit(Authenticated(user));
  }

  /// Get current authenticated user
  UserProfileModel? getCurrentUser() {
    final currentState = state;
    if (currentState is Authenticated) {
      return currentState.user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return state is Authenticated;
  }
}
