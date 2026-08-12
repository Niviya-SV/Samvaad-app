import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'learner_details_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String name;
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {

  // =========================================================
  // CONTROLLER
  // =========================================================

  final TextEditingController otpController =
  TextEditingController();

  // =========================================================
  // STATE
  // =========================================================

  bool isLoading = false;
  bool isResending = false;

  // =========================================================
  // VERIFY OTP
  // =========================================================

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    // ---------------------------------------------------------
    // VALIDATE OTP
    // ---------------------------------------------------------

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the 6-digit OTP',
          ),
        ),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'OTP must contain only numbers',
          ),
        ),
      );
      return;
    }

    // ---------------------------------------------------------
    // START LOADING
    // ---------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      // =======================================================
      // CALL BACKEND
      // =======================================================

      final result = await ApiService.verifyOtp(
        widget.email,
        otp,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // =======================================================
      // SUCCESS MESSAGE
      // =======================================================

      final message =
          result['message']?.toString() ??
              'Email verified successfully.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // -------------------------------------------------------
      // SMALL DELAY
      // -------------------------------------------------------

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      // =======================================================
      // GO TO LEARNER DETAILS
      // =======================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LearnerDetailsScreen(
            name: widget.name,
            email: widget.email,
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // -------------------------------------------------------
      // CLEAN ERROR MESSAGE
      // -------------------------------------------------------

      String message = e.toString();

      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // =========================================================
  // RESEND OTP
  // =========================================================

  Future<void> resendOtp() async {
    if (isResending) {
      return;
    }

    setState(() {
      isResending = true;
    });

    try {
      /*
       * RESEND OTP IS NOT CONNECTED YET.
       *
       * Current backend endpoints:
       *
       * POST /api/auth/register
       * POST /api/auth/verify-otp
       *
       * We have not created:
       *
       * POST /api/auth/resend-otp
       *
       * yet.
       */

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resend OTP is not connected yet.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to resend OTP.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isResending = false;
        });
      }
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: const Text(
          'Verify Email',
          style: TextStyle(
            color: Color(0xFF29263D),
            fontWeight: FontWeight.w800,
          ),
        ),

        leading: IconButton(
          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF29263D),
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.center,

            children: [

              const SizedBox(height: 50),

              // =================================================
              // ICON
              // =================================================

              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  color: const Color(0xFFEAE6F8),
                  borderRadius:
                  BorderRadius.circular(28),
                ),

                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 48,
                  color: Color(0xFF6C63A8),
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // TITLE
              // =================================================

              const Text(
                'Verify your email',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF29263D),
                ),
              ),

              const SizedBox(height: 12),

              // =================================================
              // DESCRIPTION
              // =================================================

              Text(
                'We sent a 6-digit OTP to\n${widget.email}',
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF777282),
                ),
              ),

              const SizedBox(height: 35),

              // =================================================
              // OTP FIELD
              // =================================================

              TextField(
                controller: otpController,

                keyboardType:
                TextInputType.number,

                maxLength: 6,

                textAlign: TextAlign.center,

                autofocus: true,

                style: const TextStyle(
                  fontSize: 28,
                  letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF29263D),
                ),

                decoration: InputDecoration(
                  hintText: '000000',

                  hintStyle: const TextStyle(
                    color: Color(0xFFC4C0CC),
                    letterSpacing: 8,
                  ),

                  counterText: '',

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),

                    borderSide: const BorderSide(
                      color: Color(0xFFE3E0EA),
                    ),
                  ),

                  enabledBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),

                    borderSide: const BorderSide(
                      color: Color(0xFFE3E0EA),
                    ),
                  ),

                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),

                    borderSide: const BorderSide(
                      color: Color(0xFF6C63A8),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // VERIFY BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed:
                  isLoading
                      ? null
                      : verifyOtp,

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF6C63A8),

                    disabledBackgroundColor:
                    const Color(0xFFB8B4CA),

                    foregroundColor:
                    Colors.white,

                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: isLoading
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
                    'VERIFY OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // RESEND
              // =================================================

              TextButton(
                onPressed:
                isResending
                    ? null
                    : resendOtp,

                child: isResending
                    ? const SizedBox(
                  width: 18,
                  height: 18,

                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(
                      0xFF6C63A8,
                    ),
                  ),
                )
                    : const Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Color(
                      0xFF6C63A8,
                    ),
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // =================================================
              // SECURITY MESSAGE
              // =================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: const [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFF8A8695),
                  ),

                  SizedBox(width: 6),

                  Text(
                    'Your email is securely verified',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A8695),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}