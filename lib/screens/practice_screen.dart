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

  final List<Map<String, String>> signs = [
    {
      'word': 'Hello',
      'description': 'Practice the sign for Hello.',
    },
    {
      'word': 'Thank You',
      'description': 'Practice the sign for Thank You.',
    },
    {
      'word': 'Goodbye',
      'description': 'Practice the sign for Goodbye.',
    },
    {
      'word': 'Sorry',
      'description': 'Practice the sign for Sorry.',
    },
    {
      'word': 'Please',
      'description': 'Practice the sign for Please.',
    },
  ];

  void nextSign() {
    if (currentIndex < signs.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      showPracticeComplete();
    }
  }

  void previousSign() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void showPracticeComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Practice Complete!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Great job! You reviewed all the signs in this lesson.',
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Practice',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE7E2EC),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63A8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentIndex + 1}/${signs.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C63A8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Practice this sign',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777281),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  sign['word']!,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E4F7),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.front_hand_rounded,
                      size: 100,
                      color: Color(0xFF6C63A8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                sign['description']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777281),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                      currentIndex == 0 ? null : previousSign,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: nextSign,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        backgroundColor: const Color(0xFF6C63A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        currentIndex == signs.length - 1
                            ? 'Finish'
                            : 'Next',
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
}