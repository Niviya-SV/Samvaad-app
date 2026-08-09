import 'package:flutter/material.dart';
import 'learner_details_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ----------------------------------------------------------
  // CONTROLLERS
  // ----------------------------------------------------------

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // ----------------------------------------------------------
  // STATE
  // ----------------------------------------------------------

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  // ----------------------------------------------------------
  // REGEX
  // ----------------------------------------------------------

  // Name:
  // Letters, spaces, apostrophes and hyphens.
  final RegExp _nameRegex = RegExp(
    r"^[a-zA-Z][a-zA-Z\s'-]{1,49}$",
  );

  // Email.
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password:
  // Minimum 8 characters
  // At least 1 uppercase
  // At least 1 lowercase
  // At least 1 number
  // At least 1 special character
  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
  );

  // ----------------------------------------------------------
  // DISPOSE
  // ----------------------------------------------------------

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ----------------------------------------------------------
  // REGISTER
  // ----------------------------------------------------------

  void _register() {
    // Validate fields.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check terms.
    if (!_acceptedTerms) {
      _showMessage(
        'Please accept the Terms and Conditions.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // For now this is frontend only.
    //
    // Later we will connect Supabase authentication here.
    //
    // After successful registration:
    // Register → Learner Details

    Future.delayed(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearnerDetailsScreen(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // MESSAGE
  // ----------------------------------------------------------

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // INPUT DECORATION
  // ----------------------------------------------------------

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6C63A8),
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE3E0EA),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE3E0EA),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF6C63A8),
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF29263D),
          ),
        ),
      ),

      // ------------------------------------------------------
      // BODY
      // ------------------------------------------------------

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              28,
              10,
              28,
              32,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------

                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Join Samvaad and start your Indian Sign Language journey.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF666274),
                  ),
                ),

                const SizedBox(height: 32),

                // ------------------------------------------------
                // NAME
                // ------------------------------------------------

                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,

                  textCapitalization:
                  TextCapitalization.words,

                  keyboardType: TextInputType.name,

                  decoration: _inputDecoration(
                    label: 'Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                  ),

                  validator: (value) {
                    final name = value?.trim() ?? '';

                    if (name.isEmpty) {
                      return 'Please enter your name';
                    }

                    if (!_nameRegex.hasMatch(name)) {
                      return 'Please enter a valid name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // EMAIL
                // ------------------------------------------------

                const Text(
                  'Email Address',
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

                  autocorrect: false,

                  decoration: _inputDecoration(
                    label: 'Email',
                    hint: 'example@email.com',
                    icon: Icons.email_outlined,
                  ),

                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!_emailRegex.hasMatch(email)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

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

                  decoration: _inputDecoration(
                    label: 'Password',
                    hint: 'Create a strong password',
                    icon: Icons.lock_outline_rounded,

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                          !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF777282),
                      ),
                    ),
                  ),

                  validator: (value) {
                    final password = value ?? '';

                    if (password.isEmpty) {
                      return 'Please enter a password';
                    }

                    if (!_passwordRegex.hasMatch(
                      password,
                    )) {
                      return 'Use 8+ chars, uppercase, lowercase, number & symbol';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 9),

                const Text(
                  '8+ characters • Uppercase • Lowercase • Number • Symbol',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A8695),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // CONFIRM PASSWORD
                // ------------------------------------------------

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF29263D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller:
                  _confirmPasswordController,

                  obscureText:
                  _obscureConfirmPassword,

                  decoration: _inputDecoration(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    icon: Icons.lock_reset_outlined,

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },

                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF777282),
                      ),
                    ),
                  ),

                  validator: (value) {
                    final confirmPassword =
                        value ?? '';

                    if (confirmPassword.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (confirmPassword !=
                        _passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // ------------------------------------------------
                // TERMS
                // ------------------------------------------------

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Checkbox(
                      value: _acceptedTerms,

                      activeColor:
                      const Color(0xFF6C63A8),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),

                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms =
                              value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: 11),

                        child: Text(
                          'I agree to the Terms and Conditions and Privacy Policy.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF666274),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ------------------------------------------------
                // CREATE ACCOUNT BUTTON
                // ------------------------------------------------

                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: FilledButton(
                    onPressed:
                    _isLoading ? null : _register,

                    style: FilledButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF6C63A8),

                      foregroundColor: Colors.white,

                      disabledBackgroundColor:
                      const Color(0xFFB8B4CA),

                      shape: RoundedRectangleBorder(
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
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------------------
                // LOGIN
                // ------------------------------------------------

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color(0xFF6C63A8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ------------------------------------------------
                // FOOTER
                // ------------------------------------------------

                const Center(
                  child: Text(
                    'Samvaad • Learn. Practice. Connect.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A8695),
                    ),
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