import 'package:flutter/material.dart';
import 'lesson_complete_screen.dart';
class LessonScreen extends StatefulWidget {
  final String chapterTitle;
  final String chapterSubtitle;
  final int chapterNumber;
  final int xp;

  const LessonScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterSubtitle,
    required this.chapterNumber,
    required this.xp,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currentIndex = 0;

  final List<LessonItem> lessons = const [
    LessonItem(
      word: 'Hello',
      meaning: 'A friendly greeting used when meeting someone.',
      example: 'Hello! How are you?',
      icon: Icons.waving_hand_rounded,
    ),
    LessonItem(
      word: 'Thank You',
      meaning: 'Used to express gratitude or appreciation.',
      example: 'Thank you for helping me.',
      icon: Icons.favorite_rounded,
    ),
    LessonItem(
      word: 'Goodbye',
      meaning: 'Used when leaving or ending a conversation.',
      example: 'Goodbye! See you tomorrow.',
      icon: Icons.waving_hand_rounded,
    ),
    LessonItem(
      word: 'Sorry',
      meaning: 'Used when apologizing to someone.',
      example: 'Sorry, I made a mistake.',
      icon: Icons.sentiment_satisfied_alt_rounded,
    ),
    LessonItem(
      word: 'Please',
      meaning: 'A polite word used when making a request.',
      example: 'Please help me.',
      icon: Icons.pan_tool_alt_rounded,
    ),
  ];

  LessonItem get currentLesson => lessons[currentIndex];

  double get progress => (currentIndex + 1) / lessons.length;

  void nextLesson() {
    if (currentIndex < lessons.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      showCompletionScreen();
    }
  }

  void previousLesson() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }
  void showCompletionScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LessonCompleteScreen(
          chapterTitle: widget.chapterTitle,
          xp: widget.xp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            _buildProgress(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                child: Column(
                  children: [
                    _buildLessonHeader(),

                    const SizedBox(height: 22),

                    _buildSignCard(),

                    const SizedBox(height: 22),

                    _buildMeaningCard(),

                    const SizedBox(height: 22),

                    _buildExampleCard(),
                  ],
                ),
              ),
            ),

            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF29263D),
            ),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chapterTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
                Text(
                  'Chapter ${widget.chapterNumber}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8695),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 17,
                  color: Color(0xFFE5A83B),
                ),
                const SizedBox(width: 3),
                Text(
                  '${widget.xp} XP',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6D5620),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PROGRESS
  // ------------------------------------------------------------

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE9E5EF),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      Color(0xFF6C63A8),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                '${currentIndex + 1}/${lessons.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6C63A8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // LESSON HEADER
  // ------------------------------------------------------------

  Widget _buildLessonHeader() {
    return Column(
      children: [
        const Text(
          'Learn this sign',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          widget.chapterSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF777281),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SIGN CARD
  // ------------------------------------------------------------

  Widget _buildSignCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 270,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF2EFFB),
                  Color(0xFFE9E5F7),
                ],
              ),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Icon(
                    currentLesson.icon,
                    size: 55,
                    color: const Color(0xFF6C63A8),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'SIGN VISUAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: Color(0xFF8A8695),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'AI instructor coming soon',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9A96A4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            currentLesson.word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF29263D),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Indian Sign Language • ISL',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8A8695),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // MEANING
  // ------------------------------------------------------------

  Widget _buildMeaningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E4F7),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF6C63A8),
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meaning',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  currentLesson.meaning,
                  style: const TextStyle(
                    fontSize: 13,
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

  // ------------------------------------------------------------
  // EXAMPLE
  // ------------------------------------------------------------

  Widget _buildExampleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7E2EC),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Color(0xFF6C63A8),
            size: 27,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Example',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '"${currentLesson.example}"',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontStyle: FontStyle.italic,
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

  // ------------------------------------------------------------
  // BOTTOM CONTROLS
  // ------------------------------------------------------------

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: OutlinedButton(
              onPressed: currentIndex == 0 ? null : previousLesson,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: const BorderSide(
                  color: Color(0xFFDCD7E5),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: nextLesson,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63A8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentIndex == lessons.length - 1
                          ? 'Complete Lesson'
                          : 'Next Sign',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonItem {
  final String word;
  final String meaning;
  final String example;
  final IconData icon;

  const LessonItem({
    required this.word,
    required this.meaning,
    required this.example,
    required this.icon,
  });
}