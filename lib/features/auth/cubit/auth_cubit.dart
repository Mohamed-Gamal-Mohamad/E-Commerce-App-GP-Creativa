// lib/features/auth/cubit/auth_cubit.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

/// Cubit that handles all Firebase Authentication logic.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial()) {
    _listenToAuthChanges();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── Listen to Auth State ─────────────────────────────────────────────────

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  /// Manually checks and emits the current authentication status.
  void checkAuthStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(
        userId: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // ─── Sign In ──────────────────────────────────────────────────────────────

  /// Signs in with [email] and [password] using Firebase Auth.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.uid,
          email: user.email ?? email.trim(),
          displayName: user.displayName,
        ));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e.code)));
    } catch (_) {
      emit(const AuthError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  // ─── Register ─────────────────────────────────────────────────────────────

  /// Creates a new account with [email] and [password].
  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emit(const AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
        await credential.user?.reload();
      }
      final user = _auth.currentUser ?? credential.user;
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.uid,
          email: user.email ?? email.trim(),
          displayName: user.displayName ?? displayName,
        ));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e.code)));
    } catch (_) {
      emit(const AuthError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  /// Signs out the current user and clears local session.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Auth state listener will emit AuthUnauthenticated automatically.
    } catch (_) {
      emit(const AuthError(message: 'Failed to sign out. Please try again.'));
    }
  }

  // ─── Helper ───────────────────────────────────────────────────────────────

  /// Maps Firebase error codes to human-readable messages.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
