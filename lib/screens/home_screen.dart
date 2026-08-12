import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_storage.dart';
import '../services/api_service.dart';

import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? learnerName;
  final String? email;
  final String? goal;
  final String? level;

  const HomeScreen({
    super.key,
    this.learnerName,
    this.email,
    this.goal,
    this.level,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary =
  Color(0xFF6C63A8);

  static const Color darkText =
  Color(0xFF29263D);

  static const Color secondaryText =
  Color(0xFF706B7C);

  static const Color background =
  Color(0xFFFFFBF5);

  static const Color lightPrimary =
  Color(0xFFEAE6F8);

  // ============================================================
  // USER DATA
  // ============================================================

  String _name = '';
  String _email = '';
  String _goal = '';
  String _level = '';

  // ============================================================
  // LESSON DATA
  // ============================================================

  List<Map<String, dynamic>> _lessons = [];

  // ============================================================
  // PROGRESS DATA
  // ============================================================

  List<Map<String, dynamic>> _progress = [];

  int _totalLessons = 0;
  int _completedLessons = 0;

  // REAL BACKEND STATISTICS
  int _xp = 0;
  int _currentStreak = 0;
  String? _lastActivityDate;
  int _achievementCount = 0;
  double _averageScore = 0.0;
  int _totalPracticeAttempts = 0;

  Map<String, dynamic>? _continueLesson;

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> _getToken() async {
    final prefs =
    SharedPreferencesAsync();

    return prefs.getString(
      'jwt_token',
    );
  }

  // ============================================================
  // LOAD HOME DATA
  // ============================================================

  Future<void> _loadHomeData({
    bool refresh = false,
  }) async {

    if (refresh) {
      setState(() {
        _isRefreshing = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

    try {

      // ========================================================
      // LOCAL PROFILE DATA
      // ========================================================

      String name =
      await AppStorage.getName();

      String email =
      await AppStorage.getEmail();

      String goal =
      await AppStorage.getGoal();

      String level =
      await AppStorage.getLevel();

      // ========================================================
      // WIDGET FALLBACK
      // ========================================================

      if (name.isEmpty &&
          widget.learnerName != null) {
        name = widget.learnerName!;
      }

      if (email.isEmpty &&
          widget.email != null) {
        email = widget.email!;
      }

      if (goal.isEmpty &&
          widget.goal != null) {
        goal = widget.goal!;
      }

      if (level.isEmpty &&
          widget.level != null) {
        level = widget.level!;
      }

      // ========================================================
      // GET JWT
      // ========================================================

      final token =
      await _getToken();

      if (token == null ||
          token.isEmpty) {
        throw Exception(
          'Login session not found.',
        );
      }

      // ========================================================
      // GET LESSONS + PROGRESS
      // ========================================================

      final results =
      await Future.wait([
        ApiService.getLessons(token),
        ApiService.getProgress(token),
        ApiService.getStatistics(token),
      ]);

      final lessonsData =
      results[0] as List<dynamic>;

      final progressData =
      results[1] as List<dynamic>;

      // ========================================================
      // NORMALIZE LESSONS
      // ========================================================

      final lessons =
      lessonsData
          .whereType<Map>()
          .map(
            (lesson) =>
        Map<String, dynamic>.from(
          lesson,
        ),
      )
          .toList();

      // ========================================================
      // NORMALIZE PROGRESS
      // ========================================================

      final progress =
      progressData
          .whereType<Map>()
          .map(
            (item) =>
        Map<String, dynamic>.from(
          item,
        ),
      )
          .toList();

      // ========================================================
      // REAL BACKEND STATISTICS
      // ========================================================

      final statistics =
      Map<String, dynamic>.from(
        results[2] as Map,
      );

      final backendXp =
          int.tryParse(
            statistics['xp']?.toString() ?? '',
          ) ?? 0;

      final backendStreak =
          int.tryParse(
            statistics['currentStreak']?.toString() ?? '',
          ) ?? 0;

      final backendLastActivity =
      statistics['lastActivityDate']?.toString();

      final backendAchievementCount =
          int.tryParse(
            statistics['achievementCount']?.toString() ?? '',
          ) ?? 0;

      final backendPracticeAttempts =
          int.tryParse(
            statistics['totalPracticeAttempts']?.toString() ?? '',
          ) ?? 0;

      final backendAverageScore =
          double.tryParse(
            statistics['averageScore']?.toString() ?? '',
          ) ?? 0.0;

      // ========================================================
      // SORT LESSONS
      // ========================================================

      lessons.sort(
            (a, b) {

          final chapterA =
              a['chapter']
                  ?.toString()
                  .toLowerCase() ??
                  '';

          final chapterB =
              b['chapter']
                  ?.toString()
                  .toLowerCase() ??
                  '';

          final chapterCompare =
          chapterA.compareTo(
            chapterB,
          );

          if (chapterCompare != 0) {
            return chapterCompare;
          }

          final orderA =
              int.tryParse(
                a['lessonOrder']
                    ?.toString() ??
                    '',
              ) ??
                  0;

          final orderB =
              int.tryParse(
                b['lessonOrder']
                    ?.toString() ??
                    '',
              ) ??
                  0;

          return orderA.compareTo(
            orderB,
          );
        },
      );

      // ========================================================
      // TOTAL LESSONS
      // ========================================================

      final total =
          lessons.length;

      // ========================================================
      // COMPLETED LESSONS
      // ========================================================

      final completedIds =
      <int>{};

      for (final item in progress) {

        final completed =
            item['completed'] == true;

        if (!completed) {
          continue;
        }

        final lessonId =
        int.tryParse(
          item['lessonId']
              ?.toString() ??
              '',
        );

        if (lessonId != null) {
          completedIds.add(
            lessonId,
          );
        }
      }

      final completed =
          completedIds.length;

      // ========================================================
      // FIND NEXT INCOMPLETE LESSON
      // ========================================================

      Map<String, dynamic>? nextLesson;

      for (final lesson in lessons) {

        final id =
        int.tryParse(
          lesson['id']
              ?.toString() ??
              '',
        );

        if (id == null) {
          continue;
        }

        if (!completedIds.contains(id)) {
          nextLesson = lesson;
          break;
        }
      }

      // ========================================================
      // UPDATE STATE
      // ========================================================

      if (!mounted) return;

      setState(() {

        _name = name;
        _email = email;
        _goal = goal;
        _level = level;

        _lessons = lessons;
        _progress = progress;

        _totalLessons = total;
        _completedLessons = completed;

        // Values come from the backend.
        // Do not calculate or increment streak locally.
        _xp = backendXp;
        _currentStreak = backendStreak;
        _lastActivityDate = backendLastActivity;
        _achievementCount = backendAchievementCount;
        _totalPracticeAttempts = backendPracticeAttempts;
        _averageScore = backendAverageScore;

        _continueLesson =
            nextLesson;

        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

    } catch (e) {

      debugPrint(
        'Home loading error: $e',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;

        _errorMessage =
            e.toString();
      });
    }
  }

  // ============================================================
  // OVERALL PROGRESS
  // ============================================================

  double get _overallProgress {

    if (_totalLessons <= 0) {
      return 0;
    }

    return
      (_completedLessons /
          _totalLessons)
          .clamp(0.0, 1.0);
  }

  // ============================================================
  // PROGRESS PERCENTAGE
  // ============================================================

  int get _progressPercentage {

    return (_overallProgress * 100)
        .round();
  }

  // ============================================================
  // FIRST NAME
  // ============================================================

  String get _firstName {

    final value =
    _name.trim();

    if (value.isEmpty) {
      return 'Learner';
    }

    return value
        .split(' ')
        .first;
  }

  // ============================================================
  // DISPLAY LEVEL
  // ============================================================

  String get _displayLevel {

    if (_level.trim().isEmpty) {
      return 'Beginner';
    }

    return _level.trim();
  }

  // ============================================================
  // DISPLAY GOAL
  // ============================================================

  String get _displayGoal {

    if (_goal.trim().isEmpty) {
      return 'Build your ISL skills';
    }

    return _goal.trim();
  }

  // ============================================================
  // CURRENT LESSON TITLE
  // ============================================================

  String get _continueLessonTitle {

    if (_continueLesson == null) {
      return 'All lessons completed!';
    }

    return _continueLesson!['title']
        ?.toString() ??
        'Next Lesson';
  }

  // ============================================================
  // CURRENT LESSON CHAPTER
  // ============================================================

  String get _continueLessonChapter {

    if (_continueLesson == null) {
      return '';
    }

    return _continueLesson!['chapter']
        ?.toString() ??
        '';
  }

  // ============================================================
  // CURRENT LESSON ID
  // ============================================================

  int? get _continueLessonId {

    if (_continueLesson == null) {
      return null;
    }

    return int.tryParse(
      _continueLesson!['id']
          ?.toString() ??
          '',
    );
  }

  // ============================================================
  // LEVEL LESSONS
  // ============================================================

  List<Map<String, dynamic>>
  _lessonsForLevel(
      String level,
      ) {

    return _lessons
        .where(
          (lesson) =>
      (lesson['level']
          ?.toString()
          .toLowerCase() ??
          '') ==
          level
              .toLowerCase(),
    )
        .toList();
  }

  // ============================================================
  // LEVEL COMPLETION
  // ============================================================

  double _levelProgress(
      String level,
      ) {

    final levelLessons =
    _lessonsForLevel(
      level,
    );

    if (levelLessons.isEmpty) {
      return 0;
    }

    int completed = 0;

    for (final lesson
    in levelLessons) {

      final id =
      int.tryParse(
        lesson['id']
            ?.toString() ??
            '',
      );

      if (id == null) {
        continue;
      }

      final found =
      _progress.any(
            (item) =>
        item['lessonId']
            ?.toString() ==
            id.toString() &&
            item['completed'] ==
                true,
      );

      if (found) {
        completed++;
      }
    }

    return
      (completed /
          levelLessons.length)
          .clamp(0.0, 1.0);
  }

  // ============================================================
  // OPEN LEARN
  // ============================================================

  Future<void> _openLearn() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const LearnScreen(),
      ),
    );

    if (!mounted) return;

    await _loadHomeData(
      refresh: true,
    );
  }

  // ============================================================
  // OPEN PRACTICE
  // ============================================================

  Future<void> _openPractice() async {

    if (_continueLessonId == null) {

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const PracticeScreen(
            chapterTitle:
            'Greetings',
          ),
        ),
      );

    } else {

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PracticeScreen(
                chapterTitle:
                _continueLessonChapter,
              ),
        ),
      );
    }

    if (!mounted) return;

    await _loadHomeData(
      refresh: true,
    );
  }

  // ============================================================
  // OPEN PROFILE
  // ============================================================

  Future<void> _openProfile() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProfileScreen(
              learnerName: _name,
              email: _email,
              goal: _goal,
            ),
      ),
    );

    if (!mounted) return;

    await _loadHomeData(
      refresh: true,
    );
  }

  // ============================================================
  // OPEN SETTINGS
  // ============================================================

  Future<void> _openSettings() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const SettingsScreen(),
      ),
    );

    if (!mounted) return;

    await _loadHomeData(
      refresh: true,
    );
  }

  // ============================================================
  // OPEN NOTIFICATIONS
  // ============================================================

  Future<void> _openNotifications() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const NotificationsScreen(),
      ),
    );

    if (!mounted) return;

    await _loadHomeData(
      refresh: true,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {

    if (_isLoading) {
      return const Scaffold(
        backgroundColor:
        background,

        body: Center(
          child:
          CircularProgressIndicator(
            color: primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
        background,

        elevation: 0,

        surfaceTintColor:
        Colors.transparent,

        automaticallyImplyLeading:
        false,

        title: const Text(
          'SAMVAAD',

          style: TextStyle(
            color: primary,
            fontSize: 21,
            fontWeight:
            FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),

        actions: [

          IconButton(
            onPressed:
            _openNotifications,

            icon: const Icon(
              Icons
                  .notifications_none_rounded,
              color: darkText,
              size: 27,
            ),
          ),

          IconButton(
            onPressed:
            _openSettings,

            icon: const Icon(
              Icons.settings_outlined,
              color: darkText,
              size: 25,
            ),
          ),

          const SizedBox(
            width: 8,
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: RefreshIndicator(
        color: primary,

        onRefresh: () =>
            _loadHomeData(
              refresh: true,
            ),

        child:
        SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          padding:
          const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ==================================================
              // GREETING
              // ==================================================

              Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          'Hello, $_firstName 👋',

                          style:
                          const TextStyle(
                            fontSize: 27,
                            fontWeight:
                            FontWeight.w900,
                            color:
                            darkText,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        const Text(
                          'Ready to continue your learning journey?',

                          style:
                          TextStyle(
                            fontSize: 14,
                            color:
                            secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap:
                    _openProfile,

                    child: Container(
                      width: 54,
                      height: 54,

                      decoration:
                      BoxDecoration(
                        color:
                        lightPrimary,

                        shape:
                        BoxShape.circle,

                        border:
                        Border.all(
                          color:
                          primary.withValues(
                            alpha: 0.2,
                          ),
                          width: 2,
                        ),
                      ),

                      child:
                      const Icon(
                        Icons
                            .person_rounded,
                        color: primary,
                        size: 29,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 22,
              ),

              // ==================================================
              // PROFILE
              // ==================================================

              _profileCard(),

              const SizedBox(
                height: 14,
              ),

              _realStatsCard(),

              const SizedBox(
                height: 25,
              ),

              // ==================================================
              // CONTINUE LEARNING
              // ==================================================

              _sectionTitle(
                'Continue Learning',
                'View All',
                _openLearn,
              ),

              const SizedBox(
                height: 12,
              ),

              _continueLearningCard(),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // TODAY'S ACTIVITY
              // ==================================================

              const Text(
                "Today's Task",

                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              _todayProgressCard(),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // LEARNING PATH
              // ==================================================

              const Text(
                'Learning Path',

                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              _learningPath(),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // PRACTICE
              // ==================================================

              _sectionTitle(
                'Practice',
                'Start',
                _openPractice,
              ),

              const SizedBox(
                height: 12,
              ),

              _practiceCard(),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // MOTIVATION
              // ==================================================

              _motivationCard(),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
      SafeArea(
        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          decoration:
          BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 18,
                offset:
                const Offset(
                  0,
                  -5,
                ),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

            children: [

              _navItem(
                Icons.home_rounded,
                'Home',
                true,
                    () {},
              ),

              _navItem(
                Icons
                    .menu_book_rounded,
                'Learn',
                false,
                _openLearn,
              ),

              _navItem(
                Icons
                    .sports_esports_rounded,
                'Practice',
                false,
                _openPractice,
              ),

              _navItem(
                Icons
                    .person_outline_rounded,
                'Profile',
                false,
                _openProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard() {

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color:
          const Color(0xFFEDEAF4),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 52,
            height: 52,

            decoration:
            BoxDecoration(
              color:
              lightPrimary,

              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),

            child:
            const Icon(
              Icons
                  .person_rounded,
              color: primary,
              size: 28,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(
                  _name.isEmpty
                      ? 'Learner'
                      : _name,

                  maxLines: 1,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    darkText,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  _email.isEmpty
                      ? 'Learner Profile'
                      : _email,

                  maxLines: 1,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    secondaryText,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  _displayLevel,

                  style:
                  const TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed:
            _openProfile,

            icon:
            const Icon(
              Icons
                  .edit_outlined,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REAL XP + STREAK CARD
  // ============================================================

  Widget _realStatsCard() {
    final bool hasStreak = _currentStreak > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEDEAF4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1D8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFF28C28),
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStreak
                          ? '$_currentStreak day streak'
                          : 'Start your streak',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasStreak
                          ? 'Keep completing your daily task'
                          : 'Complete today\'s task to begin',
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 42,
            color: const Color(0xFFEDEAF4),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: Color(0xFFF4B400),
                size: 21,
              ),
              const SizedBox(height: 1),
              Text(
                '$_xp XP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTINUE LEARNING CARD
  // ============================================================

  Widget _continueLearningCard() {

    // ----------------------------------------------------------
    // ALL LESSONS COMPLETED
    // ----------------------------------------------------------

    if (_continueLesson == null) {

      return Container(
        width: double.infinity,

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(
          color:
          const Color(0xFFEAE6F8),

          borderRadius:
          BorderRadius.circular(
            24,
          ),
        ),

        child: Column(
          children: [

            const Icon(
              Icons
                  .emoji_events_rounded,
              color: primary,
              size: 46,
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'All lessons completed! 🎉',

              textAlign:
              TextAlign.center,

              style:
              TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w900,
                color: darkText,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              '$_completedLessons / $_totalLessons lessons completed',

              style:
              const TextStyle(
                fontSize: 13,
                color:
                secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    // ----------------------------------------------------------
    // NEXT LESSON
    // ----------------------------------------------------------

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(19),

      decoration:
      BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFF6C63A8),
            Color(0xFF8177C4),
          ],

          begin:
          Alignment.topLeft,

          end:
          Alignment.bottomRight,
        ),

        borderRadius:
        BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color:
            primary.withValues(
              alpha: 0.2,
            ),
            blurRadius: 18,
            offset:
            const Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,

                decoration:
                BoxDecoration(
                  color:
                  Colors.white
                      .withValues(
                    alpha: 0.18,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),

                child:
                const Icon(
                  Icons
                      .front_hand_rounded,
                  color:
                  Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(
                      _continueLessonTitle,

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      _continueLessonChapter
                          .isEmpty
                          ? 'Next lesson'
                          : _continueLessonChapter,

                      style:
                      const TextStyle(
                        color:
                        Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // ----------------------------------------------------
          // REAL OVERALL PROGRESS
          // ----------------------------------------------------

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [

              const Text(
                'Overall Progress',

                style:
                TextStyle(
                  color:
                  Colors.white70,
                  fontSize: 12,
                ),
              ),

              Text(
                '$_progressPercentage%',

                style:
                const TextStyle(
                  color:
                  Colors.white,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              10,
            ),

            child:
            LinearProgressIndicator(
              value:
              _overallProgress,

              minHeight: 8,

              backgroundColor:
              const Color(
                0x4DFFFFFF,
              ),

              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(
            height: 9,
          ),

          Text(
            '$_completedLessons of $_totalLessons lessons completed',

            style:
            const TextStyle(
              color:
              Colors.white70,
              fontSize: 11,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          SizedBox(
            width:
            double.infinity,

            height: 48,

            child:
            ElevatedButton(
              onPressed:
              _openLearn,

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.white,

                foregroundColor:
                primary,

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),

              child:
              const Text(
                'Continue Learning',

                style:
                TextStyle(
                  fontWeight:
                  FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY TASK
  // ============================================================

  bool _isDailyTaskCompletedToday() {
    if (_lastActivityDate == null ||
        _lastActivityDate!.trim().isEmpty) {
      return false;
    }

    final lastActivity =
    DateTime.tryParse(_lastActivityDate!);

    if (lastActivity == null) {
      return false;
    }

    final now = DateTime.now();

    return lastActivity.year == now.year &&
        lastActivity.month == now.month &&
        lastActivity.day == now.day;
  }

  Widget _todayProgressCard() {
    final completedToday =
    _isDailyTaskCompletedToday();

    final progress =
    completedToday ? 1.0 : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEDEAF4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ======================================================
          // HEADER
          // ======================================================

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1D8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFF28C28),
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Daily Task",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completedToday
                          ? 'Daily practice completed! 🎉'
                          : 'Complete your practice for today.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // REAL STREAK
              // ==================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1ED),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFE56B5D),
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$_currentStreak',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD95C4E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ======================================================
          // TASK COUNT
          // ======================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                completedToday
                    ? 'Practice completed'
                    : 'Practice today',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: darkText,
                ),
              ),
              Text(
                completedToday ? '1 / 1' : '0 / 1',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ======================================================
          // REAL DAILY TASK BAR
          // ======================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: const Color(0xFFE9E6F2),
              valueColor: AlwaysStoppedAnimation<Color>(
                completedToday
                    ? const Color(0xFF55B97A)
                    : primary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // STATUS + XP
          // ======================================================

          Row(
            children: [
              Icon(
                completedToday
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: completedToday
                    ? const Color(0xFF55B97A)
                    : secondaryText,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  completedToday
                      ? 'You completed today\'s task.'
                      : 'Practice once today to keep your streak going.',
                  style: TextStyle(
                    fontSize: 11,
                    color: completedToday
                        ? const Color(0xFF55B97A)
                        : secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: Color(0xFFF4B400),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$_xp XP',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING PATH
  // ============================================================

  Widget _learningPath() {

    final beginner =
    _levelProgress(
      'Beginner',
    );

    final intermediate =
    _levelProgress(
      'Intermediate',
    );

    final advanced =
    _levelProgress(
      'Advanced',
    );

    final current =
    _displayLevel
        .toLowerCase();

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color:
          const Color(0xFFEDEAF4),
        ),
      ),

      child: Column(
        children: [

          _pathRow(
            Icons.looks_one_rounded,
            'Beginner',
            'Build your foundations',
            beginner,
            current ==
                'beginner',
          ),

          _connector(),

          _pathRow(
            Icons.looks_two_rounded,
            'Intermediate',
            'Build fluency',
            intermediate,
            current ==
                'intermediate',
          ),

          _connector(),

          _pathRow(
            Icons.looks_3_rounded,
            'Advanced',
            'Master communication',
            advanced,
            current ==
                'advanced',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PATH ROW
  // ============================================================

  Widget _pathRow(
      IconData icon,
      String title,
      String subtitle,
      double progress,
      bool current,
      ) {

    final percentage =
    (progress * 100)
        .round();

    final hasLessons =
        _lessonsForLevel(
          title,
        ).isNotEmpty;

    final completed =
        percentage >= 100;

    return Row(
      children: [

        Container(
          width: 48,
          height: 48,

          decoration:
          BoxDecoration(
            color: current
                ? primary.withValues(
              alpha: 0.14,
            )
                : completed
                ? Colors.green
                .withValues(
              alpha: 0.14,
            )
                : const Color(
              0xFFF3F1F7,
            ),

            shape:
            BoxShape.circle,
          ),

          child: Icon(
            completed
                ? Icons
                .check_rounded
                : icon,

            color: current
                ? primary
                : completed
                ? Colors.green
                : const Color(
              0xFF9A96A5,
            ),
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              Row(
                children: [

                  Flexible(
                    child: Text(
                      title,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.w800,

                        color: current ||
                            completed
                            ? darkText
                            : secondaryText,
                      ),
                    ),
                  ),

                  if (current) ...[
                    const SizedBox(
                      width: 8,
                    ),

                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        primary.withValues(
                          alpha: 0.12,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
                          8,
                        ),
                      ),

                      child:
                      const Text(
                        'CURRENT',

                        style:
                        TextStyle(
                          color:
                          primary,
                          fontSize: 8,
                          fontWeight:
                          FontWeight
                              .w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                hasLessons
                    ? '$percentage% complete'
                    : subtitle,

                style:
                const TextStyle(
                  fontSize: 11,
                  color:
                  secondaryText,
                ),
              ),

              if (hasLessons) ...[
                const SizedBox(
                  height: 6,
                ),

                ClipRRect(
                  borderRadius:
                  BorderRadius
                      .circular(
                    5,
                  ),

                  child:
                  LinearProgressIndicator(
                    value:
                    progress,

                    minHeight: 5,

                    backgroundColor:
                    const Color(
                      0xFFE9E6F2,
                    ),

                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(
                      current
                          ? primary
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          '$percentage%',

          style:
          TextStyle(
            fontSize: 11,
            fontWeight:
            FontWeight.w800,
            color: current
                ? primary
                : secondaryText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONNECTOR
  // ============================================================

  Widget _connector() {

    return Container(
      margin:
      const EdgeInsets.only(
        left: 23,
        top: 4,
        bottom: 4,
      ),

      height: 20,
      width: 2,

      color:
      const Color(0xFFE2DFEA),
    );
  }

  // ============================================================
  // PRACTICE CARD
  // ============================================================

  Widget _practiceCard() {

    return GestureDetector(
      onTap:
      _openPractice,

      child: Container(
        width: double.infinity,

        padding:
        const EdgeInsets.all(
          18,
        ),

        decoration:
        BoxDecoration(
          color:
          const Color(
            0xFFF2EFFB,
          ),

          borderRadius:
          BorderRadius.circular(
            22,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 56,
              height: 56,

              decoration:
              BoxDecoration(
                color:
                Colors.white,

                borderRadius:
                BorderRadius
                    .circular(
                  17,
                ),
              ),

              child:
              const Icon(
                Icons
                    .sports_esports_rounded,
                color: primary,
                size: 29,
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    _continueLesson == null
                        ? 'Practice Signs'
                        : 'Practice $_continueLessonTitle',

                    maxLines: 1,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                      color:
                      darkText,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  const Text(
                    'Practice what you have learned',

                    style:
                    TextStyle(
                      fontSize: 12,
                      color:
                      secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 38,
              height: 38,

              decoration:
              BoxDecoration(
                color:
                primary,

                borderRadius:
                BorderRadius.circular(
                  13,
                ),
              ),

              child:
              const Icon(
                Icons
                    .arrow_forward_rounded,
                color:
                Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _motivationCard() {

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(
        20,
      ),

      decoration:
      BoxDecoration(
        color: darkText,

        borderRadius:
        BorderRadius.circular(
          22,
        ),
      ),

      child:
      const Column(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,

        children: [

          Icon(
            Icons
                .format_quote_rounded,
            color:
            Colors.white54,
            size: 30,
          ),

          SizedBox(
            height: 6,
          ),

          Text(
            'Every sign you learn brings you closer to communicating without barriers.',

            style:
            TextStyle(
              color:
              Colors.white,
              fontSize: 16,
              height: 1.5,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          SizedBox(
            height: 12,
          ),

          Text(
            'Keep learning. Keep connecting.',

            style:
            TextStyle(
              color:
              Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
      String title,
      String action,
      VoidCallback onTap,
      ) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,

      children: [

        Expanded(
          child: Text(
            title,

            style:
            const TextStyle(
              fontSize: 19,
              fontWeight:
              FontWeight.w900,
              color:
              darkText,
            ),
          ),
        ),

        TextButton(
          onPressed:
          onTap,

          child:
          Text(
            action,

            style:
            const TextStyle(
              color: primary,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM NAV ITEM
  // ============================================================

  Widget _navItem(
      IconData icon,
      String label,
      bool selected,
      VoidCallback onTap,
      ) {

    return GestureDetector(
      onTap:
      onTap,

      behavior:
      HitTestBehavior.opaque,

      child: Padding(
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 12,
          vertical: 5,
        ),

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            AnimatedContainer(
              duration:
              const Duration(
                milliseconds: 200,
              ),

              width:
              selected
                  ? 48
                  : 42,

              height: 32,

              decoration:
              BoxDecoration(
                color: selected
                    ? lightPrimary
                    : Colors.transparent,

                borderRadius:
                BorderRadius.circular(
                  14,
                ),
              ),

              child: Icon(
                icon,

                size: 22,

                color: selected
                    ? primary
                    : const Color(
                  0xFF8A8695,
                ),
              ),
            ),

            const SizedBox(
              height: 3,
            ),

            Text(
              label,

              style:
              TextStyle(
                fontSize: 10,

                fontWeight:
                selected
                    ? FontWeight.w800
                    : FontWeight.w500,

                color: selected
                    ? primary
                    : const Color(
                  0xFF8A8695,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
