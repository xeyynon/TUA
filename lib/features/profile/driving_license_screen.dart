import 'package:flutter/material.dart';
import 'driving_license_card.dart';

class DrivingLicenseScreen extends StatelessWidget {
  const DrivingLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Driving License"),
      ),
      body: Center(
        child: DrivingLicenseCard(),
      ),
    );
  }
}
