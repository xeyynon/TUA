import 'package:flutter/material.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disclaimer"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SectionTitle("General Disclaimer"),
              SizedBox(height: 8),
              _Paragraph(
                "The information provided in this application is for general "
                "informational purposes only. While we strive to keep the data "
                "accurate and up to date, we make no guarantees of completeness "
                "or correctness.",
              ),

              SizedBox(height: 20),

              _SectionTitle("Traffic & Challan Data"),
              SizedBox(height: 8),
              _Paragraph(
                "Traffic conditions, challan details, and location-based data "
                "may vary due to real-time changes, technical limitations, "
                "or third-party service dependencies.",
              ),

              SizedBox(height: 20),

              _SectionTitle("User Responsibility"),
              SizedBox(height: 8),
              _Paragraph(
                "Users are responsible for verifying all information with "
                "official government portals or authorities before taking "
                "any legal or financial action.",
              ),

              SizedBox(height: 20),

              _SectionTitle("External Services"),
              SizedBox(height: 8),
              _Paragraph(
                "This application may rely on external APIs and services. "
                "We are not responsible for service interruptions, delays, "
                "or inaccuracies originating from third-party providers.",
              ),

              SizedBox(height: 20),

              _SectionTitle("Limitation of Liability"),
              SizedBox(height: 8),
              _Paragraph(
                "Under no circumstances shall the developers or associated "
                "authorities be liable for any loss or damage arising from "
                "the use of this application.",
              ),

              SizedBox(height: 30),

              Center(
                child: Text(
                  "By using this app, you agree to this disclaimer.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================
// REUSABLE WIDGETS
// ===============================

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
