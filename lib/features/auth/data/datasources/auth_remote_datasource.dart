import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/user_profile_model.dart';

/// Remote data source for Firebase Authentication and Firestore
/// Handles user sign-up, sign-in, and profile management
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  /// Sign up a new user with email and password
  /// Creates Firebase Auth user and Firestore user profile document
  Future<UserProfileModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Create Firebase Auth user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Step 2: Create initial user profile
      final userProfile = UserProfileModel(
        uid: user.uid,
        name: name,
        email: email,
        personalityType: null, // Will be set later via personality test
        currentStreak: 0,
        longestStreak: 0,
        totalPoints: 0,
        level: 1,
        completedTracks: const [],
        enrolledTracks: const [],
        avatar: '👤', // Default avatar emoji
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        isKidsMode: false,
        preferredLanguage: 'en',
        badges: const [],
        learningStats: const LearningStats(
          totalHours: 0,
          completedLessons: 0,
          completedQuizzes: 0,
          completedProjects: 0,
          avgQuizScore: 0,
        ),
        unlockedKidsLevel: 1,
      );

      // Step 3: Save user profile to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson());

      return userProfile;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      switch (e.code) {
        case 'weak-password':
          throw Exception('Password is too weak');
        case 'email-already-in-use':
          throw Exception('Account already exists');
        case 'invalid-email':
          throw Exception('Invalid email format');
        default:
          throw Exception('Sign up failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Sign in an existing user with email and password
  /// Fetches user profile from Firestore after authentication
  Future<UserProfileModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Authenticate with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in');
      }

      // Step 2: Fetch user profile from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('User profile not found');
      }

      // Step 3: Convert Firestore data to UserProfileModel
      final userData = docSnapshot.data();
      if (userData == null) {
        throw Exception('User data is null');
      }

      return UserProfileModel.fromJson(userData);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          throw Exception('Invalid credentials');
        case 'invalid-email':
          throw Exception('Invalid email format');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        default:
          throw Exception('Sign in failed: ${e.message}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Sign in anonymously as a Guest.
  /// Creates a Firebase anonymous session and a matching guest [UserProfileModel]
  /// in Firestore so that data (progress, streaks, etc.) can be migrated later
  /// if the user decides to create a full account.
  Future<UserProfileModel> signInAnonymously() async {
    try {
      // Step 1: Create an anonymous Firebase Auth session
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Failed to sign in anonymously');
      }

      // Step 2: Build a default guest profile.
      // The email uses a short UID prefix to keep it unique yet readable.
      final guestProfile = UserProfileModel(
        uid: user.uid,
        name: 'Guest Explorer',
        email: 'guest_${user.uid.substring(0, 5)}@devbuddy.app',
        personalityType: null,
        currentStreak: 0,
        longestStreak: 0,
        totalPoints: 0,
        level: 1,
        completedTracks: const [],
        enrolledTracks: const [],
        avatar: '👤',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        isKidsMode: false,
        preferredLanguage: 'en',
        badges: const [],
        learningStats: const LearningStats(
          totalHours: 0,
          completedLessons: 0,
          completedQuizzes: 0,
          completedProjects: 0,
          avgQuizScore: 0,
        ),
        unlockedKidsLevel: 1,
      );

      // Step 3: Persist the guest profile to Firestore.
      // Using set() with merge:false ensures a clean document on first creation.
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(guestProfile.toJson());

      return guestProfile;
    } on FirebaseAuthException catch (e) {
      throw Exception('Anonymous sign-in failed: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Sign out the current user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Get the current authenticated user
  /// Returns null if no user is signed in
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }

      // Fetch user profile from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      final userData = docSnapshot.data();
      if (userData == null) {
        return null;
      }

      return UserProfileModel.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Update an existing user profile
  Future<void> updateUserProfile(UserProfileModel userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userProfile.uid)
          .update(userProfile.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
