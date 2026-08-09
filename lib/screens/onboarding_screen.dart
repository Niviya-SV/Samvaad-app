import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final List<OnboardingData> pages = [
    OnboardingData(
      title: 'Learn ISL the Smart Way',
      description:
      'Build your Indian Sign Language skills through simple lessons, practice, and interactive learning.',
      icon: Icons.front_hand_rounded,
    ),
    OnboardingData(
      title: 'Practice at Your Own Pace',
      description:
      'Learn common signs, words, and phrases step by step and practice whenever you want.',
      icon: Icons.play_circle_outline_rounded,
    ),
    OnboardingData(
      title: 'Learn. Practice. Connect.',
      description:
      'Build confidence in Indian Sign Language and communicate without barriers.',
      icon: Icons.people_alt_outlined,
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        ),
      );
    }
  }

  void skipOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = pages[currentPage];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────────────
            // TOP BAR
            // ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentPage == 0
                        ? null
                        : () {
                      setState(() {
                        currentPage--;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                    ),
                    color: AppTheme.darkText,
                  ),

                  TextButton(
                    onPressed: skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────────
            // MAIN CONTENT
            // ─────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    // ─────────────────────────────────
                    // ILLUSTRATION
                    // ─────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      child: Container(
                        key: ValueKey(currentPage),
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppTheme.lightPrimary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              page.icon,
                              size: 70,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 42),

                    // ─────────────────────────────────
                    // TITLE
                    // ─────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      child: Text(
                        page.title,
                        key: ValueKey(
                          '${currentPage}_title',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkText,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─────────────────────────────────
                    // DESCRIPTION
                    // ─────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      child: Text(
                        page.description,
                        key: ValueKey(
                          '${currentPage}_description',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // ─────────────────────────────────
                    // PAGE INDICATORS
                    // ─────────────────────────────────
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                            (index) {
                          final isActive =
                              index == currentPage;

                          return AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            margin:
                            const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: isActive ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.primary
                                  : const Color(
                                0xFFD9D5E8,
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─────────────────────────────────
                    // NEXT / CONTINUE BUTTON
                    // ─────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: nextPage,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          currentPage ==
                              pages.length - 1
                              ? 'Continue'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ONBOARDING DATA
// ─────────────────────────────────────────────

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}