import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.asphaltGrey,
      child: const Center(
        child: Text(
          "Live Map Coming Here",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
