import 'package:flutter/material.dart';

import 'lesson_screen.dart';
import 'practice_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF777281);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFDFBFF),
              Color(0xFFF4F1FF),
              Color(0xFFFFF7FB),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                top: 70,
                left: -120,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x186C63A8),
                  ),
                ),
              ),

              Positioned(
                top: 560,
                right: -120,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x18F0A6C3),
                  ),
                ),
              ),

              Positioned(
                bottom: 120,
                left: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x16A9B8FF),
                  ),
                ),
              ),

              Column(
                children: [
                  _buildHeader(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          const Text(
                            'Your ISL Journey',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Learn, practice, and unlock your journey',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryText,
                            ),
                          ),

                          const SizedBox(height: 30),

                          const _LearningPath(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFEAE6F8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x146C63A8),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.sign_language_rounded,
              size: 30,
              color: primary,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learning Path',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Learn Indian Sign Language',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Color(0xAAFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Color(0xFFDCD6EB),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bolt_rounded,
                  size: 21,
                  color: primary,
                ),
                SizedBox(height: 1),
                Text(
                  '0',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                Text(
                  'XP',
                  style: TextStyle(
                    fontSize: 9,
                    color: secondaryText,
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

// ============================================================
// LEARNING PATH
// ============================================================

class _LearningPath extends StatelessWidget {
  const _LearningPath();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4300,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PathPainter(width: width),
                ),
              ),

              // ========================================================
              // 1. GREETINGS
              // ========================================================

              Positioned(
                top: 10,
                left: width / 2 - 80,
                child: _LessonNode(
                  title: 'Greetings',
                  icon: Icons.waving_hand_rounded,
                  unlocked: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LessonScreen(
                          level: 'Foundation',
                          chapterTitle: 'Greetings',
                          chapterSubtitle:
                          'Learn common greetings in Indian Sign Language.',
                          chapterNumber: 1,
                          xp: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // PRACTICE 1
              Positioned(
                top: 300,
                left: width * 0.18,
                child: _PracticeNode(
                  unlocked: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PracticeScreen(
                          chapterTitle: 'Greetings',
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ========================================================
              // 2. NUMBERS
              // ========================================================

              Positioned(
                top: 570,
                right: width * 0.12,
                child: const _LessonNode(
                  title: 'Numbers',
                  icon: Icons.numbers_rounded,
                  unlocked: false,
                ),
              ),

              // PRACTICE 2
              Positioned(
                top: 870,
                left: width * 0.30,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 3. COLORS
              // ========================================================

              Positioned(
                top: 1140,
                left: width * 0.12,
                child: const _LessonNode(
                  title: 'Colors',
                  icon: Icons.palette_rounded,
                  unlocked: false,
                ),
              ),

              // PRACTICE 3
              Positioned(
                top: 1440,
                right: width * 0.18,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 4. BASIC WORDS
              // ========================================================

              Positioned(
                top: 1710,
                left: width / 2 - 80,
                child: const _LessonNode(
                  title: 'Basic Words',
                  icon: Icons.abc_rounded,
                  unlocked: false,
                ),
              ),

              // PRACTICE 4
              Positioned(
                top: 2010,
                left: width * 0.18,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 5. FAMILY
              // ========================================================

              Positioned(
                top: 2280,
                right: width * 0.12,
                child: const _LessonNode(
                  title: 'Family',
                  icon: Icons.family_restroom_rounded,
                  unlocked: false,
                ),
              ),

              // PRACTICE 5
              Positioned(
                top: 2580,
                left: width * 0.30,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 6. FOOD & DRINKS
              // ========================================================

              Positioned(
                top: 2850,
                left: width * 0.12,
                child: const _LessonNode(
                  title: 'Food & Drinks',
                  icon: Icons.restaurant_rounded,
                  unlocked: false,
                ),
              ),

              // PRACTICE 6
              Positioned(
                top: 3150,
                right: width * 0.18,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 7. DAILY LIFE
              // ========================================================

              Positioned(
                top: 3420,
                left: width / 2 - 80,
                child: const _LessonNode(
                  title: 'Daily Life',
                  icon: Icons.wb_sunny_outlined,
                  unlocked: false,
                ),
              ),

              // PRACTICE 7
              Positioned(
                top: 3720,
                left: width * 0.18,
                child: const _PracticeNode(
                  unlocked: false,
                ),
              ),

              // ========================================================
              // 8. SCHOOL & WORK
              // ========================================================

              Positioned(
                top: 3990,
                right: width * 0.12,
                child: const _LessonNode(
                  title: 'School & Work',
                  icon: Icons.school_rounded,
                  unlocked: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// LESSON NODE
// ============================================================

class _LessonNode extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool unlocked;
  final VoidCallback? onTap;

  const _LessonNode({
    required this.title,
    required this.icon,
    required this.unlocked,
    this.onTap,
  });

  static const Color primary = Color(0xFF6C63A8);

  @override
  Widget build(BuildContext context) {
    final size = unlocked ? 128.0 : 122.0;

    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? Colors.white.withOpacity(0.90)
                    : const Color(0xFFE9E8EE),
                border: Border.all(
                  color: unlocked
                      ? primary
                      : const Color(0xFFC7C5D0),
                  width: unlocked ? 5 : 4,
                ),
                boxShadow: unlocked
                    ? const [
                  BoxShadow(
                    color: Color(0x256C63A8),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: Icon(
                unlocked ? icon : Icons.lock_rounded,
                size: unlocked ? 58 : 48,
                color: unlocked
                    ? primary
                    : const Color(0xFF9694A1),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: unlocked
                    ? const Color(0xFF29263D)
                    : const Color(0xFF85828E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRACTICE NODE
// ============================================================

class _PracticeNode extends StatelessWidget {
  final bool unlocked;
  final VoidCallback? onTap;

  const _PracticeNode({
    required this.unlocked,
    this.onTap,
  });

  static const Color primary = Color(0xFF6C63A8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: SizedBox(
        width: 145,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? const Color(0xFFF2EFFF)
                    : const Color(0xFFE9E8EE),
                border: Border.all(
                  color: unlocked
                      ? primary.withOpacity(0.55)
                      : const Color(0xFFC7C5D0),
                  width: 4,
                ),
                boxShadow: unlocked
                    ? const [
                  BoxShadow(
                    color: Color(0x186C63A8),
                    blurRadius: 15,
                  ),
                ]
                    : [],
              ),
              child: Icon(
                unlocked
                    ? Icons.videocam_rounded
                    : Icons.lock_rounded,
                size: 36,
                color: unlocked
                    ? primary
                    : const Color(0xFF9694A1),
              ),
            ),

            const SizedBox(height: 9),

            Text(
              'Practice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: unlocked
                    ? const Color(0xFF4C485B)
                    : const Color(0xFF85828E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CONTINUOUS PATH PAINTER
// ============================================================

class _PathPainter extends CustomPainter {
  final double width;

  _PathPainter({
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9C7DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Greetings
    path.moveTo(width * 0.50, 135);

    // Greetings -> Practice
    path.cubicTo(
      width * 0.48,
      210,
      width * 0.30,
      250,
      width * 0.25,
      340,
    );

    // Practice -> Numbers
    path.cubicTo(
      width * 0.20,
      450,
      width * 0.70,
      500,
      width * 0.76,
      620,
    );

    // Numbers -> Practice
    path.cubicTo(
      width * 0.82,
      740,
      width * 0.42,
      760,
      width * 0.37,
      920,
    );

    // Practice -> Colors
    path.cubicTo(
      width * 0.34,
      1020,
      width * 0.25,
      1060,
      width * 0.22,
      1190,
    );

    // Colors -> Practice
    path.cubicTo(
      width * 0.20,
      1320,
      width * 0.70,
      1360,
      width * 0.76,
      1490,
    );

    // Practice -> Basic Words
    path.cubicTo(
      width * 0.80,
      1600,
      width * 0.55,
      1640,
      width * 0.50,
      1770,
    );

    // Basic Words -> Practice
    path.cubicTo(
      width * 0.45,
      1900,
      width * 0.30,
      1930,
      width * 0.25,
      2060,
    );

    // Practice -> Family
    path.cubicTo(
      width * 0.20,
      2170,
      width * 0.70,
      2200,
      width * 0.76,
      2340,
    );

    // Family -> Practice
    path.cubicTo(
      width * 0.82,
      2460,
      width * 0.42,
      2500,
      width * 0.37,
      2630,
    );

    // Practice -> Food & Drinks
    path.cubicTo(
      width * 0.34,
      2740,
      width * 0.25,
      2780,
      width * 0.22,
      2910,
    );

    // Food & Drinks -> Practice
    path.cubicTo(
      width * 0.20,
      3040,
      width * 0.70,
      3070,
      width * 0.76,
      3200,
    );

    // Practice -> Daily Life
    path.cubicTo(
      width * 0.80,
      3310,
      width * 0.55,
      3360,
      width * 0.50,
      3480,
    );

    // Daily Life -> Practice
    path.cubicTo(
      width * 0.45,
      3610,
      width * 0.30,
      3650,
      width * 0.25,
      3780,
    );

    // Practice -> School & Work
    path.cubicTo(
      width * 0.20,
      3890,
      width * 0.70,
      3920,
      width * 0.76,
      4050,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.width != width;
  }
}