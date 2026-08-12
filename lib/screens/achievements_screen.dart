import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/app_storage.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({
    super.key,
  });

  @override
  State<AchievementsScreen> createState() =>
      _AchievementsScreenState();
}

class _AchievementsScreenState
    extends State<AchievementsScreen> {

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  List<Map<String, dynamic>> _unlockedAchievements = [];

  // ============================================================
  // AVAILABLE ACHIEVEMENTS
  // ============================================================
  //
  // These are the achievements that can exist in Samvaad.
  //
  // IMPORTANT:
  // unlocked status is NOT hardcoded.
  //
  // The backend decides which ones are unlocked.
  //
  // ============================================================

  final List<_AchievementDefinition>
  _achievementDefinitions = const [

    _AchievementDefinition(
      code: 'FIRST_SIGN',
      fallbackTitle: 'First Sign',
      fallbackDescription:
      'You completed your first sign lesson!',
      fallbackIcon: '🎉',
      fallbackXp: 50,
      materialIcon:
      Icons.front_hand_rounded,
    ),

    _AchievementDefinition(
      code: 'FIRST_PRACTICE',
      fallbackTitle: 'First Practice',
      fallbackDescription:
      'You completed your first daily practice!',
      fallbackIcon: '🎯',
      fallbackXp: 25,
      materialIcon:
      Icons.track_changes_rounded,
    ),

    _AchievementDefinition(
      code: 'TEN_SIGNS',
      fallbackTitle: 'Sign Explorer',
      fallbackDescription:
      'You completed 10 sign lessons!',
      fallbackIcon: '🏆',
      fallbackXp: 100,
      materialIcon:
      Icons.menu_book_rounded,
    ),

    _AchievementDefinition(
      code: 'THREE_DAY_STREAK',
      fallbackTitle: '3 Day Streak',
      fallbackDescription:
      'You practiced for 3 consecutive days!',
      fallbackIcon: '🔥',
      fallbackXp: 50,
      materialIcon:
      Icons.local_fire_department_rounded,
    ),

    _AchievementDefinition(
      code: 'SEVEN_DAY_STREAK',
      fallbackTitle: '7 Day Streak',
      fallbackDescription:
      'You practiced for 7 consecutive days!',
      fallbackIcon: '🔥',
      fallbackXp: 100,
      materialIcon:
      Icons.local_fire_department_rounded,
    ),

    _AchievementDefinition(
      code: 'FIFTY_SIGNS',
      fallbackTitle: 'Sign Master',
      fallbackDescription:
      'You completed 50 sign lessons!',
      fallbackIcon: '🌟',
      fallbackXp: 500,
      materialIcon:
      Icons.workspace_premium_rounded,
    ),

    _AchievementDefinition(
      code: 'PERFECT_SCORE',
      fallbackTitle: 'Perfect Score',
      fallbackDescription:
      'Score 100% on a practice quiz.',
      fallbackIcon: '💯',
      fallbackXp: 75,
      materialIcon:
      Icons.workspace_premium_rounded,
    ),

    _AchievementDefinition(
      code: 'THIRTY_DAY_STREAK',
      fallbackTitle: '30 Day Streak',
      fallbackDescription:
      'Maintain a 30 day learning streak.',
      fallbackIcon: '🔥',
      fallbackXp: 250,
      materialIcon:
      Icons.local_fire_department_rounded,
    ),

    _AchievementDefinition(
      code: 'BEGINNER_COMPLETE',
      fallbackTitle: 'ISL Scholar',
      fallbackDescription:
      'Complete the entire Beginner level.',
      fallbackIcon: '🎓',
      fallbackXp: 300,
      materialIcon:
      Icons.school_rounded,
    ),

    _AchievementDefinition(
      code: 'CONVERSATION_READY',
      fallbackTitle: 'Conversation Ready',
      fallbackDescription:
      'Complete your first conversation practice.',
      fallbackIcon: '🏅',
      fallbackXp: 200,
      materialIcon:
      Icons.emoji_events_rounded,
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadAchievements();
  }

  // ============================================================
  // LOAD ACHIEVEMENTS
  // ============================================================

  Future<void> _loadAchievements() async {

    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {

      // --------------------------------------------------------
      // GET JWT
      // --------------------------------------------------------

      final token =
      await AppStorage.getToken();

      if (token == null ||
          token.trim().isEmpty) {

        throw Exception(
          'Login session not found. Please login again.',
        );
      }

      // --------------------------------------------------------
      // GET REAL ACHIEVEMENTS
      // --------------------------------------------------------

      final data =
      await ApiService.getAchievements(
        token,
      );

      if (!mounted) return;

      final List<Map<String, dynamic>>
      unlocked = [];

      for (final item in data) {

        if (item is Map) {

          unlocked.add(
            Map<String, dynamic>.from(item),
          );
        }
      }

      setState(() {

        _unlockedAchievements =
            unlocked;

        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

    } catch (e) {

      if (!mounted) return;

      String message =
      e.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(11);
      }

      setState(() {

        _isLoading = false;
        _isRefreshing = false;

        _errorMessage =
            message;
      });
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshAchievements() async {

    setState(() {
      _isRefreshing = true;
    });

    await _loadAchievements();
  }

  // ============================================================
  // FIND UNLOCKED ACHIEVEMENT
  // ============================================================

  Map<String, dynamic>?
  _findUnlocked(
      String code,
      ) {

    for (final achievement
    in _unlockedAchievements) {

      final backendCode =
      achievement['code']
          ?.toString()
          .trim();

      if (backendCode == code) {
        return achievement;
      }
    }

    return null;
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _getIcon(
      _AchievementDefinition definition,
      Map<String, dynamic>? backend,
      ) {

    if (backend != null) {

      final icon =
      backend['icon']
          ?.toString();

      if (icon != null &&
          icon.isNotEmpty) {

        // The backend stores emoji icons.
        // Keep Material icon as the fallback.
      }
    }

    return definition.materialIcon;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {

    final unlockedCount =
        _unlockedAchievements.length;

    final totalCount =
        _achievementDefinitions.length;

    return Scaffold(

      backgroundColor:
      const Color(0xFFFFFBF5),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFFFFFBF5),

        elevation: 0,

        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context),

          icon: const Icon(
            Icons.arrow_back_rounded,
            color:
            Color(0xFF29263D),
          ),
        ),

        title: const Text(
          'Achievements',

          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.w800,
            color:
            Color(0xFF29263D),
          ),
        ),

        centerTitle: true,

        actions: [

          IconButton(
            tooltip: 'Refresh',

            onPressed:
            _isRefreshing
                ? null
                : _refreshAchievements,

            icon: _isRefreshing
                ? const SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.refresh_rounded,
              color:
              Color(0xFF29263D),
            ),
          ),
        ],
      ),

      body: SafeArea(

        child: _isLoading

            ? const Center(
          child:
          CircularProgressIndicator(),
        )

            : _errorMessage != null

            ? _buildErrorState()

            : RefreshIndicator(

          onRefresh:
          _refreshAchievements,

          child:
          SingleChildScrollView(

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

                // ====================================
                // SUMMARY
                // ====================================

                _buildSummary(
                  unlockedCount,
                  totalCount,
                ),

                const SizedBox(
                  height: 28,
                ),

                const Text(
                  'Your Achievements',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                // ====================================
                // ACHIEVEMENTS
                // ====================================

                ..._achievementDefinitions
                    .map(
                      (
                      definition,
                      ) {

                    final backend =
                    _findUnlocked(
                      definition.code,
                    );

                    final unlocked =
                        backend != null;

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 12,
                      ),

                      child:
                      _AchievementCard(
                        definition:
                        definition,

                        backendAchievement:
                        backend,

                        unlocked:
                        unlocked,

                        icon:
                        _getIcon(
                          definition,
                          backend,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummary(
      int unlocked,
      int total,
      ) {

    final double progress =
    total == 0
        ? 0
        : unlocked / total;

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(22),

      decoration:
      BoxDecoration(

        gradient:
        const LinearGradient(

          begin:
          Alignment.topLeft,

          end:
          Alignment.bottomRight,

          colors: [
            Color(0xFF6C63A8),
            Color(0xFF8178BB),
          ],
        ),

        borderRadius:
        BorderRadius.circular(26),
      ),

      child: Column(

        children: [

          Row(

            children: [

              Container(

                width: 66,
                height: 66,

                decoration:
                BoxDecoration(

                  color: Colors.white
                      .withValues(
                    alpha: 0.16,
                  ),

                  shape:
                  BoxShape.circle,
                ),

                child: const Icon(
                  Icons.emoji_events_rounded,

                  color:
                  Colors.white,

                  size: 34,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Keep going!',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      '$unlocked of $total achievements unlocked',

                      style:
                      const TextStyle(
                        fontSize: 13,
                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // ================================================
          // ACHIEVEMENT PROGRESS
          // ================================================

          ClipRRect(

            borderRadius:
            BorderRadius.circular(10),

            child:
            LinearProgressIndicator(

              value: progress,

              minHeight: 8,

              backgroundColor:
              Colors.white
                  .withValues(
                alpha: 0.20,
              ),

              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Align(

            alignment:
            Alignment.centerRight,

            child: Text(
              '${(progress * 100).round()}%',

              style:
              const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w800,
                color:
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState() {

    return Center(

      child: Padding(

        padding:
        const EdgeInsets.all(30),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.error_outline_rounded,

              size: 60,

              color:
              Color(0xFFE56B5D),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'Could not load achievements',

              textAlign:
              TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w800,
                color:
                Color(0xFF29263D),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              _errorMessage ??
                  'Something went wrong.',

              textAlign:
              TextAlign.center,

              style:
              const TextStyle(
                fontSize: 13,
                color:
                Color(0xFF777281),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(

              onPressed:
              _loadAchievements,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label:
              const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ACHIEVEMENT DEFINITION
// ============================================================

class _AchievementDefinition {

  final String code;

  final String fallbackTitle;

  final String fallbackDescription;

  final String fallbackIcon;

  final int fallbackXp;

  final IconData materialIcon;

  const _AchievementDefinition({
    required this.code,
    required this.fallbackTitle,
    required this.fallbackDescription,
    required this.fallbackIcon,
    required this.fallbackXp,
    required this.materialIcon,
  });
}

// ============================================================
// ACHIEVEMENT CARD
// ============================================================

class _AchievementCard
    extends StatelessWidget {

  final _AchievementDefinition definition;

  final Map<String, dynamic>?
  backendAchievement;

  final bool unlocked;

  final IconData icon;

  const _AchievementCard({
    required this.definition,
    required this.backendAchievement,
    required this.unlocked,
    required this.icon,
  });

  @override
  Widget build(
      BuildContext context,
      ) {

    // ==========================================================
    // REAL BACKEND VALUES
    // ==========================================================

    final title =
    backendAchievement?['title']
        ?.toString()
        .trim()
        .isNotEmpty ==
        true
        ? backendAchievement!['title']
        .toString()
        : definition.fallbackTitle;

    final description =
    backendAchievement?['description']
        ?.toString()
        .trim()
        .isNotEmpty ==
        true
        ? backendAchievement!['description']
        .toString()
        : definition.fallbackDescription;

    final xp =
        int.tryParse(
          backendAchievement?['xpReward']
              ?.toString() ??
              '',
        ) ??
            definition.fallbackXp;

    final backendIcon =
    backendAchievement?['icon']
        ?.toString();

    final unlockedAt =
    backendAchievement?['unlockedAt']
        ?.toString();

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(17),

      decoration:
      BoxDecoration(

        color: unlocked
            ? Colors.white
            : const Color(0xFFF3F1F5),

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color:
          const Color(0xFFE7E2EC),
        ),
      ),

      child: Row(

        children: [

          // ====================================================
          // ICON
          // ====================================================

          Container(

            width: 58,
            height: 58,

            decoration:
            BoxDecoration(

              color: unlocked
                  ? const Color(0xFFFFF4D8)
                  : const Color(0xFFE4E1E7),

              shape:
              BoxShape.circle,
            ),

            child: Center(

              child: unlocked &&
                  backendIcon != null &&
                  backendIcon.isNotEmpty

                  ? Text(
                backendIcon,

                style:
                const TextStyle(
                  fontSize: 27,
                ),
              )

                  : Icon(
                unlocked
                    ? icon
                    : Icons.lock_rounded,

                color: unlocked
                    ? const Color(
                  0xFFE5A83B,
                )
                    : const Color(
                  0xFF9994A3,
                ),

                size: 28,
              ),
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          // ====================================================
          // DETAILS
          // ====================================================

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

                const SizedBox(
                  height: 4,
                ),

                Text(
                  description,

                  style:
                  const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color:
                    Color(0xFF777281),
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Row(

                  children: [

                    Text(
                      '+$xp XP',

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w800,
                        color: unlocked
                            ? const Color(
                          0xFFE5A83B,
                        )
                            : const Color(
                          0xFF9994A3,
                        ),
                      ),
                    ),

                    if (unlocked &&
                        unlockedAt != null &&
                        unlockedAt.isNotEmpty) ...[

                      const SizedBox(
                        width: 8,
                      ),

                      const Text(
                        '•',

                        style:
                        TextStyle(
                          color:
                          Color(0xFFB5B0BC),
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      const Text(
                        'Unlocked',

                        style:
                        TextStyle(
                          fontSize: 10,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          Color(0xFF55B97A),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ====================================================
          // CHECK / LOCK
          // ====================================================

          if (unlocked)

            const Icon(
              Icons.check_circle_rounded,

              color:
              Color(0xFF55B97A),

              size: 22,
            )
          else

            const Icon(
              Icons.lock_outline_rounded,

              color:
              Color(0xFF9994A3),

              size: 20,
            ),
        ],
      ),
    );
  }
}