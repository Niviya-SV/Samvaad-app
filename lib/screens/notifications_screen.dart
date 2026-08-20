// import 'package:flutter/material.dart';
// import '../services/app_storage.dart';
//
// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   State<NotificationsScreen> createState() =>
//       _NotificationsScreenState();
// }
//
// class _NotificationsScreenState
//     extends State<NotificationsScreen> {
//   bool enabled = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final value = await AppStorage.getNotifications();
//
//     if (!mounted) return;
//
//     setState(() {
//       enabled = value;
//     });
//   }
//
//   Future<void> _change(bool value) async {
//     await AppStorage.saveNotifications(value);
//
//     if (!mounted) return;
//
//     setState(() {
//       enabled = value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFBF5),
//       appBar: AppBar(
//         title: const Text(
//           'Notifications',
//           style: TextStyle(fontWeight: FontWeight.w800),
//         ),
//         backgroundColor: Colors.transparent,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           Card(
//             elevation: 0,
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: SwitchListTile(
//               contentPadding: const EdgeInsets.all(18),
//               title: const Text(
//                 'Learning notifications',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               subtitle: const Text(
//                 'Receive reminders and learning updates.',
//               ),
//               value: enabled,
//               activeThumbColor: const Color(0xFF6C63A8),
//               onChanged: _change,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           if (enabled) ...[
//             const Text(
//               'Recent notifications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _notification(
//               Icons.local_fire_department_rounded,
//               'Keep your streak alive!',
//               'Practice a lesson today.',
//             ),
//
//             _notification(
//               Icons.school_rounded,
//               'Ready for your next lesson?',
//               'Continue learning Indian Sign Language.',
//             ),
//
//             _notification(
//               Icons.emoji_events_rounded,
//               'New achievement available',
//               'Complete more lessons to unlock it.',
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _notification(
//       IconData icon,
//       String title,
//       String subtitle,
//       ) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       margin: const EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: const Color(0xFFEAE6F8),
//           child: Icon(
//             icon,
//             color: const Color(0xFF6C63A8),
//           ),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.w700),
//         ),
//         subtitle: Text(subtitle),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/app_storage.dart';

import '../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool enabled = true;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _notifications = [];

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

    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      if (_notifications.isEmpty) {
        _isLoading = true;
      } else {
        _isRefreshing = true;
      }
      _errorMessage = null;
    });

    try {
      final token = await AppStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Login session not found. Please login again.');
      }

      final data = await ApiService.getNotifications(token);

      final notifications = data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (!mounted) return;

      setState(() {
        _notifications = notifications;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _change(bool value) async {
    await AppStorage.saveNotifications(value);

    if (!mounted) return;

    setState(() {
      enabled = value;
    });
  }

  Future<void> _markAsRead(int id) async {
    final token = await AppStorage.getToken();
    if (token == null || token.isEmpty) return;

    try {
      await ApiService.markNotificationAsRead(token, id);

      if (!mounted) return;

      setState(() {
        for (final notification in _notifications) {
          final notificationId =
          int.tryParse(notification['id']?.toString() ?? '');

          if (notificationId == id) {
            notification['isRead'] = true;
            notification['read'] = true;
          }
        }
      });
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  IconData _notificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'STREAK':
        return Icons.local_fire_department_rounded;
      case 'ACHIEVEMENT':
        return Icons.emoji_events_rounded;
      case 'PRACTICE':
        return Icons.track_changes_rounded;
      case 'LESSON':
        return Icons.school_rounded;
      case 'XP':
        return Icons.bolt_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  bool _isRead(Map<String, dynamic> notification) {
    final value = notification['isRead'] ?? notification['read'];

    if (value is bool) return value;

    return value?.toString().toLowerCase() == 'true';
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
      body: RefreshIndicator(
        color: const Color(0xFF6C63A8),
        onRefresh: _loadNotifications,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  style: TextStyle(fontWeight: FontWeight.w700),
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Recent notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (_isRefreshing)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C63A8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 45),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C63A8),
                    ),
                  ),
                )
              else if (_errorMessage != null)
                _buildError()
              else if (_notifications.isEmpty)
                  _buildEmpty()
                else
                  ..._notifications.map(_notification),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 35),
        child: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF6C63A8),
              size: 42,
            ),
            SizedBox(height: 15),
            Text(
              'No notifications yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Complete lessons or practice sessions to see your updates here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF706B7C),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFF6C63A8),
              size: 38,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load notifications',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF706B7C)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _loadNotifications,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notification(Map<String, dynamic> notification) {
    final id = int.tryParse(notification['id']?.toString() ?? '');
    final read = _isRead(notification);

    return Card(
      elevation: 0,
      color: read ? Colors.white : const Color(0xFFF7F4FF),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: id == null || read ? null : () => _markAsRead(id),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAE6F8),
          child: Icon(
            _notificationIcon(
              notification['type']?.toString() ?? '',
            ),
            color: const Color(0xFF6C63A8),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title']?.toString() ?? 'Notification',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            if (!read)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63A8),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Text(
          notification['message']?.toString() ?? '',
        ),
      ),
    );
  }
}
