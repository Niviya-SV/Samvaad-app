import 'package:flutter/material.dart';
import 'home_screen.dart';

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

class _LearnerDetailsScreenState extends State<LearnerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedGoal;
  String? _selectedLevel;
  String? _selectedCommunication;
  String? _selectedLearningPreference;

  bool _isLoading = false;

  final List<String> _goals = [
    'Learn basic Indian Sign Language',
    'Communicate with family and friends',
    'Improve everyday communication',
    'Learn signs for school or college',
    'Learn signs for work',
    'Become confident in ISL',
  ];

  final List<String> _levels = [
    'Complete Beginner',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _communicationOptions = [
    'I mainly use sign language',
    'I use sign language and speech',
    'I mainly use speech',
    'I am learning sign language',
    'I prefer visual communication',
  ];

  final List<String> _learningOptions = [
    'Visual lessons',
    'Step-by-step practice',
    'Short daily lessons',
    'Quizzes and games',
    'Practice conversations',
  ];

  Future<void> _finishSetup() async {
    if (_selectedGoal == null ||
        _selectedLevel == null ||
        _selectedCommunication == null ||
        _selectedLearningPreference == null) {
      _showMessage('Please complete all the details.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Go directly to Home after learner setup.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          learnerName: widget.name,
          goal: _selectedGoal!,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF29263D),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Your Learning Profile',
          style: TextStyle(
            color: Color(0xFF29263D),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E4F7),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 30,
                          color: Color(0xFF6C63A8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${widget.name}!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF29263D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF666274),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Tell us about your learning journey',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'We will use these details to personalize your Samvaad learning experience.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF666274),
                  ),
                ),

                const SizedBox(height: 30),

                // Goal
                _buildSectionTitle(
                  'What is your main goal?',
                  Icons.flag_rounded,
                ),

                const SizedBox(height: 12),

                _buildDropdown(
                  value: _selectedGoal,
                  hint: 'Choose your learning goal',
                  icon: Icons.flag_outlined,
                  items: _goals,
                  onChanged: (value) {
                    setState(() {
                      _selectedGoal = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // Level
                _buildSectionTitle(
                  'What is your current ISL level?',
                  Icons.trending_up_rounded,
                ),

                const SizedBox(height: 12),

                _buildDropdown(
                  value: _selectedLevel,
                  hint: 'Choose your current level',
                  icon: Icons.school_outlined,
                  items: _levels,
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // Communication
                _buildSectionTitle(
                  'How do you communicate?',
                  Icons.forum_outlined,
                ),

                const SizedBox(height: 12),

                _buildDropdown(
                  value: _selectedCommunication,
                  hint: 'Choose an option',
                  icon: Icons.record_voice_over_outlined,
                  items: _communicationOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedCommunication = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // Learning preference
                _buildSectionTitle(
                  'How do you prefer to learn?',
                  Icons.auto_awesome_rounded,
                ),

                const SizedBox(height: 12),

                _buildDropdown(
                  value: _selectedLearningPreference,
                  hint: 'Choose your preferred style',
                  icon: Icons.menu_book_rounded,
                  items: _learningOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedLearningPreference = value;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Accessibility note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1FB),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE4DFF2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.accessibility_new_rounded,
                        color: Color(0xFF6C63A8),
                        size: 25,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Designed for accessible learning',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF29263D),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Samvaad focuses on visual learning, clear instructions, and interactive ISL practice.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Color(0xFF666274),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _finishSetup,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63A8),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      const Color(0xFFB9B4D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Samvaad',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    'You can change these preferences later.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A8695),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF6C63A8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF29263D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2DFE8),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF6C63A8),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF6C63A8),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF96919F),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF29263D),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}