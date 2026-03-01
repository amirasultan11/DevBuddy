import 'package:equatable/equatable.dart';
import '../../data/models/user_profile_model.dart';

/// Base state for Authentication feature
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any authentication action
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication operations
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when OTP is being sent
class OtpSending extends AuthState {
  final String phoneNumber;

  const OtpSending(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// State when OTP has been sent successfully
class OtpSent extends AuthState {
  final String phoneNumber;
  final String message;

  const OtpSent({required this.phoneNumber, required this.message});

  @override
  List<Object?> get props => [phoneNumber, message];
}

/// State when OTP is being verified
class OtpVerifying extends AuthState {
  final String phoneNumber;
  final String otp;

  const OtpVerifying({required this.phoneNumber, required this.otp});

  @override
  List<Object?> get props => [phoneNumber, otp];
}

/// State when user is successfully authenticated
class Authenticated extends AuthState {
  final UserProfileModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when an authentication error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when OTP verification fails
class OtpVerificationFailed extends AuthState {
  final String message;
  final String phoneNumber;

  const OtpVerificationFailed({
    required this.message,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [message, phoneNumber];
}
