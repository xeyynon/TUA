import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedIssue = "Road Damage";
  Position? _currentPosition;
  bool _isFetchingLocation = false;

  final List<String> _issueTypes = [
    "Road Damage",
    "Signal Not Working",
    "Wrong Challan",
    "Traffic Jam",
    "Other",
  ];

  // ==========================
  // GET LIVE LOCATION
  // ==========================
  Future<void> _getLocation() async {
    setState(() => _isFetchingLocation = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage("Location service is disabled");
      setState(() => _isFetchingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage("Location permission denied");
      setState(() => _isFetchingLocation = false);
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() => _isFetchingLocation = false);
  }

  void _submitReport() {
    if (_descriptionController.text.isEmpty) {
      _showMessage("Please describe the issue");
      return;
    }

    _showMessage("Issue reported successfully ✅");
    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report an Issue")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================
            // ISSUE TYPE
            // ==========================
            const Text(
              "Issue Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedIssue,
              items: _issueTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedIssue = value!);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            // ==========================
            // DESCRIPTION
            // ==========================
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Explain the issue clearly...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ==========================
            // LOCATION
            // ==========================
            const Text(
              "Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    _currentPosition == null
                        ? "Location not captured"
                        : "Lat: ${_currentPosition!.latitude.toStringAsFixed(5)}, "
                              "Lng: ${_currentPosition!.longitude.toStringAsFixed(5)}",
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isFetchingLocation ? null : _getLocation,
                  icon: const Icon(Icons.my_location),
                  label: Text(
                    _isFetchingLocation ? "Fetching..." : "Get Location",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==========================
            // SUBMIT
            // ==========================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitReport,
                child: const Text("Submit Issue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
