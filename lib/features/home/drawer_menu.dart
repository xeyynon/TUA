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
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            accountName: const Text("User Name"),
            accountEmail: const Text("user@email.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primaryBlue),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Live Traffic Map"),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.report),
            title: const Text("Report Issue on NH"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About Us"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text("Disclaimer"),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
