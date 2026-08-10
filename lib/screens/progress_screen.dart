import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'My Progress',
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
              _buildOverallProgress(),

              const SizedBox(height: 24),

              _buildStats(),

              const SizedBox(height: 28),

              const Text(
                'Learning Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 14),

              _buildActivityCard(),

              const SizedBox(height: 28),

              const Text(
                'Learning Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 14),

              _buildLevelProgress(
                title: 'Beginner',
                subtitle: 'Greetings, Numbers & Basic Words',
                progress: 0.62,
                percentage: '62%',
                color: const Color(0xFF6C63A8),
              ),

              const SizedBox(height: 12),

              _buildLevelProgress(
                title: 'Intermediate',
                subtitle: 'Daily Life & Conversations',
                progress: 0.18,
                percentage: '18%',
                color: const Color(0xFF5E9D9A),
              ),

              const SizedBox(height: 12),

              _buildLevelProgress(
                title: 'Advanced',
                subtitle: 'Fluency & Complex Sentences',
                progress: 0.0,
                percentage: 'Locked',
                color: const Color(0xFFB7B2BF),
              ),

              const SizedBox(height: 28),

              const Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 14),

              _buildAchievement(
                icon: Icons.front_hand_rounded,
                title: 'First Sign',
                subtitle: 'Learned your first ISL sign',
                unlocked: true,
              ),

              const SizedBox(height: 10),

              _buildAchievement(
                icon: Icons.local_fire_department_rounded,
                title: '7 Day Streak',
                subtitle: 'Learned for 7 consecutive days',
                unlocked: true,
              ),

              const SizedBox(height: 10),

              _buildAchievement(
                icon: Icons.workspace_premium_rounded,
                title: 'Perfect Score',
                subtitle: 'Score 100% in a quiz',
                unlocked: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Your Learning Journey',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '42%',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  'overall',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.42,
              minHeight: 9,
              backgroundColor: Color(0x55FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.bolt_rounded,
            value: '1,240',
            label: 'Total XP',
            background: const Color(0xFFFFF4D8),
            iconColor: const Color(0xFFE5A83B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            value: '7',
            label: 'Day Streak',
            background: const Color(0xFFFDEBEC),
            iconColor: const Color(0xFFD96B73),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.menu_book_rounded,
            value: '12',
            label: 'Lessons',
            background: const Color(0xFFE8E4F7),
            iconColor: const Color(0xFF6C63A8),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard() {
    final activity = [
      ('Mon', 0.65),
      ('Tue', 0.90),
      ('Wed', 0.45),
      ('Thu', 0.75),
      ('Fri', 0.30),
      ('Sat', 1.00),
      ('Sun', 0.55),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
                  'This Week',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
              ),
              Text(
                '5 / 7 days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6C63A8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: activity.map((item) {
                return _ActivityBar(
                  day: item.$1,
                  value: item.$2,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress({
    required String title,
    required String subtitle,
    required double progress,
    required String percentage,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A8695),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFEDEAF1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool unlocked,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white
            : const Color(0xFFF3F1F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFFFFF4D8)
                  : const Color(0xFFE5E2E8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked ? icon : Icons.lock_rounded,
              color: unlocked
                  ? const Color(0xFFE5A83B)
                  : const Color(0xFF9994A3),
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8695),
                  ),
                ),
              ],
            ),
          ),

          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF55B97A),
              size: 21,
            ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
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
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF29263D),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF777281),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityBar extends StatelessWidget {
  final String day;
  final double value;

  const _ActivityBar({
    required this.day,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value,
              child: Container(
                width: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63A8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8A8695),
          ),
        ),
      ],
    );
  }
}