import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBackdrop extends StatelessWidget {
  final VoidCallback onClose; // ✅ MUST be this

  const GlassBackdrop({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose, // ✅ use directly
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(color: Colors.black.withOpacity(0.35)),
      ),
    );
  }
}
