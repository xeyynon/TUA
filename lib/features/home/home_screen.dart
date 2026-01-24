import 'package:flutter/material.dart';
import '../map/map_screen.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Traffic")),
      drawer: const DrawerMenu(),
      body: const MapScreen(),
    );
  }
}
