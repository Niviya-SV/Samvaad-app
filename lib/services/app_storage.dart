import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // ============================================================
  // SHARED PREFERENCES
  // ============================================================

  static final SharedPreferencesAsync _prefs =
  SharedPreferencesAsync();

  // ============================================================
  // JWT TOKEN
  // ============================================================

  static const String _tokenKey = 'jwt_token';

  // ------------------------------------------------------------
  // SAVE TOKEN
  // ------------------------------------------------------------

  static Future<void> saveToken(String token) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception(
        'Cannot save an empty JWT token.',
      );
    }

    await _prefs.setString(
      _tokenKey,
      cleanToken,
    );

    // Immediately verify that it was saved.
    final savedToken =
    await _prefs.getString(_tokenKey);

    debugPrint(
      '========================================',
    );

    debugPrint(
      'TOKEN SAVE CHECK',
    );

    debugPrint(
      'Token saved: '
          '${savedToken != null && savedToken.isNotEmpty}',
    );

    debugPrint(
      'Token length: '
          '${savedToken?.length ?? 0}',
    );

    debugPrint(
      '========================================',
    );

    if (savedToken == null ||
        savedToken.isEmpty) {
      throw Exception(
        'JWT token could not be saved locally.',
      );
    }
  }

  // ------------------------------------------------------------
  // GET TOKEN
  // ------------------------------------------------------------

  static Future<String?> getToken() async {
    final token =
    await _prefs.getString(_tokenKey);
    debugPrint(
      '========================================',
    );

    debugPrint(
      'APP STORAGE TOKEN CHECK',
    );

    debugPrint(
      'Token exists: '
          '${token != null && token.isNotEmpty}',
    );

    debugPrint(
      'Token length: '
          '${token?.length ?? 0}',
    );

    debugPrint(
      '========================================',
    );

    return token;
  }

  // ------------------------------------------------------------
  // CLEAR TOKEN
  // ------------------------------------------------------------

  static Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);

    debugPrint(
      'JWT token cleared.',
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  static const String _nameKey =
      'learner_name';

  static const String _emailKey =
      'learner_email';

  static const String _goalKey =
      'learner_goal';

  static const String _levelKey =
      'learner_level';

  // ------------------------------------------------------------
  // SAVE PROFILE
  // ------------------------------------------------------------

  static Future<void> saveProfile({
    required String name,
    required String email,
    String goal = '',
    String level = '',
  }) async {
    await _prefs.setString(
      _nameKey,
      name,
    );

    await _prefs.setString(
      _emailKey,
      email,
    );

    // Keep compatibility with existing screens.
    await _prefs.setString(
      'user_email',
      email,
    );

    await _prefs.setString(
      _goalKey,
      goal,
    );

    await _prefs.setString(
      _levelKey,
      level,
    );
  }

  // ------------------------------------------------------------
  // GET NAME
  // ------------------------------------------------------------

  static Future<String> getName() async {
    return await _prefs.getString(
      _nameKey,
    ) ??
        '';
  }

  // ------------------------------------------------------------
  // GET EMAIL
  // ------------------------------------------------------------

  static Future<String> getEmail() async {
    return await _prefs.getString(
      _emailKey,
    ) ??
        '';
  }

  // ------------------------------------------------------------
  // GET GOAL
  // ------------------------------------------------------------

  static Future<String> getGoal() async {
    return await _prefs.getString(
      _goalKey,
    ) ??
        '';
  }

  // ------------------------------------------------------------
  // GET LEVEL
  // ------------------------------------------------------------

  static Future<String> getLevel() async {
    return await _prefs.getString(
      _levelKey,
    ) ??
        '';
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  static const String _languageKey =
      'app_language';

  static Future<void> saveLanguage(
      String language,
      ) async {
    await _prefs.setString(
      _languageKey,
      language,
    );
  }

  static Future<String> getLanguage() async {
    return await _prefs.getString(
      _languageKey,
    ) ??
        'English';
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  static const String _notificationsKey =
      'notifications_enabled';

  static final ValueNotifier<bool>
  notificationsNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveNotifications(
      bool value,
      ) async {
    await _prefs.setBool(
      _notificationsKey,
      value,
    );

    notificationsNotifier.value =
        value;
  }

  static Future<bool> getNotifications() async {
    return await _prefs.getBool(
      _notificationsKey,
    ) ??
        true;
  }

  // ============================================================
  // SOUND
  // ============================================================

  static const String _soundKey =
      'sound_enabled';

  static final ValueNotifier<bool>
  soundNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveSound(
      bool value,
      ) async {
    await _prefs.setBool(
      _soundKey,
      value,
    );

    soundNotifier.value = value;
  }

  static Future<bool> getSound() async {
    return await _prefs.getBool(
      _soundKey,
    ) ??
        true;
  }

  // ============================================================
  // HAPTIC
  // ============================================================

  static const String _hapticKey =
      'haptic_enabled';

  static final ValueNotifier<bool>
  hapticNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveHaptic(
      bool value,
      ) async {
    await _prefs.setBool(
      _hapticKey,
      value,
    );

    hapticNotifier.value = value;
  }

  static Future<bool> getHaptic() async {
    return await _prefs.getBool(
      _hapticKey,
    ) ??
        true;
  }

  // ============================================================
  // LARGE TEXT
  // ============================================================

  static const String _largeTextKey =
      'large_text';

  static final ValueNotifier<bool>
  largeTextNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveLargeText(
      bool value,
      ) async {
    await _prefs.setBool(
      _largeTextKey,
      value,
    );

    largeTextNotifier.value =
        value;
  }

  static Future<bool> getLargeText() async {
    return await _prefs.getBool(
      _largeTextKey,
    ) ??
        false;
  }

  // ============================================================
  // HIGH CONTRAST
  // ============================================================

  static const String _highContrastKey =
      'high_contrast';

  static final ValueNotifier<bool>
  highContrastNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveHighContrast(
      bool value,
      ) async {
    await _prefs.setBool(
      _highContrastKey,
      value,
    );

    highContrastNotifier.value =
        value;
  }

  static Future<bool> getHighContrast() async {
    return await _prefs.getBool(
      _highContrastKey,
    ) ??
        false;
  }

  // ============================================================
  // REDUCED MOTION
  // ============================================================

  static const String _reducedMotionKey =
      'reduced_motion';

  static final ValueNotifier<bool>
  reducedMotionNotifier =
  ValueNotifier<bool>(false);

  static Future<void> saveReducedMotion(
      bool value,
      ) async {
    await _prefs.setBool(
      _reducedMotionKey,
      value,
    );

    reducedMotionNotifier.value =
        value;
  }

  static Future<bool> getReducedMotion() async {
    return await _prefs.getBool(
      _reducedMotionKey,
    ) ??
        false;
  }

  // ============================================================
  // ANALYTICS
  // ============================================================

  static const String _analyticsKey =
      'analytics_enabled';

  static final ValueNotifier<bool>
  analyticsNotifier =
  ValueNotifier<bool>(true);

  static Future<void> saveAnalytics(
      bool value,
      ) async {
    await _prefs.setBool(
      _analyticsKey,
      value,
    );

    analyticsNotifier.value =
        value;
  }

  static Future<bool> getAnalytics() async {
    return await _prefs.getBool(
      _analyticsKey,
    ) ??
        true;
  }

  // ============================================================
  // LEARNING PROGRESS
  // ============================================================

  static String _chapterKey(
      String level,
      int chapterNumber,
      ) {
    return 'learning_${level}_$chapterNumber';
  }

  static String _chapterProgressKey(
      String level,
      int chapterNumber,
      ) {
    return '${_chapterKey(level, chapterNumber)}_progress';
  }

  // ============================================================
  // SAVE CHAPTER COMPLETED
  // ============================================================

  static Future<void> saveChapterCompleted(
      String level,
      int chapterNumber,
      ) async {
    await _prefs.setBool(
      _chapterKey(
        level,
        chapterNumber,
      ),
      true,
    );

    await saveChapterProgress(
      level,
      chapterNumber,
      1.0,
    );
  }

  // ============================================================
  // CHECK CHAPTER COMPLETED
  // ============================================================

  static Future<bool> isChapterCompleted(
      String level,
      int chapterNumber,
      ) async {
    return await _prefs.getBool(
      _chapterKey(
        level,
        chapterNumber,
      ),
    ) ??
        false;
  }

  // ============================================================
  // SAVE CHAPTER PROGRESS
  // ============================================================

  static Future<void> saveChapterProgress(
      String level,
      int chapterNumber,
      double progress,
      ) async {
    final safeProgress =
    progress.clamp(
      0.0,
      1.0,
    );

    await _prefs.setDouble(
      _chapterProgressKey(
        level,
        chapterNumber,
      ),
      safeProgress,
    );
  }

  // ============================================================
  // GET CHAPTER PROGRESS
  // ============================================================

  static Future<double> getChapterProgress(
      String level,
      int chapterNumber,
      ) async {
    return await _prefs.getDouble(
      _chapterProgressKey(
        level,
        chapterNumber,
      ),
    ) ??
        0.0;
  }

  // ============================================================
  // GET CHAPTER STATE
  // ============================================================

  static Future<Map<String, dynamic>>
  getChapterState(
      String level,
      int chapterNumber,
      ) async {
    final completed =
    await isChapterCompleted(
      level,
      chapterNumber,
    );

    final progress =
    await getChapterProgress(
      level,
      chapterNumber,
    );

    return {
      'completed': completed,
      'progress': progress,
    };
  }

  // ============================================================
  // CHECK CHAPTER UNLOCKED
  // ============================================================

  static Future<bool> isChapterUnlocked(
      String level,
      int chapterNumber,
      ) async {
    if (chapterNumber <= 1) {
      return true;
    }

    return await isChapterCompleted(
      level,
      chapterNumber - 1,
    );
  }

  // ============================================================
  // GET LEVEL PROGRESS
  // ============================================================

  static Future<List<Map<String, dynamic>>>
  getLevelProgress(
      String level,
      int chapterCount,
      ) async {
    final result =
    <Map<String, dynamic>>[];

    for (
    int i = 1;
    i <= chapterCount;
    i++
    ) {
      final completed =
      await isChapterCompleted(
        level,
        i,
      );

      final progress =
      await getChapterProgress(
        level,
        i,
      );

      final unlocked =
      await isChapterUnlocked(
        level,
        i,
      );

      result.add({
        'chapter': i,
        'completed': completed,
        'progress': progress,
        'unlocked': unlocked,
      });
    }

    return result;
  }

  // ============================================================
  // LOAD ALL SETTINGS
  // ============================================================

  static Future<void>
  loadAllSettings() async {
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
// LAST LEARNED CHAPTER
// ============================================================

  static const String _lastLearnedChapterKey =
      'last_learned_chapter';

// ------------------------------------------------------------
// SAVE LAST LEARNED CHAPTER
// ------------------------------------------------------------

  static Future<void> saveLastLearnedChapter(
      String chapter,
      ) async {
    final cleanChapter = chapter.trim();

    if (cleanChapter.isEmpty) {
      return;
    }

    await _prefs.setString(
      _lastLearnedChapterKey,
      cleanChapter,
    );

    debugPrint(
      'Last learned chapter saved: $cleanChapter',
    );
  }

// ------------------------------------------------------------
// GET LAST LEARNED CHAPTER
// ------------------------------------------------------------

  static Future<String?> getLastLearnedChapter() async {
    return await _prefs.getString(
      _lastLearnedChapterKey,
    );
  }

// ------------------------------------------------------------
// CLEAR LAST LEARNED CHAPTER
// ------------------------------------------------------------

  static Future<void> clearLastLearnedChapter() async {
    await _prefs.remove(
      _lastLearnedChapterKey,
    );
  }
  // ============================================================
  // CLEAR LEARNING PROGRESS
  // ============================================================

  static Future<void>
  clearLearningProgress() async {
    const levels = {
      'Beginner': 6,
      'Intermediate': 5,
      'Advanced': 4,
    };

    for (final entry
    in levels.entries) {
      final level =
          entry.key;

      final chapterCount =
          entry.value;

      for (
      int i = 1;
      i <= chapterCount;
      i++
      ) {
        await _prefs.remove(
          _chapterKey(
            level,
            i,
          ),
        );

        await _prefs.remove(
          _chapterProgressKey(
            level,
            i,
          ),
        );
      }
    }
  }

  // ============================================================
  // CLEAR ALL LOCAL DATA
  // ============================================================

  static Future<void>
  clearLocalData() async {
    await _prefs.clear();

    notificationsNotifier.value =
    true;

    soundNotifier.value =
    true;

    hapticNotifier.value =
    true;

    largeTextNotifier.value =
    false;

    highContrastNotifier.value =
    false;

    reducedMotionNotifier.value =
    false;

    analyticsNotifier.value =
    true;
  }
}