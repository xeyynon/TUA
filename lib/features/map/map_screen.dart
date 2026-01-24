import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  String? openedSection; // "active" | "past" | null

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ===============================
  // GET CURRENT LOCATION
  // ===============================
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation!, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================
              // FROM → TO → GO
              // ===============================
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: _inputField(hint: "From", icon: Icons.my_location),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _inputField(hint: "To", icon: Icons.location_on),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
              ),

              // ===============================
              // MAP (45% HEIGHT)
              // ===============================
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? const LatLng(28.6139, 77.2090),
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  trafficEnabled: true,
                ),
              ),

              const SizedBox(height: 12),

              // ===============================
              // CHALLAN TABS
              // ===============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _challanTab(
                        title: "Active Challans",
                        icon: Icons.warning_amber,
                        isActive: openedSection == "active",
                        onTap: () {
                          setState(() {
                            openedSection = openedSection == "active"
                                ? null
                                : "active";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _challanTab(
                        title: "Past Challans",
                        icon: Icons.history,
                        isActive: openedSection == "past",
                        onTap: () {
                          setState(() {
                            openedSection = openedSection == "past"
                                ? null
                                : "past";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ===============================
              // EXPANDABLE CHALLAN DETAILS
              // ===============================
              if (openedSection != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: openedSection == "active"
                      ? _activeChallanList()
                      : _pastChallanList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // UI COMPONENTS
  // ===============================

  Widget _inputField({required String hint, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _challanTab({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ===============================
  // ACTIVE CHALLANS
  // ===============================
  Widget _activeChallanList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Active Challans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _challanItem(
          title: "Speed Limit Violation",
          location: "NH-48, Delhi",
          date: "22 Jan 2026",
          amount: "₹1000",
          status: "Unpaid",
          statusColor: Colors.red,
        ),

        _challanItem(
          title: "Signal Jumping",
          location: "Ring Road, Delhi",
          date: "18 Jan 2026",
          amount: "₹500",
          status: "Unpaid",
          statusColor: Colors.red,
        ),
      ],
    );
  }

  // ===============================
  // PAST CHALLANS
  // ===============================
  Widget _pastChallanList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Past Challans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _challanItem(
          title: "Helmet Violation",
          location: "MG Road, Bengaluru",
          date: "05 Dec 2025",
          amount: "₹500",
          status: "Paid",
          statusColor: Colors.green,
        ),

        _challanItem(
          title: "Wrong Parking",
          location: "Sector 18, Noida",
          date: "14 Nov 2025",
          amount: "₹300",
          status: "Paid",
          statusColor: Colors.green,
        ),
      ],
    );
  }

  // ===============================
  // INDIVIDUAL CHALLAN CARD
  // ===============================
  Widget _challanItem({
    required String title,
    required String location,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
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
          // TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 SINGLE LINE INFO BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 14,
                      color: Colors.grey,
                    ),
                    Text(
                      amount.replaceAll("₹", ""),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
