import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 109, 223),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =========================
            // FLOWIQ LOGO
            // =========================
            Image.asset(
              'assets/icons/nlogoflow.png',
              height: 110,
            ),

            const SizedBox(height: 20),

            // =========================
            // APP NAME
            // =========================
            const SizedBox(height: 6),

            // =========================
            // OPTIONAL TAGLINE
            // =========================
            const Text(
              "Smart Traffic & Road Intelligence",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
