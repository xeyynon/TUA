import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class TrafficApp extends StatelessWidget {
  const TrafficApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Traffic Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
