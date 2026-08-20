import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_storage.dart';

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
  // ============================================================
  // STATE
  // ============================================================

  int currentIndex = 0;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  bool _cameraLoading = true;
  bool _cameraError = false;

  bool _isRecording = false;
  bool _videoRecorded = false;
  bool _checkingSign = false;

  XFile? _recordedVideo;

  String? _result;
  String? _resultMessage;

  // ============================================================
  // SIGNS
  // ============================================================

  List<Map<String, String>> get signs {
    switch (widget.chapterTitle) {
      case 'Numbers':
        return [
          {
            'word': 'One',
            'description':
            'Perform the Indian Sign Language sign for One.',
          },
          {
            'word': 'Two',
            'description':
            'Perform the Indian Sign Language sign for Two.',
          },
          {
            'word': 'Three',
            'description':
            'Perform the Indian Sign Language sign for Three.',
          },
        ];

      case 'People & Family':
        return [
          {
            'word': 'Mother',
            'description':
            'Perform the Indian Sign Language sign for Mother.',
          },
          {
            'word': 'Father',
            'description':
            'Perform the Indian Sign Language sign for Father.',
          },
          {
            'word': 'Daughter',
            'description':
            'Perform the Indian Sign Language sign for Daughter.',
          },
        ];

      case 'Home':
        return [
          {
            'word': 'Bed',
            'description':
            'Perform the Indian Sign Language sign for Bed.',
          },
          {
            'word': 'Window',
            'description':
            'Perform the Indian Sign Language sign for Window.',
          },
        ];

      case 'Greetings':
      default:
        return [
          {
            'word': 'Hello',
            'description':
            'Perform the Indian Sign Language sign for Hello.',
          },
          {
            'word': 'Thank You',
            'description':
            'Perform the Indian Sign Language sign for Thank You.',
          },
          {
            'word': 'Welcome',
            'description':
            'Perform the Indian Sign Language sign for Welcome.',
          },
          {
            'word': 'Please',
            'description':
            'Perform the Indian Sign Language sign for Please.',
          },
          {
            'word': 'Sorry',
            'description':
            'Perform the Indian Sign Language sign for Sorry.',
          },
          {
            'word': 'No',
            'description':
            'Perform the Indian Sign Language sign for No.',
          },
          {
            'word': 'Bye',
            'description':
            'Perform the Indian Sign Language sign for Bye.',
          },
        ];
    }
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeCamera();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cameraController?.dispose();

    super.dispose();
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // ============================================================
  // INITIALIZE CAMERA
  // ============================================================

  Future<void> _initializeCamera() async {
    try {
      if (mounted) {
        setState(() {
          _cameraLoading = true;
          _cameraError = false;
        });
      }

      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('No camera found');
      }

      CameraDescription selectedCamera = _cameras.first;

      // Prefer front camera
      for (final camera in _cameras) {
        if (camera.lensDirection ==
            CameraLensDirection.front) {
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
        _cameraError = false;
      });
    } catch (e) {
      debugPrint('Camera initialization error: $e');

      if (!mounted) return;

      setState(() {
        _cameraLoading = false;
        _cameraError = true;
      });
    }
  }

  // ============================================================
  // START / STOP RECORDING
  // ============================================================

  Future<void> _toggleVideoRecording() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    try {
      // --------------------------------------------------------
      // START
      // --------------------------------------------------------

      if (!_isRecording) {
        await controller.startVideoRecording();

        if (!mounted) return;

        setState(() {
          _isRecording = true;
          _videoRecorded = false;
          _recordedVideo = null;
          _result = null;
          _resultMessage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Recording started. Perform the sign now!',
            ),
            backgroundColor: Color(0xFF6C63A8),
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // STOP
      // --------------------------------------------------------

      final XFile video =
      await controller.stopVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _videoRecorded = true;
        _recordedVideo = video;
        _result = null;
        _resultMessage = null;
      });

      debugPrint('========================================');
      debugPrint('VIDEO RECORDED');
      debugPrint(
        'SIGN: ${signs[currentIndex]['word']}',
      );
      debugPrint('VIDEO PATH: ${video.path}');
      debugPrint('========================================');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Video captured successfully!',
          ),
          backgroundColor: Color(0xFF55B97A),
        ),
      );
    } catch (e) {
      debugPrint('Video recording error: $e');

      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not record video: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // CHECK SIGN
  //
  // IMPORTANT:
  // This currently confirms that the video was captured.
  // Connect your ML/API endpoint here when your prediction
  // backend is ready.
  // ============================================================

  Future<void> _checkSign() async {
    if (_recordedVideo == null) {
      return;
    }

    setState(() {
      _checkingSign = true;
      _result = null;
      _resultMessage = null;
    });

    try {
      final token = await AppStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Please login again.');
      }

      final response = await ApiService.verifySign(
        token,
        _recordedVideo!,
      );

      debugPrint('========================================');
      debugPrint('ML VERIFICATION RESULT');
      debugPrint('EXPECTED: ${signs[currentIndex]['word']}');
      debugPrint('PREDICTED: ${response['sign']}');
      debugPrint('CONFIDENCE: ${response['confidence']}');
      debugPrint('========================================');

      if (!mounted) return;

      final String predicted =
          response['sign']?.toString() ?? 'Unknown';

      final double confidence =
          double.tryParse(
            response['confidence']?.toString() ?? '0',
          ) ??
              0.0;

      final expected =
      signs[currentIndex]['word']!.toLowerCase();

      final predictedNormalized =
      predicted.toLowerCase().replaceAll('_', ' ');

      final expectedNormalized =
      expected.toLowerCase().replaceAll('_', ' ');

      final bool correct =
          predictedNormalized == expectedNormalized;

      setState(() {
        _checkingSign = false;

        _result = correct ? 'CORRECT' : 'INCORRECT';

        _resultMessage = correct
            ? 'Correct! AI recognized "$predicted" '
            'with ${confidence.toStringAsFixed(1)}% confidence.'
            : 'AI recognized "$predicted" '
            '(${confidence.toStringAsFixed(1)}% confidence). '
            'Expected "${signs[currentIndex]['word']}".';
      });
    } catch (e) {
      debugPrint('Sign checking error: $e');

      if (!mounted) return;

      setState(() {
        _checkingSign = false;
        _result = 'ERROR';
        _resultMessage =
        'Unable to check the sign right now.';
      });
    }
  }

  // ============================================================
  // RETAKE
  // ============================================================

  void _retakeVideo() {
    setState(() {
      _videoRecorded = false;
      _recordedVideo = null;
      _isRecording = false;
      _checkingSign = false;
      _result = null;
      _resultMessage = null;
    });
  }

  // ============================================================
  // NEXT SIGN
  // ============================================================

  void nextSign() {
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Stop recording before continuing.',
          ),
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    if (!_videoRecorded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Record your sign before continuing.',
          ),
        ),
      );

      return;
    }

    if (currentIndex < signs.length - 1) {
      setState(() {
        currentIndex++;

        _videoRecorded = false;
        _recordedVideo = null;
        _isRecording = false;
        _checkingSign = false;
        _result = null;
        _resultMessage = null;
      });
    } else {
      _showPracticeComplete();
    }
  }

  // ============================================================
  // PREVIOUS SIGN
  // ============================================================

  void previousSign() {
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Stop recording before going back.',
          ),
        ),
      );

      return;
    }

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;

        _videoRecorded = false;
        _recordedVideo = null;
        _isRecording = false;
        _checkingSign = false;
        _result = null;
        _resultMessage = null;
      });
    }
  }

  // ============================================================
  // PRACTICE COMPLETE
  // ============================================================

  void _showPracticeComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool submitting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFFFBF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.fromLTRB(
                24,
                30,
                24,
                20,
              ),
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
                    'You recorded all ${signs.length} '
                        'signs in ${widget.chapterTitle}.',
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
                      onPressed: submitting
                          ? null
                          : () async {
                        setDialogState(() {
                          submitting = true;
                        });

                        try {
                          // =====================================
                          // GET LOGGED-IN USER TOKEN
                          // =====================================

                          final token =
                          await AppStorage.getToken();

                          if (token == null || token.isEmpty) {
                            throw Exception(
                              'Please login again.',
                            );
                          }

                          // =====================================
                          // FIND LESSON ID
                          // =====================================
                          //
                          // The practice endpoint needs a
                          // lessonId. We fetch lessons and find
                          // the current chapter.
                          // =====================================

                          final lessons =
                          await ApiService.getLessons(token);

                          int? lessonId;

                          for (final lesson in lessons) {
                            if (lesson is Map) {
                              final title =
                              lesson['title']?.toString();

                              if (title ==
                                  widget.chapterTitle) {
                                lessonId = int.tryParse(
                                  lesson['id']?.toString() ?? '',
                                );
                                break;
                              }
                            }
                          }

                          // =====================================
                          // IF LESSON ID WAS NOT FOUND
                          // =====================================

                          if (lessonId == null) {
                            throw Exception(
                              'Lesson "${widget.chapterTitle}" '
                                  'was not found.',
                            );
                          }

                          // =====================================
                          // COMPLETE LESSON
                          // =====================================

                          final result =
                          await ApiService.completeLesson(
                            token,
                            lessonId,
                          );

                          debugPrint(
                            'Practice completed: '
                                '${widget.chapterTitle}',
                          );

                          debugPrint(
                            'Completion response: $result',
                          );

                          if (!mounted) return;

                          // Close completion dialog
                          Navigator.pop(dialogContext);

                          // Return to Learning screen
                          Navigator.pop(context);

                        } catch (e) {
                          debugPrint(
                            'Practice completion error: $e',
                          );

                          if (!mounted) return;

                          setDialogState(() {
                            submitting = false;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not save progress: $e',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF6C63A8),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      child: submitting
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Save Progress & Continue',
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
      },
    );
  }

  // ============================================================
  // CAMERA
  // ============================================================

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
        mainAxisAlignment:
        MainAxisAlignment.center,
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
          // ------------------------------------------------------
          // CAMERA PREVIEW
          // ------------------------------------------------------

          CameraPreview(
            _cameraController!,
          ),

          // ------------------------------------------------------
          // BORDER
          // ------------------------------------------------------

          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.75,
                ),
                width: 3,
              ),
              borderRadius:
              BorderRadius.circular(28),
            ),
          ),

          // ------------------------------------------------------
          // SIGN INSTRUCTION
          // ------------------------------------------------------

          Positioned(
            top: 18,
            left: 18,
            right: 18,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.50,
                ),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Text(
                'Perform: '
                    '${signs[currentIndex]['word']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          // ------------------------------------------------------
          // RECORDING INDICATOR
          // ------------------------------------------------------

          if (_isRecording)
            Positioned(
              top: 75,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(
                      alpha: 0.90,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.white,
                        size: 13,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'RECORDING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ------------------------------------------------------
          // RECORD BUTTON
          // ------------------------------------------------------

          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _toggleVideoRecording,
                child: AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 200,
                  ),
                  width:
                  _isRecording ? 84 : 76,
                  height:
                  _isRecording ? 84 : 76,
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? Colors.red
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isRecording
                          ? Colors.white
                          : const Color(
                        0xFF6C63A8,
                      ),
                      width: 5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        spreadRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording
                        ? Icons.stop_rounded
                        : Icons.videocam_rounded,
                    color: _isRecording
                        ? Colors.white
                        : const Color(
                      0xFF6C63A8,
                    ),
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESULT CARD
  // ============================================================

  Widget _buildResultCard() {
    if (_result == null) {
      return const SizedBox.shrink();
    }

    final bool error = _result == 'ERROR';

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: error
            ? const Color(0xFFFFEAEA)
            : const Color(0xFFEAF7EE),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: error
              ? const Color(0xFFFFC7C7)
              : const Color(0xFFC9EBD3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            error
                ? Icons.error_outline_rounded
                : Icons.check_circle_rounded,
            color: error
                ? Colors.red
                : const Color(0xFF55B97A),
            size: 28,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              _resultMessage ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: error
                    ? Colors.red.shade700
                    : const Color(0xFF3C8156),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final sign = signs[currentIndex];

    final progress =
        (currentIndex + 1) / signs.length;

    return Scaffold(
      backgroundColor:
      const Color(0xFFFFFBF5),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
        const Color(0xFFFFFBF5),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          color:
          const Color(0xFF29263D),
          onPressed: () async {
            if (_isRecording) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Stop recording before leaving.',
                  ),
                ),
              );
              return;
            }

            // Stop/checking camera before leaving Practice.
            _checkingSign = false;

            if (!mounted) return;

            // Only pop if Practice was opened on top of another screen.
            if (Navigator.of(context).canPop()) {
              await Navigator.of(context).maybePop();
            }
          },
        ),

        title: const Text(
          'Video Practice',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF29263D),
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // PROGRESS
            // --------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                      child:
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor:
                        const Color(
                          0xFFE8E4F2,
                        ),
                        valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
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
                      fontWeight:
                      FontWeight.w700,
                      color:
                      Color(0xFF777281),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // CHAPTER
            // --------------------------------------------------

            Text(
              widget.chapterTitle.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFF6C63A8),
              ),
            ),

            const SizedBox(height: 7),

            // --------------------------------------------------
            // WORD
            // --------------------------------------------------

            Text(
              'Make the sign: ${sign['word']}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29263D),
              ),
            ),

            const SizedBox(height: 5),

            // --------------------------------------------------
            // DESCRIPTION
            // --------------------------------------------------

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                sign['description']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777281),
                ),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Tap the video button, perform the sign, '
                  'then tap stop.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF777281),
              ),
            ),

            const SizedBox(height: 14),

            // --------------------------------------------------
            // CAMERA
            // --------------------------------------------------

            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.circular(28),
                    border: Border.all(
                      color:
                      const Color(0xFFE7E2EF),
                    ),
                  ),
                  clipBehavior:
                  Clip.antiAlias,
                  child: _buildCamera(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --------------------------------------------------
            // RECORDED STATUS
            // --------------------------------------------------

            if (_videoRecorded)
              Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                padding:
                const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFEAF7EE),
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color:
                      Color(0xFF55B97A),
                    ),

                    const SizedBox(width: 9),

                    const Expanded(
                      child: Text(
                        'Video captured successfully.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          Color(0xFF3C8156),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed:
                      _checkingSign
                          ? null
                          : _retakeVideo,
                      child:
                      const Text('Retake'),
                    ),
                  ],
                ),
              ),

            // --------------------------------------------------
            // CHECK BUTTON
            // --------------------------------------------------

            if (_videoRecorded &&
                _result == null)
              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  24,
                  8,
                  24,
                  0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _checkingSign
                        ? null
                        : _checkSign,
                    icon: _checkingSign
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                        Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.psychology_rounded,
                    ),
                    label: Text(
                      _checkingSign
                          ? 'Checking...'
                          : 'Check My Sign',
                    ),
                    style:
                    FilledButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xFF6C63A8,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // --------------------------------------------------
            // RESULT
            // --------------------------------------------------

            if (_result != null) ...[
              const SizedBox(height: 8),
              _buildResultCard(),
            ],

            const SizedBox(height: 8),

            // --------------------------------------------------
            // BOTTOM CONTROLS
            // --------------------------------------------------

            Container(
              padding:
              const EdgeInsets.fromLTRB(
                24,
                10,
                24,
                18,
              ),
              child: Row(
                children: [
                  // PREVIOUS
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: OutlinedButton(
                      onPressed:
                      _isRecording ||
                          currentIndex == 0
                          ? null
                          : previousSign,
                      style:
                      OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // NEXT
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed:
                        _isRecording ||
                            !_videoRecorded
                            ? null
                            : nextSign,
                        style:
                        FilledButton.styleFrom(
                          backgroundColor:
                          const Color(
                            0xFF6C63A8,
                          ),
                          disabledBackgroundColor:
                          const Color(
                            0xFFE1DEEA,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: Text(
                          currentIndex ==
                              signs.length - 1
                              ? 'Finish Practice'
                              : 'Next Sign →',
                          style:
                          const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w700,
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