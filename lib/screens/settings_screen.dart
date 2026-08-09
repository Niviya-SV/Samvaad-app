import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import 'accessibility_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF706B7C);
  static const Color background = Color(0xFFFFFBF5);
  static const Color lightPrimary = Color(0xFFEAE6F8);

  // ============================================================
  // STATE
  // ============================================================

  String _language = 'English';

  bool _notifications = true;
  bool _sound = true;
  bool _haptic = true;

  bool _largeText = false;
  bool _highContrast = false;
  bool _reducedMotion = false;

  bool _analytics = true;

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
    final language = await AppStorage.getLanguage();

    final notifications =
    await AppStorage.getNotifications();

    final sound =
    await AppStorage.getSound();

    final haptic =
    await AppStorage.getHaptic();

    final largeText =
    await AppStorage.getLargeText();

    final highContrast =
    await AppStorage.getHighContrast();

    final reducedMotion =
    await AppStorage.getReducedMotion();

    final analytics =
    await AppStorage.getAnalytics();

    if (!mounted) return;

    setState(() {
      _language = language;

      _notifications = notifications;
      _sound = sound;
      _haptic = haptic;

      _largeText = largeText;
      _highContrast = highContrast;
      _reducedMotion = reducedMotion;

      _analytics = analytics;

      _loading = false;
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Future<void> _chooseLanguage() async {
    final languages = [
      'English',
      'हिन्दी',
      'தமிழ்',
      'తెలుగు',
      'ಕನ್ನಡ',
      'മലയാളം',
      'मराठी',
      'বাংলা',
      'ગુજરાતી',
      'ਪੰਜਾਬੀ',
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              20,
              22,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D5E3),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose Language',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select your preferred app language.',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];

                      final isSelected =
                          language == _language;

                      return ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),

                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? lightPrimary
                                : const Color(0xFFF5F3F8),
                            borderRadius:
                            BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            color: isSelected
                                ? primary
                                : secondaryText,
                          ),
                        ),

                        title: Text(
                          language,
                          style: TextStyle(
                            color: darkText,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),

                        trailing: isSelected
                            ? const Icon(
                          Icons.check_circle_rounded,
                          color: primary,
                        )
                            : null,

                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                            language,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    // SAVE LANGUAGE LOCALLY.
    await AppStorage.saveLanguage(selected);

    if (!mounted) return;

    setState(() {
      _language = selected;
    });

    _showMessage(
      'Language changed to $selected',
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  Future<void> _setNotifications(bool value) async {
    await AppStorage.saveNotifications(value);

    if (!mounted) return;

    setState(() {
      _notifications = value;
    });

    _showMessage(
      value
          ? 'Notifications enabled'
          : 'Notifications disabled',
    );
  }

  // ============================================================
  // SOUND
  // ============================================================

  Future<void> _setSound(bool value) async {
    await AppStorage.saveSound(value);

    if (!mounted) return;

    setState(() {
      _sound = value;
    });

    _showMessage(
      value ? 'Sound enabled' : 'Sound disabled',
    );
  }

  // ============================================================
  // HAPTIC
  // ============================================================

  Future<void> _setHaptic(bool value) async {
    await AppStorage.saveHaptic(value);

    if (!mounted) return;

    setState(() {
      _haptic = value;
    });

    _showMessage(
      value
          ? 'Haptic feedback enabled'
          : 'Haptic feedback disabled',
    );
  }

  // ============================================================
  // LARGE TEXT
  // ============================================================

  Future<void> _setLargeText(bool value) async {
    await AppStorage.saveLargeText(value);

    if (!mounted) return;

    setState(() {
      _largeText = value;
    });

    _showMessage(
      value
          ? 'Large text enabled'
          : 'Large text disabled',
    );
  }

  // ============================================================
  // HIGH CONTRAST
  // ============================================================

  Future<void> _setHighContrast(bool value) async {
    await AppStorage.saveHighContrast(value);

    if (!mounted) return;

    setState(() {
      _highContrast = value;
    });

    _showMessage(
      value
          ? 'High contrast enabled'
          : 'High contrast disabled',
    );
  }

  // ============================================================
  // REDUCED MOTION
  // ============================================================

  Future<void> _setReducedMotion(bool value) async {
    await AppStorage.saveReducedMotion(value);

    if (!mounted) return;

    setState(() {
      _reducedMotion = value;
    });

    _showMessage(
      value
          ? 'Reduced motion enabled'
          : 'Reduced motion disabled',
    );
  }

  // ============================================================
  // ANALYTICS
  // ============================================================

  Future<void> _setAnalytics(bool value) async {
    await AppStorage.saveAnalytics(value);

    if (!mounted) return;

    setState(() {
      _analytics = value;
    });

    _showMessage(
      value
          ? 'Analytics enabled'
          : 'Analytics disabled',
    );
  }

  // ============================================================
  // ACCESSIBILITY PAGE
  // ============================================================

  Future<void> _openAccessibility() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AccessibilityScreen(),
      ),
    );

    // Reload values when returning.
    await _loadSettings();
  }

  // ============================================================
  // CLEAR LOCAL DATA
  // ============================================================

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Clear local data?',
          ),

          content: const Text(
            'This will remove your saved profile, '
                'language, preferences, and other local '
                'Samvaad data from this device.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Clear Data',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await AppStorage.clearLocalData();

    if (!mounted) return;

    setState(() {
      _language = 'English';

      _notifications = true;
      _sound = true;
      _haptic = true;

      _largeText = false;
      _highContrast = false;
      _reducedMotion = false;

      _analytics = true;
    });

    _showMessage(
      'All local data has been cleared.',
    );
  }

  // ============================================================
  // HELP & SUPPORT
  // ============================================================

  void _showHelp() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Help & Support',
                ),
              ),
            ],
          ),

          content: const SingleChildScrollView(
            child: Text(
              'Need help with Samvaad?\n\n'
                  '• Learn: Explore ISL lessons and learning paths.\n\n'
                  '• Practice: Review signs and improve your skills.\n\n'
                  '• Profile: Update your learner information.\n\n'
                  '• Settings: Customize language, sound, notifications and accessibility.',
              style: TextStyle(
                height: 1.5,
                color: secondaryText,
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PRIVACY & SECURITY
  // ============================================================

  void _showPrivacy() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Privacy & Security',
                ),
              ),
            ],
          ),

          content: const SingleChildScrollView(
            child: Text(
              'Samvaad keeps your learner preferences '
                  'and profile information stored locally '
                  'on this device.\n\n'
                  'You can remove locally stored information '
                  'at any time using "Clear Local Data".\n\n'
                  'Analytics can be disabled from this '
                  'settings page.',
              style: TextStyle(
                height: 1.5,
                color: secondaryText,
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAbout() {
    showAboutDialog(
      context: context,

      applicationName: 'Samvaad',

      applicationVersion: '1.0.0',

      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.front_hand_rounded,
          color: primary,
        ),
      ),

      children: const [
        Text(
          'An Indian Sign Language learning platform '
              'designed to make learning accessible, '
              'interactive and engaging.',
          style: TextStyle(
            height: 1.5,
          ),
        ),
      ],
    );
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
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkText,
          ),
        ),

        title: const Text(
          'Settings',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          children: [
            // ====================================================
            // GENERAL
            // ====================================================

            _sectionTitle('General'),

            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: _language,
                  onTap: _chooseLanguage,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon:
                  Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: _notifications
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _notifications,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setNotifications,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound',
                  subtitle: _sound
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _sound,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setSound,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon: Icons.vibration_rounded,
                  title: 'Haptic Feedback',
                  subtitle: _haptic
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _haptic,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setHaptic,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ====================================================
            // ACCESSIBILITY
            // ====================================================

            _sectionTitle('Accessibility'),

            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.accessibility_new_rounded,
                  title: 'Accessibility',
                  subtitle:
                  'Large text, contrast and motion settings',
                  onTap: _openAccessibility,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon: Icons.text_fields_rounded,
                  title: 'Large Text',
                  subtitle: _largeText
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _largeText,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setLargeText,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon: Icons.contrast_rounded,
                  title: 'High Contrast',
                  subtitle: _highContrast
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _highContrast,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setHighContrast,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon:
                  Icons.motion_photos_off_rounded,
                  title: 'Reduced Motion',
                  subtitle: _reducedMotion
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _reducedMotion,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setReducedMotion,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ====================================================
            // PRIVACY
            // ====================================================

            _sectionTitle('Privacy & Security'),

            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.security_rounded,
                  title: 'Privacy & Security',
                  subtitle:
                  'Your data and privacy',
                  onTap: _showPrivacy,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon:
                  Icons.analytics_outlined,
                  title: 'Analytics',
                  subtitle: _analytics
                      ? 'Enabled'
                      : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _analytics,
                    thumbColor:
                    WidgetStateProperty.resolveWith(
                          (states) {
                        if (states.contains(
                          WidgetState.selected,
                        )) {
                          return primary;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: _setAnalytics,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon:
                  Icons.delete_outline_rounded,
                  title: 'Clear Local Data',
                  subtitle:
                  'Remove saved data from this device',
                  onTap: _clearData,
                  titleColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ====================================================
            // SUPPORT
            // ====================================================

            _sectionTitle('Support'),

            _settingsCard(
              children: [
                _settingsTile(
                  icon:
                  Icons.help_outline_rounded,
                  title: 'Help & Support',
                  subtitle:
                  'Get help using Samvaad',
                  onTap: _showHelp,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                  ),
                ),

                _divider(),

                _settingsTile(
                  icon:
                  Icons.info_outline_rounded,
                  title: 'About Samvaad',
                  subtitle:
                  'Version 1.0.0',
                  onTap: _showAbout,
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ====================================================
            // FOOTER
            // ====================================================

            const Center(
              child: Text(
                'SAMVAAD',
                style: TextStyle(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Center(
              child: Text(
                'Learn. Practice. Connect.',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: darkText,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE9E5EF),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(20),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: (iconColor ?? primary)
                    .withValues(alpha: 0.10),

                borderRadius:
                BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                color: iconColor ?? primary,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color:
                      titleColor ?? darkText,
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.7,
      indent: 75,
      endIndent: 15,
      color: Color(0xFFEDEAF2),
    );
  }
}