import 'package:flutter/material.dart';

import '../controllers/map_controller.dart';
import '../models/challan_model.dart';
import 'active_challan_card.dart';
import 'past_challan_card.dart';

class ChallanTabs extends StatelessWidget {
  final MapController controller;

  const ChallanTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Row(
            children: [
              _tab("Active Fines", "active"),
              _tab("Past Fines", "past"),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.openedSection == "active")
            Column(
              children: [
                ActiveChallanCard(
                  challan: Challan(
                    title: "Speed Limit Violation",
                    location: "NH-48, Delhi",
                    date: "22 Jan 2026",
                    amount: "₹1000",
                  ),
                  onPay: controller.openPayment,
                ),
              ],
            ),
          if (controller.openedSection == "past")
            Column(
              children: const [
                PastChallanCard(
                  title: "Helmet Violation",
                  location: "MG Road, Bengaluru",
                  date: "05 Dec 2025",
                  amount: "₹500",
                  paymentId: "TXN98451234",
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tab(String title, String value) {
    final active = controller.openedSection == value;

    return Expanded(
      child: InkWell(
        onTap: () => controller.toggleTab(value),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: active ? Colors.blue : Colors.grey.shade300,
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
