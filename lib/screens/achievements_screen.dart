import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      const Achievement(
        icon: Icons.front_hand_rounded,
        title: 'First Sign',
        description: 'Learn your first ISL sign.',
        reward: '+25 XP',
        unlocked: true,
      ),
      const Achievement(
        icon: Icons.local_fire_department_rounded,
        title: '7 Day Streak',
        description: 'Learn for 7 consecutive days.',
        reward: '+50 XP',
        unlocked: true,
      ),
      const Achievement(
        icon: Icons.menu_book_rounded,
        title: 'Quick Learner',
        description: 'Complete 10 lessons.',
        reward: '+100 XP',
        unlocked: true,
      ),
      const Achievement(
        icon: Icons.workspace_premium_rounded,
        title: 'Perfect Score',
        description: 'Score 100% on a quiz.',
        reward: '+75 XP',
        unlocked: false,
      ),
      const Achievement(
        icon: Icons.front_hand_rounded,
        title: 'Sign Explorer',
        description: 'Learn 50 different signs.',
        reward: '+150 XP',
        unlocked: false,
      ),
      const Achievement(
        icon: Icons.local_fire_department_rounded,
        title: '30 Day Streak',
        description: 'Maintain a 30 day learning streak.',
        reward: '+250 XP',
        unlocked: false,
      ),
      const Achievement(
        icon: Icons.school_rounded,
        title: 'ISL Scholar',
        description: 'Complete the entire Beginner level.',
        reward: '+300 XP',
        unlocked: false,
      ),
      const Achievement(
        icon: Icons.emoji_events_rounded,
        title: 'Conversation Ready',
        description: 'Complete your first conversation practice.',
        reward: '+200 XP',
        unlocked: false,
      ),
    ];

    final unlocked =
        achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF29263D),
          ),
        ),
        title: const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummary(unlocked, achievements.length),

              const SizedBox(height: 28),

              const Text(
                'Your Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 14),

              ...achievements.map(
                    (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AchievementCard(
                    achievement: achievement,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(int unlocked, int total) {
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
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep going!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$unlocked of $total achievements unlocked',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white
            : const Color(0xFFF3F1F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFFFFF4D8)
                  : const Color(0xFFE4E1E7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked
                  ? achievement.icon
                  : Icons.lock_rounded,
              color: unlocked
                  ? const Color(0xFFE5A83B)
                  : const Color(0xFF9994A3),
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
                  achievement.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Color(0xFF777281),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  achievement.reward,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: unlocked
                        ? const Color(0xFFE5A83B)
                        : const Color(0xFF9994A3),
                  ),
                ),
              ],
            ),
          ),

          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF55B97A),
              size: 22,
            ),
        ],
      ),
    );
  }
}

class Achievement {
  final IconData icon;
  final String title;
  final String description;
  final String reward;
  final bool unlocked;

  const Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.reward,
    required this.unlocked,
  });
}