import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import '../services/app_localization.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF706B7C);
  static const Color background = Color(0xFFFFFBF5);
  static const Color lightPrimary = Color(0xFFEAE6F8);

  String _selectedLanguage = 'English';
  bool _loading = true;

  // ============================================================
  // LANGUAGES
  // ============================================================

  final List<Map<String, String>> _languages = [
    {
      'name': 'English',
      'native': 'English',
      'code': 'en',
    },
    {
      'name': 'Hindi',
      'native': 'हिन्दी',
      'code': 'hi',
    },
    {
      'name': 'Tamil',
      'native': 'தமிழ்',
      'code': 'ta',
    },
    {
      'name': 'Telugu',
      'native': 'తెలుగు',
      'code': 'te',
    },
    {
      'name': 'Kannada',
      'native': 'ಕನ್ನಡ',
      'code': 'kn',
    },
    {
      'name': 'Malayalam',
      'native': 'മലയാളം',
      'code': 'ml',
    },
    {
      'name': 'Bengali',
      'native': 'বাংলা',
      'code': 'bn',
    },
    {
      'name': 'Marathi',
      'native': 'मराठी',
      'code': 'mr',
    },
    {
      'name': 'Gujarati',
      'native': 'ગુજરાતી',
      'code': 'gu',
    },
    {
      'name': 'Punjabi',
      'native': 'ਪੰਜਾਬੀ',
      'code': 'pa',
    },
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // ============================================================
  // LOAD SAVED LANGUAGE
  // ============================================================

  Future<void> _loadLanguage() async {
    final savedLanguage = await AppStorage.getLanguage();

    if (!mounted) return;

    setState(() {
      _selectedLanguage =
      savedLanguage.isEmpty ? 'English' : savedLanguage;

      _loading = false;
    });
  }

  // ============================================================
  // CHANGE LANGUAGE
  // ============================================================

  Future<void> _selectLanguage(String language) async {
    if (_selectedLanguage == language) {
      return;
    }

    setState(() {
      _selectedLanguage = language;
    });

    // Save language + notify the whole application.
    await AppLocalization.changeLanguage(language);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$language selected',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Go back to Settings.
    await Future.delayed(
      const Duration(milliseconds: 400),
    );

    if (!mounted) return;

    Navigator.pop(context, language);
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

      // ========================================================
      // APP BAR
      // ========================================================

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
          'Language',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        children: [
          // Header
          Container(
            width: double.infinity,
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

              borderRadius: BorderRadius.circular(24),
            ),

            child: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 38,
                ),

                SizedBox(height: 14),

                Text(
                  'Choose your language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Select the language you want to use in Samvaad.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Available languages',
            style: TextStyle(
              color: darkText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 12),

          // Language list
          ..._languages.map(
                (language) {
              final name = language['name']!;
              final native = language['native']!;
              final isSelected =
                  _selectedLanguage == name;

              return _languageCard(
                name: name,
                native: native,
                selected: isSelected,
                onTap: () {
                  _selectLanguage(name);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE CARD
  // ============================================================

  Widget _languageCard({
    required String name,
    required String native,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),

          child: AnimatedContainer(
            duration:
            const Duration(milliseconds: 200),

            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: selected
                  ? lightPrimary
                  : Colors.white,

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color: selected
                    ? primary
                    : const Color(0xFFEDEAF4),

                width: selected ? 1.8 : 1,
              ),
            ),

            child: Row(
              children: [
                // Language icon
                Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: selected
                        ? primary.withValues(alpha: 0.12)
                        : const Color(0xFFF5F3F9),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.translate_rounded,
                    color: selected
                        ? primary
                        : secondaryText,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 15),

                // Language name
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        native,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selected check
                AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 200),

                  width: 26,
                  height: 26,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: selected
                        ? primary
                        : Colors.transparent,

                    border: Border.all(
                      color: selected
                          ? primary
                          : const Color(0xFFC9C5D1),

                      width: 1.5,
                    ),
                  ),

                  child: selected
                      ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 17,
                  )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}