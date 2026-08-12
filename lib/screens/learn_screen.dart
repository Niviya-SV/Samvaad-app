import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lesson_screen.dart';
import '../services/app_storage.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int selectedLevel = 0;

  bool _loadingProgress = true;

  int _totalXP = 0;
  int _currentStreak = 0;

  // ============================================================
  // ALL LEARNING LEVELS
  // ============================================================

  final List<LearningLevel> levels = [
    // ============================================================
    // BEGINNER
    // ============================================================

    LearningLevel(
      title: 'Beginner',
      subtitle: 'Start your ISL journey',
      icon: Icons.eco_rounded,
      color: const Color(0xFF55B97A),
      chapters: [
        Chapter(
          number: 1,
          title: 'Greetings',
          subtitle: 'Hello, Thank you & Goodbye',
          icon: Icons.waving_hand_rounded,
          progress: 0.0,
          xp: 50,
          unlocked: true,
          completed: false,
        ),

        Chapter(
          number: 2,
          title: 'Numbers',
          subtitle: 'Learn numbers 1–20',
          icon: Icons.pin_rounded,
          progress: 0.0,
          xp: 70,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 3,
          title: 'Basic Words',
          subtitle: 'Everyday words & signs',
          icon: Icons.chat_bubble_rounded,
          progress: 0.0,
          xp: 80,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 4,
          title: 'Family',
          subtitle: 'People around you',
          icon: Icons.family_restroom_rounded,
          progress: 0.0,
          xp: 100,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 5,
          title: 'Colors',
          subtitle: 'Learn common colors',
          icon: Icons.palette_rounded,
          progress: 0.0,
          xp: 100,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 6,
          title: 'Food & Drinks',
          subtitle: 'Useful signs for meals',
          icon: Icons.restaurant_rounded,
          progress: 0.0,
          xp: 120,
          unlocked: false,
          completed: false,
        ),
      ],
    ),

    // ============================================================
    // INTERMEDIATE
    // ============================================================

    LearningLevel(
      title: 'Intermediate',
      subtitle: 'Build stronger conversations',
      icon: Icons.local_fire_department_rounded,
      color: const Color(0xFFE99B45),
      chapters: [
        Chapter(
          number: 1,
          title: 'Daily Life',
          subtitle: 'Talk about everyday activities',
          icon: Icons.today_rounded,
          progress: 0.0,
          xp: 120,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 2,
          title: 'School & Work',
          subtitle: 'Education and workplace signs',
          icon: Icons.school_rounded,
          progress: 0.0,
          xp: 140,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 3,
          title: 'Questions',
          subtitle: 'Ask and answer questions',
          icon: Icons.help_outline_rounded,
          progress: 0.0,
          xp: 150,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 4,
          title: 'Sentences',
          subtitle: 'Build complete sentences',
          icon: Icons.notes_rounded,
          progress: 0.0,
          xp: 170,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 5,
          title: 'Conversation',
          subtitle: 'Have simple conversations',
          icon: Icons.forum_rounded,
          progress: 0.0,
          xp: 200,
          unlocked: false,
          completed: false,
        ),
      ],
    ),

    // ============================================================
    // ADVANCED
    // ============================================================

    LearningLevel(
      title: 'Advanced',
      subtitle: 'Communicate with confidence',
      icon: Icons.workspace_premium_rounded,
      color: const Color(0xFF8A65C5),
      chapters: [
        Chapter(
          number: 1,
          title: 'Advanced Vocabulary',
          subtitle: 'Expand your ISL vocabulary',
          icon: Icons.menu_book_rounded,
          progress: 0.0,
          xp: 200,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 2,
          title: 'Complex Sentences',
          subtitle: 'Express detailed ideas',
          icon: Icons.auto_stories_rounded,
          progress: 0.0,
          xp: 220,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 3,
          title: 'Real Conversations',
          subtitle: 'Practice natural communication',
          icon: Icons.people_alt_rounded,
          progress: 0.0,
          xp: 250,
          unlocked: false,
          completed: false,
        ),

        Chapter(
          number: 4,
          title: 'Fluency',
          subtitle: 'Build confidence and fluency',
          icon: Icons.emoji_events_rounded,
          progress: 0.0,
          xp: 300,
          unlocked: false,
          completed: false,
        ),
      ],
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadLearningProgress();
  }

  // ============================================================
  // LOAD PROGRESS
  // ============================================================

  Future<void> _loadLearningProgress() async {
    int calculatedXP = 0;

    // ------------------------------------------------------------
    // Load every chapter's progress
    // ------------------------------------------------------------

    for (int levelIndex = 0; levelIndex < levels.length; levelIndex++) {
      final level = levels[levelIndex];

      for (final chapter in level.chapters) {
        final completed = await AppStorage.isChapterCompleted(
          level.title,
          chapter.number,
        );

        final progress = await AppStorage.getChapterProgress(
          level.title,
          chapter.number,
        );

        chapter.completed = completed;

        if (completed) {
          chapter.progress = 1.0;

          // XP is awarded only once because completed chapter
          // contributes its fixed XP.
          calculatedXP += chapter.xp;
        } else {
          chapter.progress = progress.clamp(0.0, 1.0);
        }
      }

      // ----------------------------------------------------------
      // Unlock chapters sequentially
      // ----------------------------------------------------------

      for (int i = 0; i < level.chapters.length; i++) {
        if (i == 0) {
          level.chapters[i].unlocked =
              _isLevelUnlocked(levelIndex);
        } else {
          level.chapters[i].unlocked =
              level.chapters[i - 1].completed;
        }
      }
    }

    // ------------------------------------------------------------
    // Load streak
    // ------------------------------------------------------------

    final streak = await _getCurrentStreak();

    if (!mounted) return;

    setState(() {
      _totalXP = calculatedXP;
      _currentStreak = streak;
      _loadingProgress = false;
    });
  }

  // ============================================================
  // LEVEL UNLOCK LOGIC
  // ============================================================

  bool _isLevelUnlocked(int levelIndex) {
    if (levelIndex == 0) {
      return true;
    }

    final previousLevel = levels[levelIndex - 1];

    return previousLevel.chapters.isNotEmpty &&
        previousLevel.chapters.every(
              (chapter) => chapter.completed,
        );
  }

  // ============================================================
  // STREAK
  // ============================================================

  Future<int> _getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final storedDates =
        prefs.getStringList('samvaad_practice_dates') ?? [];

    if (storedDates.isEmpty) {
      return 0;
    }

    final dates = storedDates
        .map((date) => DateTime.tryParse(date))
        .whereType<DateTime>()
        .map(
          (date) => DateTime(
        date.year,
        date.month,
        date.day,
      ),
    )
        .toSet()
        .toList();

    if (dates.isEmpty) {
      return 0;
    }

    dates.sort();

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    // ----------------------------------------------------------
    // If user has not practiced today or yesterday,
    // streak is no longer active.
    // ----------------------------------------------------------

    final lastDate = dates.last;

    if (lastDate != today && lastDate != yesterday) {
      return 0;
    }

    // ----------------------------------------------------------
    // Count backwards from latest practice date.
    // ----------------------------------------------------------

    int streak = 1;
    DateTime current = lastDate;

    for (int i = dates.length - 2; i >= 0; i--) {
      final expectedPrevious =
      current.subtract(const Duration(days: 1));

      if (dates[i] == expectedPrevious) {
        streak++;
        current = dates[i];
      } else if (dates[i].isBefore(expectedPrevious)) {
        break;
      }
    }

    return streak;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loadingProgress) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFBF5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63A8),
          ),
        ),
      );
    }

    final level = levels[selectedLevel];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            _buildLevelSelector(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  40,
                ),
                child: Column(
                  children: [
                    _buildLevelHeader(level),

                    const SizedBox(height: 24),

                    _buildLearningPath(level),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        10,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E5F8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Color(0xFF6C63A8),
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Learning Path',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Learn Indian Sign Language',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777281),
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // STREAK
          //
          // IMPORTANT:
          // Do NOT show it when streak == 0.
          // ------------------------------------------------------

          if (_currentStreak > 0) ...[
            _statBox(
              icon:
              Icons.local_fire_department_rounded,
              value: '$_currentStreak',
              label:
              _currentStreak == 1
                  ? 'Day'
                  : 'Days',
            ),

            const SizedBox(width: 8),
          ],

          // ------------------------------------------------------
          // XP
          // ------------------------------------------------------

          _statBox(
            icon: Icons.bolt_rounded,
            value: '$_totalXP',
            label: 'XP',
          ),
        ],
      ),
    );
  }

  Widget _statBox({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9E5EF),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color(0xFF6C63A8),
              ),

              const SizedBox(width: 3),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFF29263D),
                ),
              ),
            ],
          ),

          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF8A8695),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEVEL SELECTOR
  // ============================================================

  Widget _buildLevelSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        8,
      ),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDF5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(
          levels.length,
              (index) {
            final selected =
                selectedLevel == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLevel = index;
                  });
                },
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 250),
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(14),
                    boxShadow: selected
                        ? [
                      BoxShadow(
                        color:
                        Colors.black.withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 8,
                        offset:
                        const Offset(0, 3),
                      ),
                    ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        levels[index].icon,
                        size: 19,
                        color: selected
                            ? levels[index].color
                            : const Color(
                          0xFF9B97A5,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        levels[index].title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: selected
                              ? const Color(
                            0xFF29263D,
                          )
                              : const Color(
                            0xFF8A8695,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // LEVEL HEADER
  // ============================================================

  Widget _buildLevelHeader(
      LearningLevel level,
      ) {
    final completed = level.chapters
        .where(
          (chapter) => chapter.completed,
    )
        .length;

    final progress = level.chapters.isEmpty
        ? 0.0
        : completed / level.chapters.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            level.color.withValues(alpha: 0.18),
            level.color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: level.color.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: level.color.withValues(
                    alpha: 0.18,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              level.icon,
              color: level.color,
              size: 31,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  level.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  level.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777281),
                  ),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.white,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      level.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: level.color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING PATH
  // ============================================================

  Widget _buildLearningPath(
      LearningLevel level,
      ) {
    return Column(
      children: List.generate(
        level.chapters.length,
            (index) {
          final chapter =
          level.chapters[index];

          final isLast =
              index == level.chapters.length - 1;

          return _buildChapterNode(
            chapter: chapter,
            level: level,
            isLast: isLast,
          );
        },
      ),
    );
  }

  // ============================================================
  // CHAPTER NODE
  // ============================================================

  Widget _buildChapterNode({
    required Chapter chapter,
    required LearningLevel level,
    required bool isLast,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: chapter.unlocked
              ? () => _openChapter(chapter)
              : _showLockedMessage,
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 78,
                child: Column(
                  children: [
                    _buildChapterCircle(
                      chapter: chapter,
                      level: level,
                    ),

                    if (!isLast)
                      Container(
                        width: 4,
                        height: 75,
                        decoration: BoxDecoration(
                          color: chapter.completed
                              ? level.color
                              : const Color(
                            0xFFE4E0EA,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 22,
                  ),
                  child: _buildChapterCard(
                    chapter: chapter,
                    level: level,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CHAPTER CIRCLE
  // ============================================================

  Widget _buildChapterCircle({
    required Chapter chapter,
    required LearningLevel level,
  }) {
    final Color circleColor;

    if (!chapter.unlocked) {
      circleColor =
      const Color(0xFFE8E4EC);
    } else if (chapter.completed) {
      circleColor = level.color;
    } else {
      circleColor = Colors.white;
    }

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: chapter.unlocked
              ? level.color
              : const Color(0xFFD5D1DC),
          width: 3,
        ),
        boxShadow: [
          if (chapter.unlocked &&
              !chapter.completed)
            BoxShadow(
              color: level.color.withValues(
                alpha: 0.16,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: chapter.completed
          ? const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 30,
      )
          : chapter.unlocked
          ? Icon(
        chapter.icon,
        color: level.color,
        size: 27,
      )
          : const Icon(
        Icons.lock_rounded,
        color: Color(0xFF9D98A8),
        size: 25,
      ),
    );
  }

  // ============================================================
  // CHAPTER CARD
  // ============================================================

  Widget _buildChapterCard({
    required Chapter chapter,
    required LearningLevel level,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: chapter.unlocked
            ? Colors.white
            : const Color(0xFFF5F2F7),
        borderRadius:
        BorderRadius.circular(21),
        border: Border.all(
          color: chapter.unlocked
              ? const Color(0xFFE7E2EC)
              : const Color(0xFFE8E4EB),
        ),
        boxShadow: chapter.unlocked
            ? [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'CHAPTER ${chapter.number}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: chapter.unlocked
                        ? level.color
                        : const Color(
                      0xFF9994A2,
                    ),
                  ),
                ),
              ),

              if (chapter.unlocked)
                Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 17,
                      color: Color(0xFFE5A83B),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${chapter.xp} XP',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w700,
                        color: Color(
                          0xFF777281,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  chapter.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color: chapter.unlocked
                        ? const Color(
                      0xFF29263D,
                    )
                        : const Color(
                      0xFF9994A2,
                    ),
                  ),
                ),
              ),

              if (chapter.completed)
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: level.color
                        .withValues(
                      alpha: 0.12,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    'COMPLETED',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight:
                      FontWeight.w800,
                      color: level.color,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            chapter.subtitle,
            style: TextStyle(
              fontSize: 12,
              color: chapter.unlocked
                  ? const Color(0xFF817C89)
                  : const Color(0xFFA7A2AE),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child:
                  LinearProgressIndicator(
                    value: chapter.progress,
                    minHeight: 7,
                    backgroundColor:
                    const Color(
                      0xFFEDE9F0,
                    ),
                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(
                      chapter.unlocked
                          ? level.color
                          : const Color(
                        0xFFD0CBD6,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                '${(chapter.progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                  color: chapter.unlocked
                      ? level.color
                      : const Color(
                    0xFF9994A2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: chapter.unlocked
                ? OutlinedButton(
              onPressed: () =>
                  _openChapter(chapter),
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                level.color,
                side: BorderSide(
                  color: level.color
                      .withValues(
                    alpha: 0.4,
                  ),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
              ),
              child: Text(
                chapter.completed
                    ? 'Review Chapter'
                    : chapter.progress > 0
                    ? 'Continue Learning'
                    : 'Start Chapter',
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            )
                : OutlinedButton.icon(
              onPressed:
              _showLockedMessage,
              icon: const Icon(
                Icons.lock_rounded,
                size: 16,
              ),
              label: const Text(
                'Locked',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                const Color(
                  0xFF9994A2,
                ),
                side:
                const BorderSide(
                  color: Color(
                    0xFFDCD7E2,
                  ),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPEN CHAPTER
  // ============================================================

  Future<void> _openChapter(
      Chapter chapter,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          level:
          levels[selectedLevel].title,
          chapterTitle:
          chapter.title,
          chapterSubtitle:
          chapter.subtitle,
          chapterNumber:
          chapter.number,
          xp: chapter.xp,
        ),
      ),
    );

    // ----------------------------------------------------------
    // IMPORTANT:
    // Refresh everything when returning from lesson.
    // ----------------------------------------------------------

    await _loadLearningProgress();
  }

  // ============================================================
  // LOCKED MESSAGE
  // ============================================================

  void _showLockedMessage() {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: const Text(
          'Complete the previous chapter to unlock this one.',
        ),
        behavior:
        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
      ),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class LearningLevel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Chapter> chapters;

  LearningLevel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.chapters,
  });
}

class Chapter {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;

  double progress;

  final int xp;

  bool unlocked;
  bool completed;

  Chapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.progress,
    required this.xp,
    required this.unlocked,
    required this.completed,
  });
}