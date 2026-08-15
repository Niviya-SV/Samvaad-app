import 'package:camera/camera.dart';
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

class _PracticeScreenState extends State<PracticeScreen>
    with WidgetsBindingObserver {
  int currentIndex = 0;
  bool showAnswer = false;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  bool _cameraLoading = true;
  bool _cameraError = false;
  bool _cameraStarted = false;
  bool _photoTaken = false;

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cameraController?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _cameraLoading = true;
        _cameraError = false;
      });

      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('No camera found');
      }

      CameraDescription selectedCamera = _cameras.first;

      for (final camera in _cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      await _cameraController?.dispose();

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _cameraLoading = false;
        _cameraStarted = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cameraLoading = false;
        _cameraError = true;
      });
    }
  }

  Future<void> _capturePractice() async {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    try {
      await controller.takePicture();

      if (!mounted) return;

      setState(() {
        _photoTaken = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${signs[currentIndex]['word']} captured successfully!',
          ),
          backgroundColor: const Color(0xFF55B97A),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not capture the practice image.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void nextSign() {
    if (currentIndex < signs.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
        _photoTaken = false;
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
        _photoTaken = false;
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

  Widget _buildCamera() {
    if (_cameraLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C63A8),
        ),
      );
    }

    if (_cameraError ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 60,
            color: Color(0xFF9994A3),
          ),

          const SizedBox(height: 14),

          const Text(
            'Camera unavailable',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF555162),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: _initializeCamera,
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),

          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.75),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
          ),

          Positioned(
            top: 18,
            left: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Show the sign: ${signs[currentIndex]['word']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _capturePractice,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF6C63A8),
                      width: 5,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF6C63A8),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sign = signs[currentIndex];

    final progress =
        (currentIndex + 1) / signs.length;

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
          'Camera Practice',
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

            const SizedBox(height: 20),

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

            Text(
              'Make the sign: ${sign['word']}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29263D),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Position your hand clearly inside the camera.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF777281),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFE7E2EF),
                    ),
                  ),
                  child: _buildCamera(),
                ),
              ),
            ),

            const SizedBox(height: 14),

            if (_photoTaken)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF55B97A),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Practice captured. You can continue to the next sign.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C8156),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                14,
                24,
                20,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: OutlinedButton(
                      onPressed:
                      currentIndex == 0 ? null : previousSign,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                        onPressed:
                        _photoTaken ? nextSign : null,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF6C63A8),
                          disabledBackgroundColor:
                          const Color(0xFFE1DEEA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          currentIndex == signs.length - 1
                              ? 'Finish Practice'
                              : 'Next Sign',
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
          ],
        ),
      ),
    );
  }
}