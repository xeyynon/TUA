import 'package:flutter/material.dart';

// Screens
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/map/map_screen.dart';
import '../features/support/report_issue.dart';
import '../features/profile/driving_license_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String map = '/map';
  static const String reportIssue = '/report-issue';
  static const String drivingLicense = '/driving-license';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    map: (context) => const MapScreen(),
    reportIssue: (context) => const ReportIssueScreen(),
    drivingLicense: (context) => const DrivingLicenseScreen(),
  };
}
