import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/challan_model.dart';
import '../services/location_service.dart';

class MapController extends ChangeNotifier {
  GoogleMapController? mapController;
  LatLng? currentLocation;

  // ✅ REQUIRED FOR ROUTING
  LatLng? fromLatLng;
  LatLng? toLatLng;

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  List<Map<String, String>> fromSuggestions = [];
  List<Map<String, String>> toSuggestions = [];

  String? openedSection; // active | past
  bool showPaymentSheet = false;
  Challan? selectedChallan;

  final fromController = TextEditingController();
  final toController = TextEditingController();

  Future<void> init() async {
    currentLocation = await LocationService.getCurrentLocation();
    notifyListeners();
  }

  void toggleTab(String value) {
    openedSection = openedSection == value ? null : value;
    notifyListeners();
  }

  void openPayment(Challan challan) {
    selectedChallan = challan;
    showPaymentSheet = true;
    notifyListeners();
  }

  void closePayment() {
    showPaymentSheet = false;
    notifyListeners();
  }

  void setFromSuggestions(List<Map<String, String>> list) {
    fromSuggestions = list;
    notifyListeners();
  }

  void setToSuggestions(List<Map<String, String>> list) {
    toSuggestions = list;
    notifyListeners();
  }
}
