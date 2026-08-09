import 'package:flutter/material.dart';
import '../services/app_storage.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool analytics = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await AppStorage.getAnalytics();

    if (!mounted) return;

    setState(() {
      analytics = value;
    });
  }

  Future<void> _changeAnalytics(bool value) async {
    await AppStorage.saveAnalytics(value);

    if (!mounted) return;

    setState(() {
      analytics = value;
    });
  }

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear local data?'),
        content: const Text(
          'This will remove your locally stored Samvaad profile and preferences from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await AppStorage.clearLocalData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Local data cleared'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text(
          'Privacy & Security',
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
            child: SwitchListTile(
              contentPadding: const EdgeInsets.all(18),
              secondary: const Icon(
                Icons.analytics_outlined,
                color: Color(0xFF6C63A8),
              ),
              title: const Text(
                'Analytics',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'Allow anonymous usage analytics.',
              ),
              value: analytics,
              onChanged: _changeAnalytics,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(
                Icons.security_rounded,
                color: Color(0xFF6C63A8),
              ),
              title: const Text(
                'Account security',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text(
                'Authentication and account security settings.',
              ),
            ),
          ),

          const SizedBox(height: 15),

          Card(
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Clear local data',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                ),
              ),
              subtitle: const Text(
                'Remove locally stored profile and preferences.',
              ),
              onTap: _clearData,
            ),
          ),
        ],
      ),
    );
  }
}