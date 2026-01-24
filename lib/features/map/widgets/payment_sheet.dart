import 'package:flutter/material.dart';

class PaymentSheet extends StatelessWidget {
  final VoidCallback onClose; // ✅ DEFINE IT

  const PaymentSheet({
    super.key,
    required this.onClose, // ✅ ACCEPT IT
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pay Challan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose, // ✅ USE IT
                ),
              ],
            ),

            const Divider(),

            // PAYMENT OPTIONS (same as before)
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text("UPI"),
              onTap: onClose,
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Debit / Credit Card"),
              onTap: onClose,
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("Net Banking"),
              onTap: onClose,
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onClose, // ✅ SAME CALLBACK
                child: const Text("Proceed to Pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
