import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import 'practice_screen.dart';

class LessonScreen extends StatefulWidget {
  final String level;
  final String chapterTitle;
  final String chapterSubtitle;
  final int chapterNumber;
  final int xp;

  const LessonScreen({
    super.key,
    required this.level,
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

  late final List<LessonItem> lessonItems;

  @override
  void initState() {
    super.initState();

    lessonItems = LessonContent.getItems(
      widget.level,
      widget.chapterTitle,
    );
  }

  LessonItem get currentItem {
    return lessonItems[currentIndex];
  }

  bool get isLastItem {
    return currentIndex == lessonItems.length - 1;
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _nextLesson() {
    if (isLastItem) {
      _completeLesson();
      return;
    }

    setState(() {
      currentIndex++;
    });
  }

  // ============================================================
  // PREVIOUS
  // ============================================================

  void _previousLesson() {
    if (currentIndex == 0) {
      return;
    }

    setState(() {
      currentIndex--;
    });
  }

  // ============================================================
  // COMPLETE LESSON
  // ============================================================

  Future<void> _completeLesson() async {
    // IMPORTANT:
    // Save completion BEFORE opening the completion screen.
    await AppStorage.saveChapterCompleted(
      widget.level,
      widget.chapterNumber,
    );

    await AppStorage.saveChapterProgress(
      widget.level,
      widget.chapterNumber,
      1.0,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LessonCompleteScreen(
          level: widget.level,
          chapterTitle: widget.chapterTitle,
          chapterNumber: widget.chapterNumber,
          xp: widget.xp,
          itemCount: lessonItems.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (currentIndex + 1) / lessonItems.length;

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

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chapterTitle,
              style: const TextStyle(
                color: Color(0xFF29263D),
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            Text(
              'Chapter ${widget.chapterNumber}',
              style: const TextStyle(
                color: Color(0xFF8A8695),
                fontSize: 11,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1CF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 15,
                  color: Color(0xFFE5A51A),
                ),
                const SizedBox(width: 3),
                Text(
                  '${widget.xp} XP',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8D6813),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // PROGRESS
            // ==================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor:
                        const Color(0xFFE9E5EC),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63A8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentIndex + 1}/${lessonItems.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6C63A8),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.level.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Color(0xFF6C63A8),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      currentItem.word,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      currentItem.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Color(0xFF777281),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // AVATAR PLACEHOLDER
                    // ==================================================

                    Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FA),
                        borderRadius:
                        BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFDED8EF),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration:
                            const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              currentItem.icon,
                              size: 58,
                              color:
                              const Color(0xFF6C63A8),
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'Teaching avatar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6C63A8),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Avatar coming soon',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF898494),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // REMEMBER CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE7E2EC),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration:
                            const BoxDecoration(
                              color: Color(0xFFEDE9FA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 21,
                              color: Color(0xFF6C63A8),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Remember',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w800,
                                    color:
                                    Color(0xFF29263D),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  currentItem.tip,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.45,
                                    color:
                                    Color(0xFF777281),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // BOTTOM ACTION
            // ==========================================================

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                18,
              ),
              color: const Color(0xFFFFFBF5),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: currentIndex == 0
                          ? null
                          : _previousLesson,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        const Color(0xFF6C63A8),
                        side: const BorderSide(
                          color: Color(0xFFD9D3E7),
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _nextLesson,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF6C63A8),
                          foregroundColor: Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastItem
                                  ? 'Complete Lesson'
                                  : 'Next Sign',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isLastItem
                                  ? Icons.check_rounded
                                  : Icons
                                  .arrow_forward_rounded,
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

// ============================================================================
// LESSON ITEM
// ============================================================================

class LessonItem {
  final String word;
  final String description;
  final String tip;
  final IconData icon;

  const LessonItem({
    required this.word,
    required this.description,
    required this.tip,
    required this.icon,
  });
}

// ============================================================================
// LESSON CONTENT
// ============================================================================

class LessonContent {
  static List<LessonItem> getItems(
      String level,
      String chapter,
      ) {
    final key = chapter.toLowerCase().trim();

    // ============================================================
    // BEGINNER
    // ============================================================

    if (key == 'greetings') {
      return const [
        LessonItem(
          word: 'Hello',
          description:
          'Learn the ISL sign for greeting someone.',
          tip:
          'Use this sign when you meet someone or want to greet them.',
          icon: Icons.waving_hand_rounded,
        ),
        LessonItem(
          word: 'Thank You',
          description:
          'Learn how to express gratitude in ISL.',
          tip:
          'Use this sign when thanking someone.',
          icon: Icons.volunteer_activism_rounded,
        ),
        LessonItem(
          word: 'Goodbye',
          description:
          'Learn the ISL sign used when leaving.',
          tip:
          'Use this when saying goodbye to someone.',
          icon: Icons.waving_hand_rounded,
        ),
      ];
    }

    if (key == 'numbers') {
      return const [
        LessonItem(
          word: 'One',
          description:
          'Learn the ISL sign for the number one.',
          tip:
          'Practice the hand position slowly before moving on.',
          icon: Icons.looks_one_rounded,
        ),
        LessonItem(
          word: 'Two',
          description:
          'Learn the ISL sign for the number two.',
          tip:
          'Keep your hand position clear and steady.',
          icon: Icons.looks_two_rounded,
        ),
        LessonItem(
          word: 'Three',
          description:
          'Learn the ISL sign for the number three.',
          tip:
          'Focus on the correct finger position.',
          icon: Icons.looks_3_rounded,
        ),
        LessonItem(
          word: 'Four',
          description:
          'Learn the ISL sign for the number four.',
          tip:
          'Repeat the movement several times.',
          icon: Icons.looks_4_rounded,
        ),
        LessonItem(
          word: 'Five',
          description:
          'Learn the ISL sign for the number five.',
          tip:
          'Keep your fingers comfortably extended.',
          icon: Icons.looks_5_rounded,
        ),
      ];
    }

    if (key == 'basic words') {
      return const [
        LessonItem(
          word: 'Yes',
          description:
          'Learn a basic affirmative sign.',
          tip:
          'Practice the movement naturally.',
          icon: Icons.check_circle_outline_rounded,
        ),
        LessonItem(
          word: 'No',
          description:
          'Learn a basic negative sign.',
          tip:
          'Make the hand movement clearly.',
          icon: Icons.cancel_outlined,
        ),
        LessonItem(
          word: 'Please',
          description:
          'Learn a common polite expression.',
          tip:
          'Use polite signs naturally during conversations.',
          icon: Icons.favorite_border_rounded,
        ),
        LessonItem(
          word: 'Sorry',
          description:
          'Learn a common expression of apology.',
          tip:
          'Practice the sign with a natural expression.',
          icon: Icons.sentiment_dissatisfied_rounded,
        ),
        LessonItem(
          word: 'Help',
          description:
          'Learn a useful everyday sign.',
          tip:
          'This is useful in many everyday situations.',
          icon: Icons.help_outline_rounded,
        ),
      ];
    }

    if (key == 'family') {
      return const [
        LessonItem(
          word: 'Mother',
          description:
          'Learn the sign for mother.',
          tip:
          'Pay attention to the hand position.',
          icon: Icons.family_restroom_rounded,
        ),
        LessonItem(
          word: 'Father',
          description:
          'Learn the sign for father.',
          tip:
          'Practice the movement slowly.',
          icon: Icons.family_restroom_rounded,
        ),
        LessonItem(
          word: 'Brother',
          description:
          'Learn the sign for brother.',
          tip:
          'Repeat until the movement feels natural.',
          icon: Icons.people_outline_rounded,
        ),
        LessonItem(
          word: 'Sister',
          description:
          'Learn the sign for sister.',
          tip:
          'Focus on the correct hand position.',
          icon: Icons.people_outline_rounded,
        ),
        LessonItem(
          word: 'Family',
          description:
          'Learn the sign for family.',
          tip:
          'Use this sign when referring to your family.',
          icon: Icons.family_restroom_rounded,
        ),
      ];
    }

    if (key == 'colors') {
      return const [
        LessonItem(
          word: 'Red',
          description:
          'Learn the ISL sign for red.',
          tip:
          'Practice the sign several times.',
          icon: Icons.circle_rounded,
        ),
        LessonItem(
          word: 'Blue',
          description:
          'Learn the ISL sign for blue.',
          tip:
          'Focus on consistent hand movement.',
          icon: Icons.circle_rounded,
        ),
        LessonItem(
          word: 'Green',
          description:
          'Learn the ISL sign for green.',
          tip:
          'Keep the movement controlled.',
          icon: Icons.circle_rounded,
        ),
        LessonItem(
          word: 'Yellow',
          description:
          'Learn the ISL sign for yellow.',
          tip:
          'Practice slowly first.',
          icon: Icons.circle_rounded,
        ),
        LessonItem(
          word: 'Black',
          description:
          'Learn the ISL sign for black.',
          tip:
          'Repeat the sign until comfortable.',
          icon: Icons.circle_rounded,
        ),
      ];
    }

    if (key == 'food & drinks') {
      return const [
        LessonItem(
          word: 'Food',
          description:
          'Learn a useful food-related sign.',
          tip:
          'Practice the sign in front of a mirror.',
          icon: Icons.restaurant_rounded,
        ),
        LessonItem(
          word: 'Water',
          description:
          'Learn the sign for water.',
          tip:
          'Use this sign in everyday conversations.',
          icon: Icons.water_drop_rounded,
        ),
        LessonItem(
          word: 'Milk',
          description:
          'Learn the sign for milk.',
          tip:
          'Repeat the movement slowly.',
          icon: Icons.local_drink_rounded,
        ),
        LessonItem(
          word: 'Eat',
          description:
          'Learn the sign for eating.',
          tip:
          'Practice the movement naturally.',
          icon: Icons.restaurant_rounded,
        ),
        LessonItem(
          word: 'Drink',
          description:
          'Learn the sign for drinking.',
          tip:
          'Focus on the hand movement.',
          icon: Icons.local_cafe_rounded,
        ),
      ];
    }

    // ============================================================
    // INTERMEDIATE
    // ============================================================

    if (key == 'daily life') {
      return const [
        LessonItem(
          word: 'Wake Up',
          description:
          'Learn a daily-life expression.',
          tip:
          'Practice the movement naturally.',
          icon: Icons.wb_sunny_rounded,
        ),
        LessonItem(
          word: 'Sleep',
          description:
          'Learn the sign for sleep.',
          tip:
          'Focus on the hand position.',
          icon: Icons.bedtime_rounded,
        ),
        LessonItem(
          word: 'Work',
          description:
          'Learn the sign for work.',
          tip:
          'Repeat the movement several times.',
          icon: Icons.work_outline_rounded,
        ),
        LessonItem(
          word: 'Home',
          description:
          'Learn the sign for home.',
          tip:
          'Use this sign in everyday conversations.',
          icon: Icons.home_outlined,
        ),
        LessonItem(
          word: 'Go',
          description:
          'Learn a common movement-related sign.',
          tip:
          'Keep the movement clear.',
          icon: Icons.directions_walk_rounded,
        ),
      ];
    }

    if (key == 'school & work') {
      return const [
        LessonItem(
          word: 'School',
          description:
          'Learn the sign for school.',
          tip:
          'Practice the hand position carefully.',
          icon: Icons.school_rounded,
        ),
        LessonItem(
          word: 'Teacher',
          description:
          'Learn the sign for teacher.',
          tip:
          'Repeat the movement slowly.',
          icon: Icons.person_outline_rounded,
        ),
        LessonItem(
          word: 'Student',
          description:
          'Learn the sign for student.',
          tip:
          'Focus on accuracy.',
          icon: Icons.person_outline_rounded,
        ),
        LessonItem(
          word: 'Book',
          description:
          'Learn the sign for book.',
          tip:
          'Practice until the movement feels natural.',
          icon: Icons.menu_book_rounded,
        ),
        LessonItem(
          word: 'Work',
          description:
          'Learn the sign for work.',
          tip:
          'Use the sign naturally in context.',
          icon: Icons.work_outline_rounded,
        ),
      ];
    }

    if (key == 'questions') {
      return const [
        LessonItem(
          word: 'What',
          description:
          'Learn a common question word.',
          tip:
          'Practice the sign with the correct expression.',
          icon: Icons.help_outline_rounded,
        ),
        LessonItem(
          word: 'Who',
          description:
          'Learn the sign for asking who.',
          tip:
          'Facial expression is important in questions.',
          icon: Icons.person_search_rounded,
        ),
        LessonItem(
          word: 'Where',
          description:
          'Learn the sign for asking where.',
          tip:
          'Practice the movement clearly.',
          icon: Icons.location_on_outlined,
        ),
        LessonItem(
          word: 'When',
          description:
          'Learn the sign for asking when.',
          tip:
          'Repeat the movement slowly.',
          icon: Icons.schedule_rounded,
        ),
        LessonItem(
          word: 'Why',
          description:
          'Learn the sign for asking why.',
          tip:
          'Use the appropriate facial expression.',
          icon: Icons.question_mark_rounded,
        ),
      ];
    }

    if (key == 'sentences') {
      return const [
        LessonItem(
          word: 'I Am',
          description:
          'Practice forming a simple statement.',
          tip:
          'Focus on the order of signs.',
          icon: Icons.person_rounded,
        ),
        LessonItem(
          word: 'I Want',
          description:
          'Practice expressing a simple desire.',
          tip:
          'Keep each sign clear.',
          icon: Icons.favorite_rounded,
        ),
        LessonItem(
          word: 'I Like',
          description:
          'Practice expressing preference.',
          tip:
          'Combine the signs naturally.',
          icon: Icons.thumb_up_alt_outlined,
        ),
        LessonItem(
          word: 'I Need',
          description:
          'Practice expressing a need.',
          tip:
          'Practice the complete phrase.',
          icon: Icons.priority_high_rounded,
        ),
        LessonItem(
          word: 'I Know',
          description:
          'Practice expressing knowledge.',
          tip:
          'Focus on natural transitions.',
          icon: Icons.lightbulb_outline_rounded,
        ),
      ];
    }

    if (key == 'conversation') {
      return const [
        LessonItem(
          word: 'How Are You?',
          description:
          'Practice a simple conversational phrase.',
          tip:
          'Use a natural facial expression.',
          icon: Icons.chat_bubble_outline_rounded,
        ),
        LessonItem(
          word: 'I Am Fine',
          description:
          'Practice responding in conversation.',
          tip:
          'Keep the signs connected naturally.',
          icon: Icons.sentiment_satisfied_alt_rounded,
        ),
        LessonItem(
          word: 'What Is Your Name?',
          description:
          'Practice introducing a question.',
          tip:
          'Focus on the complete sequence.',
          icon: Icons.badge_outlined,
        ),
        LessonItem(
          word: 'My Name Is...',
          description:
          'Practice introducing yourself.',
          tip:
          'Practice the complete phrase.',
          icon: Icons.person_outline_rounded,
        ),
        LessonItem(
          word: 'Nice To Meet You',
          description:
          'Practice a common conversational phrase.',
          tip:
          'Keep the conversation natural.',
          icon: Icons.handshake_outlined,
        ),
      ];
    }

    // ============================================================
    // ADVANCED
    // ============================================================

    if (key == 'advanced vocabulary') {
      return const [
        LessonItem(
          word: 'Community',
          description:
          'Learn an advanced vocabulary concept.',
          tip:
          'Focus on precision and consistency.',
          icon: Icons.groups_rounded,
        ),
        LessonItem(
          word: 'Communication',
          description:
          'Expand your communication vocabulary.',
          tip:
          'Practice the sign repeatedly.',
          icon: Icons.forum_outlined,
        ),
        LessonItem(
          word: 'Opportunity',
          description:
          'Learn an advanced vocabulary item.',
          tip:
          'Practice the movement slowly.',
          icon: Icons.lightbulb_outline_rounded,
        ),
        LessonItem(
          word: 'Experience',
          description:
          'Expand your vocabulary for conversation.',
          tip:
          'Focus on natural movement.',
          icon: Icons.auto_stories_rounded,
        ),
        LessonItem(
          word: 'Important',
          description:
          'Learn a useful advanced expression.',
          tip:
          'Practice with a clear facial expression.',
          icon: Icons.priority_high_rounded,
        ),
      ];
    }

    if (key == 'complex sentences') {
      return const [
        LessonItem(
          word: 'Because',
          description:
          'Practice connecting ideas.',
          tip:
          'Focus on smooth transitions.',
          icon: Icons.link_rounded,
        ),
        LessonItem(
          word: 'Although',
          description:
          'Practice expressing contrast.',
          tip:
          'Keep the complete sentence clear.',
          icon: Icons.compare_arrows_rounded,
        ),
        LessonItem(
          word: 'If',
          description:
          'Practice conditional expressions.',
          tip:
          'Practice the full sentence structure.',
          icon: Icons.call_split_rounded,
        ),
        LessonItem(
          word: 'Before',
          description:
          'Practice describing sequence.',
          tip:
          'Keep the order of signs consistent.',
          icon: Icons.arrow_back_rounded,
        ),
        LessonItem(
          word: 'After',
          description:
          'Practice describing sequence.',
          tip:
          'Connect the signs naturally.',
          icon: Icons.arrow_forward_rounded,
        ),
      ];
    }

    if (key == 'real conversations') {
      return const [
        LessonItem(
          word: 'Introduction',
          description:
          'Practice a realistic introduction.',
          tip:
          'Focus on natural communication.',
          icon: Icons.person_add_alt_rounded,
        ),
        LessonItem(
          word: 'Asking For Help',
          description:
          'Practice a real-life interaction.',
          tip:
          'Keep your signs clear and confident.',
          icon: Icons.help_outline_rounded,
        ),
        LessonItem(
          word: 'At The Store',
          description:
          'Practice signs used while shopping.',
          tip:
          'Think about the complete context.',
          icon: Icons.storefront_outlined,
        ),
        LessonItem(
          word: 'At School',
          description:
          'Practice a school-related interaction.',
          tip:
          'Use natural transitions between signs.',
          icon: Icons.school_outlined,
        ),
        LessonItem(
          word: 'Making Plans',
          description:
          'Practice discussing plans.',
          tip:
          'Focus on conversational flow.',
          icon: Icons.event_note_rounded,
        ),
      ];
    }

    if (key == 'fluency') {
      return const [
        LessonItem(
          word: 'Speed',
          description:
          'Practice signing more naturally.',
          tip:
          'Increase speed only after accuracy is strong.',
          icon: Icons.speed_rounded,
        ),
        LessonItem(
          word: 'Expression',
          description:
          'Practice facial and body expression.',
          tip:
          'Expression is an important part of communication.',
          icon: Icons.face_rounded,
        ),
        LessonItem(
          word: 'Accuracy',
          description:
          'Improve consistency and precision.',
          tip:
          'Slow down when accuracy drops.',
          icon: Icons.track_changes_rounded,
        ),
        LessonItem(
          word: 'Flow',
          description:
          'Practice smooth transitions.',
          tip:
          'Avoid unnecessary pauses between signs.',
          icon: Icons.waves_rounded,
        ),
        LessonItem(
          word: 'Confidence',
          description:
          'Bring everything together.',
          tip:
          'Practice complete conversations confidently.',
          icon: Icons.emoji_events_rounded,
        ),
      ];
    }

    // ============================================================
    // FALLBACK
    // ============================================================

    return const [
      LessonItem(
        word: 'Coming Soon',
        description:
        'Lesson content is being prepared.',
        tip:
        'The lesson structure is ready for content.',
        icon: Icons.construction_rounded,
      ),
    ];
  }
}

// ============================================================================
// LESSON COMPLETE
// ============================================================================

class LessonCompleteScreen extends StatelessWidget {
  final String level;
  final String chapterTitle;
  final int chapterNumber;
  final int xp;
  final int itemCount;

  const LessonCompleteScreen({
    super.key,
    required this.level,
    required this.chapterTitle,
    required this.chapterNumber,
    required this.xp,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Lesson Complete',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F6EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 65,
                  color: Color(0xFF55B97A),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Great Job!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You completed $chapterTitle.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF777281),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFE7E2EC),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon:
                        Icons.menu_book_rounded,
                        value: '$itemCount',
                        label: 'Signs',
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 45,
                      color: const Color(0xFFE7E2EC),
                    ),

                    Expanded(
                      child: _Stat(
                        icon: Icons.bolt_rounded,
                        value: '+$xp',
                        label: 'XP',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ==========================================================
              // PRACTICE
              // ==========================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PracticeScreen(
                              chapterTitle: chapterTitle,
                            ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF6C63A8),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Practice These Signs',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==========================================================
              // BACK TO LEARNING
              // ==========================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    // This pops LessonCompleteScreen.
                    //
                    // Because LessonScreen was replaced by
                    // LessonCompleteScreen, the route underneath
                    // is LearnScreen.
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    const Color(0xFF6C63A8),
                    side: const BorderSide(
                      color: Color(0xFFD9D3E7),
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Back to Learning',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STAT
// ============================================================================

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Stat({
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
          color: const Color(0xFF6C63A8),
          size: 24,
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8A8695),
          ),
        ),
      ],
    );
  }
}