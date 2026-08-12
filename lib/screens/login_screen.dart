import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/app_storage.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // =========================================================
  // STATE
  // =========================================================

  bool _obscurePassword = true;
  bool _isLoading = false;

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email =
      _emailController.text.trim();

      final password =
          _passwordController.text;

      // =======================================================
      // CALL LOGIN API
      // =======================================================

      final result = await ApiService.login(
        email,
        password,
      );

      debugPrint(
        'LOGIN RESPONSE: $result',
      );

      // =======================================================
      // GET JWT TOKEN
      // =======================================================

      final token =
      result['token']?.toString();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Login succeeded but no token was received.',
        );
      }

      // =======================================================
      // SAVE JWT THROUGH AppStorage
      // =======================================================

      await AppStorage.saveToken(token);

      debugPrint(
        'JWT TOKEN SAVED SUCCESSFULLY',
      );

      // =======================================================
      // VERIFY TOKEN WAS ACTUALLY SAVED
      // =======================================================

      final savedToken =
      await AppStorage.getToken();

      if (savedToken == null ||
          savedToken.isEmpty) {
        throw Exception(
          'Login succeeded but the session could not be saved.',
        );
      }

      debugPrint(
        'JWT TOKEN VERIFIED IN LOCAL STORAGE',
      );

      // =======================================================
      // SAVE EMAIL
      // =======================================================

      String learnerName = 'Learner';
      String learnerEmail = email;
      String learnerGoal = '';
      String learnerLevel = '';

      // =======================================================
      // GET PROFILE
      // =======================================================

      try {
        final profile =
        await ApiService.getProfile(
          token,
        );

        debugPrint(
          'PROFILE RESPONSE: $profile',
        );

        Map<String, dynamic> userData =
        Map<String, dynamic>.from(profile);

        // -----------------------------------------------------
        // PROFILE WRAPPED INSIDE "user"
        // -----------------------------------------------------

        if (profile['user'] is Map) {
          userData =
          Map<String, dynamic>.from(
            profile['user'],
          );
        }

        // -----------------------------------------------------
        // PROFILE WRAPPED INSIDE "data"
        // -----------------------------------------------------

        else if (profile['data'] is Map) {
          userData =
          Map<String, dynamic>.from(
            profile['data'],
          );
        }

        // =====================================================
        // NAME
        // =====================================================

        if (userData['name'] != null &&
            userData['name']
                .toString()
                .trim()
                .isNotEmpty) {
          learnerName =
              userData['name']
                  .toString()
                  .trim();
        }

        // =====================================================
        // EMAIL
        // =====================================================

        if (userData['email'] != null &&
            userData['email']
                .toString()
                .trim()
                .isNotEmpty) {
          learnerEmail =
              userData['email']
                  .toString()
                  .trim();
        }

        // =====================================================
        // GOAL
        // =====================================================

        if (userData['goal'] != null) {
          learnerGoal =
              userData['goal']
                  .toString()
                  .trim();
        }

        // =====================================================
        // LEVEL
        // =====================================================

        if (userData['level'] != null) {
          learnerLevel =
              userData['level']
                  .toString()
                  .trim();
        }
      } catch (e) {
        // -----------------------------------------------------
        // LOGIN SUCCEEDED EVEN IF PROFILE FETCH FAILS
        // -----------------------------------------------------

        debugPrint(
          'PROFILE FETCH ERROR: $e',
        );
      }

      // =======================================================
      // SAVE PROFILE LOCALLY
      // =======================================================

      await AppStorage.saveProfile(
        name: learnerName,
        email: learnerEmail,
        goal: learnerGoal,
        level: learnerLevel,
      );

      debugPrint(
        '--------------------------------',
      );

      debugPrint(
        'LOGIN USER DATA',
      );

      debugPrint(
        'Name: $learnerName',
      );

      debugPrint(
        'Email: $learnerEmail',
      );

      debugPrint(
        'Goal: $learnerGoal',
      );

      debugPrint(
        'Level: $learnerLevel',
      );

      debugPrint(
        'JWT SAVED: YES',
      );

      debugPrint(
        '--------------------------------',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // =======================================================
      // SUCCESS MESSAGE
      // =======================================================

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Login successful! Welcome back 🎉',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // =======================================================
      // SMALL DELAY
      // =======================================================

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      if (!mounted) return;

      // =======================================================
      // GO TO HOME
      // =======================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            learnerName: learnerName,
            email: learnerEmail,
            goal: learnerGoal,
            level: learnerLevel,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      String message =
      e.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(11);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
          Colors.redAccent,
          duration:
          const Duration(
            seconds: 4,
          ),
        ),
      );
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFFFBF5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // =================================================
                // BACK BUTTON
                // =================================================

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // TITLE
                // =================================================

                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Log in to continue your Samvaad learning journey.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color:
                    Color(0xFF777282),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // =================================================
                // EMAIL LABEL
                // =================================================

                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // =================================================
                // EMAIL
                // =================================================

                TextFormField(
                  controller:
                  _emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  textInputAction:
                  TextInputAction.next,

                  decoration:
                  InputDecoration(
                    hintText:
                    'Enter your email',

                    prefixIcon:
                    const Icon(
                      Icons
                          .email_outlined,
                    ),

                    filled: true,

                    fillColor:
                    Colors.white,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      BorderSide.none,
                    ),

                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      const BorderSide(
                        color:
                        Color(
                          0xFFE5E1EB,
                        ),
                      ),
                    ),

                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      const BorderSide(
                        color:
                        Color(
                          0xFF6C63A8,
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),

                  validator:
                      (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 22,
                ),

                // =================================================
                // PASSWORD LABEL
                // =================================================

                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xFF29263D),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // =================================================
                // PASSWORD
                // =================================================

                TextFormField(
                  controller:
                  _passwordController,

                  obscureText:
                  _obscurePassword,

                  textInputAction:
                  TextInputAction.done,

                  onFieldSubmitted:
                      (_) {
                    _login();
                  },

                  decoration:
                  InputDecoration(
                    hintText:
                    'Enter your password',

                    prefixIcon:
                    const Icon(
                      Icons
                          .lock_outline_rounded,
                    ),

                    suffixIcon:
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                          !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons
                            .visibility_outlined
                            : Icons
                            .visibility_off_outlined,
                      ),
                    ),

                    filled: true,

                    fillColor:
                    Colors.white,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      BorderSide.none,
                    ),

                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      const BorderSide(
                        color:
                        Color(
                          0xFFE5E1EB,
                        ),
                      ),
                    ),

                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      const BorderSide(
                        color:
                        Color(
                          0xFF6C63A8,
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),

                  validator:
                      (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 12,
                ),

                // =================================================
                // FORGOT PASSWORD
                // =================================================

                Align(
                  alignment:
                  Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Password reset will be connected next.',
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color:
                        Color(0xFF6C63A8),
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                // =================================================
                // LOGIN BUTTON
                // =================================================

                SizedBox(
                  width:
                  double.infinity,

                  height: 56,

                  child: FilledButton(
                    onPressed:
                    _isLoading
                        ? null
                        : _login,

                    style:
                    FilledButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xFF6C63A8,
                      ),

                      foregroundColor:
                      Colors.white,

                      disabledBackgroundColor:
                      const Color(
                        0xFFB8B3D0,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                        AlwaysStoppedAnimation<
                            Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                // =================================================
                // REGISTER
                // =================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color:
                        Color(0xFF777282),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color:
                          Color(0xFF6C63A8),
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // ACCESSIBILITY
                // =================================================

                Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: const [
                      Icon(
                        Icons
                            .accessibility_new_rounded,
                        size: 18,
                        color:
                        Color(0xFF8A8695),
                      ),

                      SizedBox(
                        width: 6,
                      ),

                      Text(
                        'Learning designed for everyone',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                          Color(0xFF8A8695),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}