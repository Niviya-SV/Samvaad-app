import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Practice',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color(0xFF29263D),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFF08A34),
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  '7',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6D542F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Turn learning into confidence.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777281),
                ),
              ),

              const SizedBox(height: 22),

              _buildDailyChallenge(context),

              const SizedBox(height: 30),

              const Text(
                'Practice Your Skills',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choose an activity and keep improving.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777281),
                ),
              ),

              const SizedBox(height: 16),

              _buildCameraCard(context),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildPracticeCard(
                      context,
                      icon: Icons.play_circle_fill_rounded,
                      title: 'Watch & Copy',
                      subtitle: 'Watch and copy signs',
                      xp: '+10 XP',
                      color: const Color(0xFF6C63A8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPracticeCard(
                      context,
                      icon: Icons.quiz_rounded,
                      title: 'Quick Quiz',
                      subtitle: 'Test your knowledge',
                      xp: '+15 XP',
                      color: const Color(0xFF55A878),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildPracticeCard(
                      context,
                      icon: Icons.extension_rounded,
                      title: 'Sentence Builder',
                      subtitle: 'Build sentences',
                      xp: '+20 XP',
                      color: const Color(0xFFE39A3E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPracticeCard(
                      context,
                      icon: Icons.pan_tool_alt_rounded,
                      title: 'Fingerspelling',
                      subtitle: 'Practice A–Z',
                      xp: '+15 XP',
                      color: const Color(0xFFDB6F88),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildProgressCard(),

              const SizedBox(height: 25),

              _buildTipCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DAILY CHALLENGE
  // ============================================================

  Widget _buildDailyChallenge(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C63A8),
            Color(0xFF8277BE),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'DAILY CHALLENGE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Practice 5 signs today',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Complete your daily challenge and earn bonus XP.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.2,
                    minHeight: 7,
                    backgroundColor: Color(0x55FFFFFF),
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '1 / 5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 43,
            child: ElevatedButton(
              onPressed: () {
                _showMessage(
                  context,
                  'Daily Challenge',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C63A8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue Challenge',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CAMERA PRACTICE
  // ============================================================

  Widget _buildCameraCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMessage(
          context,
          'Camera Practice will be connected soon.',
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE7E2EC),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E4F7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.videocam_rounded,
                color: Color(0xFF6C63A8),
                size: 32,
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camera Practice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF29263D),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Practice your signs using the camera.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Color(0xFF777281),
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    '+25 XP  •  AI Practice',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C63A8),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF898491),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRACTICE CARD
  // ============================================================

  Widget _buildPracticeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String xp,
        required Color color,
      }) {
    return GestureDetector(
      onTap: () {
        _showMessage(
          context,
          '$title will be connected soon.',
        );
      },
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: const Color(0xFFE7E2EC),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29263D),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.3,
                color: Color(0xFF817C89),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              xp,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Practice Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF29263D),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              _progressItem(
                Icons.front_hand_rounded,
                '12',
                'Signs',
              ),
              _progressItem(
                Icons.quiz_rounded,
                '4',
                'Quizzes',
              ),
              _progressItem(
                Icons.emoji_events_rounded,
                '2',
                'Challenges',
              ),
              _progressItem(
                Icons.bolt_rounded,
                '240',
                'XP',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressItem(
      IconData icon,
      String value,
      String label,
      ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 21,
          color: const Color(0xFF6C63A8),
        ),
        const SizedBox(height: 7),
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
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF85808E),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TIP
  // ============================================================

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEF9),
        borderRadius: BorderRadius.circular(21),
      ),
      child: const Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            '💡',
            style: TextStyle(
              fontSize: 27,
            ),
          ),

          SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice tip',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Practice a few signs every day instead of trying to learn everything at once.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF777281),
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
  // MESSAGE
  // ============================================================

  static void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}