// lib/core/utils/shared_prefs_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for all SharedPreferences operations.
/// Handles onboarding state, login persistence, and theme mode.
class SharedPrefsHelper {
  final SharedPreferences _prefs;
  static SharedPrefsHelper? _instance;

  SharedPrefsHelper._(this._prefs);

  /// Must be called once at app startup (before runApp).
  static Future<SharedPrefsHelper> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = SharedPrefsHelper._(prefs);
    return _instance!;
  }

  /// Global instance accessor.
  static SharedPrefsHelper get instance => _instance!;

  // ─── Onboarding ─────────────────────────────────────────────────────────────

  /// Returns true if the user hasn't seen onboarding yet (first launch).
  bool isFirstLaunch() => !(_prefs.getBool('onboarding_seen') ?? false);

  /// Returns true if onboarding has been seen.
  static bool get hasSeenOnboarding =>
      _instance?._prefs.getBool('onboarding_seen') ?? false;

  /// Marks the onboarding screens as seen.
  Future<void> setOnboardingSeen() async =>
      await _prefs.setBool('onboarding_seen', true);

  /// Static convenience method to mark onboarding as seen.
  static Future<void> markOnboardingSeen() async =>
      await _instance?.setOnboardingSeen();

  // ─── Login State ────────────────────────────────────────────────────────────

  /// Returns true if a user session was previously persisted.
  bool isLoggedIn() => _prefs.getBool('user_logged_in') ?? false;

  /// Persists login state.
  Future<void> setLoggedIn(bool value) async =>
      await _prefs.setBool('user_logged_in', value);

  /// Clears login state on logout.
  Future<void> clearLoginState() async =>
      await _prefs.remove('user_logged_in');

  // ─── Theme Mode ─────────────────────────────────────────────────────────────

  /// Returns true if dark mode is enabled.
  bool isDarkMode() => _prefs.getBool('dark_mode') ?? false;

  /// Persists the dark mode preference.
  Future<void> setDarkMode(bool isDark) async =>
      await _prefs.setBool('dark_mode', isDark);
}

