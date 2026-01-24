import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SectionTitle("About the App"),
              SizedBox(height: 8),
              _Paragraph(
                "This application is designed to simplify road transport "
                "and traffic-related services for citizens. It provides access "
                "to live traffic updates, challan information, issue reporting, "
                "and digital vehicle-related records in a single platform.",
              ),
              SizedBox(height: 20),
              _SectionTitle("Our Vision"),
              SizedBox(height: 8),
              _Paragraph(
                "Our vision is to create a transparent, efficient, and "
                "technology-driven ecosystem for road transport services, "
                "reducing manual effort and improving citizen experience.",
              ),
              SizedBox(height: 20),
              _SectionTitle("Key Features"),
              SizedBox(height: 8),
              _Bullet("Live traffic map with real-time updates"),
              _Bullet("View and pay traffic challans"),
              _Bullet("Report road issues with photo & location"),
              _Bullet("Digital driving license and vehicle information"),
              _Bullet("User-friendly and secure interface"),
              SizedBox(height: 20),
              _SectionTitle("Authority"),
              SizedBox(height: 8),
              _Paragraph(
                "This application is developed as a technology initiative "
                "in alignment with digital governance and smart transportation "
                "goals. It aims to support citizens and authorities alike.",
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "",
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

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
