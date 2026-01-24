import 'dart:ui';
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

  String? openedSection; // "active" | "past"
  bool _showPaymentSheet = false;

  Map<String, String>? _selectedChallan;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ===============================
  // LOCATION
  // ===============================
  Future<void> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

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

  // ===============================
  // MAIN BUILD
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _mainContent(),
          if (_showPaymentSheet) ...[
            _glassBackdrop(),
            _paymentSheet(),
          ],
        ],
      ),
    );
  }

  // ===============================
  // MAIN CONTENT
  // ===============================
  Widget _mainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fromToBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: GoogleMap(
                onMapCreated: (c) => _mapController = c,
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
            _challanTabs(),
            const SizedBox(height: 12),
            if (openedSection != null)
              Container(
                margin: const EdgeInsets.all(12),
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
    );
  }

  // ===============================
  // FROM → TO BAR
  // ===============================
  Widget _fromToBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: _inputField("From", Icons.my_location)),
          const SizedBox(width: 8),
          Expanded(child: _inputField("To", Icons.location_on)),
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
    );
  }

  Widget _inputField(String hint, IconData icon) {
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

  // ===============================
  // CHALLAN TABS
  // ===============================
  Widget _challanTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(child: _tab("Active Fines", Icons.warning_amber, "active")),
          const SizedBox(width: 12),
          Expanded(child: _tab("Past Fines", Icons.history, "past")),
        ],
      ),
    );
  }

  Widget _tab(String title, IconData icon, String value) {
    final active = openedSection == value;
    return InkWell(
      onTap: () => setState(() {
        openedSection = active ? null : value;
      }),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
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
        const Text("Active Fines",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _challanItem(
          title: "Speed Limit Violation",
          location: "NH-48, Delhi",
          date: "22 Jan 2026",
          amount: "₹1000",
        ),
        _challanItem(
          title: "Signal Jumping",
          location: "Ring Road, Delhi",
          date: "18 Jan 2026",
          amount: "₹500",
        ),
      ],
    );
  }

  // ===============================
  // PAST CHALLANS (FIXED)
  // ===============================
  Widget _pastChallanList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Past Fines",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _pastChallanItem(
          title: "Helmet Violation",
          location: "MG Road, Bengaluru",
          date: "05 Dec 2025",
          amount: "₹500",
          paymentId: "TXN98451234",
        ),
        _pastChallanItem(
          title: "Wrong Parking",
          location: "Sector 18, Noida",
          date: "14 Nov 2025",
          amount: "₹300",
          paymentId: "TXN76543210",
        ),
        _pastChallanItem(
          title: "Signal Jumping",
          location: "Outer Ring Road, Hyderabad",
          date: "01 Oct 2025",
          amount: "₹1000",
          paymentId: "TXN55667788",
        ),
      ],
    );
  }

  // ===============================
  // CHALLAN CARD (ACTIVE)
  // ===============================
  Widget _challanItem({
    required String title,
    required String location,
    required String date,
    required String amount,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              const Text("Unpaid", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow(location, date, amount),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  _selectedChallan = {
                    "title": title,
                    "amount": amount,
                  };
                  _showPaymentSheet = true;
                });
              },
              child: const Text("Pay Now"),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // PAST CHALLAN CARD
  // ===============================
  Widget _pastChallanItem({
    required String title,
    required String location,
    required String date,
    required String amount,
    required String paymentId,
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
          // ================= TITLE + STATUS =================
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Paid",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ================= LOCATION =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 12),
                  softWrap: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ================= DATE + AMOUNT =================
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.currency_rupee,
                      size: 14, color: Colors.grey),
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

          const SizedBox(height: 8),

          // ================= PAYMENT ID =================
          Text(
            "Payment ID: $paymentId",
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String loc, String date, String amt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _info(Icons.place, loc),
        _info(Icons.calendar_today, date),
        _info(Icons.currency_rupee, amt.replaceAll("₹", "")),
      ],
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

  // ===============================
  // GLASS BACKDROP
  // ===============================
  Widget _glassBackdrop() {
    return GestureDetector(
      onTap: () => setState(() => _showPaymentSheet = false),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(color: Colors.black.withOpacity(0.35)),
      ),
    );
  }

  // ===============================
  // PAYMENT SHEET
  // ===============================
  Widget _paymentSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pay Challan",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _showPaymentSheet = false),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.payments), title: Text("UPI")),
                  ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text("Debit / Credit Card")),
                  ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text("Net Banking")),
                  ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text("Wallet")),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful")),
                  );
                  setState(() => _showPaymentSheet = false);
                },
                child: const Text("Proceed to Pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
