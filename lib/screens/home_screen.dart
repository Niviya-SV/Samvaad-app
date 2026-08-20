// // // import 'package:flutter/material.dart';
// // //
// // // import '../services/api_service.dart';
// // // import '../services/app_storage.dart';
// // //
// // // import 'learn_screen.dart';
// // // import 'practice_screen.dart';
// // // import 'profile_screen.dart';
// // // import 'settings_screen.dart';
// // // import 'notifications_screen.dart';
// // //
// // // class HomeScreen extends StatefulWidget {
// // //   final String? learnerName;
// // //   final String? email;
// // //   final String? goal;
// // //   final String? level;
// // //
// // //   const HomeScreen({
// // //     super.key,
// // //     this.learnerName,
// // //     this.email,
// // //     this.goal,
// // //     this.level,
// // //   });
// // //
// // //   @override
// // //   State<HomeScreen> createState() => _HomeScreenState();
// // // }
// // //
// // // class _HomeScreenState extends State<HomeScreen> {
// // //   static const Color primary = Color(0xFF6C63A8);
// // //   static const Color darkText = Color(0xFF29263D);
// // //   static const Color secondaryText = Color(0xFF706B7C);
// // //   static const Color background = Color(0xFFFFFBF5);
// // //   static const Color lightPrimary = Color(0xFFEAE6F8);
// // //
// // //   String _name = '';
// // //   String _email = '';
// // //   String _goal = '';
// // //
// // //   bool _isLoading = true;
// // //
// // //   int _streak = 0;
// // //   int _xp = 0;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLearnerData();
// // //   }
// // //
// // //   // ============================================================
// // //   // LOAD USER DATA + STREAK
// // //   // ============================================================
// // //
// // //   Future<void> _loadLearnerData() async {
// // //     try {
// // //       final name = await AppStorage.getName();
// // //       final email = await AppStorage.getEmail();
// // //       final goal = await AppStorage.getGoal();
// // //
// // //       // getToken() returns String?, so null becomes ''
// // //       final token = await AppStorage.getToken() ?? '';
// // //
// // //       int streak = 0;
// // //       int finalXp = 0;
// // //
// // //       if (token.isNotEmpty) {
// // //         try {
// // //           final statistics =
// // //           await ApiService.getStatistics(token);
// // //
// // //           streak = int.tryParse(
// // //             statistics['currentStreak']?.toString() ?? '0',
// // //           ) ?? 0;
// // //
// // //           finalXp = int.tryParse(
// // //             statistics['xp']?.toString() ?? '0',
// // //           ) ?? 0;
// // //
// // //           debugPrint('Current XP: $finalXp');
// // //           debugPrint('Current streak: $streak');
// // //         } catch (e) {
// // //           debugPrint('Failed to load statistics: $e');
// // //         }
// // //       }
// // //
// // //       if (!mounted) return;
// // //
// // //       setState(() {
// // //         _name = name.isNotEmpty
// // //             ? name
// // //             : (widget.learnerName ?? '');
// // //
// // //         _email = email.isNotEmpty
// // //             ? email
// // //             : (widget.email ?? '');
// // //
// // //         _goal = goal.isNotEmpty
// // //             ? goal
// // //             : (widget.goal ?? '');
// // //
// // //         _xp = finalXp;
// // //         _streak = streak;
// // //
// // //         _isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       debugPrint('Failed to load home data: $e');
// // //
// // //       if (!mounted) return;
// // //
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }
// // //
// // //   String get _displayName {
// // //     if (_name.trim().isEmpty) {
// // //       return 'Learner';
// // //     }
// // //
// // //     return _name.trim();
// // //   }
// // //
// // //   String get _firstName {
// // //     return _displayName.split(' ').first;
// // //   }
// // //
// // //   String get _displayGoal {
// // //     if (_goal.trim().isEmpty) {
// // //       return 'Learn Indian Sign Language';
// // //     }
// // //
// // //     return _goal.trim();
// // //   }
// // //
// // //   // ============================================================
// // //   // NAVIGATION
// // //   // ============================================================
// // //
// // //   Future<void> _openLearn() async {
// // //     await Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => const LearnScreen(),
// // //       ),
// // //     );
// // //
// // //     if (mounted) {
// // //       await _loadLearnerData();
// // //     }
// // //   }
// // //
// // //   Future<void> _openPractice() async {
// // //     await Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => const PracticeScreen(
// // //           chapterTitle: 'Greetings',
// // //         ),
// // //       ),
// // //     );
// // //
// // //     if (mounted) {
// // //       await _loadLearnerData();
// // //     }
// // //   }
// // //
// // //   Future<void> _openProfile() async {
// // //     await Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => ProfileScreen(
// // //           learnerName: _name,
// // //           email: _email,
// // //           goal: _goal,
// // //         ),
// // //       ),
// // //     );
// // //
// // //     if (mounted) {
// // //       await _loadLearnerData();
// // //     }
// // //   }
// // //
// // //   Future<void> _openSettings() async {
// // //     await Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => const SettingsScreen(),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Future<void> _openNotifications() async {
// // //     await Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => const NotificationsScreen(),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // BUILD
// // //   // ============================================================
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     if (_isLoading) {
// // //       return const Scaffold(
// // //         backgroundColor: background,
// // //         body: Center(
// // //           child: CircularProgressIndicator(
// // //             color: primary,
// // //           ),
// // //         ),
// // //       );
// // //     }
// // //
// // //     return Scaffold(
// // //       backgroundColor: background,
// // //
// // //       appBar: AppBar(
// // //         backgroundColor: background,
// // //         elevation: 0,
// // //         surfaceTintColor: Colors.transparent,
// // //         automaticallyImplyLeading: false,
// // //         title: const Text(
// // //           'SAMVAAD',
// // //           style: TextStyle(
// // //             color: primary,
// // //             fontSize: 22,
// // //             fontWeight: FontWeight.w900,
// // //             letterSpacing: 1.5,
// // //           ),
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             onPressed: _openNotifications,
// // //             icon: const Icon(
// // //               Icons.notifications_none_rounded,
// // //               color: darkText,
// // //               size: 27,
// // //             ),
// // //           ),
// // //           IconButton(
// // //             onPressed: _openSettings,
// // //             icon: const Icon(
// // //               Icons.settings_outlined,
// // //               color: darkText,
// // //               size: 26,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 6),
// // //         ],
// // //       ),
// // //
// // //       body: RefreshIndicator(
// // //         color: primary,
// // //         onRefresh: _loadLearnerData,
// // //         child: SingleChildScrollView(
// // //           physics: const AlwaysScrollableScrollPhysics(),
// // //           padding: const EdgeInsets.fromLTRB(
// // //             20,
// // //             10,
// // //             20,
// // //             100,
// // //           ),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 'Hello, $_firstName 👋',
// // //                 style: const TextStyle(
// // //                   fontSize: 27,
// // //                   fontWeight: FontWeight.w900,
// // //                   color: darkText,
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 7),
// // //
// // //               Text(
// // //                 _displayGoal,
// // //                 style: const TextStyle(
// // //                   fontSize: 14,
// // //                   color: secondaryText,
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 28),
// // //
// // //               _statsCard(),
// // //
// // //               const SizedBox(height: 30),
// // //
// // //               const Text(
// // //                 'Continue Learning',
// // //                 style: TextStyle(
// // //                   fontSize: 21,
// // //                   fontWeight: FontWeight.w900,
// // //                   color: darkText,
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 14),
// // //
// // //               _continueLearningCard(),
// // //
// // //               const SizedBox(height: 30),
// // //
// // //               const Text(
// // //                 'Your Learning Journey',
// // //                 style: TextStyle(
// // //                   fontSize: 21,
// // //                   fontWeight: FontWeight.w900,
// // //                   color: darkText,
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 7),
// // //
// // //               const Text(
// // //                 'Learn signs step by step and unlock new topics.',
// // //                 style: TextStyle(
// // //                   fontSize: 13,
// // //                   color: secondaryText,
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 16),
// // //
// // //               _learningJourneyCard(),
// // //
// // //               const SizedBox(height: 30),
// // //
// // //               _motivationCard(),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //
// // //       bottomNavigationBar: SafeArea(
// // //         top: false,
// // //         child: Container(
// // //           height: 76,
// // //           decoration: const BoxDecoration(
// // //             color: Colors.white,
// // //             border: Border(
// // //               top: BorderSide(
// // //                 color: Color(0xFFEAE6EF),
// // //               ),
// // //             ),
// // //           ),
// // //           child: Row(
// // //             mainAxisAlignment:
// // //             MainAxisAlignment.spaceAround,
// // //             children: [
// // //               _navItem(
// // //                 icon: Icons.home_rounded,
// // //                 label: 'Home',
// // //                 selected: true,
// // //                 onTap: () {},
// // //               ),
// // //               _navItem(
// // //                 icon: Icons.menu_book_outlined,
// // //                 label: 'Learn',
// // //                 selected: false,
// // //                 onTap: _openLearn,
// // //               ),
// // //               _navItem(
// // //                 icon: Icons.videocam_outlined,
// // //                 label: 'Practice',
// // //                 selected: false,
// // //                 onTap: _openPractice,
// // //               ),
// // //               _navItem(
// // //                 icon: Icons.person_outline_rounded,
// // //                 label: 'Profile',
// // //                 selected: false,
// // //                 onTap: _openProfile,
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // STREAK CARD
// // //   // ============================================================
// // //   Widget _statsCard() {
// // //     return Row(
// // //       children: [
// // //         // =========================================================
// // //         // XP CARD
// // //         // =========================================================
// // //         Expanded(
// // //           child: Container(
// // //             padding: const EdgeInsets.symmetric(
// // //               horizontal: 14,
// // //               vertical: 18,
// // //             ),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(22),
// // //               border: Border.all(
// // //                 color: const Color(0xFFE8E4EF),
// // //               ),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   width: 50,
// // //                   height: 50,
// // //                   decoration: BoxDecoration(
// // //                     color: const Color(0xFFFFF4D8),
// // //                     borderRadius: BorderRadius.circular(15),
// // //                   ),
// // //                   child: const Icon(
// // //                     Icons.bolt_rounded,
// // //                     color: Color(0xFFE5A83B),
// // //                     size: 28,
// // //                   ),
// // //                 ),
// // //
// // //                 const SizedBox(width: 10),
// // //
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment:
// // //                     CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         '$_xp',
// // //                         maxLines: 1,
// // //                         overflow: TextOverflow.ellipsis,
// // //                         style: const TextStyle(
// // //                           fontSize: 22,
// // //                           fontWeight: FontWeight.w900,
// // //                           color: darkText,
// // //                         ),
// // //                       ),
// // //                       const Text(
// // //                         'XP',
// // //                         maxLines: 1,
// // //                         style: TextStyle(
// // //                           fontSize: 11,
// // //                           color: secondaryText,
// // //                           fontWeight: FontWeight.w600,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //
// // //         const SizedBox(width: 12),
// // //
// // //         // =========================================================
// // //         // STREAK CARD
// // //         // =========================================================
// // //         Expanded(
// // //           child: Container(
// // //             padding: const EdgeInsets.symmetric(
// // //               horizontal: 14,
// // //               vertical: 18,
// // //             ),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(22),
// // //               border: Border.all(
// // //                 color: const Color(0xFFE8E4EF),
// // //               ),
// // //             ),
// // //             child: Row(
// // //               children: [
// // //                 Container(
// // //                   width: 50,
// // //                   height: 50,
// // //                   decoration: BoxDecoration(
// // //                     color: const Color(0xFFFFF3E4),
// // //                     borderRadius: BorderRadius.circular(15),
// // //                   ),
// // //                   child: const Icon(
// // //                     Icons.local_fire_department_rounded,
// // //                     color: Color(0xFFFF922B),
// // //                     size: 28,
// // //                   ),
// // //                 ),
// // //
// // //                 const SizedBox(width: 10),
// // //
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment:
// // //                     CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         '$_streak',
// // //                         maxLines: 1,
// // //                         overflow: TextOverflow.ellipsis,
// // //                         style: const TextStyle(
// // //                           fontSize: 22,
// // //                           fontWeight: FontWeight.w900,
// // //                           color: darkText,
// // //                         ),
// // //                       ),
// // //                       const Text(
// // //                         'Day Streak',
// // //                         maxLines: 1,
// // //                         overflow: TextOverflow.ellipsis,
// // //                         style: TextStyle(
// // //                           fontSize: 11,
// // //                           color: secondaryText,
// // //                           fontWeight: FontWeight.w600,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //   Widget _streakCard() {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(24),
// // //         border: Border.all(
// // //           color: const Color(0xFFE8E4EF),
// // //         ),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             width: 64,
// // //             height: 64,
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFFFFF3E4),
// // //               borderRadius: BorderRadius.circular(20),
// // //             ),
// // //             child: const Icon(
// // //               Icons.local_fire_department_rounded,
// // //               color: Color(0xFFFF922B),
// // //               size: 34,
// // //             ),
// // //           ),
// // //
// // //           const SizedBox(width: 17),
// // //
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment:
// // //               CrossAxisAlignment.start,
// // //               children: [
// // //                 const Text(
// // //                   'Learning Streak',
// // //                   style: TextStyle(
// // //                     fontSize: 17,
// // //                     fontWeight: FontWeight.w800,
// // //                     color: darkText,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 5),
// // //                 Text(
// // //                   _streak == 0
// // //                       ? 'Start learning today to build your streak!'
// // //                       : 'Keep learning to continue your streak.',
// // //                   style: const TextStyle(
// // //                     fontSize: 12,
// // //                     color: secondaryText,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //
// // //           Column(
// // //             children: [
// // //               Text(
// // //                 '$_streak',
// // //                 style: const TextStyle(
// // //                   fontSize: 25,
// // //                   fontWeight: FontWeight.w900,
// // //                   color: primary,
// // //                 ),
// // //               ),
// // //               const Text(
// // //                 'days',
// // //                 style: TextStyle(
// // //                   fontSize: 11,
// // //                   color: secondaryText,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // CONTINUE LEARNING
// // //   // ============================================================
// // //
// // //   Widget _continueLearningCard() {
// // //     return GestureDetector(
// // //       onTap: _openLearn,
// // //       child: Container(
// // //         width: double.infinity,
// // //         padding: const EdgeInsets.all(19),
// // //         decoration: BoxDecoration(
// // //           color: lightPrimary,
// // //           borderRadius: BorderRadius.circular(24),
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               width: 58,
// // //               height: 58,
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(18),
// // //               ),
// // //               child: const Icon(
// // //                 Icons.waving_hand_rounded,
// // //                 color: primary,
// // //                 size: 30,
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(width: 16),
// // //
// // //             const Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment:
// // //                 CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'Greetings',
// // //                     style: TextStyle(
// // //                       fontSize: 17,
// // //                       fontWeight: FontWeight.w900,
// // //                       color: darkText,
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 4),
// // //                   Text(
// // //                     'Continue learning basic greetings',
// // //                     style: TextStyle(
// // //                       fontSize: 12,
// // //                       color: secondaryText,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             const Icon(
// // //               Icons.arrow_forward_rounded,
// // //               color: primary,
// // //               size: 27,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // LEARNING JOURNEY
// // //   // ============================================================
// // //
// // //   Widget _learningJourneyCard() {
// // //     return GestureDetector(
// // //       onTap: _openLearn,
// // //       child: Container(
// // //         width: double.infinity,
// // //         padding: const EdgeInsets.all(20),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(24),
// // //           border: Border.all(
// // //             color: const Color(0xFFE8E4EF),
// // //           ),
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             _journeyRow(
// // //               icon: Icons.waving_hand_rounded,
// // //               title: 'Greetings',
// // //               subtitle: '3 signs',
// // //               active: true,
// // //             ),
// // //
// // //             _journeyConnector(),
// // //
// // //             _journeyRow(
// // //               icon: Icons.numbers_rounded,
// // //               title: 'Numbers',
// // //               subtitle: '5 signs',
// // //               active: false,
// // //             ),
// // //
// // //             _journeyConnector(),
// // //
// // //             _journeyRow(
// // //               icon: Icons.palette_outlined,
// // //               title: 'Colors',
// // //               subtitle: '5 signs',
// // //               active: false,
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _journeyRow({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //     required bool active,
// // //   }) {
// // //     return Row(
// // //       children: [
// // //         Container(
// // //           width: 54,
// // //           height: 54,
// // //           decoration: BoxDecoration(
// // //             color: active
// // //                 ? lightPrimary
// // //                 : const Color(0xFFF3F1F6),
// // //             shape: BoxShape.circle,
// // //             border: Border.all(
// // //               color: active
// // //                   ? primary
// // //                   : const Color(0xFFE0DDE5),
// // //               width: active ? 2 : 1,
// // //             ),
// // //           ),
// // //           child: Icon(
// // //             active
// // //                 ? icon
// // //                 : Icons.lock_outline_rounded,
// // //             color: active
// // //                 ? primary
// // //                 : const Color(0xFF9A96A5),
// // //             size: 25,
// // //           ),
// // //         ),
// // //
// // //         const SizedBox(width: 16),
// // //
// // //         Expanded(
// // //           child: Column(
// // //             crossAxisAlignment:
// // //             CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   fontSize: 16,
// // //                   fontWeight: FontWeight.w800,
// // //                   color: active
// // //                       ? darkText
// // //                       : secondaryText,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 3),
// // //               Text(
// // //                 subtitle,
// // //                 style: const TextStyle(
// // //                   fontSize: 12,
// // //                   color: secondaryText,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //
// // //         Icon(
// // //           active
// // //               ? Icons.arrow_forward_rounded
// // //               : Icons.lock_outline_rounded,
// // //           color: active
// // //               ? primary
// // //               : const Color(0xFFAAA6B1),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _journeyConnector() {
// // //     return Container(
// // //       margin: const EdgeInsets.only(
// // //         left: 26,
// // //         top: 6,
// // //         bottom: 6,
// // //       ),
// // //       height: 25,
// // //       width: 2,
// // //       color: const Color(0xFFE5E1EA),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // MOTIVATION
// // //   // ============================================================
// // //
// // //   Widget _motivationCard() {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(21),
// // //       decoration: BoxDecoration(
// // //         color: darkText,
// // //         borderRadius: BorderRadius.circular(24),
// // //       ),
// // //       child: const Column(
// // //         crossAxisAlignment:
// // //         CrossAxisAlignment.start,
// // //         children: [
// // //           Icon(
// // //             Icons.format_quote_rounded,
// // //             color: Colors.white54,
// // //             size: 32,
// // //           ),
// // //           SizedBox(height: 5),
// // //           Text(
// // //             'Every sign you learn brings you closer to better communication.',
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 16,
// // //               height: 1.5,
// // //               fontWeight: FontWeight.w700,
// // //             ),
// // //           ),
// // //           SizedBox(height: 12),
// // //           Text(
// // //             'Keep learning. Keep practicing.',
// // //             style: TextStyle(
// // //               color: Colors.white60,
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // ============================================================
// // //   // BOTTOM NAVIGATION ITEM
// // //   // ============================================================
// // //
// // //   Widget _navItem({
// // //     required IconData icon,
// // //     required String label,
// // //     required bool selected,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(16),
// // //       child: Padding(
// // //         padding: const EdgeInsets.symmetric(
// // //           horizontal: 12,
// // //           vertical: 7,
// // //         ),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             Container(
// // //               width: 48,
// // //               height: 32,
// // //               decoration: BoxDecoration(
// // //                 color: selected
// // //                     ? lightPrimary
// // //                     : Colors.transparent,
// // //                 borderRadius: BorderRadius.circular(14),
// // //               ),
// // //               child: Icon(
// // //                 icon,
// // //                 color: selected
// // //                     ? primary
// // //                     : secondaryText,
// // //                 size: 23,
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(height: 3),
// // //
// // //             Text(
// // //               label,
// // //               style: TextStyle(
// // //                 fontSize: 11,
// // //                 fontWeight: selected
// // //                     ? FontWeight.w800
// // //                     : FontWeight.w500,
// // //                 color: selected
// // //                     ? primary
// // //                     : secondaryText,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// //
// // import '../services/api_service.dart';
// // import '../services/app_storage.dart';
// //
// // import 'learn_screen.dart';
// // import 'practice_screen.dart';
// // import 'profile_screen.dart';
// // import 'settings_screen.dart';
// // import 'notifications_screen.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   final String? learnerName;
// //   final String? email;
// //   final String? goal;
// //   final String? level;
// //
// //   const HomeScreen({
// //     super.key,
// //     this.learnerName,
// //     this.email,
// //     this.goal,
// //     this.level,
// //   });
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   static const Color primary = Color(0xFF6C63A8);
// //   static const Color darkText = Color(0xFF29263D);
// //   static const Color secondaryText = Color(0xFF706B7C);
// //   static const Color background = Color(0xFFFFFBF5);
// //   static const Color lightPrimary = Color(0xFFEAE6F8);
// //
// //   String _name = '';
// //   String _email = '';
// //   String _goal = '';
// //
// //   bool _isLoading = true;
// //
// //   int _streak = 0;
// //   int _xp = 0;
// //
// //   int _completedLessons = 0;
// //   int _totalLessons = 0;
// //   double _completionPercentage = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLearnerData();
// //   }
// //
// //   // ============================================================
// //   // LOAD USER DATA + STREAK
// //   // ============================================================
// //
// //   Future<void> _loadLearnerData() async {
// //     try {
// //       final name = await AppStorage.getName();
// //       final email = await AppStorage.getEmail();
// //       final goal = await AppStorage.getGoal();
// //
// //       // getToken() returns String?, so null becomes ''
// //       final token = await AppStorage.getToken() ?? '';
// //
// //       int streak = 0;
// //       int finalXp = 0;
// //
// //       if (token.isNotEmpty) {
// //         try {
// //           final statistics =
// //           await ApiService.getStatistics(token);
// //
// //           streak = int.tryParse(
// //             statistics['currentStreak']?.toString() ?? '0',
// //           ) ?? 0;
// //
// //           finalXp = int.tryParse(
// //             statistics['xp']?.toString() ?? '0',
// //           ) ?? 0;
// //
// //           _completedLessons = int.tryParse(
// //             statistics['completedLessons']?.toString() ?? '0',
// //           ) ?? 0;
// //
// //           _totalLessons = int.tryParse(
// //             statistics['totalLessons']?.toString() ?? '0',
// //           ) ?? 0;
// //
// //           _completionPercentage = double.tryParse(
// //             statistics['completionPercentage']?.toString() ?? '0',
// //           ) ?? 0.0;
// //
// //           debugPrint('Current XP: $finalXp');
// //           debugPrint('Current streak: $streak');
// //         } catch (e) {
// //           debugPrint('Failed to load statistics: $e');
// //         }
// //       }
// //
// //       if (!mounted) return;
// //
// //       setState(() {
// //         _name = name.isNotEmpty
// //             ? name
// //             : (widget.learnerName ?? '');
// //
// //         _email = email.isNotEmpty
// //             ? email
// //             : (widget.email ?? '');
// //
// //         _goal = goal.isNotEmpty
// //             ? goal
// //             : (widget.goal ?? '');
// //
// //         _xp = finalXp;
// //         _streak = streak;
// //
// //         _isLoading = false;
// //       });
// //     } catch (e) {
// //       debugPrint('Failed to load home data: $e');
// //
// //       if (!mounted) return;
// //
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   String get _displayName {
// //     if (_name.trim().isEmpty) {
// //       return 'Learner';
// //     }
// //
// //     return _name.trim();
// //   }
// //
// //   String get _firstName {
// //     return _displayName.split(' ').first;
// //   }
// //
// //   String get _displayGoal {
// //     if (_goal.trim().isEmpty) {
// //       return 'Learn Indian Sign Language';
// //     }
// //
// //     return _goal.trim();
// //   }
// //
// //   // ============================================================
// //   // NAVIGATION
// //   // ============================================================
// //
// //   Future<void> _openLearn() async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const LearnScreen(),
// //       ),
// //     );
// //
// //     if (mounted) {
// //       await _loadLearnerData();
// //     }
// //   }
// //
// //   Future<void> _openPractice() async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const PracticeScreen(
// //           chapterTitle: 'Greetings',
// //         ),
// //       ),
// //     );
// //
// //     if (mounted) {
// //       await _loadLearnerData();
// //     }
// //   }
// //
// //   Future<void> _openProfile() async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => ProfileScreen(
// //           learnerName: _name,
// //           email: _email,
// //           goal: _goal,
// //         ),
// //       ),
// //     );
// //
// //     if (mounted) {
// //       await _loadLearnerData();
// //     }
// //   }
// //
// //   Future<void> _openSettings() async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const SettingsScreen(),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _openNotifications() async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const NotificationsScreen(),
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // BUILD
// //   // ============================================================
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (_isLoading) {
// //       return const Scaffold(
// //         backgroundColor: background,
// //         body: Center(
// //           child: CircularProgressIndicator(
// //             color: primary,
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Scaffold(
// //       backgroundColor: background,
// //
// //       appBar: AppBar(
// //         backgroundColor: background,
// //         elevation: 0,
// //         surfaceTintColor: Colors.transparent,
// //         automaticallyImplyLeading: false,
// //         title: const Text(
// //           'SAMVAAD',
// //           style: TextStyle(
// //             color: primary,
// //             fontSize: 22,
// //             fontWeight: FontWeight.w900,
// //             letterSpacing: 1.5,
// //           ),
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed: _openNotifications,
// //             icon: const Icon(
// //               Icons.notifications_none_rounded,
// //               color: darkText,
// //               size: 27,
// //             ),
// //           ),
// //           IconButton(
// //             onPressed: _openSettings,
// //             icon: const Icon(
// //               Icons.settings_outlined,
// //               color: darkText,
// //               size: 26,
// //             ),
// //           ),
// //           const SizedBox(width: 6),
// //         ],
// //       ),
// //
// //       body: RefreshIndicator(
// //         color: primary,
// //         onRefresh: _loadLearnerData,
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           padding: const EdgeInsets.fromLTRB(
// //             20,
// //             10,
// //             20,
// //             100,
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Hello, $_firstName 👋',
// //                 style: const TextStyle(
// //                   fontSize: 27,
// //                   fontWeight: FontWeight.w900,
// //                   color: darkText,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 7),
// //
// //               Text(
// //                 _displayGoal,
// //                 style: const TextStyle(
// //                   fontSize: 14,
// //                   color: secondaryText,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 28),
// //
// //               _statsCard(),
// //
// //               const SizedBox(height: 30),
// //
// //               const Text(
// //                 'Continue Learning',
// //                 style: TextStyle(
// //                   fontSize: 21,
// //                   fontWeight: FontWeight.w900,
// //                   color: darkText,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 14),
// //
// //               _continueLearningCard(),
// //
// //               const SizedBox(height: 30),
// //
// //               const Text(
// //                 'Your Learning Progress',
// //                 style: TextStyle(
// //                   fontSize: 21,
// //                   fontWeight: FontWeight.w900,
// //                   color: darkText,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 14),
// //
// //               _learningProgressCard(),
// //
// //               const SizedBox(height: 30),
// //
// //               _motivationCard(),
// //             ],
// //           ),
// //         ),
// //       ),
// //
// //       bottomNavigationBar: SafeArea(
// //         top: false,
// //         child: Container(
// //           height: 76,
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             border: Border(
// //               top: BorderSide(
// //                 color: Color(0xFFEAE6EF),
// //               ),
// //             ),
// //           ),
// //           child: Row(
// //             mainAxisAlignment:
// //             MainAxisAlignment.spaceAround,
// //             children: [
// //               _navItem(
// //                 icon: Icons.home_rounded,
// //                 label: 'Home',
// //                 selected: true,
// //                 onTap: () {},
// //               ),
// //               _navItem(
// //                 icon: Icons.menu_book_outlined,
// //                 label: 'Learn',
// //                 selected: false,
// //                 onTap: _openLearn,
// //               ),
// //               _navItem(
// //                 icon: Icons.videocam_outlined,
// //                 label: 'Practice',
// //                 selected: false,
// //                 onTap: _openPractice,
// //               ),
// //               _navItem(
// //                 icon: Icons.person_outline_rounded,
// //                 label: 'Profile',
// //                 selected: false,
// //                 onTap: _openProfile,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // STREAK CARD
// //   // ============================================================
// //   Widget _statsCard() {
// //     return Row(
// //       children: [
// //         // =========================================================
// //         // XP CARD
// //         // =========================================================
// //         Expanded(
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(
// //               horizontal: 14,
// //               vertical: 18,
// //             ),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(22),
// //               border: Border.all(
// //                 color: const Color(0xFFE8E4EF),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFFFF4D8),
// //                     borderRadius: BorderRadius.circular(15),
// //                   ),
// //                   child: const Icon(
// //                     Icons.bolt_rounded,
// //                     color: Color(0xFFE5A83B),
// //                     size: 28,
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 10),
// //
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment:
// //                     CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         '$_xp',
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.w900,
// //                           color: darkText,
// //                         ),
// //                       ),
// //                       const Text(
// //                         'XP',
// //                         maxLines: 1,
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           color: secondaryText,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //
// //         const SizedBox(width: 12),
// //
// //         // =========================================================
// //         // STREAK CARD
// //         // =========================================================
// //         Expanded(
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(
// //               horizontal: 14,
// //               vertical: 18,
// //             ),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(22),
// //               border: Border.all(
// //                 color: const Color(0xFFE8E4EF),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFFFF3E4),
// //                     borderRadius: BorderRadius.circular(15),
// //                   ),
// //                   child: const Icon(
// //                     Icons.local_fire_department_rounded,
// //                     color: Color(0xFFFF922B),
// //                     size: 28,
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 10),
// //
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment:
// //                     CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         '$_streak',
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.w900,
// //                           color: darkText,
// //                         ),
// //                       ),
// //                       const Text(
// //                         'Day Streak',
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           color: secondaryText,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //   Widget _streakCard() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         border: Border.all(
// //           color: const Color(0xFFE8E4EF),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 64,
// //             height: 64,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFFFFF3E4),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: const Icon(
// //               Icons.local_fire_department_rounded,
// //               color: Color(0xFFFF922B),
// //               size: 34,
// //             ),
// //           ),
// //
// //           const SizedBox(width: 17),
// //
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment:
// //               CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Learning Streak',
// //                   style: TextStyle(
// //                     fontSize: 17,
// //                     fontWeight: FontWeight.w800,
// //                     color: darkText,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Text(
// //                   _streak == 0
// //                       ? 'Start learning today to build your streak!'
// //                       : 'Keep learning to continue your streak.',
// //                   style: const TextStyle(
// //                     fontSize: 12,
// //                     color: secondaryText,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           Column(
// //             children: [
// //               Text(
// //                 '$_streak',
// //                 style: const TextStyle(
// //                   fontSize: 25,
// //                   fontWeight: FontWeight.w900,
// //                   color: primary,
// //                 ),
// //               ),
// //               const Text(
// //                 'days',
// //                 style: TextStyle(
// //                   fontSize: 11,
// //                   color: secondaryText,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // CONTINUE LEARNING
// //   // ============================================================
// //
// //   Widget _continueLearningCard() {
// //     return GestureDetector(
// //       onTap: _openLearn,
// //       child: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.all(19),
// //         decoration: BoxDecoration(
// //           color: lightPrimary,
// //           borderRadius: BorderRadius.circular(24),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 58,
// //               height: 58,
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(18),
// //               ),
// //               child: const Icon(
// //                 Icons.waving_hand_rounded,
// //                 color: primary,
// //                 size: 30,
// //               ),
// //             ),
// //
// //             const SizedBox(width: 16),
// //
// //             const Expanded(
// //               child: Column(
// //                 crossAxisAlignment:
// //                 CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Greetings',
// //                     style: TextStyle(
// //                       fontSize: 17,
// //                       fontWeight: FontWeight.w900,
// //                       color: darkText,
// //                     ),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     'Continue learning basic greetings',
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: secondaryText,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const Icon(
// //               Icons.arrow_forward_rounded,
// //               color: primary,
// //               size: 27,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // LEARNING PROGRESS
// //   // ============================================================
// //
// //   Widget _learningProgressCard() {
// //     final progress = (_completionPercentage / 100.0)
// //         .clamp(0.0, 1.0);
// //
// //     return GestureDetector(
// //       onTap: _openLearn,
// //       child: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(24),
// //           border: Border.all(
// //             color: const Color(0xFFE8E4EF),
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const Text(
// //                   'Overall Progress',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w800,
// //                     color: darkText,
// //                   ),
// //                 ),
// //                 Text(
// //                   '${_completionPercentage.round()}%',
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.w900,
// //                     color: primary,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //
// //             const SizedBox(height: 14),
// //
// //             ClipRRect(
// //               borderRadius: BorderRadius.circular(10),
// //               child: LinearProgressIndicator(
// //                 value: progress,
// //                 minHeight: 12,
// //                 backgroundColor: lightPrimary,
// //                 valueColor: const AlwaysStoppedAnimation<Color>(
// //                   primary,
// //                 ),
// //               ),
// //             ),
// //
// //
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // MOTIVATION
// //   // ============================================================
// //
// //   Widget _motivationCard() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(21),
// //       decoration: BoxDecoration(
// //         color: darkText,
// //         borderRadius: BorderRadius.circular(24),
// //       ),
// //       child: const Column(
// //         crossAxisAlignment:
// //         CrossAxisAlignment.start,
// //         children: [
// //           Icon(
// //             Icons.format_quote_rounded,
// //             color: Colors.white54,
// //             size: 32,
// //           ),
// //           SizedBox(height: 5),
// //           Text(
// //             'Every sign you learn brings you closer to better communication.',
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 16,
// //               height: 1.5,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),
// //           SizedBox(height: 12),
// //           Text(
// //             'Keep learning. Keep practicing.',
// //             style: TextStyle(
// //               color: Colors.white60,
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ============================================================
// //   // BOTTOM NAVIGATION ITEM
// //   // ============================================================
// //
// //   Widget _navItem({
// //     required IconData icon,
// //     required String label,
// //     required bool selected,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(16),
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(
// //           horizontal: 12,
// //           vertical: 7,
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               width: 48,
// //               height: 32,
// //               decoration: BoxDecoration(
// //                 color: selected
// //                     ? lightPrimary
// //                     : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(14),
// //               ),
// //               child: Icon(
// //                 icon,
// //                 color: selected
// //                     ? primary
// //                     : secondaryText,
// //                 size: 23,
// //               ),
// //             ),
// //
// //             const SizedBox(height: 3),
// //
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 11,
// //                 fontWeight: selected
// //                     ? FontWeight.w800
// //                     : FontWeight.w500,
// //                 color: selected
// //                     ? primary
// //                     : secondaryText,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
//
// import '../services/api_service.dart';
// import '../services/app_storage.dart';
//
// import 'learn_screen.dart';
// import 'practice_screen.dart';
// import 'profile_screen.dart';
// import 'settings_screen.dart';
// import 'notifications_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String? learnerName;
//   final String? email;
//   final String? goal;
//   final String? level;
//
//   const HomeScreen({
//     super.key,
//     this.learnerName,
//     this.email,
//     this.goal,
//     this.level,
//   });
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   static const Color primary = Color(0xFF6C63A8);
//   static const Color darkText = Color(0xFF29263D);
//   static const Color secondaryText = Color(0xFF706B7C);
//   static const Color background = Color(0xFFFFFBF5);
//   static const Color lightPrimary = Color(0xFFEAE6F8);
//
//   String _name = '';
//   String _email = '';
//   String _goal = '';
//
//   bool _isLoading = true;
//
//   int _streak = 0;
//   int _xp = 0;
//
//   int _completedLessons = 0;
//   int _totalLessons = 0;
//   double _completionPercentage = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLearnerData();
//   }
//
//   // ============================================================
//   // LOAD USER DATA + STREAK
//   // ============================================================
//
//   Future<void> _loadLearnerData() async {
//     try {
//       final name = await AppStorage.getName();
//       final email = await AppStorage.getEmail();
//       final goal = await AppStorage.getGoal();
//
//       // getToken() returns String?, so null becomes ''
//       final token = await AppStorage.getToken() ?? '';
//
//       int streak = 0;
//       int finalXp = 0;
//
//       if (token.isNotEmpty) {
//         try {
//           final statistics =
//           await ApiService.getStatistics(token);
//
//           streak = int.tryParse(
//             statistics['currentStreak']?.toString() ?? '0',
//           ) ?? 0;
//
//           finalXp = int.tryParse(
//             statistics['xp']?.toString() ?? '0',
//           ) ?? 0;
//
//           _completedLessons = int.tryParse(
//             statistics['completedLessons']?.toString() ?? '0',
//           ) ?? 0;
//
//           _totalLessons = int.tryParse(
//             statistics['totalLessons']?.toString() ?? '0',
//           ) ?? 0;
//
//           _completionPercentage = double.tryParse(
//             statistics['completionPercentage']?.toString() ?? '0',
//           ) ?? 0.0;
//
//           debugPrint('Current XP: $finalXp');
//           debugPrint('Current streak: $streak');
//         } catch (e) {
//           debugPrint('Failed to load statistics: $e');
//         }
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _name = name.isNotEmpty
//             ? name
//             : (widget.learnerName ?? '');
//
//         _email = email.isNotEmpty
//             ? email
//             : (widget.email ?? '');
//
//         _goal = goal.isNotEmpty
//             ? goal
//             : (widget.goal ?? '');
//
//         _xp = finalXp;
//         _streak = streak;
//
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('Failed to load home data: $e');
//
//       if (!mounted) return;
//
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   String get _displayName {
//     if (_name.trim().isEmpty) {
//       return 'Learner';
//     }
//
//     return _name.trim();
//   }
//
//   String get _firstName {
//     return _displayName.split(' ').first;
//   }
//
//   String get _displayGoal {
//     if (_goal.trim().isEmpty) {
//       return 'Learn Indian Sign Language';
//     }
//
//     return _goal.trim();
//   }
//
//   // ============================================================
//   // NAVIGATION
//   // ============================================================
//
//   Future<void> _openLearn() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const LearnScreen(),
//       ),
//     );
//
//     if (mounted) {
//       await _loadLearnerData();
//     }
//   }
//
//   Future<void> _openPractice() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const PracticeScreen(
//           chapterTitle: 'Greetings',
//         ),
//       ),
//     );
//
//     if (mounted) {
//       await _loadLearnerData();
//     }
//   }
//
//   Future<void> _openProfile() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ProfileScreen(
//           learnerName: _name,
//           email: _email,
//           goal: _goal,
//         ),
//       ),
//     );
//
//     if (mounted) {
//       await _loadLearnerData();
//     }
//   }
//
//   Future<void> _openSettings() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const SettingsScreen(),
//       ),
//     );
//   }
//
//   Future<void> _openNotifications() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const NotificationsScreen(),
//       ),
//     );
//   }
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         backgroundColor: background,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: primary,
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: background,
//
//       appBar: AppBar(
//         backgroundColor: background,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'SAMVAAD',
//           style: TextStyle(
//             color: primary,
//             fontSize: 22,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 1.5,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _openNotifications,
//             icon: const Icon(
//               Icons.notifications_none_rounded,
//               color: darkText,
//               size: 27,
//             ),
//           ),
//           IconButton(
//             onPressed: _openSettings,
//             icon: const Icon(
//               Icons.settings_outlined,
//               color: darkText,
//               size: 26,
//             ),
//           ),
//           const SizedBox(width: 6),
//         ],
//       ),
//
//       body: RefreshIndicator(
//         color: primary,
//         onRefresh: _loadLearnerData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.fromLTRB(
//             20,
//             10,
//             20,
//             100,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Hello, $_firstName 👋',
//                 style: const TextStyle(
//                   fontSize: 27,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 7),
//
//               Text(
//                 _displayGoal,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: secondaryText,
//                 ),
//               ),
//
//               const SizedBox(height: 28),
//
//               _statsCard(),
//
//               const SizedBox(height: 30),
//
//               const Text(
//                 'Continue Learning',
//                 style: TextStyle(
//                   fontSize: 21,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               _continueLearningCard(),
//
//               const SizedBox(height: 30),
//
//               const Text(
//                 'Your Learning Progress',
//                 style: TextStyle(
//                   fontSize: 21,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               _learningProgressCard(),
//
//               const SizedBox(height: 22),
//
//               _dailyGoalCard(),
//
//               const SizedBox(height: 18),
//
//               _quickPracticeCard(),
//
//               const SizedBox(height: 30),
//
//               _motivationCard(),
//             ],
//           ),
//         ),
//       ),
//
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Container(
//           height: 76,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             border: Border(
//               top: BorderSide(
//                 color: Color(0xFFEAE6EF),
//               ),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment:
//             MainAxisAlignment.spaceAround,
//             children: [
//               _navItem(
//                 icon: Icons.home_rounded,
//                 label: 'Home',
//                 selected: true,
//                 onTap: () {},
//               ),
//               _navItem(
//                 icon: Icons.menu_book_outlined,
//                 label: 'Learn',
//                 selected: false,
//                 onTap: _openLearn,
//               ),
//               _navItem(
//                 icon: Icons.videocam_outlined,
//                 label: 'Practice',
//                 selected: false,
//                 onTap: _openPractice,
//               ),
//               _navItem(
//                 icon: Icons.person_outline_rounded,
//                 label: 'Profile',
//                 selected: false,
//                 onTap: _openProfile,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // STREAK CARD
//   // ============================================================
//   Widget _statsCard() {
//     return Row(
//       children: [
//         // =========================================================
//         // XP CARD
//         // =========================================================
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 18,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(
//                 color: const Color(0xFFE8E4EF),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF4D8),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Icon(
//                     Icons.bolt_rounded,
//                     color: Color(0xFFE5A83B),
//                     size: 28,
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '$_xp',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w900,
//                           color: darkText,
//                         ),
//                       ),
//                       const Text(
//                         'XP',
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: secondaryText,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         // =========================================================
//         // STREAK CARD
//         // =========================================================
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 18,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(
//                 color: const Color(0xFFE8E4EF),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF3E4),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Icon(
//                     Icons.local_fire_department_rounded,
//                     color: Color(0xFFFF922B),
//                     size: 28,
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '$_streak',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w900,
//                           color: darkText,
//                         ),
//                       ),
//                       const Text(
//                         'Day Streak',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: secondaryText,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _streakCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: const Color(0xFFE8E4EF),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3E4),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Icon(
//               Icons.local_fire_department_rounded,
//               color: Color(0xFFFF922B),
//               size: 34,
//             ),
//           ),
//
//           const SizedBox(width: 17),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Learning Streak',
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w800,
//                     color: darkText,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   _streak == 0
//                       ? 'Start learning today to build your streak!'
//                       : 'Keep learning to continue your streak.',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: secondaryText,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Column(
//             children: [
//               Text(
//                 '$_streak',
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w900,
//                   color: primary,
//                 ),
//               ),
//               const Text(
//                 'days',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: secondaryText,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // CONTINUE LEARNING
//   // ============================================================
//
//   Widget _continueLearningCard() {
//     return GestureDetector(
//       onTap: _openLearn,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(19),
//         decoration: BoxDecoration(
//           color: lightPrimary,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 58,
//               height: 58,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: const Icon(
//                 Icons.waving_hand_rounded,
//                 color: primary,
//                 size: 30,
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Greetings',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w900,
//                       color: darkText,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Continue learning basic greetings',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: secondaryText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Icon(
//               Icons.arrow_forward_rounded,
//               color: primary,
//               size: 27,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // LEARNING PROGRESS
//   // ============================================================
//
//   Widget _learningProgressCard() {
//     final progress = (_completionPercentage / 100.0)
//         .clamp(0.0, 1.0);
//
//     return GestureDetector(
//       onTap: _openLearn,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(
//             color: const Color(0xFFE8E4EF),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Overall Progress',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w800,
//                     color: darkText,
//                   ),
//                 ),
//                 Text(
//                   '${_completionPercentage.round()}%',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w900,
//                     color: primary,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 14),
//
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: LinearProgressIndicator(
//                 value: progress,
//                 minHeight: 12,
//                 backgroundColor: lightPrimary,
//                 valueColor: const AlwaysStoppedAnimation<Color>(
//                   primary,
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // DAILY GOAL
//   // ============================================================
//
//   Widget _dailyGoalCard() {
//     final hasStreak = _streak > 0;
//
//     return GestureDetector(
//         onTap: _openLearn,
//         child: Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF7E8),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: const Color(0xFFF1E4C9),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 54,
//             height: 54,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFE8B2),
//               borderRadius: BorderRadius.circular(17),
//             ),
//             child: const Icon(
//               Icons.track_changes_rounded,
//               color: Color(0xFFE2A52D),
//               size: 29,
//             ),
//           ),
//
//           const SizedBox(width: 15),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Today's Goal",
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w900,
//                     color: darkText,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   hasStreak
//                       ? 'Complete one activity today to keep your streak going.'
//                       : 'Complete one activity today to start your learning streak.',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: secondaryText,
//                     height: 1.35,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 10),
//
//           IconButton(
//             onPressed: _openLearn,
//             icon: const Icon(
//               Icons.arrow_forward_rounded,
//               color: primary,
//               size: 27,
//             ),
//             tooltip: 'Start learning',
//           ),
//         ],
//       ),
//         ),
//     );
//   }
//
//   // ============================================================
//   // QUICK PRACTICE
//   // ============================================================
//
//   Widget _quickPracticeCard() {
//     return GestureDetector(
//       onTap: _openPractice,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: lightPrimary,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 54,
//               height: 54,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(17),
//               ),
//               child: const Icon(
//                 Icons.videocam_rounded,
//                 color: primary,
//                 size: 29,
//               ),
//             ),
//
//             const SizedBox(width: 15),
//
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Quick Practice',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w900,
//                       color: darkText,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Test the signs you have learned.',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: secondaryText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Icon(
//               Icons.arrow_forward_rounded,
//               color: primary,
//               size: 27,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // MOTIVATION
//   // ============================================================
//
//   Widget _motivationCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(21),
//       decoration: BoxDecoration(
//         color: darkText,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: const Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.format_quote_rounded,
//             color: Colors.white54,
//             size: 32,
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Every sign you learn brings you closer to better communication.',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               height: 1.5,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Keep learning. Keep practicing.',
//             style: TextStyle(
//               color: Colors.white60,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // BOTTOM NAVIGATION ITEM
//   // ============================================================
//
//   Widget _navItem({
//     required IconData icon,
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 7,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 48,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: selected
//                     ? lightPrimary
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(
//                 icon,
//                 color: selected
//                     ? primary
//                     : secondaryText,
//                 size: 23,
//               ),
//             ),
//
//             const SizedBox(height: 3),
//
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: selected
//                     ? FontWeight.w800
//                     : FontWeight.w500,
//                 color: selected
//                     ? primary
//                     : secondaryText,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/app_storage.dart';

import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? learnerName;
  final String? email;
  final String? goal;
  final String? level;

  const HomeScreen({
    super.key,
    this.learnerName,
    this.email,
    this.goal,
    this.level,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primary = Color(0xFF6C63A8);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF706B7C);
  static const Color background = Color(0xFFFFFBF5);
  static const Color lightPrimary = Color(0xFFEAE6F8);

  String _name = '';
  String _email = '';
  String _goal = '';

  bool _isLoading = true;

  int _streak = 0;
  int _xp = 0;
  int _unreadNotifications = 0;

  int _completedLessons = 0;
  int _totalLessons = 0;
  double _completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadLearnerData();
  }

  // ============================================================
  // LOAD USER DATA + STREAK
  // ============================================================

  Future<void> _loadLearnerData() async {
    try {
      final name = await AppStorage.getName();
      final email = await AppStorage.getEmail();
      final goal = await AppStorage.getGoal();

      // getToken() returns String?, so null becomes ''
      final token = await AppStorage.getToken() ?? '';

      int streak = 0;
      int finalXp = 0;
      int unreadNotifications = 0;

      if (token.isNotEmpty) {
        try {
          final statistics =
          await ApiService.getStatistics(token);

          streak = int.tryParse(
            statistics['currentStreak']?.toString() ?? '0',
          ) ?? 0;

          finalXp = int.tryParse(
            statistics['xp']?.toString() ?? '0',
          ) ?? 0;

          _completedLessons = int.tryParse(
            statistics['completedLessons']?.toString() ?? '0',
          ) ?? 0;

          _totalLessons = int.tryParse(
            statistics['totalLessons']?.toString() ?? '0',
          ) ?? 0;

          _completionPercentage = double.tryParse(
            statistics['completionPercentage']?.toString() ?? '0',
          ) ?? 0.0;

          try {
            unreadNotifications =
            await ApiService.getUnreadNotificationCount(token);
          } catch (e) {
            debugPrint('Failed to load notification count: $e');
          }

          debugPrint('Current XP: $finalXp');
          debugPrint('Current streak: $streak');
        } catch (e) {
          debugPrint('Failed to load statistics: $e');
        }
      }

      if (!mounted) return;

      setState(() {
        _name = name.isNotEmpty
            ? name
            : (widget.learnerName ?? '');

        _email = email.isNotEmpty
            ? email
            : (widget.email ?? '');

        _goal = goal.isNotEmpty
            ? goal
            : (widget.goal ?? '');

        _xp = finalXp;
        _streak = streak;
        _unreadNotifications = unreadNotifications;

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load home data: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _displayName {
    if (_name.trim().isEmpty) {
      return 'Learner';
    }

    return _name.trim();
  }

  String get _firstName {
    return _displayName.split(' ').first;
  }

  String get _displayGoal {
    if (_goal.trim().isEmpty) {
      return 'Learn Indian Sign Language';
    }

    return _goal.trim();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  Future<void> _openLearn() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LearnScreen(),
      ),
    );

    if (mounted) {
      await _loadLearnerData();
    }
  }

  Future<void> _openPractice() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PracticeScreen(
          chapterTitle: 'Greetings',
        ),
      ),
    );

    if (mounted) {
      await _loadLearnerData();
    }
  }

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          learnerName: _name,
          email: _email,
          goal: _goal,
        ),
      ),
    );

    if (mounted) {
      await _loadLearnerData();
    }
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );

    if (mounted) {
      await _loadLearnerData();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
        automaticallyImplyLeading: false,
        title: const Text(
          'SAMVAAD',
          style: TextStyle(
            color: primary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openNotifications,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: darkText,
                  size: 27,
                ),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE85D75),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: background,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _unreadNotifications > 99
                            ? '99+'
                            : '$_unreadNotifications',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(
              Icons.settings_outlined,
              color: darkText,
              size: 26,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: RefreshIndicator(
        color: primary,
        onRefresh: _loadLearnerData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $_firstName 👋',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                _displayGoal,
                style: const TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 28),

              _statsCard(),

              const SizedBox(height: 30),

              const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 14),

              _continueLearningCard(),

              const SizedBox(height: 30),

              const Text(
                'Your Learning Progress',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 14),

              _learningProgressCard(),

              const SizedBox(height: 22),

              _dailyGoalCard(),

              const SizedBox(height: 18),

              _quickPracticeCard(),

              const SizedBox(height: 30),

              _motivationCard(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFEAE6EF),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: true,
                onTap: () {},
              ),
              _navItem(
                icon: Icons.menu_book_outlined,
                label: 'Learn',
                selected: false,
                onTap: _openLearn,
              ),
              _navItem(
                icon: Icons.videocam_outlined,
                label: 'Practice',
                selected: false,
                onTap: _openPractice,
              ),
              _navItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                selected: false,
                onTap: _openProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STREAK CARD
  // ============================================================
  Widget _statsCard() {
    return Row(
      children: [
        // =========================================================
        // XP CARD
        // =========================================================
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE8E4EF),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Color(0xFFE5A83B),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_xp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: darkText,
                        ),
                      ),
                      const Text(
                        'XP',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // =========================================================
        // STREAK CARD
        // =========================================================
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE8E4EF),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF922B),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_streak',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: darkText,
                        ),
                      ),
                      const Text(
                        'Day Streak',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _streakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8E4EF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF922B),
              size: 34,
            ),
          ),

          const SizedBox(width: 17),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learning Streak',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _streak == 0
                      ? 'Start learning today to build your streak!'
                      : 'Keep learning to continue your streak.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                '$_streak',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
              const Text(
                'days',
                style: TextStyle(
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTINUE LEARNING
  // ============================================================

  Widget _continueLearningCard() {
    return GestureDetector(
      onTap: _openLearn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.waving_hand_rounded,
                color: primary,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Greetings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Continue learning basic greetings',
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_rounded,
              color: primary,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LEARNING PROGRESS
  // ============================================================

  Widget _learningProgressCard() {
    final progress = (_completionPercentage / 100.0)
        .clamp(0.0, 1.0);

    return GestureDetector(
      onTap: _openLearn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE8E4EF),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                Text(
                  '${_completionPercentage.round()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: lightPrimary,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  primary,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ============================================================
  // DAILY GOAL
  // ============================================================

  Widget _dailyGoalCard() {
    final hasStreak = _streak > 0;

    return GestureDetector(
      onTap: _openLearn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7E8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFF1E4C9),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8B2),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.track_changes_rounded,
                color: Color(0xFFE2A52D),
                size: 29,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Goal",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    hasStreak
                        ? 'Complete one activity today to keep your streak going.'
                        : 'Complete one activity today to start your learning streak.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            IconButton(
              onPressed: _openLearn,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: primary,
                size: 27,
              ),
              tooltip: 'Start learning',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUICK PRACTICE
  // ============================================================

  Widget _quickPracticeCard() {
    return GestureDetector(
      onTap: _openPractice,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.videocam_rounded,
                color: primary,
                size: 29,
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Practice',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: darkText,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Test the signs you have learned.',
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_rounded,
              color: primary,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _motivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: darkText,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: Colors.white54,
            size: 32,
          ),
          SizedBox(height: 5),
          Text(
            'Every sign you learn brings you closer to better communication.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Keep learning. Keep practicing.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION ITEM
  // ============================================================

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: selected
                    ? lightPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected
                    ? primary
                    : secondaryText,
                size: 23,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w800
                    : FontWeight.w500,
                color: selected
                    ? primary
                    : secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}