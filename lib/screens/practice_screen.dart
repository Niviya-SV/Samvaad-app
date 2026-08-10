import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  final String chapterTitle;

  const PracticeScreen({
    super.key,
    required this.chapterTitle,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int currentIndex = 0;
  bool showAnswer = false;

  final List<Map<String, String>> signs = [
    {
      'word': 'Hello',
      'description': 'A friendly greeting used when meeting someone.',
    },
    {
      'word': 'Thank You',
      'description': 'Used to express gratitude or appreciation.',
    },
    {
      'word': 'Good Morning',
      'description': 'A greeting used in the morning.',
    },
    {
      'word': 'Goodbye',
      'description': 'Used when leaving or saying farewell.',
    },
  ];

  void nextSign() {
    if (currentIndex < signs.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    } else {
      showPracticeComplete();
    }
  }

  void previousSign() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void showPracticeComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFBF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 38,
                  color: Color(0xFF55B97A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Practice Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You practiced all ${signs.length} signs in ${widget.chapterTitle}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF777281),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Back to Learning',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sign = signs[currentIndex];
    final progress = (currentIndex + 1) / signs.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF29263D),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Practice',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor: const Color(0xFFE8E4F2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63A8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentIndex + 1}/${signs.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF777281),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Chapter label
                    Text(
                      widget.chapterTitle.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF6C63A8),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Practice this sign',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Look at the sign and practice it yourself.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777281),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Sign demonstration card
                    Container(
                      width: double.infinity,
                      height: 310,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFE7E2EF),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Temporary avatar/sign placeholder
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE9FA),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.front_hand_rounded,
                                size: 82,
                                color: Color(0xFF6C63A8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            sign['word']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF29263D),
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'Sign demonstration',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9994A3),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Information
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: showAnswer
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FB),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Color(0xFF6C63A8),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Try making the sign yourself before checking the meaning.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Color(0xFF555162),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      secondChild: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7EE),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF4EAA70),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Meaning',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF3C8156),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    sign['description']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: Color(0xFF555162),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Show meaning
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          showAnswer = !showAnswer;
                        });
                      },
                      icon: Icon(
                        showAnswer
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      label: Text(
                        showAnswer ? 'Hide Meaning' : 'Show Meaning',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63A8),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom controls
            Container(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: currentIndex == 0 ? null : previousSign,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: nextSign,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63A8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentIndex == signs.length - 1
                                  ? 'Finish Practice'
                                  : 'Next Sign',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}