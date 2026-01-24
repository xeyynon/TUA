import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true, // ✅ important
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // =========================
              // FLOWIQ LOGO
              // =========================
              Image.asset(
                'assets/icons/nflowiq.png',
                height: 90,
              ),

              const SizedBox(height: 16),

              // =========================
              // APP NAME
              // =========================
              const Text(
                "FlowIQ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // EMAIL / PHONE
              // =========================
              const TextField(
                decoration: InputDecoration(
                  labelText: "Email / Phone",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // PASSWORD
              // =========================
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // LOGIN BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.home,
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
