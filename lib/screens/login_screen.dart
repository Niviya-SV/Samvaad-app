import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Validate fields first.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Temporary delay for frontend testing.
    // Supabase authentication will be added later.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // GO TO HOME
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          // Temporary: showing email until we connect
          // the registered learner profile.
          learnerName: 'Your Name',

          // These will come from the learner profile later.
          goal: '',
         // level: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ------------------------------------------------
                // BACK BUTTON
                // ------------------------------------------------

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),

                  color: const Color(0xFF29263D),
                ),

                const SizedBox(height: 30),

                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------

                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Log in to continue your Samvaad learning journey.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF777282),
                  ),
                ),

                const SizedBox(height: 40),

                // ------------------------------------------------
                // EMAIL
                // ------------------------------------------------

                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  textInputAction:
                  TextInputAction.next,

                  decoration: InputDecoration(
                    hintText: 'Enter your email',

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),

                    filled: true,

                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: const BorderSide(
                        color: Color(0xFFE5E1EB),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: const BorderSide(
                        color: Color(0xFF6C63A8),
                        width: 1.5,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // ------------------------------------------------
                // PASSWORD
                // ------------------------------------------------

                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,

                  obscureText: _obscurePassword,

                  textInputAction:
                  TextInputAction.done,

                  onFieldSubmitted: (_) {
                    _login();
                  },

                  decoration: InputDecoration(
                    hintText: 'Enter your password',

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                          !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),

                    filled: true,

                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: const BorderSide(
                        color: Color(0xFFE5E1EB),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),

                      borderSide: const BorderSide(
                        color: Color(0xFF6C63A8),
                        width: 1.5,
                      ),
                    ),
                  ),

                  validator: (value) {
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

                const SizedBox(height: 12),

                // ------------------------------------------------
                // FORGOT PASSWORD
                // ------------------------------------------------

                Align(
                  alignment:
                  Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Password reset will be available soon.',
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF6C63A8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ------------------------------------------------
                // LOGIN BUTTON
                // ------------------------------------------------

                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: FilledButton(
                    onPressed:
                    _isLoading ? null : _login,

                    style: FilledButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF6C63A8),

                      foregroundColor:
                      Colors.white,

                      disabledBackgroundColor:
                      const Color(0xFFB8B3D0),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
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

                const SizedBox(height: 28),

                // ------------------------------------------------
                // REGISTER
                // ------------------------------------------------

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Color(0xFF777282),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFF6C63A8),
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // ACCESSIBILITY NOTE
                // ------------------------------------------------

                Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: const [
                      Icon(
                        Icons.accessibility_new_rounded,
                        size: 18,
                        color: Color(0xFF8A8695),
                      ),

                      SizedBox(width: 6),

                      Text(
                        'Learning designed for everyone',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A8695),
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