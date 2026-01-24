import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../home/drawer_menu.dart';
import 'report_store.dart';
import 'report_model.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  // =========================
  // FORM + IMAGE
  // =========================
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedIssue;
  Position? _currentPosition;
  bool _loadingLocation = false;

  final List<String> _issueTypes = [
    "Accident",
    "Road Damage",
    "Signal Not Working",
    "Water Logging",
    "Other",
  ];

  // =========================
  // INIT
  // =========================
  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  // =========================
  // GET CURRENT LOCATION
  // =========================
  Future<void> _fetchLocation() async {
    setState(() => _loadingLocation = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loadingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _loadingLocation = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _loadingLocation = false;
    });
  }

  // =========================
  // PICK IMAGE FROM CAMERA
  // =========================
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to open camera")),
      );
    }
  }

  // =========================
  // SUBMIT REPORT
  // =========================
  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a photo")),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not available")),
      );
      return;
    }

    final report = TrafficReport(
      issueType: _selectedIssue!,
      description: _descriptionController.text,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      imagePath: _imageFile!.path,
      createdAt: DateTime.now(),
    );

    ReportStore.reports.add(report);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Issue reported successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Issue"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const DrawerMenu(), // ✅ hamburger drawer
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // ISSUE TYPE
                // =========================
                const Text(
                  "Issue Type",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedIssue,
                  items: _issueTypes
                      .map(
                        (issue) => DropdownMenuItem(
                          value: issue,
                          child: Text(issue),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedIssue = value);
                  },
                  validator: (value) =>
                      value == null ? "Please select an issue" : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // DESCRIPTION
                // =========================
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter description"
                      : null,
                  decoration: const InputDecoration(
                    hintText: "Describe the issue clearly...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // LOCATION INFO
                // =========================
                const Text(
                  "Current Location",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _loadingLocation
                      ? const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text("Fetching location..."),
                          ],
                        )
                      : _currentPosition == null
                          ? const Text("Location not available")
                          : Text(
                              "Lat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                ),

                const SizedBox(height: 16),

                // =========================
                // PHOTO UPLOAD
                // =========================
                const Text(
                  "Photo Evidence",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Tap to capture photo"),
                            ],
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // SUBMIT BUTTON
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Submit Report"),
                    onPressed: _submitReport,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
