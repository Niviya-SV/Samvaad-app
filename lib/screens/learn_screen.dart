import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

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
                        children: const [
                          SizedBox(height: 10),

                          Text(
                            'Your ISL Journey',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Learn, practice, and unlock your journey',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryText,
                            ),
                          ),

                          SizedBox(height: 30),

                          _LearningPath(),
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
              color: const Color(0xAAFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFDCD6EB),
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
// LEARNING DATA
// ============================================================

class ISLData {
  static const Map<String, List<Map<String, String>>> chapters = {
    'Greetings': [
      {
        'title': 'Hello',
        'subtitle':
        'Learn the Indian Sign Language sign for Hello.',
        'model': 'assets/models/hello.glb',
      },
      {
        'title': 'Thank You',
        'subtitle':
        'Learn the Indian Sign Language sign for Thank You.',
        'model': 'assets/models/thankyou.glb',
      },
      {
        'title': 'Welcome',
        'subtitle':
        'Learn the Indian Sign Language sign for Welcome.',
        'model': 'assets/models/welcome.glb',
      },
      {
        'title': 'Sorry',
        'subtitle':
        'Learn the Indian Sign Language sign for Sorry.',
        'model': 'assets/models/sorry.glb',
      },
      {
        'title': 'No',
        'subtitle':
        'Learn the Indian Sign Language sign for No.',
        'model': 'assets/models/no.glb',
      },
      {
        'title': 'Bye',
        'subtitle':
        'Learn the Indian Sign Language sign for Bye.',
        'model': 'assets/models/bye.glb',
      },
    ],

    'Numbers': [
      {
        'title': 'One',
        'subtitle':
        'Learn the Indian Sign Language sign for One.',
        'model': 'assets/models/one.glb',
      },
      {
        'title': 'Two',
        'subtitle':
        'Learn the Indian Sign Language sign for Two.',
        'model': 'assets/models/two.glb',
      },
      {
        'title': 'Three',
        'subtitle':
        'Learn the Indian Sign Language sign for Three.',
        'model': 'assets/models/three.glb',
      },
    ],

    'People & Family': [
      {
        'title': 'Mother',
        'subtitle':
        'Learn the Indian Sign Language sign for Mother.',
        'model': 'assets/models/mother.glb',
      },
      {
        'title': 'Father',
        'subtitle':
        'Learn the Indian Sign Language sign for Father.',
        'model': 'assets/models/father.glb',
      },
      {
        'title': 'Daughter',
        'subtitle':
        'Learn the Indian Sign Language sign for Daughter.',
        'model': 'assets/models/daughter.glb',
      },
    ],

    'Home': [
      {
        'title': 'Bed',
        'subtitle':
        'Learn the Indian Sign Language sign for Bed.',
        'model': 'assets/models/bed.glb',
      },
      {
        'title': 'Window',
        'subtitle':
        'Learn the Indian Sign Language sign for Window.',
        'model': 'assets/models/window.glb',
      },
    ],
  };
}

// ============================================================
// LEARNING PATH
// ============================================================

class _LearningPath extends StatelessWidget {
  const _LearningPath();

  void _openChapter(
      BuildContext context,
      String chapter,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ISLLearningScreen(
          chapterTitle: chapter,
        ),
      ),
    );
  }

  void _openPractice(
      BuildContext context,
      String chapter,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          chapterTitle: chapter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 2500,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PathPainter(
                    width: width,
                  ),
                ),
              ),

              // ==================================================
              // GREETINGS
              // ==================================================

              Positioned(
                top: 10,
                left: width / 2 - 80,
                child: _LessonNode(
                  title: 'Greetings',
                  icon: Icons.waving_hand_rounded,
                  unlocked: true,
                  signCount: 7,
                  onTap: () {
                    _openChapter(
                      context,
                      'Greetings',
                    );
                  },
                ),
              ),

              Positioned(
                top: 270,
                left: width * 0.18,
                child: _PracticeNode(
                  unlocked: true,
                  onTap: () {
                    _openPractice(
                      context,
                      'Greetings',
                    );
                  },
                ),
              ),

              // ==================================================
              // NUMBERS
              // ==================================================

              Positioned(
                top: 530,
                right: width * 0.10,
                child: _LessonNode(
                  title: 'Numbers',
                  icon: Icons.numbers_rounded,
                  unlocked: true,
                  signCount: 3,
                  onTap: () {
                    _openChapter(
                      context,
                      'Numbers',
                    );
                  },
                ),
              ),

              Positioned(
                top: 790,
                left: width * 0.30,
                child: _PracticeNode(
                  unlocked: true,
                  onTap: () {
                    _openPractice(
                      context,
                      'Numbers',
                    );
                  },
                ),
              ),

              // ==================================================
              // PEOPLE & FAMILY
              // ==================================================

              Positioned(
                top: 1050,
                left: width * 0.08,
                child: _LessonNode(
                  title: 'People & Family',
                  icon: Icons.family_restroom_rounded,
                  unlocked: true,
                  signCount: 3,
                  onTap: () {
                    _openChapter(
                      context,
                      'People & Family',
                    );
                  },
                ),
              ),

              Positioned(
                top: 1310,
                right: width * 0.18,
                child: _PracticeNode(
                  unlocked: true,
                  onTap: () {
                    _openPractice(
                      context,
                      'People & Family',
                    );
                  },
                ),
              ),

              // ==================================================
              // HOME
              // ==================================================

              Positioned(
                top: 1570,
                left: width / 2 - 80,
                child: _LessonNode(
                  title: 'Home',
                  icon: Icons.home_rounded,
                  unlocked: true,
                  signCount: 2,
                  onTap: () {
                    _openChapter(
                      context,
                      'Home',
                    );
                  },
                ),
              ),

              Positioned(
                top: 1830,
                left: width * 0.18,
                child: _PracticeNode(
                  unlocked: true,
                  onTap: () {
                    _openPractice(
                      context,
                      'Home',
                    );
                  },
                ),
              ),

              // ==================================================
              // FUTURE CHAPTERS
              // ==================================================

              Positioned(
                top: 2090,
                right: width * 0.10,
                child: const _LessonNode(
                  title: 'More Coming',
                  icon: Icons.lock_rounded,
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
// GLB LEARNING SCREEN
// ============================================================

class _ISLLearningScreen extends StatefulWidget {
  final String chapterTitle;

  const _ISLLearningScreen({
    required this.chapterTitle,
  });

  @override
  State<_ISLLearningScreen> createState() =>
      _ISLLearningScreenState();
}

class _ISLLearningScreenState extends State<_ISLLearningScreen> {
  final Flutter3DController _controller = Flutter3DController();

  late final List<Map<String, String>> _signs;

  int _currentIndex = 0;

  List<String> _animations = [];

  bool _loading = true;
  bool _modelLoaded = false;

  String _status = 'Loading...';

  String get _currentTitle => _signs[_currentIndex]['title']!;

  String get _currentSubtitle => _signs[_currentIndex]['subtitle']!;

  String get _currentModel => _signs[_currentIndex]['model']!;

  bool get _isLastSign => _currentIndex == _signs.length - 1;

  @override
  void initState() {
    super.initState();

    _signs = ISLData.chapters[widget.chapterTitle] ?? [];

    if (_signs.isEmpty) {
      _loading = false;
      _status = 'No signs available';
    }
  }

  // ==========================================================
  // GLB LOADED
  // ==========================================================

  Future<void> _onModelLoaded(String modelAddress) async {
    if (!mounted) return;

    setState(() {
      _modelLoaded = true;
      _loading = true;
      _animations = [];
      _status = 'Preparing animation...';
    });

    debugPrint('========================================');
    debugPrint('CHAPTER: ${widget.chapterTitle}');
    debugPrint('SIGN: $_currentTitle');
    debugPrint('MODEL: $_currentModel');
    debugPrint('MODEL LOADED: $modelAddress');

    try {
      final animations =
      await _controller.getAvailableAnimations();

      if (!mounted) return;

      _animations = animations;

      debugPrint('ANIMATIONS: $animations');

      // Keep the avatar centered and at a comfortable distance.
      // The user cannot pinch/rotate/zoom it because enableTouch
      // is disabled below.
      try {
        // ==========================================================
// AVATAR CAMERA / FRAMING
// ==========================================================

        // ==========================================
// AVATAR CAMERA - CENTERED FULL BODY
// ==========================================
// ==========================================
// AVATAR CAMERA - FINAL FRAMING
// ==========================================

        try {
          _controller.resetCameraTarget();
          _controller.resetCameraOrbit();

          // Move the avatar DOWN inside the box
          _controller.setCameraTarget(
            0.0,
            1.25,
            0.0,
          );

          // Keep the current good avatar size
          _controller.setCameraOrbit(
            0.0,
            75.0,
            85.0,
          );
        } catch (e) {
          debugPrint('Camera setup error: $e');
        }
      } catch (e) {
        debugPrint('Camera setup error: $e');
      }

      if (!mounted) return;

      setState(() {
        _loading = false;
        _status = animations.isEmpty
            ? 'Ready to learn'
            : 'Playing $_currentTitle';
      });

      // Automatically perform the sign when the GLB is ready.
      if (animations.isNotEmpty) {
        _controller.playAnimation(
          animationName: animations.first,
          loopCount: 0,
        );
      } else {
        _controller.playAnimation();
      }
    } catch (e) {
      debugPrint('GLB animation error: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _status = 'Could not load animation';
      });
    }

    debugPrint('========================================');
  }

  // ==========================================================
  // GLB ERROR
  // ==========================================================

  void _onModelError(String error) {
    debugPrint('GLB MODEL ERROR: $error');

    if (!mounted) return;

    setState(() {
      _modelLoaded = false;
      _loading = false;
      _animations = [];
      _status = 'Could not load model';
    });
  }

  // ==========================================================
  // PLAY
  // ==========================================================

  void _playAnimation() {
    if (_loading || !_modelLoaded) return;

    if (_animations.isNotEmpty) {
      _controller.playAnimation(
        animationName: _animations.first,
      );
    } else {
      _controller.playAnimation();
    }

    setState(() {
      _status = 'Playing $_currentTitle';
    });
  }

  // ==========================================================
  // PAUSE
  // ==========================================================

  void _pauseAnimation() {
    if (_loading || !_modelLoaded) return;

    _controller.pauseAnimation();

    setState(() {
      _status = 'Paused';
    });
  }

  // ==========================================================
  // REPLAY
  // ==========================================================

  void _resetAnimation() {
    if (_loading || !_modelLoaded) return;

    _controller.resetAnimation();

    setState(() {
      _status = 'Playing $_currentTitle';
    });
  }

  // ==========================================================
  // NEXT SIGN
  // ==========================================================

  void _nextSign() {
    if (_loading) return;

    if (_isLastSign) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentIndex++;
      _animations = [];
      _modelLoaded = false;
      _loading = true;
      _status = 'Loading $_currentTitle...';
    });
  }

  // ==========================================================
  // PREVIOUS SIGN
  // ==========================================================

  void _previousSign() {
    if (_loading || _currentIndex == 0) return;

    setState(() {
      _currentIndex--;
      _animations = [];
      _modelLoaded = false;
      _loading = true;
      _status = 'Loading $_currentTitle...';
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (_signs.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDFBFF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFF29263D),
          ),
          title: const Text(
            'Learning',
            style: TextStyle(
              color: Color(0xFF29263D),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'No signs available for ${widget.chapterTitle}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF777281),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF29263D),
        ),
        title: const Text(
          'Learning',
          style: TextStyle(
            color: Color(0xFF29263D),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // A scroll view prevents the yellow/black overflow indicator
      // on small phones while keeping the avatar box fixed.
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            children: [
              // ==================================================
              // CHAPTER
              // ==================================================

              Text(
                widget.chapterTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6C63A8),
                ),
              ),

              const SizedBox(height: 5),

              // ==================================================
              // SIGN TITLE
              // ==================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  4,
                  24,
                  8,
                ),
                child: Column(
                  children: [
                    Text(
                      _currentTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29263D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _currentSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Color(0xFF777281),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // GLB VIEWER
              // ==================================================

              Container(
                height: 340,
                margin: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFE2DDEF),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x146C63A8),
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Flutter3DViewer(
                      key: ValueKey(_currentModel),
                      controller: _controller,
                      src: _currentModel,
                      activeGestureInterceptor: true,
                      enableTouch: false,
                      progressBarColor:
                      const Color(0xFF6C63A8),
                      onProgress: (double progress) {
                        debugPrint(
                          'GLB progress: ${(progress * 100).toStringAsFixed(0)}%',
                        );
                      },
                      onLoad: _onModelLoaded,
                      onError: _onModelError,
                    ),

                    if (_loading)
                      Container(
                        color: Colors.white.withOpacity(0.72),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6C63A8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // STATUS
              // ==================================================

              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C63A8),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // CONTROLS
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loading
                          ? null
                          : _playAnimation,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                      ),
                      label: const Text('Play'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        const Color(0xFF6C63A8),
                        side: const BorderSide(
                          color: Color(0xFFD0C9E8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(22),
                        ),
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: _loading
                          ? null
                          : _pauseAnimation,
                      icon: const Icon(
                        Icons.pause_rounded,
                      ),
                      label: const Text('Pause'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        const Color(0xFF6C63A8),
                        side: const BorderSide(
                          color: Color(0xFFD0C9E8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(22),
                        ),
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: _loading
                          ? null
                          : _resetAnimation,
                      icon: const Icon(
                        Icons.replay_rounded,
                      ),
                      label: const Text('Replay'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        const Color(0xFF6C63A8),
                        side: const BorderSide(
                          color: Color(0xFFD0C9E8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PROGRESS
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Row(
                  children: [
                    Text(
                      '${_currentIndex + 1}/${_signs.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF777281),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_currentIndex + 1) /
                              _signs.length,
                          minHeight: 6,
                          backgroundColor:
                          const Color(0xFFE7E2F3),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            Color(0xFF6C63A8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PREVIOUS / NEXT
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    if (_currentIndex > 0) ...[
                      SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed:
                          _loading ? null : _previousSign,
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF6C63A8),
                            side: const BorderSide(
                              color: Color(0xFF6C63A8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            '← Back',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],

                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                          _loading ? null : _nextSign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF6C63A8),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            const Color(0xFFD6D2E5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLastSign
                                    ? 'Finish'
                                    : 'Next',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _isLastSign
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
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
      ),
    );
  }
}

// LESSON NODE
// ============================================================

class _LessonNode extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool unlocked;
  final int? signCount;
  final VoidCallback? onTap;

  const _LessonNode({
    required this.title,
    required this.icon,
    required this.unlocked,
    this.signCount,
    this.onTap,
  });

  static const Color primary =
  Color(0xFF6C63A8);

  @override
  Widget build(BuildContext context) {
    final size = unlocked ? 128.0 : 122.0;

    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: SizedBox(
        width: 180,
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
                unlocked
                    ? icon
                    : Icons.lock_rounded,
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
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: unlocked
                    ? const Color(0xFF29263D)
                    : const Color(0xFF85828E),
              ),
            ),

            if (signCount != null) ...[
              const SizedBox(height: 3),
              Text(
                '$signCount signs',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777281),
                ),
              ),
            ],
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

  static const Color primary =
  Color(0xFF6C63A8);

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
// PATH PAINTER
// ============================================================

class _PathPainter extends CustomPainter {
  final double width;

  _PathPainter({
    required this.width,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = const Color(0xFFC9C7DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(
      width * 0.50,
      135,
    );

    path.cubicTo(
      width * 0.48,
      210,
      width * 0.30,
      250,
      width * 0.25,
      340,
    );

    path.cubicTo(
      width * 0.20,
      450,
      width * 0.70,
      500,
      width * 0.76,
      620,
    );

    path.cubicTo(
      width * 0.82,
      740,
      width * 0.42,
      760,
      width * 0.37,
      920,
    );

    path.cubicTo(
      width * 0.34,
      1020,
      width * 0.25,
      1060,
      width * 0.22,
      1190,
    );

    path.cubicTo(
      width * 0.20,
      1320,
      width * 0.70,
      1360,
      width * 0.76,
      1490,
    );

    path.cubicTo(
      width * 0.80,
      1600,
      width * 0.55,
      1640,
      width * 0.50,
      1770,
    );

    path.cubicTo(
      width * 0.45,
      1900,
      width * 0.30,
      1930,
      width * 0.25,
      2060,
    );

    path.cubicTo(
      width * 0.20,
      2170,
      width * 0.70,
      2200,
      width * 0.76,
      2340,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _PathPainter oldDelegate,
      ) {
    return oldDelegate.width != width;
  }
}
