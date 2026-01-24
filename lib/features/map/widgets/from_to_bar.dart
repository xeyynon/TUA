import 'package:flutter/material.dart';

import '../controllers/map_controller.dart';

class FromToBar extends StatelessWidget {
  final MapController controller;
  final VoidCallback onFromSearch;
  final VoidCallback onToSearch;
  final VoidCallback onRoutePressed;

  const FromToBar({
    super.key,
    required this.controller,
    required this.onFromSearch,
    required this.onToSearch,
    required this.onRoutePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // FROM
          Expanded(
            child: TextField(
              controller: controller.fromController,
              decoration: InputDecoration(
                hintText: "From",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.my_location, size: 20),
                  onPressed: onFromSearch, // 🔥 place search
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // TO
          Expanded(
            child: TextField(
              controller: controller.toController,
              decoration: InputDecoration(
                hintText: "To",
                prefixIcon: IconButton(
                  icon: const Icon(Icons.location_on, size: 20),
                  onPressed: onToSearch, // 🔥 place search
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ROUTE BUTTON
          SizedBox(
            height: 48,
            width: 48,
            child: ElevatedButton(
              onPressed: onRoutePressed, // 🔥 draw route
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
