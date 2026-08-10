import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String chapterTitle;

  const QuizScreen({
    super.key,
    required this.chapterTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  final List<QuizQuestion> questions = const [
    QuizQuestion(
      word: 'Hello',
      question: 'What does this sign mean?',
      options: [
        'Hello',
        'Goodbye',
        'Sorry',
        'Thank You',
      ],
      correctAnswer: 0,
    ),
    QuizQuestion(
      word: 'Thank You',
      question: 'Choose the correct meaning.',
      options: [
        'Please',
        'Thank You',
        'Good Morning',
        'Sorry',
      ],
      correctAnswer: 1,
    ),
    QuizQuestion(
      word: 'Good Morning',
      question: 'Which phrase does this sign represent?',
      options: [
        'Goodbye',
        'Hello',
        'Good Morning',
        'Thank You',
      ],
      correctAnswer: 2,
    ),
    QuizQuestion(
      word: 'Goodbye',
      question: 'What does this sign mean?',
      options: [
        'Sorry',
        'Please',
        'Thank You',
        'Goodbye',
      ],
      correctAnswer: 3,
    ),
    QuizQuestion(
      word: 'Sorry',
      question: 'Select the correct meaning.',
      options: [
        'Sorry',
        'Hello',
        'Please',
        'Goodbye',
      ],
      correctAnswer: 0,
    ),
  ];

  QuizQuestion get question => questions[currentQuestion];

  double get progress =>
      (currentQuestion + 1) / questions.length;

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == question.correctAnswer) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (!answered) return;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      showQuizResult();
    }
  }

  void showQuizResult() {
    final percentage =
    ((score / questions.length) * 100).round();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          chapterTitle: widget.chapterTitle,
          score: score,
          total: questions.length,
          percentage: percentage,
        ),
      ),
    );
  }

  Color optionColor(int index) {
    if (!answered) {
      return Colors.white;
    }

    if (index == question.correctAnswer) {
      return const Color(0xFFE8F5EC);
    }

    if (index == selectedAnswer) {
      return const Color(0xFFFDEBEC);
    }

    return Colors.white;
  }

  Color optionBorderColor(int index) {
    if (!answered) {
      return const Color(0xFFE4DFEA);
    }

    if (index == question.correctAnswer) {
      return const Color(0xFF55B97A);
    }

    if (index == selectedAnswer) {
      return const Color(0xFFD96B73);
    }

    return const Color(0xFFE4DFEA);
  }

  IconData? optionIcon(int index) {
    if (!answered) return null;

    if (index == question.correctAnswer) {
      return Icons.check_circle_rounded;
    }

    if (index == selectedAnswer) {
      return Icons.cancel_rounded;
    }

    return null;
  }

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
            Icons.close_rounded,
            color: Color(0xFF29263D),
          ),
        ),
        title: const Text(
          'Quick Quiz',
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
              padding: const EdgeInsets.fromLTRB(
                24,
                8,
                24,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor:
                        const Color(0xFFE8E4F2),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63A8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentQuestion + 1}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF777281),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // Chapter
                    Center(
                      child: Text(
                        widget.chapterTitle.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Color(0xFF6C63A8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Question
                    Center(
                      child: Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF29263D),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Sign visual placeholder
                    Container(
                      width: double.infinity,
                      height: 230,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FA),
                        borderRadius:
                        BorderRadius.circular(26),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 105,
                            height: 105,
                            decoration:
                            const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.front_hand_rounded,
                              size: 58,
                              color: Color(0xFF6C63A8),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'ISL SIGN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                              color: Color(0xFF8A8695),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.word,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF29263D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Choose your answer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Options
                    ...List.generate(
                      question.options.length,
                          (index) => Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),
                        child: _AnswerOption(
                          number: index + 1,
                          text: question.options[index],
                          backgroundColor:
                          optionColor(index),
                          borderColor:
                          optionBorderColor(index),
                          icon: optionIcon(index),
                          onTap: () =>
                              selectAnswer(index),
                        ),
                      ),
                    ),

                    // Feedback
                    if (answered)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 4,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedAnswer ==
                              question.correctAnswer
                              ? const Color(0xFFE8F5EC)
                              : const Color(0xFFFDEBEC),
                          borderRadius:
                          BorderRadius.circular(17),
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Icon(
                              selectedAnswer ==
                                  question.correctAnswer
                                  ? Icons
                                  .check_circle_rounded
                                  : Icons
                                  .info_outline_rounded,
                              color: selectedAnswer ==
                                  question.correctAnswer
                                  ? const Color(0xFF55B97A)
                                  : const Color(0xFFD96B73),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedAnswer ==
                                    question.correctAnswer
                                    ? 'Correct! Great job.'
                                    : 'Not quite. The correct answer is "${question.options[question.correctAnswer]}".',
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Color(0xFF555162),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                12,
                24,
                20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed:
                  answered ? nextQuestion : null,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF6C63A8),
                    disabledBackgroundColor:
                    const Color(0xFFDAD6E5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    currentQuestion ==
                        questions.length - 1 &&
                        answered
                        ? 'See Results'
                        : 'Next Question',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final int number;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.number,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: borderColor,
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6C63A8),
                  ),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF29263D),
                  ),
                ),
              ),

              if (icon != null)
                Icon(
                  icon,
                  size: 22,
                  color: icon ==
                      Icons.check_circle_rounded
                      ? const Color(0xFF55B97A)
                      : const Color(0xFFD96B73),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String word;
  final String question;
  final List<String> options;
  final int correctAnswer;

  const QuizQuestion({
    required this.word,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

// ------------------------------------------------------------
// QUIZ RESULT SCREEN
// ------------------------------------------------------------

class QuizResultScreen extends StatelessWidget {
  final String chapterTitle;
  final int score;
  final int total;
  final int percentage;

  const QuizResultScreen({
    super.key,
    required this.chapterTitle,
    required this.score,
    required this.total,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final bool passed = percentage >= 60;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFFE8F5EC)
                      : const Color(0xFFFDEBEC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed
                      ? Icons.emoji_events_rounded
                      : Icons.refresh_rounded,
                  size: 54,
                  color: passed
                      ? const Color(0xFF55B97A)
                      : const Color(0xFFD96B73),
                ),
              ),

              const SizedBox(height: 26),

              Text(
                passed ? 'Great Job!' : 'Keep Practicing!',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You completed the $chapterTitle quiz.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777281),
                ),
              ),

              const SizedBox(height: 28),

              // Score
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE7E2EC),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF6C63A8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score / $total correct',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777281),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFE5A83B),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '+25 XP',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6D5620),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF6C63A8),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Back to Learning',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        chapterTitle: chapterTitle,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Try Quiz Again',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6C63A8),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}