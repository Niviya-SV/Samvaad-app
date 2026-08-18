import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/app_storage.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SamvaadApp());
}

class SamvaadApp extends StatelessWidget {
  const SamvaadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samvaad',
      theme: AppTheme.lightTheme,
      home: const AppStartupScreen(),
    );
  }
}

class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await AppStorage.getToken();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isLoggedIn) {
      return const HomeScreen();
    }

    return const WelcomeScreen();
  }
}