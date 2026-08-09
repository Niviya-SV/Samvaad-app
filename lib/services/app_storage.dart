import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final SharedPreferencesAsync _prefs =
  SharedPreferencesAsync();

  // ============================================================
  // PROFILE
  // ============================================================

  static const String _nameKey = 'learner_name';
  static const String _emailKey = 'learner_email';
  static const String _goalKey = 'learner_goal';
  static const String _levelKey = 'learner_level';

  static Future<void> saveProfile({
    required String name,
    required String email,
    String goal = '',
    String level = '',
  }) async {
    await _prefs.setString(_nameKey, name);
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_goalKey, goal);
    await _prefs.setString(_levelKey, level);
  }

  static Future<String> getName() async {
    return await _prefs.getString(_nameKey) ?? '';
  }

  static Future<String> getEmail() async {
    return await _prefs.getString(_emailKey) ?? '';
  }

  static Future<String> getGoal() async {
    return await _prefs.getString(_goalKey) ?? '';
  }

  static Future<String> getLevel() async {
    return await _prefs.getString(_levelKey) ?? '';
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  static const String _languageKey = 'app_language';

  static Future<void> saveLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    return await _prefs.getString(_languageKey) ?? 'English';
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  static const String _notificationsKey =
      'notifications_enabled';

  static final ValueNotifier<bool> notificationsNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveNotifications(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
    notificationsNotifier.value = value;
  }

  static Future<bool> getNotifications() async {
    return await _prefs.getBool(_notificationsKey) ?? true;
  }

  // ============================================================
  // SOUND
  // ============================================================

  static const String _soundKey = 'sound_enabled';

  static final ValueNotifier<bool> soundNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveSound(bool value) async {
    await _prefs.setBool(_soundKey, value);
    soundNotifier.value = value;
  }

  static Future<bool> getSound() async {
    return await _prefs.getBool(_soundKey) ?? true;
  }

  // ============================================================
  // HAPTIC
  // ============================================================

  static const String _hapticKey = 'haptic_enabled';

  static final ValueNotifier<bool> hapticNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveHaptic(bool value) async {
    await _prefs.setBool(_hapticKey, value);
    hapticNotifier.value = value;
  }

  static Future<bool> getHaptic() async {
    return await _prefs.getBool(_hapticKey) ?? true;
  }

  // ============================================================
  // LARGE TEXT
  // ============================================================

  static const String _largeTextKey = 'large_text';

  static final ValueNotifier<bool> largeTextNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveLargeText(bool value) async {
    await _prefs.setBool(_largeTextKey, value);

    // Immediately update the application.
    largeTextNotifier.value = value;
  }

  static Future<bool> getLargeText() async {
    return await _prefs.getBool(_largeTextKey) ?? false;
  }

  // ============================================================
  // HIGH CONTRAST
  // ============================================================

  static const String _highContrastKey = 'high_contrast';

  static final ValueNotifier<bool> highContrastNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveHighContrast(bool value) async {
    await _prefs.setBool(_highContrastKey, value);

    // Immediately update the application.
    highContrastNotifier.value = value;
  }

  static Future<bool> getHighContrast() async {
    return await _prefs.getBool(_highContrastKey) ?? false;
  }

  // ============================================================
  // REDUCED MOTION
  // ============================================================

  static const String _reducedMotionKey = 'reduced_motion';

  static final ValueNotifier<bool> reducedMotionNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveReducedMotion(bool value) async {
    await _prefs.setBool(_reducedMotionKey, value);

    // Immediately update the application.
    reducedMotionNotifier.value = value;
  }

  static Future<bool> getReducedMotion() async {
    return await _prefs.getBool(_reducedMotionKey) ?? false;
  }

  // ============================================================
  // PRIVACY / ANALYTICS
  // ============================================================

  static const String _analyticsKey =
      'analytics_enabled';

  static final ValueNotifier<bool> analyticsNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveAnalytics(bool value) async {
    await _prefs.setBool(_analyticsKey, value);
    analyticsNotifier.value = value;
  }

  static Future<bool> getAnalytics() async {
    return await _prefs.getBool(_analyticsKey) ?? true;
  }

  // ============================================================
  // LOAD ALL SETTINGS
  // ============================================================

  static Future<void> loadAllSettings() async {
    notificationsNotifier.value =
    await getNotifications();

    soundNotifier.value =
    await getSound();

    hapticNotifier.value =
    await getHaptic();

    largeTextNotifier.value =
    await getLargeText();

    highContrastNotifier.value =
    await getHighContrast();

    reducedMotionNotifier.value =
    await getReducedMotion();

    analyticsNotifier.value =
    await getAnalytics();
  }

  // ============================================================
  // CLEAR LOCAL DATA
  // ============================================================

  static Future<void> clearLocalData() async {
    await _prefs.clear();

    notificationsNotifier.value = true;
    soundNotifier.value = true;
    hapticNotifier.value = true;

    largeTextNotifier.value = false;
    highContrastNotifier.value = false;
    reducedMotionNotifier.value = false;

    analyticsNotifier.value = true;
  }
}