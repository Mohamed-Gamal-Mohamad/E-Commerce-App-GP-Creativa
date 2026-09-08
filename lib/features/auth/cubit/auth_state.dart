// lib/features/auth/cubit/auth_state.dart
import 'package:equatable/equatable.dart';

/// All possible states for the authentication flow.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any check.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// A Firebase operation is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// The user is successfully authenticated.
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String? displayName;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [userId, email, displayName];
}

/// The user is not authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An authentication error occurred.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

