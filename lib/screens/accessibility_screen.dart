import 'package:flutter/material.dart';

import '../services/app_storage.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() =>
      _AccessibilityScreenState();
}

class _AccessibilityScreenState
    extends State<AccessibilityScreen> {
  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF706B7C);
  static const Color background = Color(0xFFFFFBF5);

  bool _largeText = false;
  bool _highContrast = false;
  bool _reducedMotion = false;

  bool _loading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  // ============================================================
  // LOAD SETTINGS
  // ============================================================

  Future<void> _loadSettings() async {
    final largeText =
    await AppStorage.getLargeText();

    final highContrast =
    await AppStorage.getHighContrast();

    final reducedMotion =
    await AppStorage.getReducedMotion();

    if (!mounted) return;

    setState(() {
      _largeText = largeText;
      _highContrast = highContrast;
      _reducedMotion = reducedMotion;

      _loading = false;
    });
  }

  // ============================================================
  // LARGE TEXT
  // ============================================================

  Future<void> _changeLargeText(
      bool value,
      ) async {
    setState(() {
      _largeText = value;
    });

    await AppStorage.saveLargeText(value);
  }

  // ============================================================
  // HIGH CONTRAST
  // ============================================================

  Future<void> _changeHighContrast(
      bool value,
      ) async {
    setState(() {
      _highContrast = value;
    });

    await AppStorage.saveHighContrast(value);
  }

  // ============================================================
  // REDUCED MOTION
  // ============================================================

  Future<void> _changeReducedMotion(
      bool value,
      ) async {
    setState(() {
      _reducedMotion = value;
    });

    await AppStorage.saveReducedMotion(value);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(
            color: primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Accessibility',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Container(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6C63A8),
                  Color(0xFF8177C4),
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius:
              BorderRadius.circular(24),
            ),

            child: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Icon(
                  Icons.accessibility_new_rounded,
                  color: Colors.white,
                  size: 40,
                ),

                SizedBox(height: 14),

                Text(
                  'Make Samvaad easier to use',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 7),

                Text(
                  'Customize the app to make learning more comfortable and accessible.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // LARGE TEXT
          // ======================================================

          _settingTile(
            icon: Icons.text_fields_rounded,
            title: 'Large Text',
            subtitle:
            'Increase the size of text throughout the app.',
            value: _largeText,
            onChanged: _changeLargeText,
          ),

          const SizedBox(height: 12),

          // ======================================================
          // HIGH CONTRAST
          // ======================================================

          _settingTile(
            icon: Icons.contrast_rounded,
            title: 'High Contrast',
            subtitle:
            'Use stronger colors and contrast for easier reading.',
            value: _highContrast,
            onChanged: _changeHighContrast,
          ),

          const SizedBox(height: 12),

          // ======================================================
          // REDUCED MOTION
          // ======================================================

          _settingTile(
            icon: Icons.motion_photos_off_rounded,
            title: 'Reduce Motion',
            subtitle:
            'Reduce animations and movement throughout the app.',
            value: _reducedMotion,
            onChanged: _changeReducedMotion,
          ),

          const SizedBox(height: 28),

          // ======================================================
          // INFORMATION
          // ======================================================

          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(20),

              border: Border.all(
                color: const Color(0xFFE5E1EC),
              ),
            ),

            child: const Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: primary,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'These settings are saved automatically and will remain active when you reopen Samvaad.',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: value
              ? primary.withValues(alpha: 0.5)
              : const Color(0xFFE5E1EC),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: value
                  ? primary.withValues(alpha: 0.12)
                  : const Color(0xFFF3F1F7),

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: value
                  ? primary
                  : secondaryText,
              size: 26,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,

            activeTrackColor: primary,
          ),
        ],
      ),
    );
  }
}