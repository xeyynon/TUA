import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // =========================
          // USER HEADER (AVATAR CLICKABLE)
          // =========================
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            accountName: const Text("User Name"),
            accountEmail: const Text("user@email.com"),

            // 👇 USER AVATAR → DRIVING LICENSE PAGE
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pushNamed(
                  context,
                  AppRoutes.drivingLicense,
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primaryBlue),
              ),
            ),
          ),

          // =========================
          // LIVE MAP
          // =========================
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Live Traffic Map"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            },
          ),

          // =========================
          // REPORT ISSUE
          // =========================
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text("Report Issue on NH"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.reportIssue,
              );
            },
          ),

          // =========================
          // ABOUT US
          // =========================
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.aboutUs,
              );
            },
          ),

          // =========================
          // DISCLAIMER
          // =========================
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text("Disclaimer"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.disclaimer,
              );
            },
          ),

          const Divider(),

          // =========================
          // LOGOUT
          // =========================
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
              );
            },
          ),
        ],
      ),
    );
  }
}
