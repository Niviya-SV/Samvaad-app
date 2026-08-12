import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/app_storage.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isLoading = true;
  String? errorMessage;

  int totalXp = 0;
  int currentStreak = 0;
  int completedLessons = 0;
  int totalLessons = 0;

  double completionPercentage = 0.0;
  double averageScore = 0.0;
  int totalPracticeAttempts = 0;
  int achievementCount = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  // =========================================================
  // LOAD REAL PROGRESS FROM BACKEND
  // =========================================================

  Future<void> loadProgress() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await AppStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Login session not found. Please login again.');
      }

      final statistics = await ApiService.getStatistics(token);

      if (!mounted) return;

      setState(() {
        totalXp = _toInt(statistics['xp']);
        currentStreak = _toInt(statistics['currentStreak']);

        completedLessons =
            _toInt(statistics['completedLessons']);

        totalLessons =
            _toInt(statistics['totalLessons']);

        completionPercentage =
            _toDouble(statistics['completionPercentage']);

        averageScore =
            _toDouble(statistics['averageScore']);

        totalPracticeAttempts =
            _toInt(statistics['totalPracticeAttempts']);

        achievementCount =
            _toInt(statistics['achievementCount']);

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // =========================================================
  // SAFE NUMBER CONVERSION
  // =========================================================

  int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is double) return value.round();

    return int.tryParse(value.toString()) ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }

  // =========================================================
  // PROGRESS VALUE
  // =========================================================

  double get overallProgress {
    if (totalLessons <= 0) {
      return 0.0;
    }

    return (completedLessons / totalLessons)
        .clamp(0.0, 1.0);
  }

  String get overallPercentage {
    return '${(overallProgress * 100).round()}%';
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF29263D),
          ),
        ),

        title: const Text(
          'My Progress',

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: loadProgress,

            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF6C63A8),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63A8),
          ),
        )
            : RefreshIndicator(
          color: const Color(0xFF6C63A8),

          onRefresh: loadProgress,

          child: SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),

            padding:
            const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // =================================================
                // ERROR
                // =================================================

                if (errorMessage != null)
                  _buildErrorCard(),

                if (errorMessage != null)
                  const SizedBox(height: 16),

                // =================================================
                // OVERALL PROGRESS
                // =================================================

                _buildOverallProgress(),

                const SizedBox(height: 24),

                // =================================================
                // REAL STATS
                // =================================================

                _buildStats(),

                const SizedBox(height: 28),

                // =================================================
                // LEARNING ACTIVITY
                // =================================================

                const Text(
                  'Learning Activity',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 14),

                _buildActivityCard(),

                const SizedBox(height: 28),

                // =================================================
                // LEARNING PROGRESS
                // =================================================

                const Text(
                  'Learning Progress',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 14),

                _buildLevelProgress(
                  title: 'Beginner',
                  subtitle:
                  'Greetings, Numbers & Basic Words',
                  progress:
                  overallProgress,
                  percentage:
                  overallPercentage,
                  color:
                  const Color(0xFF6C63A8),
                ),

                const SizedBox(height: 12),

                _buildLevelProgress(
                  title: 'Intermediate',
                  subtitle:
                  'Daily Life & Conversations',
                  progress: 0.0,
                  percentage: 'Locked',
                  color:
                  const Color(0xFFB7B2BF),
                ),

                const SizedBox(height: 12),

                _buildLevelProgress(
                  title: 'Advanced',
                  subtitle:
                  'Fluency & Complex Sentences',
                  progress: 0.0,
                  percentage: 'Locked',
                  color:
                  const Color(0xFFB7B2BF),
                ),

                const SizedBox(height: 28),

                // =================================================
                // ACHIEVEMENTS
                // =================================================

                const Text(
                  'Recent Achievements',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 14),

                _buildAchievement(
                  icon:
                  Icons.front_hand_rounded,
                  title: 'First Sign',
                  subtitle:
                  'Learned your first ISL sign',
                  unlocked:
                  completedLessons >= 1,
                ),

                const SizedBox(height: 10),

                _buildAchievement(
                  icon:
                  Icons.local_fire_department_rounded,
                  title: '7 Day Streak',
                  subtitle:
                  'Learned for 7 consecutive days',
                  unlocked:
                  currentStreak >= 7,
                ),

                const SizedBox(height: 10),

                _buildAchievement(
                  icon:
                  Icons.workspace_premium_rounded,
                  title: 'Perfect Score',
                  subtitle:
                  'Score 100% in a quiz',
                  unlocked:
                  averageScore >= 100,
                ),

                const SizedBox(height: 10),

                _buildAchievement(
                  icon:
                  Icons.menu_book_rounded,
                  title: '10 Lessons',
                  subtitle:
                  'Completed 10 lessons',
                  unlocked:
                  completedLessons >= 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ERROR CARD
  // =========================================================

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.red.shade50,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),

      child: Row(
        children: [

          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade700,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
              ),
            ),
          ),

          IconButton(
            onPressed: loadProgress,

            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // OVERALL PROGRESS
  // =========================================================

  Widget _buildOverallProgress() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF6C63A8),
            Color(0xFF8178BB),
          ],
        ),

        borderRadius:
        BorderRadius.circular(26),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              const Expanded(
                child: Text(
                  'Your Learning Journey',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Keep learning to reach your next milestone.',

            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Text(
                overallPercentage,

                style: const TextStyle(
                  fontSize: 42,
                  fontWeight:
                  FontWeight.w900,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 8),

              Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 7,
                ),

                child: Text(
                  'overall',

                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white
                        .withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: overallProgress,

              minHeight: 9,

              backgroundColor:
              const Color(0x55FFFFFF),

              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$completedLessons of $totalLessons lessons completed',

            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // REAL STATS
  // =========================================================

  Widget _buildStats() {
    return Row(
      children: [

        Expanded(
          child: _StatCard(
            icon: Icons.bolt_rounded,

            value: '$totalXp',

            label: 'Total XP',

            background:
            const Color(0xFFFFF4D8),

            iconColor:
            const Color(0xFFE5A83B),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatCard(
            icon:
            Icons.local_fire_department_rounded,

            value: '$currentStreak',

            label: currentStreak == 1
                ? 'Day Streak'
                : 'Day Streak',

            background:
            const Color(0xFFFDEBEC),

            iconColor:
            const Color(0xFFD96B73),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatCard(
            icon:
            Icons.menu_book_rounded,

            value:
            '$completedLessons',

            label: 'Lessons',

            background:
            const Color(0xFFE8E4F7),

            iconColor:
            const Color(0xFF6C63A8),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ACTIVITY
  // =========================================================

  Widget _buildActivityCard() {
    /*
     * We currently only have aggregate statistics from
     * /progress/statistics.
     *
     * Therefore we should NOT fake daily activity values.
     *
     * This card shows real practice information instead.
     */

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              const Expanded(
                child: Text(
                  'Learning Activity',

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
              ),

              Text(
                '$totalPracticeAttempts practice attempts',

                style: const TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                  color: Color(0xFF6C63A8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [

              Expanded(
                child: _ActivityInfo(
                  icon:
                  Icons.menu_book_rounded,
                  value:
                  '$completedLessons',
                  label:
                  'Lessons completed',
                ),
              ),

              Expanded(
                child: _ActivityInfo(
                  icon:
                  Icons.quiz_rounded,
                  value:
                  '$totalPracticeAttempts',
                  label:
                  'Practice attempts',
                ),
              ),

              Expanded(
                child: _ActivityInfo(
                  icon:
                  Icons.star_rounded,
                  value:
                  averageScore
                      .toStringAsFixed(0),
                  label:
                  'Average score',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LEVEL PROGRESS
  // =========================================================

  Widget _buildLevelProgress({
    required String title,
    required String subtitle,
    required double progress,
    required String percentage,
    required Color color,
  }) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color:
          const Color(0xFFE7E2EC),
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 43,
                height: 43,

                decoration:
                BoxDecoration(
                  color: color.withValues(
                    alpha: 0.12,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),

                child: Icon(
                  Icons.school_rounded,
                  color: color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style:
                      const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xFF29263D),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style:
                      const TextStyle(
                        fontSize: 11,
                        color:
                        Color(0xFF8A8695),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                percentage,

                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(10),

            child:
            LinearProgressIndicator(
              value: progress,

              minHeight: 7,

              backgroundColor:
              const Color(0xFFEDEAF1),

              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ACHIEVEMENT
  // =========================================================

  Widget _buildAchievement({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool unlocked,
  }) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white
            : const Color(0xFFF3F1F5),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          const Color(0xFFE7E2EC),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 48,
            height: 48,

            decoration:
            BoxDecoration(
              color: unlocked
                  ? const Color(0xFFFFF4D8)
                  : const Color(0xFFE5E2E8),

              shape: BoxShape.circle,
            ),

            child: Icon(
              unlocked
                  ? icon
                  : Icons.lock_rounded,

              color: unlocked
                  ? const Color(0xFFE5A83B)
                  : const Color(0xFF9994A3),

              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style:
                  const TextStyle(
                    fontSize: 11,
                    color:
                    Color(0xFF8A8695),
                  ),
                ),
              ],
            ),
          ),

          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color:
              Color(0xFF55B97A),
              size: 21,
            ),
        ],
      ),
    );
  }
}

// =============================================================
// STAT CARD
// =============================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color background;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.background,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: iconColor,
            size: 23,
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style:
            const TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w900,
              color:
              Color(0xFF29263D),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,

            textAlign:
            TextAlign.center,

            style:
            const TextStyle(
              fontSize: 10,
              color:
              Color(0xFF777281),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// ACTIVITY INFO
// =============================================================

class _ActivityInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ActivityInfo({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Icon(
          icon,
          color:
          const Color(0xFF6C63A8),
          size: 23,
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style:
          const TextStyle(
            fontSize: 18,
            fontWeight:
            FontWeight.w900,
            color:
            Color(0xFF29263D),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,

          textAlign:
          TextAlign.center,

          style:
          const TextStyle(
            fontSize: 9,
            color:
            Color(0xFF777281),
          ),
        ),
      ],
    );
  }
}