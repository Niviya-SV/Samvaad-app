import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class LearnerDetailsScreen extends StatefulWidget {
  final String name;
  final String email;

  const LearnerDetailsScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<LearnerDetailsScreen> createState() =>
      _LearnerDetailsScreenState();
}

class _LearnerDetailsScreenState
    extends State<LearnerDetailsScreen> {

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary =
  Color(0xFF6C63A8);

  static const Color darkText =
  Color(0xFF29263D);

  static const Color secondaryText =
  Color(0xFF777282);

  static const Color background =
  Color(0xFFFFFBF5);

  static const Color lightPrimary =
  Color(0xFFEAE6F8);

  static const Color borderColor =
  Color(0xFFE7E2F0);

  // ============================================================
  // STATE
  // ============================================================

  String? _selectedGoal;
  String? _selectedLevel;

  bool _isSaving = false;

  // ============================================================
  // GOALS
  // ============================================================

  final List<String> _goals = [
    'Learn basic signs',
    'Communicate with family or friends',
    'Improve my ISL skills',
    'Learn for school or work',
    'Explore Indian Sign Language',
  ];

  // ============================================================
  // LEVELS
  // ============================================================

  final List<Map<String, String>> _levels = [
    {
      'title': 'Beginner',
      'subtitle':
      'I am new to Indian Sign Language',
    },
    {
      'title': 'Intermediate',
      'subtitle':
      'I know some basic signs',
    },
    {
      'title': 'Advanced',
      'subtitle':
      'I can already communicate using ISL',
    },
  ];

  // ============================================================
  // SAVE DETAILS
  // ============================================================

  Future<void> _saveDetails() async {

    // ----------------------------------------------------------
    // VALIDATE GOAL
    // ----------------------------------------------------------

    if (_selectedGoal == null) {
      _showMessage(
        'Please select your learning goal.',
      );
      return;
    }

    // ----------------------------------------------------------
    // VALIDATE LEVEL
    // ----------------------------------------------------------

    if (_selectedLevel == null) {
      _showMessage(
        'Please select your current level.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {

      // ========================================================
      // SHARED PREFERENCES
      // ========================================================

      final prefs = SharedPreferencesAsync();

      // ========================================================
      // SAVE NAME
      // ========================================================

      await prefs.setString(
        'name',
        widget.name.trim(),
      );

      // ========================================================
      // SAVE EMAIL
      // ========================================================

      await prefs.setString(
        'email',
        widget.email.trim(),
      );

      // ========================================================
      // SAVE GOAL
      // ========================================================

      await prefs.setString(
        'goal',
        _selectedGoal!,
      );

      // ========================================================
      // SAVE LEVEL
      // ========================================================

      await prefs.setString(
        'level',
        _selectedLevel!,
      );

      // ========================================================
      // MARK DETAILS AS COMPLETED
      // ========================================================

      await prefs.setBool(
        'learner_details_completed',
        true,
      );

      debugPrint(
        'Learner details saved successfully',
      );

      debugPrint(
        'Name: ${widget.name}',
      );

      debugPrint(
        'Email: ${widget.email}',
      );

      debugPrint(
        'Goal: $_selectedGoal',
      );

      debugPrint(
        'Level: $_selectedLevel',
      );

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      // ========================================================
      // SUCCESS MESSAGE
      // ========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile saved successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // ========================================================
      // WAIT A LITTLE
      // ========================================================

      await Future.delayed(
        const Duration(milliseconds: 600),
      );

      if (!mounted) return;

      // ========================================================
      // GO TO LOGIN
      // ========================================================
      //
      // IMPORTANT:
      // We directly open LoginScreen instead of using
      // Navigator.pushNamed('/login').
      //
      // This avoids the "route not found" problem.
      // ========================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
            (route) => false,
      );

    } catch (e) {

      // ========================================================
      // ERROR
      // ========================================================

      debugPrint(
        'Learner details save error: $e',
      );

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage(
        'Could not save profile: $e',
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
          backgroundColor: darkText,
          margin:
          const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // GOAL CARD
  // ============================================================

  Widget _goalCard(
      String goal,
      ) {
    final selected =
        _selectedGoal == goal;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = goal;
        });
      },

      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),

        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        decoration:
        BoxDecoration(
          color: selected
              ? lightPrimary
              : Colors.white,

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: selected
                ? primary
                : borderColor,
            width: selected ? 2 : 1,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 42,
              height: 42,

              decoration:
              BoxDecoration(
                color: selected
                    ? primary
                    : const Color(
                  0xFFF1EFF7,
                ),
                shape:
                BoxShape.circle,
              ),

              child: Icon(
                Icons.flag_rounded,
                color: selected
                    ? Colors.white
                    : primary,
                size: 21,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Text(
                goal,

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: darkText,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            _radioCircle(selected),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LEVEL CARD
  // ============================================================

  Widget _levelCard({
    required String title,
    required String subtitle,
  }) {

    final selected =
        _selectedLevel == title;

    IconData icon;

    if (title == 'Beginner') {
      icon =
          Icons.looks_one_rounded;
    } else if (title == 'Intermediate') {
      icon =
          Icons.looks_two_rounded;
    } else {
      icon =
          Icons.looks_3_rounded;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = title;
        });
      },

      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),

        margin:
        const EdgeInsets.only(
          bottom: 12,
        ),

        padding:
        const EdgeInsets.all(16),

        decoration:
        BoxDecoration(
          color: selected
              ? lightPrimary
              : Colors.white,

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: selected
                ? primary
                : borderColor,
            width: selected ? 2 : 1,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,

              decoration:
              BoxDecoration(
                color: selected
                    ? primary
                    : const Color(
                  0xFFF1EFF7,
                ),
                shape:
                BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: selected
                    ? Colors.white
                    : primary,
                size: 25,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      selected
                          ? FontWeight.w800
                          : FontWeight.w700,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,

                    style:
                    const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color:
                      secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            _radioCircle(selected),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RADIO CIRCLE
  // ============================================================

  Widget _radioCircle(
      bool selected,
      ) {
    return Container(
      width: 24,
      height: 24,

      decoration:
      BoxDecoration(
        shape:
        BoxShape.circle,

        color: selected
            ? primary
            : Colors.transparent,

        border:
        Border.all(
          color: selected
              ? primary
              : const Color(
            0xFFBDB8C8,
          ),
          width: 2,
        ),
      ),

      child: selected
          ? const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 16,
      )
          : null,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
        background,

        elevation: 0,

        surfaceTintColor:
        Colors.transparent,

        leading: IconButton(
          onPressed: _isSaving
              ? null
              : () {
            Navigator.pop(
              context,
            );
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkText,
          ),
        ),

        title: const Text(
          'Learner Profile',

          style: TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight:
            FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          padding:
          const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            30,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              // ==================================================
              // HEADER
              // ==================================================

              const Text(
                'Tell us about you',

                style: TextStyle(
                  fontSize: 30,
                  fontWeight:
                  FontWeight.w900,
                  color: darkText,
                  height: 1.15,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Help us personalize your Indian Sign Language learning journey.',

                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // USER INFO
              // ==================================================

              Container(
                width: double.infinity,

                padding:
                const EdgeInsets.all(
                  18,
                ),

                decoration:
                BoxDecoration(
                  color:
                  Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                  border:
                  Border.all(
                    color:
                    borderColor,
                  ),
                ),

                child: Row(
                  children: [

                    Container(
                      width: 52,
                      height: 52,

                      decoration:
                      const BoxDecoration(
                        color:
                        lightPrimary,
                        shape:
                        BoxShape.circle,
                      ),

                      child:
                      const Icon(
                        Icons
                            .person_rounded,
                        color: primary,
                        size: 28,
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child:
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(
                            widget.name,

                            maxLines: 1,

                            overflow:
                            TextOverflow
                                .ellipsis,

                            style:
                            const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight
                                  .w800,
                              color:
                              darkText,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            widget.email,

                            maxLines: 1,

                            overflow:
                            TextOverflow
                                .ellipsis,

                            style:
                            const TextStyle(
                              fontSize: 13,
                              color:
                              secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              // ==================================================
              // GOAL
              // ==================================================

              const Text(
                'What is your learning goal?',

                style:
                TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(
                height: 7,
              ),

              const Text(
                'Choose what you want to achieve with Samvaad.',

                style:
                TextStyle(
                  fontSize: 13,
                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              ..._goals.map(
                    (goal) =>
                    _goalCard(goal),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // LEVEL
              // ==================================================

              const Text(
                'What is your current level?',

                style:
                TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(
                height: 7,
              ),

              const Text(
                'This helps us choose the right learning path for you.',

                style:
                TextStyle(
                  fontSize: 13,
                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              ..._levels.map(
                    (level) => _levelCard(
                  title:
                  level['title']!,
                  subtitle:
                  level['subtitle']!,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // SAVE BUTTON
              // ==================================================

              SizedBox(
                width:
                double.infinity,

                height: 56,

                child:
                FilledButton(
                  onPressed:
                  _isSaving
                      ? null
                      : _saveDetails,

                  style:
                  FilledButton
                      .styleFrom(
                    backgroundColor:
                    primary,

                    disabledBackgroundColor:
                    primary.withValues(
                      alpha: 0.55,
                    ),

                    foregroundColor:
                    Colors.white,

                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  child: _isSaving
                      ? const SizedBox(
                    width: 24,
                    height: 24,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color:
                      Colors.white,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [
                      Text(
                        'Save & Continue',

                        style:
                        TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              const Center(
                child: Text(
                  'Samvaad • Learn. Practice. Connect.',

                  style:
                  TextStyle(
                    fontSize: 12,
                    color:
                    Color(0xFF8A8695),
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