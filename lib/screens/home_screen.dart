import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import '../services/app_localization.dart';

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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF706B7C);
  static const Color background = Color(0xFFFFFBF5);
  static const Color lightPrimary = Color(0xFFEAE6F8);

  // ============================================================
  // LEARNER DATA
  // ============================================================

  String _name = '';
  String _email = '';
  String _goal = '';
  String _level = '';

  bool _isLoading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadLearnerData();
  }

  // ============================================================
  // LOAD LEARNER DATA
  // ============================================================

  Future<void> _loadLearnerData() async {
    final name = await AppStorage.getName();
    final email = await AppStorage.getEmail();
    final goal = await AppStorage.getGoal();
    final level = await AppStorage.getLevel();

    if (!mounted) return;

    setState(() {
      _name = name.isNotEmpty
          ? name
          : (widget.learnerName ?? '');

      _email = email.isNotEmpty
          ? email
          : (widget.email ?? '');

      _goal = goal.isNotEmpty
          ? goal
          : (widget.goal ?? '');

      _level = level.isNotEmpty
          ? level
          : (widget.level ?? '');

      _isLoading = false;
    });
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          learnerName: _name,
          email: _email,
          goal: _goal,
        ),
      ),
    );

    if (!mounted) return;

    await _loadLearnerData();
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );

    if (!mounted) return;

    await _loadLearnerData();
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );

    if (!mounted) return;

    await _loadLearnerData();
  }

  // ============================================================
  // LEARN
  // ============================================================

  Future<void> _openLearn() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LearnScreen(),
      ),
    );

    if (!mounted) return;

    await _loadLearnerData();
  }

  // ============================================================
  // PRACTICE
  // ============================================================

  Future<void> _openPractice() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PracticeScreen(
          chapterTitle: 'Greetings',
        ),
      ),
    );
  }

  // ============================================================
  // DISPLAY NAME
  // ============================================================

  String get _displayName {
    final value = _name.trim();

    if (value.isEmpty) {
      return AppLocalization.t('learner');
    }

    return value;
  }

  String get _firstName {
    final value = _displayName.trim();

    if (value.isEmpty) {
      return AppLocalization.t('learner');
    }

    return value.split(' ').first;
  }

  // ============================================================
  // DISPLAY GOAL
  // ============================================================

  String get _displayGoal {
    if (_goal.trim().isEmpty) {
      return AppLocalization.t('build_isl');
    }

    return _goal.trim();
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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(
            color: primary,
          ),
        ),
      );
    }

    // IMPORTANT:
    // This listens to language changes.
    return ValueListenableBuilder<String>(
      valueListenable: AppLocalization.languageNotifier,
      builder: (context, language, child) {
        return _buildHome(language);
      },
    );
  }

  // ============================================================
  // HOME UI
  // ============================================================

  Widget _buildHome(String language) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SAMVAAD',
              style: TextStyle(
                color: primary,
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),

            Text(
              language,
              style: const TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: AppLocalization.t('notifications'),
            onPressed: _openNotifications,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkText,
              size: 27,
            ),
          ),

          IconButton(
            tooltip: AppLocalization.t('settings'),
            onPressed: _openSettings,
            icon: const Icon(
              Icons.settings_outlined,
              color: darkText,
              size: 25,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: RefreshIndicator(
        color: primary,
        onRefresh: _loadLearnerData,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // GREETING
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalization.t('hello')}, $_firstName 👋',
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          AppLocalization.t('ready_to_learn'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: _openProfile,

                    child: Container(
                      width: 54,
                      height: 54,

                      decoration: BoxDecoration(
                        color: lightPrimary,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        color: primary,
                        size: 29,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // PROFILE QUICK CARD
              // ==================================================

              _profileCard(),

              const SizedBox(height: 25),

              // ==================================================
              // CONTINUE LEARNING
              // ==================================================

              _sectionTitle(
                AppLocalization.t('continue_learning'),
                AppLocalization.t('view_all'),
                _openLearn,
              ),

              const SizedBox(height: 12),

              _continueLearningCard(),

              const SizedBox(height: 28),

              // ==================================================
              // TODAY'S GOAL
              // ==================================================

              Text(
                AppLocalization.t('todays_goal'),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              _goalCard(),

              const SizedBox(height: 28),

              // ==================================================
              // LEARNING PATH
              // ==================================================

              Text(
                AppLocalization.t('learning_path'),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              _learningPath(),

              const SizedBox(height: 28),

              // ==================================================
              // PRACTICE
              // ==================================================

              _sectionTitle(
                AppLocalization.t('practice'),
                AppLocalization.t('start'),
                _openPractice,
              ),

              const SizedBox(height: 12),

              _practiceCard(),

              const SizedBox(height: 28),

              // ==================================================
              // MOTIVATION
              // ==================================================

              _motivationCard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, -5),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,

            children: [
              _navItem(
                Icons.home_rounded,
                AppLocalization.t('home'),
                true,
                    () {},
              ),

              _navItem(
                Icons.menu_book_rounded,
                AppLocalization.t('learn'),
                false,
                _openLearn,
              ),

              _navItem(
                Icons.sports_esports_rounded,
                AppLocalization.t('practice'),
                false,
                _openPractice,
              ),

              _navItem(
                Icons.person_outline_rounded,
                AppLocalization.t('profile'),
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
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFEDEAF4),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: lightPrimary,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.person_rounded,
              color: primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _email.isEmpty
                      ? AppLocalization.t('learner_profile')
                      : _email,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _displayLevel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: _openProfile,
            icon: const Icon(
              Icons.edit_outlined,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTINUE LEARNING CARD
  // ============================================================

  Widget _continueLearningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63A8),
            Color(0xFF8177C4),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
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

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius:
                  BorderRadius.circular(15),
                ),

                child: const Icon(
                  Icons.front_hand_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      AppLocalization.t('greetings'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      AppLocalization.t(
                        'continue_current_lesson',
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Text(
                AppLocalization.t('lesson_progress'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const Text(
                '20%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: const LinearProgressIndicator(
              value: 0.2,
              minHeight: 8,
              backgroundColor: Color(0x4DFFFFFF),
              valueColor:
              AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton(
              onPressed: _openLearn,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),

              child: Text(
                AppLocalization.t('continue_learning'),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
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
  // GOAL CARD
  // ============================================================

  Widget _goalCard() {
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

      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 68,

            child: Stack(
              alignment: Alignment.center,

              children: [
                const SizedBox(
                  width: 68,
                  height: 68,

                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 7,

                    backgroundColor:
                    Color(0xFFE9E6F2),

                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      primary,
                    ),
                  ),
                ),

                const Text(
                  '1/2',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  AppLocalization.t(
                    'daily_learning_goal',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _displayGoal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 13,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  AppLocalization.t(
                    'lesson_remaining',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING PATH
  // ============================================================

  Widget _learningPath() {
    final current =
    _displayLevel.toLowerCase();

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
        children: [
          _pathRow(
            Icons.looks_one_rounded,
            AppLocalization.t('beginner'),
            AppLocalization.t('build_foundations'),
            Colors.green,
            current.contains('beginner') ||
                current.contains('शुरुआ'),
          ),

          _connector(),

          _pathRow(
            Icons.looks_two_rounded,
            AppLocalization.t('intermediate'),
            AppLocalization.t('build_fluency'),
            Colors.orange,
            current.contains('intermediate') ||
                current.contains('मध्य'),
          ),

          _connector(),

          _pathRow(
            Icons.looks_3_rounded,
            AppLocalization.t('advanced'),
            AppLocalization.t('master_communication'),
            Colors.deepPurple,
            current.contains('advanced') ||
                current.contains('उन्नत'),
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
      Color color,
      bool active,
      ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.14)
                : const Color(0xFFF3F1F7),

            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            color: active
                ? color
                : const Color(0xFF9A96A5),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: active
                            ? darkText
                            : secondaryText,
                      ),
                    ),
                  ),

                  if (active) ...[
                    const SizedBox(width: 8),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),

                      decoration: BoxDecoration(
                        color:
                        color.withValues(alpha: 0.12),
                        borderRadius:
                        BorderRadius.circular(8),
                      ),

                      child: Text(
                        AppLocalization.t('current'),
                        style: TextStyle(
                          color: color,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),

        Icon(
          active
              ? Icons.check_circle_rounded
              : Icons.lock_outline_rounded,

          color: active
              ? color
              : const Color(0xFFB7B3C0),

          size: 22,
        ),
      ],
    );
  }

  // ============================================================
  // CONNECTOR
  // ============================================================

  Widget _connector() {
    return Container(
      margin: const EdgeInsets.only(
        left: 23,
        top: 4,
        bottom: 4,
      ),

      height: 20,
      width: 2,

      color: const Color(0xFFE2DFEA),
    );
  }

  // ============================================================
  // PRACTICE CARD
  // ============================================================

  Widget _practiceCard() {
    return GestureDetector(
      onTap: _openPractice,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFFF2EFFB),
          borderRadius: BorderRadius.circular(22),
        ),

        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(17),
              ),

              child: const Icon(
                Icons.sports_esports_rounded,
                color: primary,
                size: 29,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    AppLocalization.t(
                      'practice_signs',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AppLocalization.t(
                      'review_learned',
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: primary,
                borderRadius:
                BorderRadius.circular(13),
              ),

              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
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
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: darkText,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Colors.white54,
            size: 30,
          ),

          const SizedBox(height: 6),

          Text(
            AppLocalization.t('motivation'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            AppLocalization.t('keep_learning'),
            style: const TextStyle(
              color: Colors.white60,
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
      MainAxisAlignment.spaceBetween,

      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: darkText,
            ),
          ),
        ),

        TextButton(
          onPressed: onTap,

          child: Text(
            action,
            style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.w700,
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
      onTap: onTap,

      behavior: HitTestBehavior.opaque,

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            AnimatedContainer(
              duration:
              const Duration(milliseconds: 200),

              width: selected ? 48 : 42,
              height: 32,

              decoration: BoxDecoration(
                color: selected
                    ? lightPrimary
                    : Colors.transparent,

                borderRadius:
                BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                size: 22,

                color: selected
                    ? primary
                    : const Color(0xFF8A8695),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,

              style: TextStyle(
                fontSize: 10,

                fontWeight: selected
                    ? FontWeight.w800
                    : FontWeight.w500,

                color: selected
                    ? primary
                    : const Color(0xFF8A8695),
              ),
            ),
          ],
        ),
      ),
    );
  }
}