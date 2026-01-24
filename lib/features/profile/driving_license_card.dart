import 'dart:math';
import 'package:flutter/material.dart';

class DrivingLicenseCard extends StatefulWidget {
  const DrivingLicenseCard({super.key});

  @override
  State<DrivingLicenseCard> createState() => _DrivingLicenseCardState();
}

class _DrivingLicenseCardState extends State<DrivingLicenseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  void _flipCard() {
    if (_controller.isAnimating) return;

    if (_controller.value == 0) {
      _controller.forward(); // front → back
    } else {
      _controller.reverse(); // back → front
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ===================================================
  // UI
  // ===================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Abhinav Sharma",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final angle = _controller.value * pi;
              final showBack = angle >= pi / 2;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: showBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _buildBack(),
                      )
                    : _buildFront(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Tap card to flip",
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  // ===================================================
  // CARD CONTAINER
  // ===================================================

  Widget _card({required Widget child}) {
    return Container(
      width: 350,
      height: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ===================================================
  // FRONT
  // ===================================================

  Widget _buildFront() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header("Government of India", "Driving Licence"),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _icon(Icons.person),
                  const SizedBox(width: 12),
                  Expanded(child: _personalInfo()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // BACK
  // ===================================================

  Widget _buildBack() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header("Vehicle Details", ""),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _icon(Icons.directions_car),
                  const SizedBox(width: 12),
                  Expanded(child: _vehicleInfo()),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white54),
          const Center(
            child: Text(
              "Ministry of Road Transport & Highways",
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // PARTS
  // ===================================================

  Widget _header(String left, String right) {
    return Row(
      children: [
        const Icon(Icons.account_balance, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(left,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(right,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _icon(IconData icon) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 48, color: Colors.blue),
    );
  }

  Widget _personalInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow("DOB", "09-10-2004"),
        InfoRow("DL No", "DL-0420110123456"),
        InfoRow("Blood Group", "B+"),
        InfoRow("Valid Till", "08-10-2034"),
        SizedBox(height: 6),
        Text(
          "221B, MG Road, Indiranagar, Bengaluru, Karnataka - 560038",
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }

  Widget _vehicleInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow("Reg No", "KA01AB1234"),
        InfoRow("Type", "Motor Car"),
        InfoRow("Make", "Maruti Swift"),
        InfoRow("Fuel", "Petrol"),
        InfoRow("Chassis", "MA3EWB12345678901"),
        InfoRow("Engine", "K12MN9876543"),
        InfoRow("RC Valid", "15-07-2033"),
        InfoRow("Insurance", "20-06-2027"),
        InfoRow("PUC", "12-03-2026"),
      ],
    );
  }
}

// ===================================================
// INFO ROW
// ===================================================

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
          const Text(": ", style: TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
