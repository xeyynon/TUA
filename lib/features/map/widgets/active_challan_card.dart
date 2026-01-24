import 'package:flutter/material.dart';

import '../models/challan_model.dart';

class ActiveChallanCard extends StatelessWidget {
  final Challan challan;
  final void Function(Challan) onPay; // ✅ IMPORTANT CHANGE

  const ActiveChallanCard({
    super.key,
    required this.challan,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                challan.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const Text("Unpaid", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info(Icons.place, challan.location),
              _info(Icons.calendar_today, challan.date),
              _info(
                Icons.currency_rupee,
                challan.amount.replaceAll("₹", ""),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => onPay(challan), // ✅ PASS ARGUMENT
              child: const Text("Pay Now"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
