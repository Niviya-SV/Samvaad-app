// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_storage.dart';
// import 'achievements_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final String learnerName;
//   final String email;
//   final String goal;
//
//   const ProfileScreen({
//     super.key,
//     required this.learnerName,
//     required this.email,
//     required this.goal,
//   });
//
//   @override
//   State<ProfileScreen> createState() =>
//       _ProfileScreenState();
// }
//
// class _ProfileScreenState
//     extends State<ProfileScreen> {
//   // ------------------------------------------------------------
//   // COLORS
//   // ------------------------------------------------------------
//
//   static const Color primary =
//   Color(0xFF6C63A8);
//
//   static const Color darkText =
//   Color(0xFF29263D);
//
//   static const Color secondaryText =
//   Color(0xFF706B7C);
//
//   static const Color background =
//   Color(0xFFFFFBF5);
//
//   static const Color lightPrimary =
//   Color(0xFFEAE6F8);
//
//   // ------------------------------------------------------------
//   // CONTROLLERS
//   // ------------------------------------------------------------
//
//   late final TextEditingController
//   _nameController;
//
//   late final TextEditingController
//   _emailController;
//
//   late final TextEditingController
//   _goalController;
//
//   // ------------------------------------------------------------
//   // STATE
//   // ------------------------------------------------------------
//
//   String _level = '';
//   int _xp = 0;
//   int _streak = 0;
//
//   bool _saving = false;
//
//   // ------------------------------------------------------------
//   // INIT
//   // ------------------------------------------------------------
//
//   @override
//   void initState() {
//     super.initState();
//
//     _nameController =
//         TextEditingController(
//           text: widget.learnerName,
//         );
//
//     _emailController =
//         TextEditingController(
//           text: widget.email,
//         );
//
//     _goalController =
//         TextEditingController(
//           text: widget.goal,
//         );
//
//     _loadLevel();
//   }
//
//   // ------------------------------------------------------------
//   // LOAD LEVEL
//   // ------------------------------------------------------------
//
//   Future<void> _loadLevel() async {
//     final level = await AppStorage.getLevel();
//
//     int xp = 0;
//     int streak = 0;
//
//     final token = await AppStorage.getToken();
//
//     if (token != null && token.isNotEmpty) {
//       try {
//         final statistics =
//         await ApiService.getStatistics(token);
//
//         xp = int.tryParse(
//           statistics['xp']?.toString() ?? '0',
//         ) ??
//             0;
//
//         streak = int.tryParse(
//           statistics['currentStreak']?.toString() ?? '0',
//         ) ??
//             0;
//       } catch (e) {
//         debugPrint('Failed to load profile statistics: $e');
//       }
//     }
//
//     if (!mounted) return;
//
//     setState(() {
//       _level = level;
//       _xp = xp;
//       _streak = streak;
//     });
//   }
//
//   // ------------------------------------------------------------
//   // DISPOSE
//   // ------------------------------------------------------------
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _goalController.dispose();
//
//     super.dispose();
//   }
//
//   // ------------------------------------------------------------
//   // SAVE PROFILE
//   // ------------------------------------------------------------
//
//   Future<void> _saveProfile() async {
//     final name =
//     _nameController.text.trim();
//
//     final email =
//     _emailController.text.trim();
//
//     final goal =
//     _goalController.text.trim();
//
//     if (name.isEmpty) {
//       _showMessage(
//         'Please enter your name.',
//       );
//       return;
//     }
//
//     if (email.isEmpty) {
//       _showMessage(
//         'Please enter your email.',
//       );
//       return;
//     }
//
//     setState(() {
//       _saving = true;
//     });
//
//     try {
//       await AppStorage.saveProfile(
//         name: name,
//         email: email,
//         goal: goal,
//         level: _level,
//       );
//
//       if (!mounted) return;
//
//       _showMessage(
//         'Profile updated successfully!',
//       );
//
//       // IMPORTANT:
//       // Do NOT create another HomeScreen.
//       // Just return to the existing HomeScreen.
//       Navigator.pop(context);
//     } catch (e) {
//       if (!mounted) return;
//
//       setState(() {
//         _saving = false;
//       });
//
//       _showMessage(
//         'Could not save profile.',
//       );
//     }
//   }
//
//   // ------------------------------------------------------------
//   // CHANGE LEVEL
//   // ------------------------------------------------------------
//
//   void _selectLevel() {
//     showModalBottomSheet(
//       context: context,
//
//       backgroundColor: Colors.white,
//
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(25),
//         ),
//       ),
//
//       builder: (sheetContext) {
//         final levels = [
//           'Beginner',
//           'Intermediate',
//           'Advanced',
//         ];
//
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//
//               children: [
//                 const Text(
//                   'Choose your level',
//                   style: TextStyle(
//                     fontSize: 21,
//                     fontWeight: FontWeight.w900,
//                     color: darkText,
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 const Text(
//                   'You can change this anytime.',
//                   style: TextStyle(
//                     color: secondaryText,
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 ...levels.map(
//                       (level) {
//                     final selected =
//                         _level == level;
//
//                     return ListTile(
//                       contentPadding:
//                       EdgeInsets.zero,
//
//                       leading: Container(
//                         width: 44,
//                         height: 44,
//
//                         decoration: BoxDecoration(
//                           color: selected
//                               ? lightPrimary
//                               : const Color(
//                             0xFFF4F2F8,
//                           ),
//                           shape: BoxShape.circle,
//                         ),
//
//                         child: Icon(
//                           level == 'Beginner'
//                               ? Icons.looks_one_rounded
//                               : level ==
//                               'Intermediate'
//                               ? Icons
//                               .looks_two_rounded
//                               : Icons
//                               .looks_3_rounded,
//
//                           color: selected
//                               ? primary
//                               : secondaryText,
//                         ),
//                       ),
//
//                       title: Text(
//                         level,
//                         style: TextStyle(
//                           fontWeight:
//                           FontWeight.w700,
//
//                           color: selected
//                               ? primary
//                               : darkText,
//                         ),
//                       ),
//
//                       trailing: selected
//                           ? const Icon(
//                         Icons
//                             .check_circle_rounded,
//                         color: primary,
//                       )
//                           : null,
//
//                       onTap: () {
//                         setState(() {
//                           _level = level;
//                         });
//
//                         Navigator.pop(
//                           sheetContext,
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // ------------------------------------------------------------
//   // DELETE PROFILE
//   // ------------------------------------------------------------
//
//   Future<void> _deleteProfile() async {
//     final confirmed =
//     await showDialog<bool>(
//       context: context,
//
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text(
//             'Remove profile?',
//           ),
//
//           content: const Text(
//             'This will remove your locally saved profile and settings from this device.',
//           ),
//
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   false,
//                 );
//               },
//
//               child: const Text(
//                 'Cancel',
//               ),
//             ),
//
//             FilledButton(
//               style: FilledButton.styleFrom(
//                 backgroundColor:
//                 Colors.redAccent,
//               ),
//
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   true,
//                 );
//               },
//
//               child: const Text(
//                 'Remove',
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmed != true) {
//       return;
//     }
//
//     await AppStorage.clearLocalData();
//
//     if (!mounted) return;
//
//     _showMessage(
//       'Local profile data removed.',
//     );
//
//     Navigator.pop(context);
//   }
//
//   // ------------------------------------------------------------
//   // MESSAGE
//   // ------------------------------------------------------------
//
//   void _showMessage(String message) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           behavior:
//           SnackBarBehavior.floating,
//         ),
//       );
//   }
//
//   // ------------------------------------------------------------
//   // BUILD
//   // ------------------------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//
//       appBar: AppBar(
//         backgroundColor: background,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//
//         title: const Text(
//           'My Profile',
//           style: TextStyle(
//             color: darkText,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             color: darkText,
//           ),
//         ),
//       ),
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(
//             20,
//             10,
//             20,
//             30,
//           ),
//
//           child: Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//
//             children: [
//               // ==================================================
//               // AVATAR
//               // ==================================================
//
//               Center(
//                 child: Container(
//                   width: 92,
//                   height: 92,
//
//                   decoration: BoxDecoration(
//                     color: lightPrimary,
//                     shape: BoxShape.circle,
//
//                     border: Border.all(
//                       color:
//                       primary.withValues(
//                         alpha: 0.18,
//                       ),
//                       width: 3,
//                     ),
//                   ),
//
//                   child: const Icon(
//                     Icons.person_rounded,
//                     color: primary,
//                     size: 52,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               Center(
//                 child: Text(
//                   _nameController.text.isEmpty
//                       ? 'Learner'
//                       : _nameController.text,
//
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     color: darkText,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 5),
//
//               const Center(
//                 child: Text(
//                   'Your Samvaad learning profile',
//                   style: TextStyle(
//                     color: secondaryText,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // ==================================================
//               // PERSONAL DETAILS
//               // ==================================================
//
//               const Text(
//                 'Personal Details',
//                 style: TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               _textField(
//                 controller: _nameController,
//                 label: 'Full Name',
//                 hint: 'Enter your name',
//                 icon: Icons.person_outline_rounded,
//                 onChanged: (_) {
//                   setState(() {});
//                 },
//               ),
//
//               const SizedBox(height: 15),
//
//               _textField(
//                 controller: _emailController,
//                 label: 'Email',
//                 hint: 'Enter your email',
//                 icon: Icons.email_outlined,
//                 keyboardType:
//                 TextInputType.emailAddress,
//               ),
//
//               const SizedBox(height: 15),
//
//               _textField(
//                 controller: _goalController,
//                 label: 'Learning Goal',
//                 hint: 'What do you want to achieve?',
//                 icon: Icons.flag_outlined,
//                 maxLines: 2,
//               ),
//
//               const SizedBox(height: 25),
//
//               // ==================================================
//               // LEVEL
//               // ==================================================
//
//               const Text(
//                 'Learning Level',
//                 style: TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               GestureDetector(
//                 onTap: _selectLevel,
//
//                 child: Container(
//                   width: double.infinity,
//                   padding:
//                   const EdgeInsets.all(16),
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//
//                     borderRadius:
//                     BorderRadius.circular(18),
//
//                     border: Border.all(
//                       color:
//                       const Color(0xFFE4E0EC),
//                     ),
//                   ),
//
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 44,
//                         height: 44,
//
//                         decoration: BoxDecoration(
//                           color: lightPrimary,
//                           borderRadius:
//                           BorderRadius.circular(
//                             13,
//                           ),
//                         ),
//
//                         child: const Icon(
//                           Icons.school_outlined,
//                           color: primary,
//                         ),
//                       ),
//
//                       const SizedBox(width: 13),
//
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//
//                           children: [
//                             const Text(
//                               'Current Level',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color:
//                                 secondaryText,
//                               ),
//                             ),
//
//                             const SizedBox(height: 3),
//
//                             Text(
//                               _level.isEmpty
//                                   ? 'Not selected'
//                                   : _level,
//
//                               style:
//                               const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight:
//                                 FontWeight.w800,
//                                 color: darkText,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const Icon(
//                         Icons
//                             .keyboard_arrow_down_rounded,
//                         color: secondaryText,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
// // ==================================================
// // ACHIEVEMENTS
// // ==================================================
//
//               const Text(
//                 'Achievements',
//                 style: TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.w900,
//                   color: darkText,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const AchievementsScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(
//                       color: const Color(0xFFE4E0EC),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 48,
//                         height: 48,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFFF4D8),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Icon(
//                           Icons.emoji_events_rounded,
//                           color: Color(0xFFE5A83B),
//                           size: 27,
//                         ),
//                       ),
//
//                       const SizedBox(width: 14),
//
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'My Achievements',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w800,
//                                 color: darkText,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'View your unlocked achievements and rewards',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: secondaryText,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         color: secondaryText,
//                         size: 17,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
// // ==================================================
// // SAVE
// // ==================================================
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//
//                 child: FilledButton(
//                   onPressed:
//                   _saving
//                       ? null
//                       : _saveProfile,
//
//                   style:
//                   FilledButton.styleFrom(
//                     backgroundColor: primary,
//                     foregroundColor:
//                     Colors.white,
//
//                     disabledBackgroundColor:
//                     primary.withValues(
//                       alpha: 0.5,
//                     ),
//
//                     shape:
//                     RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(
//                         17,
//                       ),
//                     ),
//                   ),
//
//                   child: _saving
//                       ? const SizedBox(
//                     width: 23,
//                     height: 23,
//
//                     child:
//                     CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       color: Colors.white,
//                     ),
//                   )
//                       : const Text(
//                     'Save Changes',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight:
//                       FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // ==================================================
//               // REMOVE
//               // ==================================================
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//
//                 child: OutlinedButton.icon(
//                   onPressed:
//                   _deleteProfile,
//
//                   icon: const Icon(
//                     Icons.delete_outline_rounded,
//                     color: Colors.redAccent,
//                   ),
//
//                   label: const Text(
//                     'Remove Local Profile',
//                     style: TextStyle(
//                       color: Colors.redAccent,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   style:
//                   OutlinedButton.styleFrom(
//                     side: const BorderSide(
//                       color: Color(0xFFFFCDD2),
//                     ),
//
//                     shape:
//                     RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(
//                         17,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Your profile is stored locally on this device.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: secondaryText,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // TEXT FIELD
//   // ============================================================
//
//   Widget _textField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     ValueChanged<String>? onChanged,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       onChanged: onChanged,
//
//       style: const TextStyle(
//         color: darkText,
//         fontWeight: FontWeight.w600,
//       ),
//
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//
//         labelStyle: const TextStyle(
//           color: secondaryText,
//         ),
//
//         hintStyle: const TextStyle(
//           color: Color(0xFFAAA6B4),
//         ),
//
//         prefixIcon: Icon(
//           icon,
//           color: primary,
//         ),
//
//         filled: true,
//         fillColor: Colors.white,
//
//         contentPadding:
//         const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 17,
//         ),
//
//         border: OutlineInputBorder(
//           borderRadius:
//           BorderRadius.circular(18),
//
//           borderSide: const BorderSide(
//             color: Color(0xFFE4E0EC),
//           ),
//         ),
//
//         enabledBorder:
//         OutlineInputBorder(
//           borderRadius:
//           BorderRadius.circular(18),
//
//           borderSide: const BorderSide(
//             color: Color(0xFFE4E0EC),
//           ),
//         ),
//
//         focusedBorder:
//         OutlineInputBorder(
//           borderRadius:
//           BorderRadius.circular(18),
//
//           borderSide: const BorderSide(
//             color: primary,
//             width: 1.5,
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_storage.dart';
import 'achievements_screen.dart';

class ProfileScreen extends StatefulWidget {
final String learnerName;
final String email;
final String goal;

const ProfileScreen({
super.key,
required this.learnerName,
required this.email,
required this.goal,
});

@override
State<ProfileScreen> createState() =>
_ProfileScreenState();
}

class _ProfileScreenState
extends State<ProfileScreen> {
// ------------------------------------------------------------
// COLORS
// ------------------------------------------------------------

static const Color primary =
Color(0xFF6C63A8);

static const Color darkText =
Color(0xFF29263D);

static const Color secondaryText =
Color(0xFF706B7C);

static const Color background =
Color(0xFFFFFBF5);

static const Color lightPrimary =
Color(0xFFEAE6F8);

// ------------------------------------------------------------
// CONTROLLERS
// ------------------------------------------------------------

late final TextEditingController
_nameController;

late final TextEditingController
_emailController;

late final TextEditingController
_goalController;

// ------------------------------------------------------------
// STATE
// ------------------------------------------------------------

String _level = '';
int _xp = 0;
int _streak = 0;

bool _saving = false;

// ------------------------------------------------------------
// INIT
// ------------------------------------------------------------

@override
void initState() {
super.initState();

_nameController =
TextEditingController(
text: widget.learnerName,
);

_emailController =
TextEditingController(
text: widget.email,
);

_goalController =
TextEditingController(
text: widget.goal,
);

_loadLevel();
}

// ------------------------------------------------------------
// LOAD LEVEL
// ------------------------------------------------------------

Future<void> _loadLevel() async {
final level = await AppStorage.getLevel();

int xp = 0;
int streak = 0;

final token = await AppStorage.getToken();

if (token != null && token.isNotEmpty) {
try {
final statistics =
await ApiService.getStatistics(token);

xp = int.tryParse(
statistics['xp']?.toString() ?? '0',
) ??
0;

streak = int.tryParse(
statistics['currentStreak']?.toString() ?? '0',
) ??
0;
} catch (e) {
debugPrint('Failed to load profile statistics: $e');
}
}

if (!mounted) return;

setState(() {
_level = level;
_xp = xp;
_streak = streak;
});
}

// ------------------------------------------------------------
// DISPOSE
// ------------------------------------------------------------

@override
void dispose() {
_nameController.dispose();
_emailController.dispose();
_goalController.dispose();

super.dispose();
}

// ------------------------------------------------------------
// SAVE PROFILE
// ------------------------------------------------------------

Future<void> _saveProfile() async {
final name =
_nameController.text.trim();

final email =
_emailController.text.trim();

final goal =
_goalController.text.trim();

if (name.isEmpty) {
_showMessage(
'Please enter your name.',
);
return;
}

if (email.isEmpty) {
_showMessage(
'Please enter your email.',
);
return;
}

setState(() {
_saving = true;
});

try {
await AppStorage.saveProfile(
name: name,
email: email,
goal: goal,
level: _level,
);

if (!mounted) return;

_showMessage(
'Profile updated successfully!',
);

// IMPORTANT:
// Do NOT create another HomeScreen.
// Just return to the existing HomeScreen.
Navigator.pop(context);
} catch (e) {
if (!mounted) return;

setState(() {
_saving = false;
});

_showMessage(
'Could not save profile.',
);
}
}

// ------------------------------------------------------------
// CHANGE LEVEL
// ------------------------------------------------------------

void _selectLevel() {
showModalBottomSheet(
context: context,

backgroundColor: Colors.white,

shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(25),
),
),

builder: (sheetContext) {
final levels = [
'Beginner',
'Intermediate',
'Advanced',
];

return SafeArea(
child: Padding(
padding: const EdgeInsets.all(24),

child: Column(
mainAxisSize: MainAxisSize.min,

crossAxisAlignment:
CrossAxisAlignment.start,

children: [
const Text(
'Choose your level',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.w900,
color: darkText,
),
),

const SizedBox(height: 8),

const Text(
'You can change this anytime.',
style: TextStyle(
color: secondaryText,
),
),

const SizedBox(height: 20),

...levels.map(
(level) {
final selected =
_level == level;

return ListTile(
contentPadding:
EdgeInsets.zero,

leading: Container(
width: 44,
height: 44,

decoration: BoxDecoration(
color: selected
? lightPrimary
    : const Color(
0xFFF4F2F8,
),
shape: BoxShape.circle,
),

child: Icon(
level == 'Beginner'
? Icons.looks_one_rounded
    : level ==
'Intermediate'
? Icons
    .looks_two_rounded
    : Icons
    .looks_3_rounded,

color: selected
? primary
    : secondaryText,
),
),

title: Text(
level,
style: TextStyle(
fontWeight:
FontWeight.w700,

color: selected
? primary
    : darkText,
),
),

trailing: selected
? const Icon(
Icons
    .check_circle_rounded,
color: primary,
)
    : null,

onTap: () {
setState(() {
_level = level;
});

Navigator.pop(
sheetContext,
);
},
);
},
),

const SizedBox(height: 10),
],
),
),
);
},
);
}

// ------------------------------------------------------------
// DELETE PROFILE
// ------------------------------------------------------------

Future<void> _deleteProfile() async {
final confirmed =
await showDialog<bool>(
context: context,

builder: (dialogContext) {
return AlertDialog(
title: const Text(
'Remove profile?',
),

content: const Text(
'This will remove your locally saved profile and settings from this device.',
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
backgroundColor:
Colors.redAccent,
),

onPressed: () {
Navigator.pop(
dialogContext,
true,
);
},

child: const Text(
'Remove',
),
),
],
);
},
);

if (confirmed != true) {
return;
}

await AppStorage.clearLocalData();

if (!mounted) return;

_showMessage(
'Local profile data removed.',
);

Navigator.pop(context);
}

// ------------------------------------------------------------
// MESSAGE
// ------------------------------------------------------------

void _showMessage(String message) {
if (!mounted) return;

ScaffoldMessenger.of(context)
..hideCurrentSnackBar()
..showSnackBar(
SnackBar(
content: Text(message),
behavior:
SnackBarBehavior.floating,
),
);
}

// ------------------------------------------------------------
// BUILD
// ------------------------------------------------------------

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: background,

appBar: AppBar(
backgroundColor: background,
elevation: 0,
surfaceTintColor: Colors.transparent,

title: const Text(
'My Profile',
style: TextStyle(
color: darkText,
fontWeight: FontWeight.w900,
),
),

leading: IconButton(
onPressed: () {
Navigator.pop(context);
},

icon: const Icon(
Icons.arrow_back_rounded,
color: darkText,
),
),
),

body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(
20,
10,
20,
30,
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
// ==================================================
// AVATAR
// ==================================================

Center(
child: Container(
width: 92,
height: 92,

decoration: BoxDecoration(
color: lightPrimary,
shape: BoxShape.circle,

border: Border.all(
color:
primary.withValues(
alpha: 0.18,
),
width: 3,
),
),

child: const Icon(
Icons.person_rounded,
color: primary,
size: 52,
),
),
),

const SizedBox(height: 14),

Center(
child: Text(
_nameController.text.isEmpty
? 'Learner'
    : _nameController.text,

style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.w900,
color: darkText,
),
),
),

const SizedBox(height: 5),

const Center(
child: Text(
'Your Samvaad learning profile',
style: TextStyle(
color: secondaryText,
fontSize: 13,
),
),
),

const SizedBox(height: 30),
Row(
children: [
Expanded(
child: _profileStatCard(
icon: Icons.bolt_rounded,
value: '$_xp',
label: 'XP',
iconColor: const Color(0xFFE5A83B),
iconBackground: const Color(0xFFFFF4D8),
),
),

const SizedBox(width: 12),

Expanded(
child: _profileStatCard(
icon: Icons.local_fire_department_rounded,
value: '$_streak',
label: 'Day Streak',
iconColor: const Color(0xFFFF922B),
iconBackground: const Color(0xFFFFF3E4),
),
),
],
),

const SizedBox(height: 30),

// ==================================================
// PERSONAL DETAILS
// ==================================================

const Text(
'Personal Details',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.w900,
color: darkText,
),
),

const SizedBox(height: 12),


_textField(
controller: _nameController,
label: 'Full Name',
hint: 'Enter your name',
icon: Icons.person_outline_rounded,
onChanged: (_) {
setState(() {});
},
),

const SizedBox(height: 15),

_textField(
controller: _emailController,
label: 'Email',
hint: 'Enter your email',
icon: Icons.email_outlined,
keyboardType:
TextInputType.emailAddress,
),

const SizedBox(height: 15),

_textField(
controller: _goalController,
label: 'Learning Goal',
hint: 'What do you want to achieve?',
icon: Icons.flag_outlined,
maxLines: 2,
),

const SizedBox(height: 25),

// ==================================================
// LEVEL
// ==================================================

const Text(
'Learning Level',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.w900,
color: darkText,
),
),

const SizedBox(height: 12),

GestureDetector(
onTap: _selectLevel,

child: Container(
width: double.infinity,
padding:
const EdgeInsets.all(16),

decoration: BoxDecoration(
color: Colors.white,

borderRadius:
BorderRadius.circular(18),

border: Border.all(
color:
const Color(0xFFE4E0EC),
),
),

child: Row(
children: [
Container(
width: 44,
height: 44,

decoration: BoxDecoration(
color: lightPrimary,
borderRadius:
BorderRadius.circular(
13,
),
),

child: const Icon(
Icons.school_outlined,
color: primary,
),
),

const SizedBox(width: 13),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
const Text(
'Current Level',
style: TextStyle(
fontSize: 11,
color:
secondaryText,
),
),

const SizedBox(height: 3),

Text(
_level.isEmpty
? 'Not selected'
    : _level,

style:
const TextStyle(
fontSize: 15,
fontWeight:
FontWeight.w800,
color: darkText,
),
),
],
),
),

const Icon(
Icons
    .keyboard_arrow_down_rounded,
color: secondaryText,
),
],
),
),
),

const SizedBox(height: 30),

// ==================================================
// ACHIEVEMENTS
// ==================================================

const Text(
'Achievements',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.w900,
color: darkText,
),
),

const SizedBox(height: 12),

GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const AchievementsScreen(),
),
);
},
child: Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(
color: const Color(0xFFE4E0EC),
),
),
child: Row(
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
color: const Color(0xFFFFF4D8),
borderRadius: BorderRadius.circular(14),
),
child: const Icon(
Icons.emoji_events_rounded,
color: Color(0xFFE5A83B),
size: 27,
),
),

const SizedBox(width: 14),

const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'My Achievements',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w800,
color: darkText,
),
),
SizedBox(height: 4),
Text(
'View your unlocked achievements and rewards',
style: TextStyle(
fontSize: 12,
color: secondaryText,
),
),
],
),
),

const Icon(
Icons.arrow_forward_ios_rounded,
color: secondaryText,
size: 17,
),
],
),
),
),

const SizedBox(height: 30),

// ==================================================
// SAVE
// ==================================================

SizedBox(
width: double.infinity,
height: 55,

child: FilledButton(
onPressed:
_saving
? null
    : _saveProfile,

style:
FilledButton.styleFrom(
backgroundColor: primary,
foregroundColor:
Colors.white,

disabledBackgroundColor:
primary.withValues(
alpha: 0.5,
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
17,
),
),
),

child: _saving
? const SizedBox(
width: 23,
height: 23,

child:
CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
)
    : const Text(
'Save Changes',
style: TextStyle(
fontSize: 16,
fontWeight:
FontWeight.w800,
),
),
),
),

const SizedBox(height: 16),

// ==================================================
// REMOVE
// ==================================================

SizedBox(
width: double.infinity,
height: 52,

child: OutlinedButton.icon(
onPressed:
_deleteProfile,

icon: const Icon(
Icons.delete_outline_rounded,
color: Colors.redAccent,
),

label: const Text(
'Remove Local Profile',
style: TextStyle(
color: Colors.redAccent,
fontWeight: FontWeight.w700,
),
),

style:
OutlinedButton.styleFrom(
side: const BorderSide(
color: Color(0xFFFFCDD2),
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
17,
),
),
),
),
),

const SizedBox(height: 15),

const Center(
child: Text(
'Your profile is stored locally on this device.',
textAlign: TextAlign.center,
style: TextStyle(
color: secondaryText,
fontSize: 11,
),
),
),
],
),
),
),
);
}

// ============================================================
// TEXT FIELD
// ============================================================


Widget _profileStatCard({
required IconData icon,
required String value,
required String label,
required Color iconColor,
required Color iconBackground,
}) {
return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: const Color(0xFFE4E0EC),
),
),
child: Row(
children: [
Container(
width: 46,
height: 46,
decoration: BoxDecoration(
color: iconBackground,
borderRadius: BorderRadius.circular(14),
),
child: Icon(
icon,
color: iconColor,
size: 26,
),
),
const SizedBox(width: 10),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
value,
style: const TextStyle(
fontSize: 21,
fontWeight: FontWeight.w900,
color: darkText,
),
),
Text(
label,
style: const TextStyle(
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
);
}

Widget _textField({
required TextEditingController controller,
required String label,
required String hint,
required IconData icon,
TextInputType? keyboardType,
int maxLines = 1,
ValueChanged<String>? onChanged,
}) {
return TextField(
controller: controller,
keyboardType: keyboardType,
maxLines: maxLines,
onChanged: onChanged,

style: const TextStyle(
color: darkText,
fontWeight: FontWeight.w600,
),

decoration: InputDecoration(
labelText: label,
hintText: hint,

labelStyle: const TextStyle(
color: secondaryText,
),

hintStyle: const TextStyle(
color: Color(0xFFAAA6B4),
),

prefixIcon: Icon(
icon,
color: primary,
),

filled: true,
fillColor: Colors.white,

contentPadding:
const EdgeInsets.symmetric(
horizontal: 16,
vertical: 17,
),

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),

borderSide: const BorderSide(
color: Color(0xFFE4E0EC),
),
),

enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),

borderSide: const BorderSide(
color: Color(0xFFE4E0EC),
),
),

focusedBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),

borderSide: const BorderSide(
color: primary,
width: 1.5,
),
),
),
);
}
}