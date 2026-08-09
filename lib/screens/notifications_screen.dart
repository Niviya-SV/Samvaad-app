import 'package:flutter/material.dart';
import '../services/app_storage.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await AppStorage.getNotifications();

    if (!mounted) return;

    setState(() {
      enabled = value;
    });
  }

  Future<void> _change(bool value) async {
    await AppStorage.saveNotifications(value);

    if (!mounted) return;

    setState(() {
      enabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.all(18),
              title: const Text(
                'Learning notifications',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text(
                'Receive reminders and learning updates.',
              ),
              value: enabled,
              activeThumbColor: const Color(0xFF6C63A8),
              onChanged: _change,
            ),
          ),

          const SizedBox(height: 20),

          if (enabled) ...[
            const Text(
              'Recent notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            _notification(
              Icons.local_fire_department_rounded,
              'Keep your streak alive!',
              'Practice a lesson today.',
            ),

            _notification(
              Icons.school_rounded,
              'Ready for your next lesson?',
              'Continue learning Indian Sign Language.',
            ),

            _notification(
              Icons.emoji_events_rounded,
              'New achievement available',
              'Complete more lessons to unlock it.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _notification(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAE6F8),
          child: Icon(
            icon,
            color: const Color(0xFF6C63A8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}